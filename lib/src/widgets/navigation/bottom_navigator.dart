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
          key: Key('statsNavigator'),
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: 'Stats',
        ),
        NavigationDestination(
          key: Key('topListsNavigator'),
          icon: Icon(Icons.list_alt_outlined),
          selectedIcon: Icon(Icons.list_alt),
          label: 'Top Lists',
        ),
        NavigationDestination(
          key: Key('historyNavigator'),
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(Icons.history),
          label: 'History',
        ),
      ],
    );
  }
}
