import 'package:flutter/material.dart';

class SpotifyButton extends StatelessWidget {
  const SpotifyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Theme.of(context).brightness == Brightness.light
          ? 'assets/icons/Spotify_Icon_RGB_Black.png'
          : 'assets/icons/Spotify_Icon_RGB_White.png',
      height: 24,
      width: 24,
    );
  }
}
