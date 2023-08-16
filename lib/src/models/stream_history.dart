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
  final num ms_played;
  final String conn_country;
  final String ip_addr_decrypted;
  final String user_agent_decrypted;
  final String master_metadata_track_name;
  final String master_metadata_album_artist_name;
  final String master_metadata_album_album_name;
  final String spotify_track_uri;
  final String? episode_name;
  final String? episode_show_name;
  final String? spotify_episode_uri;
  final String reason_start;
  final String reason_end;
  final bool shuffle;
  final bool skipped;
  final bool offline;
  final num offline_timestamp;
  final bool incognito_mode;

  ExtendedStreamHistoryEntry(
      {required this.ts,
      required this.username,
      required this.platform,
      required this.ms_played,
      required this.conn_country,
      required this.ip_addr_decrypted,
      required this.user_agent_decrypted,
      required this.master_metadata_track_name,
      required this.master_metadata_album_artist_name,
      required this.master_metadata_album_album_name,
      required this.spotify_track_uri,
      required this.episode_name,
      required this.episode_show_name,
      required this.spotify_episode_uri,
      required this.reason_start,
      required this.reason_end,
      required this.shuffle,
      required this.skipped,
      required this.offline,
      required this.offline_timestamp,
      required this.incognito_mode});
}

class StreamHistoryDBEntry {
  final int id;
  final String timestamp;
  final int ms_played;
  final String track_uri;
  final String track_name;
  final String artist_name;
  final String album_name;
  final String reason_start;
  final String reason_end;
  final bool shuffle;
  final bool skipped;
  final bool offline;

  StreamHistoryDBEntry(
      {required this.id,
      required this.timestamp,
      required this.ms_played,
      required this.track_uri,
      required this.track_name,
      required this.artist_name,
      required this.album_name,
      required this.reason_start,
      required this.reason_end,
      required this.shuffle,
      required this.skipped,
      required this.offline});

  factory StreamHistoryDBEntry.fromMap(Map<String, dynamic> json) {
    return StreamHistoryDBEntry(
      id: json['id'],
      timestamp: json['timestamp'],
      ms_played: json['ms_played'],
      track_uri: json['track_uri'],
      track_name: json['track_name'],
      artist_name: json['artist_name'],
      album_name: json['album_name'],
      reason_start: json['reason_start'],
      reason_end: json['reason_end'],
      shuffle: json['shuffle'] == 1,
      skipped: json['skipped'] == 1,
      offline: json['offline'] == 1,
    );
  }

  @override
  String toString() {
    return 'StreamHistoryDBEntry{id: $id, timestamp: $timestamp, ms_played: $ms_played, track_uri: $track_uri, track_name: $track_name, artist_name: $artist_name, album_name: $album_name, reason_start: $reason_start, reason_end: $reason_end, shuffle: $shuffle, skipped: $skipped, offline: $offline}';
  }
}
