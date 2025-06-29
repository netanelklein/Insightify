import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../auth/secrets.dart';
import '../utils/input_validator.dart';

class AccessToken {
  String accessToken;
  String tokenType;
  int expiresIn;
  AccessToken(
      {required this.accessToken,
      required this.tokenType,
      required this.expiresIn});

  factory AccessToken.fromJson(Map<String, dynamic> json) {
    return AccessToken(
        accessToken: json['access_token'],
        tokenType: json['token_type'],
        expiresIn: json['expires_in']);
  }

  AccessToken.empty()
      : accessToken = '',
        tokenType = '',
        expiresIn = 0;
}

Future<AccessToken> getAccessToken() async {
  String clientID = spotifyClientID;
  String clientSecret = spotifyClientSecret;
  var response = await http
      .post(Uri.parse("https://accounts.spotify.com/api/token"), body: {
    "grant_type": "client_credentials",
    "client_id": clientID,
    "client_secret": clientSecret
  });

  if (response.statusCode == 200) {
    return AccessToken.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load access token');
  }
}

Future<List<String>> getTrackData(
    String artistName, String trackName, AccessToken token) async {
  // Validate and sanitize input parameters
  final sanitizedArtist = InputValidator.sanitizeMusicName(artistName);
  final sanitizedTrack = InputValidator.sanitizeMusicName(trackName);

  if (token.accessToken == '' ||
      sanitizedArtist == null ||
      sanitizedTrack == null) {
    return ['', ''];
  }

  String trackUri = '';
  String albumName = '';

  // URL encode the sanitized parameters
  final encodedArtist = Uri.encodeComponent(sanitizedArtist);
  final encodedTrack = Uri.encodeComponent(sanitizedTrack);

  var response = await http.get(
      Uri.parse(
          "https://api.spotify.com/v1/search?q=remaster%20artist:$encodedArtist%20track:$encodedTrack&type=track&limit=1"),
      headers: {"Authorization": "${token.tokenType} ${token.accessToken}"});

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    if (data['tracks']['items'].isNotEmpty) {
      trackUri = data['tracks']['items'][0]['uri'];
      albumName = data['tracks']['items'][0]['album']['name'];
      return [trackUri, albumName];
    }
    return ['', ''];
  } else if (response.statusCode == 429) {
    await Future.delayed(
        Duration(seconds: int.parse(response.headers['retry-after']!)));
    return ['', ''];
  } else {
    throw Exception('Failed to load track id. ${response.toString()}');
  }
}

Future<Map<String, dynamic>> fetchMetadata(AccessToken token,
    List<String> trackIds, Map<String, String> trackAlbumMap) async {
  if (token.accessToken == '' || trackIds.length > 50 || trackIds.isEmpty) {
    return {};
  }

  var response = await http.get(
      Uri.parse("https://api.spotify.com/v1/tracks?ids=${trackIds.join(',')}"),
      headers: {"Authorization": "${token.tokenType} ${token.accessToken}"});
  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    Map<String, dynamic> metadata = {};
    for (var track in data['tracks']) {
      if (metadata[track['artists'][0]['name']] == null) {
        metadata[track['artists'][0]['name']] = {
          'artist_id': track['artists'][0]['id'],
          'artist_image': track['artists'][0]['images'] != null
              ? track['artists'][0]['images'][0]['url']
              : null,
          'albums': {}
        };
      }
      metadata[track['artists'][0]['name']]['albums']
          [trackAlbumMap[track['id']]] = {
        'album_id': track['album']['id'],
        'album_image': track['album']['images'] != null
            ? track['album']['images'][0]['url']
            : null
      };
    }

    // Get artist ids for artist that don't have artist_image
    List<String> artistIds = [];
    for (var artist in metadata.entries) {
      if (artist.value['artist_image'] == null) {
        artistIds.add(artist.value['artist_id']);
      }
    }

    if (artistIds.length > 50) {
      artistIds = artistIds.sublist(0, 50);
    }

    // Get artist images
    if (artistIds.isNotEmpty) {
      response = await http.get(
          Uri.parse(
              "https://api.spotify.com/v1/artists?ids=${artistIds.join(',')}"),
          headers: {
            "Authorization": "${token.tokenType} ${token.accessToken}"
          });
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        for (var artist in data['artists']) {
          metadata[artist['name']]['artist_image'] =
              artist['images'].isNotEmpty ? artist['images'][0]['url'] : '';
        }
      } else if (response.statusCode == 429) {
        // Rate limit exceeded
        await Future.delayed(
            Duration(seconds: int.parse(response.headers['retry-after']!)));
      } else if (response.statusCode == 401) {
        // Access token expired
        // TODO: this is not efficient. need to find a way to set the token in the app state.
        token = await getAccessToken();
        return await fetchMetadata(token, trackIds, trackAlbumMap);
      } else {
        throw Exception(
            'Failed to load artist photo. ${response.body.toString()}');
      }
    }
    return metadata;
  } else if (response.statusCode == 429) {
    // Rate limit exceeded
    await Future.delayed(
        Duration(seconds: int.parse(response.headers['retry-after']!)));
  } else if (response.statusCode == 401) {
    // Access token expired
    // TODO: this is not efficient. need to find a way to set the token in the app state.
    token = await getAccessToken();
    return await fetchMetadata(token, trackIds, trackAlbumMap);
  } else {
    throw Exception('Failed to load metadata. ${response.toString()}');
  }
  throw Exception('Function did not complete normally');
}
