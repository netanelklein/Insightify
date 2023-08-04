import '../utils/functions.dart';
import '../services/spotify_api_fetch.dart';
import 'album.dart';

class Artist {
  String? id;
  final String name;
  String? imageUrl;
  List<Album> albums;

  Artist(
      {required this.name,
      required this.albums,
      AccessToken? token,
      String? trackId}) {
    if (token != null && trackId != null) {
      fetchArtistPhoto(this, token, trackId);
    }
  }

  int get timePlayed {
    return albums.fold(
        0, (previousValue, element) => previousValue + element.timePlayed);
  }

  get favoriteAlbum {
    return albums.reduce(
        (curr, next) => curr.timePlayed > next.timePlayed ? curr : next);
  }

  get artistId {
    return id;
  }

  void setId(String artistId) {
    id = artistId;
  }

  void addAlbum(Album album) {
    albums.add(album);
  }

  bool containsAlbum(String albumName) {
    return albums.any((element) => element.name == albumName);
  }

  Album getAlbum(String albumName) {
    return albums.firstWhere((element) => element.name == albumName);
  }

  set setAlbum(Album album) {
    albums[albums.indexWhere((element) => element.name == album.name)] = album;
  }

  set image(String? url) {
    imageUrl = url;
  }

  @override
  String toString() {
    return '${msToTime(timePlayed)[0]} days, ${msToTime(timePlayed)[1]} hours, ${msToTime(timePlayed)[2]} minutes and ${msToTime(timePlayed)[3]} seconds.';
  }
}
