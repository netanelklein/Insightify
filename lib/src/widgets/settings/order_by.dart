import 'package:flutter/material.dart';
import '../../utils/database_helper.dart';

class SetOrderBy extends StatefulWidget {
  const SetOrderBy({super.key});

  @override
  State<SetOrderBy> createState() => _SetOrderByState();
}

class _SetOrderByState extends State<SetOrderBy> {
  OrderBy? _value = DatabaseHelper().getOrderBy;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Order By', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 10),
        Text('Select the order in which the top lists are sorted:'),
        RadioListTile(
          title: Text('Total Play Time'),
          value: OrderBy.total_ms_played,
          groupValue: _value,
          onChanged: (value) {
            setState(() {
              _value = value;
              DatabaseHelper().setOrderBy = value!;
            });
          },
        ),
        RadioListTile(
          title: Text('Number of Plays'),
          value: OrderBy.times_played,
          groupValue: _value,
          onChanged: (value) {
            setState(() {
              _value = value;
              DatabaseHelper().setOrderBy = value!;
            });
          },
        ),
      ],
    );
  }
}
