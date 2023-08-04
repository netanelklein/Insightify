import 'package:insightify/src/services/spotify_api_fetch.dart';

import '../models/history.dart';
import '../models/artist.dart';
import '../models/album.dart';
import '../models/track.dart';
import '../models/stream_history.dart';

History getHistory(
    ExtendedStreamHistory streamHistory, int minMsPlayed, AccessToken token) {
  History history = History(artists: []);

  for (ExtendedStreamHistoryEntry entry in streamHistory.entries) {
    if (entry.msPlayed < minMsPlayed) {
      continue;
    }
    if (!history.containsArtist(entry.artist)) {
      history.addArtist(Artist(name: entry.artist, albums: []));
    }

    Artist artist = history.getArtist(entry.artist);

    if (!artist.containsAlbum(entry.album)) {
      artist.addAlbum(
          Album(name: entry.album, artistName: entry.artist, tracks: []));
    }

    Album album = artist.getAlbum(entry.album);

    if (!album.containsTrack(entry.title)) {
      album.addTrack(Track(
          title: entry.title,
          artistName: entry.artist,
          albumName: entry.album,
          msPlayed: entry.msPlayed,
          timesPlayed: 1,
          skipped: entry.skipped ? 1 : 0,
          trackId: entry.uri.split(':').last));
    } else {
      Track track = album.getTrack(entry.title);
      track.msPlayed += entry.msPlayed;
      track.timesPlayed += 1;
      track.skipped += entry.skipped ? 1 : 0;
      album.setTrack = track;
    }

    artist.setAlbum = album;
    history.setArtist = artist;
  }

  return history;
}

ExtendedStreamHistory getExtendedStreamHistory(
    List<dynamic> json, AccessToken token) {
  List<ExtendedStreamHistoryEntry> entries = [];
  for (var element in json) {
    if (element['master_metadata_track_name'] == null) {
      // Check if it's a non-extended data
      if (element['endTime'] != null) {
        getTrackData(element['artistName'], element['trackName'], token).then(
            (trackData) => entries.add(ExtendedStreamHistoryEntry(
                ts: element['endTime'],
                msPlayed: element['msPlayed'],
                artist: element['artistName'],
                album: trackData[1],
                title: element['trackName'],
                uri: trackData[0],
                reasonStart: '',
                reasonEnd: '',
                shuffle: false,
                skipped: false,
                offline: false)));
      }
      continue;
    }
    entries.add(ExtendedStreamHistoryEntry(
        ts: DateTime.parse(element['ts']),
        msPlayed: element['ms_played'],
        artist: element['master_metadata_album_artist_name'],
        album: element['master_metadata_album_album_name'],
        title: element['master_metadata_track_name'],
        uri: element['spotify_track_uri'],
        reasonStart: element['reason_start'],
        reasonEnd: element['reason_end'],
        shuffle: element['shuffle'] == null ? false : element['shuffle']!,
        skipped: element['skipped'] == null ? false : element['skipped']!,
        offline: element['offline'] == null ? false : element['offline']!));
  }
  return ExtendedStreamHistory(items: entries);
}
