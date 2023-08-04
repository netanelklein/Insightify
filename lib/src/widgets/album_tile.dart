import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../utils/database_helper.dart';
import '../utils/functions.dart';
import '../../app_state.dart';

class AlbumTile extends StatelessWidget {
  const AlbumTile(
      {super.key,
      required this.artistName,
      required this.albumName,
      required this.timePlayed,
      required this.index});
  final String artistName;
  final String albumName;
  final int timePlayed;
  final int index;

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
            leading: (snapshot.data![0]['cover_art'] == null ||
                    snapshot.data![0]['cover_art'] == '')
                ? const Icon(Icons.album, size: 50)
                : Material(
                    elevation: 7,
                    child: Image.network(snapshot.data![0]['cover_art'])),
            title: Text('${index + 1}. $albumName'),
            subtitle: Text(
                'You listened to this album for ${msToTimeString(timePlayed)}'),
            trailing: PopupMenuButton<String>(
              onSelected: (String result) async {
                Uri url = Uri.parse(
                    "spotify:album:${snapshot.data![0]['spotify_id']}");
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
                      snapshot.data![0]['spotify_id'] != null ? true : false,
                  child: const Text('Open in Spotify'),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );

    // if (album.coverArtUrl == null) {
    //   fetchAlbumCover(album, token, album.tracks[0].id);
    // }
    // return ListTile(
    //   leading: album.coverArtUrl == null
    //       ? const Icon(
    //           Icons.album,
    //           size: 50,
    //         )
    //       : ClipRRect(
    //           borderRadius: BorderRadius.circular(5.0),
    //           child: Image.network(album.coverArtUrl!)),
    //   title: Text('${index + 1}. ${album.name} - ${album.artistName}'),
    //   subtitle: Text(album.toString()),
    //   isThreeLine: true,
    //   trailing: PopupMenuButton<String>(
    //     onSelected: (String result) async {
    //       Uri url = Uri.parse("spotify:album:${album.id}");
    //       if (await canLaunchUrl(url)) {
    //         await launchUrl(url);
    //       } else {
    //         // throw 'Could not launch $url';
    //       }
    //     },
    //     itemBuilder: (context) => <PopupMenuEntry<String>>[
    //       PopupMenuItem<String>(
    //         value: '1',
    //         enabled: album.id != null ? true : false,
    //         child: const Text('Open in Spotify'),
    //       ),
    //     ],
    //   ),
    // );
  }
}
