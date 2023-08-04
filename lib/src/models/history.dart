import 'artist.dart';
import 'album.dart';
import 'track.dart';

class History {
  final List<Artist> artists;

  History({required this.artists});

  History.empty() : artists = [];

  int get timePlayed {
    return artists.fold(
        0, (previousValue, element) => previousValue + element.timePlayed);
  }

  get favoriteArtist {
    return artists.reduce(
        (curr, next) => curr.timePlayed > next.timePlayed ? curr : next);
  }

  void addArtist(Artist artist) {
    artists.add(artist);
  }

  bool containsArtist(String artistName) {
    return artists.any((element) => element.name == artistName);
  }

  Artist getArtist(String artistName) {
    return artists.firstWhere((element) => element.name == artistName);
  }

  set setArtist(Artist artist) {
    artists[artists.indexWhere((element) => element.name == artist.name)] =
        artist;
  }

  void combine(History history) {
    for (Artist artist in history.artists) {
      if (!containsArtist(artist.name)) {
        addArtist(artist);
      } else {
        Artist currentArtist = getArtist(artist.name);
        for (var album in artist.albums) {
          if (!currentArtist.containsAlbum(album.name)) {
            currentArtist.addAlbum(album);
          } else {
            Album currentAlbum = currentArtist.getAlbum(album.name);
            for (var track in album.tracks) {
              if (!currentAlbum.containsTrack(track.title)) {
                currentAlbum.addTrack(track);
              } else {
                Track currentTrack = currentAlbum.getTrack(track.title);
                currentTrack.msPlayed += track.msPlayed;
                currentTrack.timesPlayed += track.timesPlayed;
                currentTrack.skipped += track.skipped;
                currentAlbum.setTrack = currentTrack;
              }
            }
          }
        }
        setArtist = currentArtist;
      }
    }
  }

  int length() {
    return artists.fold(
        0, (previousValue, element) => previousValue + element.albums.length);
  }

  void sort() {
    artists.sort((a, b) => b.timePlayed.compareTo(a.timePlayed));
    for (var artist in artists) {
      artist.albums.sort((a, b) => b.timePlayed.compareTo(a.timePlayed));
      for (var album in artist.albums) {
        album.tracks.sort((a, b) => b.timePlayed.compareTo(a.timePlayed));
      }
    }
  }

  get topTracks {
    List<Track> tracks = [];
    for (var artist in artists) {
      for (var album in artist.albums) {
        for (var track in album.tracks) {
          tracks.add(track);
        }
      }
    }
    tracks.sort((a, b) => b.timePlayed.compareTo(a.timePlayed));
    return tracks;
  }

  get topAlbums {
    List<Album> albums = [];
    for (var artist in artists) {
      for (var album in artist.albums) {
        albums.add(album);
      }
    }
    albums.sort((a, b) => b.timePlayed.compareTo(a.timePlayed));
    return albums;
  }
}
