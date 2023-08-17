import 'package:flutter/material.dart';
// import '../widgets/settings/min_count.dart';
// import '../widgets/settings/order_by.dart';
import '../widgets/settings/clear_data.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back)),
        elevation: 2,
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            // const MinCount(),
            // const Divider(),
            // const SetOrderBy(),
            // const Divider(),
            ClearData(key: Key('clearDataWidget')),
          ],
        ),
      ),
    );
  }
}
