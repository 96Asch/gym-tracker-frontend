import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/config.dart';
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
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var colorScheme = Theme.of(context).colorScheme;

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: shortestSide < Config.phoneSize ? 2 : 4,
          children: widget.exercises
              .map((e) => ExerciseGridTile(
                    exercise: e,
                    colorScheme: colorScheme,
                  ))
              .toList(),
        ));
  }
}
