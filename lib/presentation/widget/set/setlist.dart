import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/model/entity/program/programexercise.dart';
import 'package:namer_app/model/entity/set/set.dart';
import 'package:namer_app/presentation/state/setapi.dart';
import 'package:namer_app/presentation/widget/set/addsetdialog.dart';
import 'package:namer_app/presentation/widget/set/setentry.dart';

class SetList extends ConsumerStatefulWidget {
  final ProgramExercise programExercise;
  final List<Set> sets;

  const SetList({required this.programExercise, required this.sets});

  @override
  ConsumerState<SetList> createState() => _SetListState();
}

class _SetListState extends ConsumerState<SetList> {
  late List<Set> dismissbleSets;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    dismissbleSets = widget.sets;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...dismissbleSets
            .asMap()
            .entries
            .toList()
            .reversed
            .take(5)
            .toList()
            .reversed
            .map((entry) {
          return Dismissible(
            onDismissed: (direction) {
              ref
                  .read(setApiProvider.notifier)
                  .deleteSet(widget.programExercise.programId, entry.value);
            },
            confirmDismiss: (direction) async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Delete?"),
                  actions: [
                    ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context, true);
                        },
                        child: Text("Confirm"))
                  ],
                ),
              );
              return confirm;
            },
            dismissThresholds: <DismissDirection, double>{
              DismissDirection.endToStart: 0.7
            },
            direction: DismissDirection.endToStart,
            background: Container(
              clipBehavior: Clip.antiAlias,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            key: ValueKey(entry),
            child: SetEntry(
              st: entry.value,
              colorScheme: colorScheme,
              counter: entry.key + 1,
            ),
          );
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
