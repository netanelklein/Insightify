import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_state.dart';
import '../../screens/album_page.dart';
import '../../utils/database_helper.dart';
import '../../utils/functions.dart';
import '../../widgets/common/spotify_button.dart';

class AlbumTile extends StatelessWidget {
  const AlbumTile(
      {super.key,
      required this.artistName,
      required this.albumName,
      required this.timePlayed,
      required this.index,
      required this.isTopList});
  final String artistName;
  final String albumName;
  final int timePlayed;
  final int index;
  final bool isTopList;

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<AppState>(context).accessToken;
    final albumMetadata =
        DatabaseHelper().getAlbumMetadata(artistName, albumName, token);

    return FutureBuilder(
      future: albumMetadata,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListTile(
              enabled: true,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AlbumPage(
                          artistName: artistName,
                          albumName: albumName,
                          timePlayed: timePlayed))),
              leading: (snapshot.data![0]['cover_art'] == null ||
                      snapshot.data![0]['cover_art'] == '')
                  ? const Icon(Icons.album, size: 50)
                  : Material(
                      elevation: 7,
                      child: Image.network(snapshot.data![0]['cover_art'])),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${index + 1}. $albumName'),
                  isTopList
                      ? Text(
                          'by $artistName',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              subtitle: Text(
                  'You listened to this album for ${msToTimeStringShort(timePlayed)}'),
              trailing: snapshot.data![0]['spotify_id'] != null
                  ? IconButton(
                      tooltip: 'OPEN SPOTIFY',
                      onPressed: () => openSpotify(
                          'spotify:album:${snapshot.data![0]['spotify_id']}'),
                      icon: const SpotifyButton())
                  : null
              // PopupMenuButton<String>(
              //   onSelected: (String result) async {
              //     Uri url = Uri.parse(
              //         "spotify:album:${snapshot.data![0]['spotify_id']}");
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
              //           snapshot.data![0]['spotify_id'] != null ? true : false,
              //       child: Row(
              //         children: [
              //           Image.asset(
              //             Theme.of(context).brightness == Brightness.light
              //                 ? 'assets/icons/Spotify_Icon_RGB_Black.png'
              //                 : 'assets/icons/Spotify_Icon_RGB_White.png',
              //             height: 20,
              //             width: 20,
              //           ),
              //           const SizedBox(width: 10),
              //           const Text('Open in Spotify'),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              );
        } else {
          return ListTile(
            leading: const Icon(Icons.album, size: 50),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${index + 1}. $albumName'),
                isTopList
                    ? Text(
                        'by $artistName',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            subtitle: Text(
                'You listened to this album for ${msToTimeStringShort(timePlayed)}'),
          );
        }
      },
    );
  }
}
