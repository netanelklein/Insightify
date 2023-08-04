import 'package:spotify_analyzer/src/services/spotify_api_fetch.dart';

import '../utils/functions.dart';
import 'track.dart';

class Album {
  String? id;
  final String name;
  final String artistName;
  String? coverArtUrl;
  List<Track> tracks;

  Album(
      {required this.name,
      required this.artistName,
      required this.tracks,
      AccessToken? token,
      String? trackId}) {
    if (token != null && trackId != null) {
      fetchAlbumCover(this, token, trackId);
    }
  }

  int get timePlayed {
    return tracks.fold(
        0, (previousValue, element) => previousValue + element.timePlayed);
  }

  get favoriteTrack {
    return tracks.reduce(
        (curr, next) => curr.timePlayed > next.timePlayed ? curr : next);
  }

  get albumId {
    return id;
  }

  void setId(String albumId) {
    id = albumId;
  }

  void addTrack(Track track) {
    tracks.add(track);
  }

  bool containsTrack(String trackName) {
    return tracks.any((element) => element.title == trackName);
  }

  Track getTrack(String trackName) {
    return tracks.firstWhere((element) => element.title == trackName);
  }

  set setTrack(Track track) {
    tracks[tracks.indexWhere((element) => element.title == track.title)] =
        track;
  }

  set coverArt(String url) {
    coverArtUrl = url;
  }

  @override
  String toString() {
    List<int> time = msToTime(timePlayed);
    return '${time[0]} days, ${time[1]} hours, ${time[2]} minutes and ${time[3]} seconds.';
  }
}
