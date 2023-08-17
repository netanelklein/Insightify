import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_state.dart';
import '../../screens/artist_page.dart';
import '../../utils/functions.dart';
import '../../utils/database_helper.dart';
import '../../widgets/common/spotify_button.dart';

class ArtistTile extends StatelessWidget {
  const ArtistTile(
      {super.key,
      required this.artistName,
      required this.index,
      required this.timePlayed});

  final String artistName;
  final int index;
  final int timePlayed;

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<AppState>(context).accessToken;
    final artistMetadata =
        DatabaseHelper().getArtistMetadata(artistName, token);

    return FutureBuilder(
        future: artistMetadata,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListTile(
              enabled: true,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ArtistPage(
                          artistName: artistName, timePlayed: timePlayed))),
              leading: (snapshot.data![0]['image'] == null ||
                      snapshot.data![0]['image'] == '')
                  ? const Icon(Icons.person, size: 50)
                  : Material(
                      elevation: 7,
                      child: Image.network(snapshot.data![0]['image'])),
              title: Text('${index + 1}. $artistName'),
              subtitle: Text(
                  'You listened to this artist for ${msToTimeStringShort(timePlayed)}'),
              trailing: snapshot.data![0]['spotify_id'] != null
                  ? IconButton(
                      tooltip: 'OPEN SPOTIFY',
                      onPressed: () => openSpotify(
                          'spotify:artist:${snapshot.data![0]['spotify_id']}'),
                      icon: SpotifyButton())
                  // PopupMenuButton<String>(
                  //     onSelected: (String result) async {
                  //       Uri url = Uri.parse(
                  //           "spotify:artist:${snapshot.data![0]['spotify_id']}");
                  //       if (await canLaunchUrl(url)) {
                  //         await launchUrl(url);
                  //       } else {
                  //         // throw 'Could not launch $url';
                  //       }
                  //     },
                  //     itemBuilder: (context) => <PopupMenuEntry<String>>[
                  //       PopupMenuItem<String>(
                  //         value: '1',
                  //         enabled: snapshot.data![0]['spotify_id'] != null
                  //             ? true
                  //             : false,
                  //         child: const Text('Open in Spotify'),
                  //       ),
                  //     ],
                  //   )
                  : null,
            );
          } else {
            return ListTile(
              leading: const Icon(Icons.person, size: 50),
              title: Text('${index + 1}. $artistName'),
              subtitle: Text(
                  'You listened to this artist for ${msToTimeStringShort(timePlayed)}'),
            );
          }
        });
  }
}
