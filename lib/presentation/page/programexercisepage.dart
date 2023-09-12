import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/util.dart';
import 'package:namer_app/model/entity/appmessage.dart';
import 'package:namer_app/model/entity/exercise/exercise.dart';
import 'package:namer_app/model/entity/program/program.dart';
import 'package:namer_app/presentation/state/programexerciseapi.dart';
import 'package:namer_app/presentation/state/setapi.dart';
import 'package:namer_app/presentation/widget/errorsnackbar.dart';
import 'package:namer_app/presentation/widget/expandingfab/actionbutton.dart';
import 'package:namer_app/presentation/widget/expandingfab/expandingfab.dart';
import 'package:namer_app/presentation/widget/set/setlist.dart';

class ProgramExercisePage extends ConsumerStatefulWidget {
  final Program program;

  ProgramExercisePage({required this.program});

  @override
  ConsumerState<ProgramExercisePage> createState() =>
      _ProgramExercisePageState();
}

class _ProgramExercisePageState extends ConsumerState<ProgramExercisePage> {
  int _currentExpandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final allPe = ref.watch(programExerciseApiProvider);

    ref.listen(programExerciseApiProvider, (previous, next) {
      next.maybeWhen(
        error: (error, stackTrace) {
          if (error is AppMessage) {
            print('hello');
            ScaffoldMessenger.of(context)
                .showSnackBar(getErrorSnackbar(Colors.red, error.message));
          }
        },
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.program.name),
      ),
      body: allPe.when(
        skipError: true,
        data: (data) {
          final programExercises = data[widget.program.id];
          int index = 0;

          if (programExercises == null) {
            return Placeholder();
          }

          return RefreshIndicator(
            onRefresh: () async {
              for (final pe in programExercises) {
                await ref
                    .read(setApiProvider.notifier)
                    .loadSet(pe.id, force: true);
              }
              return Future(() => null);
            },
            child: SingleChildScrollView(
              child: ExpansionPanelList(
                  expansionCallback: (panelIndex, isExpanded) {
                    for (final pe in programExercises) {
                      ref.read(setApiProvider.notifier).loadSet(pe.id);
                    }

                    setState(() {
                      _currentExpandedIndex =
                          _currentExpandedIndex == panelIndex ? -1 : panelIndex;
                    });
                  },
                  children: programExercises
                      .where(
                          (element) => element.programId == widget.program.id)
                      .map((e) => ExpansionPanel(
                            canTapOnHeader: true,
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              if (isExpanded) {
                                return ProgramExerciseExpandedHeader(
                                    exercise: e.exercise);
                              }
                              return Center(
                                  child: Text(e.exercise.name.capitalize()));
                            },
                            body: SetList(programExercise: e, sets: e.sets),
                            isExpanded: index++ == _currentExpandedIndex,
                          ))
                      .toList()),
            ),
          );
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => CircularProgressIndicator(),
      ),
      floatingActionButton: ExpandableFab(
        distance: 100,
        children: [
          ActionButton(icon: Icon(Icons.delete_forever)),
        ],
      ),
    );
  }
}

class ProgramExerciseExpandedHeader extends StatelessWidget {
  final Exercise exercise;

  const ProgramExerciseExpandedHeader({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            exercise.name.toUpperCase(),
            style: TextStyle(
              fontSize: 17,
              shadows: [Shadow(offset: Offset(3, 2))],
            ),
          ),
          Text(
            exercise.muscles.map((e) => e.name.capitalize()).join(', '),
            softWrap: true,
            maxLines: 3,
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
