import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:namer_app/model/entity/program/program.dart';

class ProgramEntry extends StatelessWidget {
  final Program program;
  const ProgramEntry({
    required this.program,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(program.name),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.access_time),
          SizedBox(width: 10),
          Text(DateFormat(DateFormat.YEAR_MONTH_DAY).format(program.endDate)),
        ],
      ),
      leading: Icon(Icons.abc),
    );
  }
}
