import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_state.dart';
import '../../utils/constants.dart';

class HistorySort extends StatelessWidget {
  const HistorySort({
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
            value: HistoryOrderBy.newestFirst,
            child: Row(children: [
              Radio(
                  value: HistoryOrderBy.newestFirst,
                  groupValue: appState.getHistorySort,
                  onChanged: (_) {}),
              const Text('Newest first')
            ]),
          ),
          PopupMenuItem(
            value: HistoryOrderBy.oldestFirst,
            child: Row(children: [
              Radio(
                  value: HistoryOrderBy.oldestFirst,
                  groupValue: appState.getHistorySort,
                  onChanged: (_) {}),
              const Text('Oldest first')
            ]),
          ),
        ],
        onSelected: (value) => appState.setHistorySort = value,
        icon: const Icon(Icons.sort),
      );
    });
  }
}
