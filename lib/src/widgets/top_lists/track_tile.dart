import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_state.dart';
import '../../utils/database_helper.dart';
import '../../utils/functions.dart';

class TrackTile extends StatelessWidget {
  const TrackTile(
      {super.key,
      required this.trackName,
      required this.artistName,
      required this.albumName,
      required this.index,
      required this.timePlayed,
      required this.timesPlayed,
      required this.timesSkipped,
      required this.isTopList});
  final String trackName;
  final String artistName;
  final String? albumName;
  final int index;
  final int timePlayed;
  final int timesPlayed;
  final int timesSkipped;
  final bool isTopList;

  openSpotify(String trackUri) async {
    Uri url = Uri.parse(trackUri);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<AppState>(context).accessToken;
    final trackMetadata = DatabaseHelper()
        .getTrackMetadata(artistName, albumName, trackName, token);

    return FutureBuilder(
        future: trackMetadata,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return ListTile(
                leading: const Icon(Icons.music_note, size: 50),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${index + 1}. $trackName'),
                    isTopList
                        ? Text(
                            'by ${artistName}',
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
                subtitle: Text(
                    'You listened to this track for ${msToTimeStringShort(timePlayed)}.\nPlayed: $timesPlayed times\nSkipped: $timesSkipped times'),
              );
            }
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
                    Text('${index + 1}. $trackName'),
                    isTopList
                        ? Text(
                            'by ${artistName}',
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
                subtitle: Text(
                    'You listened to this track for ${msToTimeStringShort(timePlayed)}.\nPlayed: $timesPlayed times\nSkipped: $timesSkipped times'),
                trailing: snapshot.data![0]['track_uri'] != null
                    ? IconButton(
                        tooltip: 'PLAY IN SPOTIFY',
                        onPressed: () =>
                            openSpotify(snapshot.data![0]['track_uri']),
                        icon: Image.asset(
                          Theme.of(context).brightness == Brightness.light
                              ? 'assets/icons/Spotify_Icon_RGB_Black.png'
                              : 'assets/icons/Spotify_Icon_RGB_White.png',
                          height: 24,
                          width: 24,
                        ),
                      )
                    : null
                // PopupMenuButton<String>(
                //   onSelected: (String result) async {
                //     Uri url = Uri.parse("${snapshot.data![0]['track_uri']}");
                //     if (await canLaunchUrl(url)) {
                //       await launchUrl(url);
                //     } else {
                //       // throw 'Could not launch $url';
                //     }
                //   },
                //   itemBuilder: (context) => <PopupMenuEntry<String>>[
                //     PopupMenuItem<String>(
                //       value: '1',
                //       enabled:
                //           snapshot.data![0]['track_uri'] != null ? true : false,
                //       child: const Text('Play in Spotify'),
                //     ),
                //   ],
                // ),
                );
          } else {
            return ListTile(
              leading: const Icon(Icons.music_note, size: 50),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${index + 1}. $trackName'),
                  isTopList
                      ? Text(
                          'by ${artistName}',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
              subtitle: Text(
                  'You listened to this track for ${msToTimeStringShort(timePlayed)}.\nPlayed: $timesPlayed times\nSkipped: $timesSkipped times'),
            );
          }
        });
  }
}
