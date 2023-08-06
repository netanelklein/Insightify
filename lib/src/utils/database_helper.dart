import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../services/spotify_api_fetch.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static late Database _database;

  DatabaseHelper._internal();

  static Future<void> initDatabase() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), 'spotify_analyzer.db'),
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS stream_history(id INTEGER PRIMARY KEY AUTOINCREMENT, timestamp TEXT, ms_played INTEGER, track_uri TEXT, track_name TEXT, artist_name TEXT, album_name TEXT, reason_start TEXT, reason_end TEXT, shuffle INTEGER, skipped INTEGER, offline INTEGER)');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS artists(id INTEGER PRIMARY KEY AUTOINCREMENT, artist_name TEXT UNIQUE, image TEXT, spotify_id TEXT)');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS albums(id INTEGER PRIMARY KEY AUTOINCREMENT, album_name TEXT, artist_name TEXT, cover_art TEXT, spotify_id TEXT, UNIQUE(album_name, artist_name))');
    }, version: 1);
  }

  Future<bool> isDatabaseEmpty() async {
    final List<Map<String, dynamic>> data =
        await _database.rawQuery('SELECT * FROM stream_history LIMIT 1');
    return data.isEmpty;
  }

  String _getDataType(Map<String, dynamic> data) {
    final List<String> extendedDataKeys = [
      'ts',
      'username',
      'platform',
      'ms_played',
      'conn_country',
      'ip_addr_decrypted',
      'user_agent_decrypted',
      'master_metadata_track_name',
      'master_metadata_album_artist_name',
      'master_metadata_album_album_name',
      'spotify_track_uri',
      'episode_name',
      'episode_show_name',
      'spotify_episode_uri',
      'reason_start',
      'reason_end',
      'shuffle',
      'skipped',
      'offline',
      'offline_timestamp',
      'incognito_mode'
    ];

    final List<String> nonExtendedDataKeys = [
      'endTime',
      'artistName',
      'trackName',
      'msPlayed',
    ];

    if (data.keys.toSet().containsAll(extendedDataKeys)) {
      return 'extended';
    } else if (data.keys.toSet().containsAll(nonExtendedDataKeys)) {
      return 'non-extended';
    } else {
      return 'unknown';
    }
  }

  Future<int> insertDataBatch(List<dynamic> data) async {
    // Validate all data is of the same type
    final type = _getDataType(data[0]);
    for (final Map<String, dynamic> item in data) {
      if (_getDataType(item) != type) {
        return 0;
      }
    }

    Batch batch = _database.batch();
    switch (type) {
      case 'extended':
        for (final Map<String, dynamic> item in data) {
          _insertExtendedData(item, batch);
        }
        break;
      case 'non-extended':
        for (final Map<String, dynamic> item in data) {
          _insertNonExtendedData(item, batch);
        }
        break;
      default:
        return 0;
    }
    await batch.commit(noResult: true);
    return 1;
  }

  Future<int> insertData(Map<String, dynamic> data) async {
    final type = _getDataType(data);
    switch (type) {
      case 'extended':
        return await _insertExtendedData(data);
      case 'non-extended':
        return await _insertNonExtendedData(data);
      default:
        return 0;
    }
  }

  Future<int> _insertExtendedData(Map<String, dynamic> data,
      [Batch? batch]) async {
    Map<String, dynamic> mappedData = {
      'timestamp': data['ts'],
      'ms_played': data['ms_played'],
      'track_uri': data['spotify_track_uri'],
      'track_name': data['master_metadata_track_name'],
      'artist_name': data['master_metadata_album_artist_name'],
      'album_name': data['master_metadata_album_album_name'],
      'reason_start': data['reason_start'],
      'reason_end': data['reason_end'],
      'shuffle': (data['shuffle'] != null && data['shuffle']) ? 1 : 0,
      'skipped': (data['skipped'] != null && data['skipped']) ? 1 : 0,
      'offline': (data['offline'] != null && data['offline']) ? 1 : 0
    };

    if (batch != null) {
      batch.insert(
          'artists',
          {
            'artist_name': data['master_metadata_album_artist_name'],
            'image': null,
            'spotify_id': null
          },
          conflictAlgorithm: ConflictAlgorithm.ignore);

      batch.insert(
          'albums',
          {
            'album_name': data['master_metadata_album_album_name'],
            'artist_name': data['master_metadata_album_artist_name'],
            'cover_art': null,
            'spotify_id': null
          },
          conflictAlgorithm: ConflictAlgorithm.ignore);

      batch.insert('stream_history', mappedData,
          conflictAlgorithm: ConflictAlgorithm.replace);
      return 1;
    }

    await _database.insert(
        'artists',
        {
          'artist_name': data['master_metadata_album_artist_name'],
          'image': null,
          'spotify_id': null
        },
        conflictAlgorithm: ConflictAlgorithm.ignore);

    await _database.insert(
        'albums',
        {
          'album_name': data['master_metadata_album_album_name'],
          'artist_name': data['master_metadata_album_artist_name'],
          'cover_art': null,
          'spotify_id': null
        },
        conflictAlgorithm: ConflictAlgorithm.ignore);

    return await _database.insert('stream_history', mappedData,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> _insertNonExtendedData(Map<String, dynamic> data,
      [Batch? batch]) async {
    Map<String, dynamic> mappedData = {
      'timestamp': data['endTime'],
      'ms_played': data['msPlayed'],
      'track_name': data['trackName'],
      'artist_name': data['artistName'],
      'skipped': data['msPlayed'] < 30000 ? 1 : 0
    };

    if (batch != null) {
      batch.insert(
          'artists',
          {
            'artist_name': data['artistName'],
            'image': null,
            'spotify_id': null
          },
          conflictAlgorithm: ConflictAlgorithm.ignore);

      batch.insert('stream_history', mappedData,
          conflictAlgorithm: ConflictAlgorithm.replace);
      return 1;
    }

    await _database.insert('artists',
        {'artist_name': data['artistName'], 'image': null, 'spotify_id': null},
        conflictAlgorithm: ConflictAlgorithm.ignore);

    return await _database.insert('stream_history', mappedData,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getData() async {
    return await _database.query('stream_history');
  }

  Future<void> deleteData() async {
    await _database.delete('stream_history');
  }

  Future<void> deleteDatabase() async {
    await databaseFactory
        .deleteDatabase(join(await getDatabasesPath(), 'spotify_analyzer.db'));
  }

  Future<void> close() async {
    await _database.close();
  }

  Future<List<Map<String, dynamic>>> getTopArtists() async {
    return await _database.rawQuery(
        'SELECT artist_name, SUM(ms_played) AS total_ms_played, COUNT(*) AS times_played, SUM(skipped) AS times_skipped FROM stream_history WHERE artist_name IS NOT NULL GROUP BY artist_name ORDER BY total_ms_played DESC');
  }

  Future<List<Map<String, dynamic>>> getTopAlbums([String? artistName]) async {
    if (artistName == null) {
      return await _database.rawQuery(
          'SELECT album_name, artist_name, SUM(ms_played) AS total_ms_played, COUNT(*) AS times_played, SUM(skipped) AS times_skipped FROM stream_history WHERE album_name IS NOT NULL GROUP BY artist_name, album_name ORDER BY total_ms_played DESC');
    }
    return await _database.rawQuery(
        'SELECT album_name, SUM(ms_played) AS total_ms_played, COUNT(*) AS times_played, SUM(skipped) AS times_skipped FROM stream_history WHERE artist_name = ? AND album_name IS NOT NULL GROUP BY artist_name, album_name ORDER BY total_ms_played DESC',
        [artistName]);
  }

  Future<List<Map<String, dynamic>>> getTopTracks(
      [String? artistName, String? albumName]) async {
    if (artistName == null && albumName == null) {
      return await _database.rawQuery(
          'SELECT track_name, artist_name, album_name, SUM(ms_played) AS total_ms_played, COUNT(*) AS times_played, SUM(skipped) AS times_skipped FROM stream_history WHERE track_name IS NOT NULL GROUP BY artist_name, track_name ORDER BY total_ms_played DESC');
    }
    if (artistName != null && albumName == null) {
      return await _database.rawQuery(
          'SELECT track_name, artist_name, album_name, SUM(ms_played) AS total_ms_played, COUNT(*) AS times_played, SUM(skipped) AS times_skipped FROM stream_history WHERE artist_name = ? AND track_name IS NOT NULL GROUP BY artist_name, track_name ORDER BY total_ms_played DESC',
          [artistName]);
    }
    if (artistName == null && albumName != null) {
      return await _database.rawQuery(
          'SELECT track_name, artist_name, album_name, SUM(ms_played) AS total_ms_played, COUNT(*) AS times_played, SUM(skipped) AS times_skipped FROM stream_history WHERE album_name = ? AND track_name IS NOT NULL GROUP BY artist_name, track_name ORDER BY total_ms_played DESC',
          [albumName]);
    }
    return await _database.rawQuery(
        'SELECT track_name, SUM(ms_played) AS total_ms_played, COUNT(*) AS times_played, SUM(skipped) AS times_skipped FROM stream_history WHERE artist_name = ? AND album_name = ? AND track_name IS NOT NULL GROUP BY artist_name, track_name ORDER BY total_ms_played DESC',
        [artistName, albumName]);
  }

  Future<List<Map<String, dynamic>>> getTotalTimePlayed() async {
    return await _database.rawQuery(
        'SELECT SUM(ms_played) AS total_ms_played FROM stream_history WHERE track_name IS NOT NULL');
  }

  Future<List<Map<String, dynamic>>> getMostPlayedDay() async {
    return await _database.rawQuery(
        'SELECT strftime("%d/%m/%Y", timestamp) AS day, SUM(ms_played) AS total_ms_played, COUNT(*) AS times_played FROM stream_history WHERE track_name IS NOT NULL GROUP BY day ORDER BY times_played DESC LIMIT 1');
  }

  Future<List<Map<String, dynamic>>> getArtistMetadata(
      String artistName, AccessToken token) async {
    final metadata = await _database.rawQuery(
        'SELECT artist_name, image, spotify_id FROM artists WHERE artist_name = ?',
        [artistName]);
    if (metadata[0]['image'] == null || metadata[0]['spotify_id'] == null) {
      final trackIds = await getNoMetadataTracklist(artistName);
      final trackAlbumMap = {
        for (var e in trackIds)
          e['track_uri'].split(':').last.toString(): e['album_name'].toString()
      };
      final newMetadata = await fetchMetadata(
          token,
          trackIds
              .map((e) => e['track_uri'].split(':').last.toString())
              .toList(),
          trackAlbumMap);
      await updateMetadata(newMetadata);
      return await _database.rawQuery(
          'SELECT artist_name, image, spotify_id FROM artists WHERE artist_name = ?',
          [artistName]);
    }
    return metadata;
  }

  Future<List<Map<String, dynamic>>> getAlbumMetadata(
      String artistName, String albumName, AccessToken token) async {
    final metadata = await _database.rawQuery(
        'SELECT album_name, artist_name, cover_art, spotify_id FROM albums WHERE artist_name = ? AND album_name = ?',
        [artistName, albumName]);

    if (metadata[0]['cover_art'] == null || metadata[0]['spotify_id'] == null) {
      final trackIds = await getNoMetadataTracklist(artistName);
      final trackAlbumMap = {
        for (var e in trackIds)
          e['track_uri'].split(':').last.toString(): e['album_name'].toString()
      };
      final newMetadata = await fetchMetadata(
          token,
          trackIds
              .map((e) => e['track_uri'].split(':').last.toString())
              .toList(),
          trackAlbumMap);
      await updateMetadata(newMetadata);
      return await _database.rawQuery(
          'SELECT album_name, artist_name, cover_art, spotify_id FROM albums WHERE artist_name = ? AND album_name = ?',
          [artistName, albumName]);
    }

    return metadata;
  }

  Future<List<Map<String, dynamic>>> getTrackMetadata(String artistName,
      String? albumName, String trackName, AccessToken token) async {
    if (albumName == null) {
      return [];
    }
    final metadata = await _database.rawQuery(
        'SELECT stream_history.track_uri, albums.cover_art FROM stream_history INNER JOIN albums ON stream_history.album_name = albums.album_name AND stream_history.artist_name = albums.artist_name WHERE stream_history.artist_name = ? AND stream_history.album_name = ? AND stream_history.track_name = ? LIMIT 1',
        [artistName, albumName, trackName]);
    if (metadata[0]['cover_art'] == null) {
      final albumMetadata =
          await getAlbumMetadata(artistName, albumName, token);
      metadata[0]['cover_art'] = albumMetadata[0]['cover_art'];
    }
    return metadata;
  }

  Future<List<Map<String, dynamic>>> getNoMetadataTracklist(
      String firstArtist) async {
    final List<Map<String, dynamic>> trackIds = [];
    // Get track ids for albums of the artist that dosen't have metadata
    final albums = await _database.rawQuery(
        'SELECT album_name FROM albums WHERE artist_name = ? AND (cover_art IS NULL OR spotify_id IS NULL)',
        [firstArtist]);

    final trackIdsFromDb = await _database.rawQuery(
        'SELECT album_name, MIN(track_uri) AS track_uri FROM stream_history WHERE artist_name = ? AND album_name IN (${List.generate(albums.length, (index) => '?').join(',')}) GROUP BY album_name LIMIT 50',
        [firstArtist, ...albums.map((e) => e['album_name'])]);

    trackIds.addAll(trackIdsFromDb);

    // if track ids is shorter than 50, try to get metadata for another artist
    while (trackIds.length < 50) {
      final artists = await _database.rawQuery(
          'SELECT artist_name FROM artists WHERE artist_name != ? AND (image IS NULL OR spotify_id IS NULL)',
          [firstArtist]);

      final otherAlbums = await _database.rawQuery(
          'SELECT album_name FROM albums WHERE artist_name IN (${List.generate(artists.length, (index) => '?').join(',')}) AND (cover_art IS NULL OR spotify_id IS NULL) LIMIT ${50 - trackIds.length}',
          [...artists.map((e) => e['artist_name'])]);

      final otherTrackIds = await _database.rawQuery(
          'SELECT album_name, MIN(track_uri) AS track_uri FROM stream_history WHERE artist_name IN (${List.generate(artists.length, (index) => '?').join(',')}) AND album_name IN (${List.generate(otherAlbums.length, (index) => '?').join(',')}) GROUP BY album_name LIMIT ${50 - trackIds.length}',
          [
            ...artists.map((e) => e['artist_name']),
            ...otherAlbums.map((e) => e['album_name'])
          ]);
      if (otherTrackIds.isEmpty) {
        break;
      }
      trackIds.addAll(otherTrackIds);
    }
    return trackIds;
  }

  Future<void> updateMetadata(Map<String, dynamic> metadata) {
    Batch batch = _database.batch();
    for (var artist in metadata.entries) {
      batch.update(
          'artists',
          {
            'image': artist.value['artist_image'],
            'spotify_id': artist.value['artist_id']
          },
          where: 'artist_name = ?',
          whereArgs: [artist.key]);
      for (var album in artist.value['albums'].entries) {
        batch.update(
            'albums',
            {
              'cover_art': album.value['album_image'],
              'spotify_id': album.value['album_id']
            },
            where: 'artist_name = ? AND album_name = ?',
            whereArgs: [artist.key, album.key]);
      }
    }
    return batch.commit();
  }
}
