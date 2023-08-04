import 'package:flutter/material.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator(
      {super.key, required this.onChange, int selectedIndex = 0})
      : _selectedIndex = selectedIndex;

  final ValueChanged<int> onChange;
  final int _selectedIndex;

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) => widget.onChange(index),
      selectedIndex: widget._selectedIndex,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: 'Stats',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Top Artists',
        ),
        NavigationDestination(
          icon: Icon(Icons.album_outlined),
          selectedIcon: Icon(Icons.album),
          label: 'Top Albums',
        ),
        NavigationDestination(
          icon: Icon(Icons.music_note_outlined),
          selectedIcon: Icon(Icons.music_note),
          label: 'Top Tracks',
        ),
      ],
    );
  }
}
