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
        entry.artistName, entry.albumName, entry.trackName, token);

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
                Text(entry.trackName),
                Text(
                  'by ${entry.artistName}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                )
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Reason Started: ${entry.reasonStart}'),
                // Text('Reason Ended: ${entry.reasonEnd}'),
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
            trailing: entry.trackUri != '' && entry.trackUri != null
                ? IconButton(
                    tooltip: 'OPEN SPOTIFY',
                    onPressed: () => openSpotify(entry.trackUri!),
                    icon: const SpotifyButton())
                : null,
          );
        } else {
          return ListTile(
            leading: const Icon(Icons.music_note, size: 50),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.trackName),
                Text(
                  'by ${entry.artistName}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                )
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reason Started: ${entry.reasonStart}'),
                Text('Reason Ended: ${entry.reasonEnd}'),
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
