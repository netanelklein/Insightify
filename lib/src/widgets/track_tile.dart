import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_state.dart';
import '../utils/database_helper.dart';
import '../utils/functions.dart';

class TrackTile extends StatelessWidget {
  const TrackTile(
      {super.key,
      required this.trackName,
      required this.artistName,
      required this.albumName,
      required this.index,
      required this.timePlayed,
      required this.timesSkipped});
  final String trackName;
  final String artistName;
  final String? albumName;
  final int index;
  final int timePlayed;
  final int timesSkipped;

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
                title: Text('${index + 1}. $trackName - $artistName'),
                subtitle: Text(
                    'You listened to this track for ${msToTimeString(timePlayed)}. It was skipped $timesSkipped times.'),
              );
            }
            return ListTile(
              leading: (snapshot.data![0]['cover_art'] == null ||
                      snapshot.data![0]['cover_art'] == '')
                  ? const Icon(Icons.music_note, size: 50)
                  : Material(
                      elevation: 7,
                      child: Image.network(snapshot.data![0]['cover_art'])),
              title: Text('${index + 1}. $trackName - $artistName'),
              subtitle: Text(
                  'You listened to this track for ${msToTimeString(timePlayed)}. It was skipped $timesSkipped times.'),
              trailing: PopupMenuButton<String>(
                onSelected: (String result) async {
                  Uri url = Uri.parse("${snapshot.data![0]['track_uri']}");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    // throw 'Could not launch $url';
                  }
                },
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: '1',
                    enabled:
                        snapshot.data![0]['track_uri'] != null ? true : false,
                    child: const Text('Play in Spotify'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
    // Album album = history.getArtist(track.artistName).getAlbum(track.album);
    // if (album.coverArtUrl == null) {
    //   fetchAlbumCover(album, token, track.id);
    // }
    // String? coverUrl =
    //     history.getArtist(track.artistName).getAlbum(track.album).coverArtUrl;
    // return ListTile(
    //   leading: coverUrl == null
    //       ? const Icon(
    //           Icons.music_note,
    //           size: 50,
    //         )
    //       : ClipRRect(
    //           borderRadius: BorderRadius.circular(5.0),
    //           child: Image.network(coverUrl)),
    //   title: Text('${index + 1}. ${track.title} - ${track.artistName}'),
    //   subtitle: Text(track.toString()),
    //   isThreeLine: true,
    //   trailing: PopupMenuButton<String>(
    //     onSelected: (String result) async {
    //       Uri url = Uri.parse("spotify:track:${track.id}");
    //       if (await canLaunchUrl(url)) {
    //         await launchUrl(url);
    //       } else {
    //         // throw 'Could not launch $url';
    //       }
    //     },
    //     itemBuilder: (context) => <PopupMenuEntry<String>>[
    //       const PopupMenuItem<String>(
    //         value: '1',
    //         child: Text('Play in Spotify'),
    //       ),
    //     ],
    //   ),
    // );
  }
}
