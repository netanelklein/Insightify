import 'package:flutter/material.dart';

class SetOrderBy extends StatefulWidget {
  const SetOrderBy({super.key});

  @override
  State<SetOrderBy> createState() => _SetOrderByState();
}

class _SetOrderByState extends State<SetOrderBy> {
  // OrderBy? _value = DatabaseHelper().getOrderBy;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Order By', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        const Text('Select the order in which the top lists are sorted:'),
        // RadioListTile(
        //   title: const Text('Total Play Time'),
        //   value: OrderBy.totalMsPlayed,
        //   groupValue: _value,
        //   onChanged: (value) {
        //     setState(() {
        //       _value = value;
        //       DatabaseHelper().setOrderBy = value!;
        //     });
        //   },
        // ),
        // RadioListTile(
        //   title: const Text('Number of Plays'),
        //   value: OrderBy.timesPlayed,
        //   groupValue: _value,
        //   onChanged: (value) {
        //     setState(() {
        //       _value = value;
        //       DatabaseHelper().setOrderBy = value!;
        //     });
        //   },
        // ),
      ],
    );
  }
}
