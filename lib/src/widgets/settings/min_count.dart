import 'package:flutter/material.dart';
import '../../utils/database_helper.dart';

class MinCount extends StatefulWidget {
  const MinCount({super.key});

  @override
  State<MinCount> createState() => _MinCountState();
}

class _MinCountState extends State<MinCount> {
  double _value = DatabaseHelper().getMinTime.toDouble();
  void _onChanged(double value) {
    setState(() {
      _value = value;
      DatabaseHelper().setMinTime = value.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Minimum Play Time',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        const Text(
            'Set the minimum time (in seconds) a song must be played to be counted as a play:'),
        Slider(
            value: _value,
            onChanged: _onChanged,
            min: 0,
            max: 60,
            divisions: 60,
            label: _value.round().toString()),
      ],
    );
  }
}
