import 'package:flutter/material.dart';
import 'package:namer_app/config/util.dart';
import 'package:namer_app/model/entity/exercise/exercise.dart';

class ExerciseGridTile extends StatelessWidget {
  const ExerciseGridTile({
    super.key,
    required this.colorScheme,
    required this.exercise,
  });

  final Exercise exercise;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.primary.withAlpha(150),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GridTile(
        header: ColoredBox(
          color: colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              exercise.name.toUpperCase(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        footer: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(exercise.muscles
              .map((muscle) => muscle.name.capitalize())
              .join(', ')),
        ),
        child: Icon(Icons.ac_unit_outlined),
      ),
    );
  }
}
