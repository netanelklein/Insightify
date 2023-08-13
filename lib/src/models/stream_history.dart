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
