import 'package:flutter/material.dart';
import 'package:namer_app/config/util.dart';
import 'package:namer_app/model/entity/exercise/exercise.dart';

class ExerciseGridTile extends StatelessWidget {
  const ExerciseGridTile({
    super.key,
    this.isSelected = false,
    this.rank = 0,
    this.showRank = false,
    required this.colorScheme,
    required this.exercise,
  });

  final int rank;
  final bool isSelected;
  final Exercise exercise;
  final ColorScheme colorScheme;
  final bool showRank;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isSelected) {
      return Transform.scale(
        scale: 0.9,
        child: getBorderContainer(
          Stack(
            children: [
              ColoredBox(color: colorScheme.tertiary, child: getGridTile()),
              if (showRank)
                Transform.translate(
                  offset: Offset(10, 10),
                  child: Text(
                    rank.toString(),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(offset: Offset(3, 2))],
                    ),
                  ),
                )
              else
                Text(""),
            ],
          ),
        ),
      );
    }

    return getBorderContainer(getGridTile());
  }

  Widget getBorderContainer(Widget child) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  Widget getGridTile() {
    return GridTile(
      header: ColoredBox(
        color: colorScheme.primary.withAlpha(150),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            exercise.name.toUpperCase(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      footer: ColoredBox(
        color: colorScheme.primary.withAlpha(200),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(exercise.muscles
              .map((muscle) => muscle.name.capitalize())
              .join(', ')),
        ),
      ),
      child: ColoredBox(
          color: colorScheme.primaryContainer.withAlpha(100), child: null),
    );
  }
}
