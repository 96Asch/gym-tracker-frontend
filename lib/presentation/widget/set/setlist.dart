import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:namer_app/config/util.dart';
import 'package:namer_app/model/entity/program/programexercise.dart';
import 'package:namer_app/model/entity/set/set.dart';
import 'package:namer_app/presentation/state/setapi.dart';
import 'package:namer_app/presentation/widget/errorsnackbar.dart';

class SetList extends ConsumerStatefulWidget {
  final ProgramExercise programExercise;
  final List<Set> sets;

  const SetList({required this.programExercise, required this.sets});

  @override
  ConsumerState<SetList> createState() => _SetListState();
}

class _SetListState extends ConsumerState<SetList> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...widget.sets
            .asMap()
            .entries
            .toList()
            .reversed
            .take(5)
            .toList()
            .reversed
            .map((entry) {
          return SetEntry(
              st: entry.value,
              colorScheme: colorScheme,
              counter: entry.key + 1);
        }),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    if (widget.sets.isNotEmpty) {
                      return AddSetDialog(
                        programExercise: widget.programExercise,
                        lastRepetitions: widget.sets.last.repetitions,
                        lastWeight: widget.sets.last.weightInKg,
                        lastDouble: widget.sets.last.isDouble,
                      );
                    }
                    return AddSetDialog(
                      programExercise: widget.programExercise,
                      lastRepetitions: 0,
                      lastWeight: 0,
                      lastDouble: false,
                    );
                  });
            },
            icon: Icon(Icons.add),
            label: Text('Log'),
          ),
        )
      ],
    );
  }
}

class AddSetDialog extends ConsumerStatefulWidget {
  final ProgramExercise programExercise;
  final int lastRepetitions;
  final double lastWeight;
  final bool lastDouble;

  AddSetDialog({
    required this.programExercise,
    required this.lastRepetitions,
    required this.lastWeight,
    required this.lastDouble,
    super.key,
  });

  @override
  ConsumerState<AddSetDialog> createState() => _AddSetDialogState();
}

class _AddSetDialogState extends ConsumerState<AddSetDialog> {
  final _formRepetitionsController = TextEditingController();
  final _formWeightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isDouble = false;

  @override
  void initState() {
    _formRepetitionsController.text = widget.lastRepetitions.toString();
    _formWeightController.text = widget.lastWeight.toString();
    _isDouble = widget.lastDouble;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void showErrorSnackbar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(getErrorSnackbar(
        Colors.white70,
        message,
      ));
    }

    ref.listen(setApiProvider, (previous, next) {
      next.maybeWhen(
        error: (error, stackTrace) {
          showErrorSnackbar(error.toString());
        },
        data: (data) {
          Navigator.pop(context);
        },
        orElse: () {},
      );
    });

    return SimpleDialog(
      title: Text('Log set'),
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || !value.isInt()) {
                        return 'repetitions must be a whole number';
                      }
                      return null;
                    },
                    controller: _formRepetitionsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      icon: Icon(Icons.numbers),
                      labelText: 'Repetitions',
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || !value.isDouble()) {
                        return 'weight must be a number';
                      }
                      return null;
                    },
                    controller: _formWeightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      icon: Icon(Icons.scale),
                      labelText: 'Weight in kg',
                    ),
                  ),
                  CheckboxListTile(
                      title: Text("Double"),
                      tristate: false,
                      value: _isDouble,
                      onChanged: (value) {
                        setState(() {
                          _isDouble = value!;
                        });
                      }),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: ElevatedButton.icon(
            icon: Icon(Icons.done),
            label: Text('Submit'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final newSet = Set(
                  id: 0,
                  programExerciseId: widget.programExercise.id,
                  isDouble: _isDouble,
                  repetitions: int.parse(_formRepetitionsController.text),
                  weightInKg: double.parse(_formWeightController.text),
                );
                ref
                    .read(setApiProvider.notifier)
                    .addSet(widget.programExercise, newSet);
              }
            },
          ),
        ),
      ],
    );
  }
}

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
