import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/calcgriditems.dart';
import 'package:namer_app/model/entity/exercise/exercise.dart';
import 'package:namer_app/presentation/state/selectableexercise.dart';
import 'package:namer_app/presentation/widget/exercise/exercisegridtile.dart';

class SelectableExerciseGrid extends ConsumerWidget {
  final List<Exercise> exercises;

  SelectableExerciseGrid({required this.exercises});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var colorScheme = Theme.of(context).colorScheme;
    final selectedExercises = ref.watch(selectableExerciseProvider);

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          mainAxisSpacing: 10,
          crossAxisSpacing: 15,
          crossAxisCount: getNumGridItems(context),
          children: exercises.map((exercise) {
            return GestureDetector(
              onTap: () {
                if (selectedExercises.contains(exercise)) {
                  ref
                      .read(selectableExerciseProvider.notifier)
                      .remove(exercise);
                } else {
                  ref.read(selectableExerciseProvider.notifier).add(exercise);
                }
              },
              child: ExerciseGridTile(
                showRank: true,
                rank: selectedExercises.contains(exercise)
                    ? selectedExercises.indexOf(exercise) + 1
                    : 0,
                exercise: exercise,
                colorScheme: colorScheme,
                isSelected: selectedExercises.contains(exercise),
              ),
            );
          }).toList(),
        ));
  }
}
