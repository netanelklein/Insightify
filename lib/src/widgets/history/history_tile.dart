import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app_state.dart';
import '../../models/stream_history.dart';
import '../../utils/database_helper.dart';
import '../../utils/functions.dart';
import '../../widgets/common/spotify_button.dart';

class HistoryTile extends StatelessWidget {
  const HistoryTile({super.key, required this.entry});

  final StreamHistoryDBEntry entry;

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<AppState>(context).accessToken;
    final trackMetadata = DatabaseHelper().getTrackMetadata(
        entry.artist_name, entry.album_name, entry.track_name, token);

    return FutureBuilder(
      future: trackMetadata,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListTile(
            leading: (snapshot.data![0]['cover_art'] == null ||
                    snapshot.data![0]['cover_art'] == '')
                ? const Icon(Icons.music_note, size: 50)
                : Material(
                    elevation: 7,
                    child: Image.network(snapshot.data![0]['cover_art'])),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${entry.track_name}'),
                Text(
                  'by ${entry.artist_name}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                )
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reason Started: ${entry.reason_start}'),
                Text('Reason Ended: ${entry.reason_end}'),
                Row(children: [
                  entry.shuffle!
                      ? Icon(
                          Icons.shuffle,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : const Icon(Icons.shuffle, size: 20, color: Colors.grey),
                  const SizedBox(width: 5),
                  entry.skipped
                      ? Icon(
                          Icons.skip_next,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : const Icon(Icons.skip_next,
                          size: 20, color: Colors.grey),
                  const SizedBox(width: 5),
                  entry.offline!
                      ? Icon(
                          Icons.wifi_off,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : const Icon(Icons.wifi_off,
                          size: 20, color: Colors.grey),
                ]),
                Text(
                    'Time Ended: ${timestampToString(entry.timestamp, false)}'),
              ],
            ),
            trailing: entry.track_uri != '' && entry.track_uri != null
                ? IconButton(
                    tooltip: 'OPEN SPOTIFY',
                    onPressed: () => openSpotify(entry.track_uri!),
                    icon: SpotifyButton())
                : null,
          );
        } else {
          return ListTile(
            leading: const Icon(Icons.music_note, size: 50),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${entry.track_name}'),
                Text(
                  'by ${entry.artist_name}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                )
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reason Started: ${entry.reason_start}'),
                Text('Reason Ended: ${entry.reason_end}'),
                Row(children: [
                  entry.shuffle!
                      ? Icon(
                          Icons.shuffle,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : const Icon(Icons.shuffle, size: 20, color: Colors.grey),
                  const SizedBox(width: 5),
                  entry.skipped
                      ? Icon(
                          Icons.skip_next,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : const Icon(Icons.skip_next,
                          size: 20, color: Colors.grey),
                  const SizedBox(width: 5),
                  entry.offline!
                      ? Icon(
                          Icons.wifi_off,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : const Icon(Icons.wifi_off,
                          size: 20, color: Colors.grey),
                ]),
                Text(
                    'Time Ended: ${timestampToString(entry.timestamp, false)}'),
              ],
            ),
          );
        }
      },
    );
  }
}
