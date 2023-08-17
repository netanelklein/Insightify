// A model class for StreamHistory
class StreamHistoryEntry {
  final String endTime;
  final String artistName;
  final String trackName;
  final num msPlayed;

  StreamHistoryEntry(
      {required this.endTime,
      required this.artistName,
      required this.trackName,
      required this.msPlayed});
}

class ExtendedStreamHistoryEntry {
  final String ts;
  final String username;
  final String platform;
  final num msPlayed;
  final String connCountry;
  final String ipAddrDecrypted;
  final String userAgentDecrypted;
  final String masterMetadataTrackName;
  final String masterMetadataAlbumArtistName;
  final String masterMetadataAlbumAlbumName;
  final String spotifyTrackUri;
  final String? episodeName;
  final String? episodeShowName;
  final String? spotifyEpisodeUri;
  final String reasonStart;
  final String reasonEnd;
  final bool shuffle;
  final bool skipped;
  final bool offline;
  final num offlineTimestamp;
  final bool incognitoMode;

  ExtendedStreamHistoryEntry(
      {required this.ts,
      required this.username,
      required this.platform,
      required this.msPlayed,
      required this.connCountry,
      required this.ipAddrDecrypted,
      required this.userAgentDecrypted,
      required this.masterMetadataTrackName,
      required this.masterMetadataAlbumArtistName,
      required this.masterMetadataAlbumAlbumName,
      required this.spotifyTrackUri,
      required this.episodeName,
      required this.episodeShowName,
      required this.spotifyEpisodeUri,
      required this.reasonStart,
      required this.reasonEnd,
      required this.shuffle,
      required this.skipped,
      required this.offline,
      required this.offlineTimestamp,
      required this.incognitoMode});
}

class StreamHistoryDBEntry {
  final int id;
  final String timestamp;
  final int msPlayed;
  final String? trackUri;
  final String trackName;
  final String artistName;
  final String? albumName;
  final String? reasonStart;
  final String? reasonEnd;
  final bool? shuffle;
  final bool skipped;
  final bool? offline;

  StreamHistoryDBEntry(
      {required this.id,
      required this.timestamp,
      required this.msPlayed,
      required this.trackUri,
      required this.trackName,
      required this.artistName,
      required this.albumName,
      required this.reasonStart,
      required this.reasonEnd,
      required this.shuffle,
      required this.skipped,
      required this.offline});

  factory StreamHistoryDBEntry.fromMap(Map<String, dynamic> json) {
    return StreamHistoryDBEntry(
      id: json['id'],
      timestamp: json['timestamp'],
      msPlayed: json['ms_played'],
      trackUri: json['track_uri'],
      trackName: json['track_name'],
      artistName: json['artist_name'],
      albumName: json['album_name'],
      reasonStart: json['reason_start'],
      reasonEnd: json['reason_end'],
      shuffle: json['shuffle'] == 1,
      skipped: json['skipped'] == 1,
      offline: json['offline'] == 1,
    );
  }

  @override
  String toString() {
    return 'StreamHistoryDBEntry{id: $id, timestamp: $timestamp, ms_played: $msPlayed, track_uri: $trackUri, track_name: $trackName, artist_name: $artistName, album_name: $albumName, reason_start: $reasonStart, reason_end: $reasonEnd, shuffle: $shuffle, skipped: $skipped, offline: $offline}';
  }
}
