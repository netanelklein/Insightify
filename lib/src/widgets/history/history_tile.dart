import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app_state.dart';
import '../../models/stream_history.dart';
import '../../utils/database_helper.dart';

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
        if (snapshot.hasData) {
          final track = snapshot.data!;
          return ListTile(
            leading:
                (track[0]['cover_art'] == null || track[0]['cover_art'] == '')
                    ? const Icon(Icons.music_note, size: 50)
                    : Material(
                        elevation: 7,
                        child: Image.network(track[0]['cover_art'])),
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
            subtitle: Row(children: [
              entry.shuffle
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
                  : const Icon(Icons.skip_next, size: 20, color: Colors.grey),
              const SizedBox(width: 5),
              entry.offline
                  ? Icon(
                      Icons.wifi_off,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : const Icon(Icons.wifi_off, size: 20, color: Colors.grey),
            ]),
            // trailing: Text(
            //   Functions().formatDuration(track.durationMs),
            //   style: Theme.of(context).textTheme.caption,
            // ),
          );
        } else {
          return ListTile(
            leading: const CircularProgressIndicator(),
            title: const Text('Loading...'),
          );
        }
      },
    );
  }
}
