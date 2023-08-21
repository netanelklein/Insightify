import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_state.dart';
import '../../utils/constants.dart';

class TopListsSort extends StatelessWidget {
  const TopListsSort({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, _) {
      return PopupMenuButton(
        position: PopupMenuPosition.under,
        tooltip: 'Sort by',
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          PopupMenuItem(
            value: TopListsOrderBy.time,
            child: Row(children: [
              Radio(
                  value: TopListsOrderBy.time,
                  groupValue: appState.getListsSort,
                  onChanged: (_) {}),
              const Text('Total play time')
            ]),
          ),
          PopupMenuItem(
            value: TopListsOrderBy.timesPlayed,
            child: Row(children: [
              Radio(
                  value: TopListsOrderBy.timesPlayed,
                  groupValue: appState.getListsSort,
                  onChanged: (_) {}),
              const Text('Amount of times played')
            ]),
          ),
        ],
        onSelected: (value) => appState.setListsSort = value,
        icon: const Icon(Icons.sort),
      );
    });
  }
}
