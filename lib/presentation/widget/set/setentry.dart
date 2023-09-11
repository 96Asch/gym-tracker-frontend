import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:namer_app/model/entity/set/set.dart';

class SetEntry extends StatelessWidget {
  const SetEntry({
    super.key,
    required this.st,
    required this.colorScheme,
    required this.counter,
  });

  final ColorScheme colorScheme;
  final int counter;
  final Set st;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
        leading: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: ColoredBox(
            color: colorScheme.secondary.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text(
                counter.toString(),
                style: TextStyle(
                  fontSize: 15,
                  shadows: [Shadow(offset: Offset(2, 2))],
                ),
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.numbers_sharp),
                    SizedBox(width: 5),
                    Text('${st.repetitions}'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.monitor_weight),
                    SizedBox(width: 5),
                    Text('${st.weightInKg}'),
                    if (st.isDouble)
                      Icon(
                        Icons.keyboard_double_arrow_up,
                        color: colorScheme.primary,
                      )
                  ],
                ),
              ],
            ),
            Text.rich(TextSpan(children: [
              WidgetSpan(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0, 10, 0),
                child: Icon(
                  Icons.edit_calendar_rounded,
                  color: colorScheme.onBackground.withAlpha(150),
                ),
              )),
              TextSpan(
                  text: DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY)
                      .format(st.createdAt!.toLocal())),
            ])),
          ],
        ),
      ),
    );
  }
}
