import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/calcgriditems.dart';
import 'package:namer_app/model/entity/exercise/exercise.dart';
import 'package:namer_app/presentation/widget/exercise/exercisegridtile.dart';

class ExerciseGrid extends ConsumerStatefulWidget {
  final List<Exercise> exercises;

  ExerciseGrid({required this.exercises});

  @override
  ConsumerState<ExerciseGrid> createState() => _ExerciseGridState();
}

class _ExerciseGridState extends ConsumerState<ExerciseGrid> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          mainAxisSpacing: 15,
          childAspectRatio: (itemWidth / itemHeight),
          crossAxisSpacing: 15,
          crossAxisCount: getNumGridItems(context),
          children: widget.exercises
              .map((e) => ExerciseGridTile(
                    isSelected: false,
                    exercise: e,
                    colorScheme: colorScheme,
                  ))
              .toList(),
        ));
  }
}
