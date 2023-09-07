import 'package:flutter/material.dart';
import 'package:namer_app/config/util.dart';
import 'package:namer_app/model/entity/muscle/muscle.dart';

class MuscleTile extends StatelessWidget {
  final Muscle muscle;
  final bool isSelected;

  const MuscleTile({required this.muscle, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isSelected) {
      final selectedScheme = colorScheme.copyWith(
          primary: Colors.green, secondary: Colors.green.withAlpha(150));
      return Transform.scale(
        scale: 0.95,
        child: Stack(
          children: [
            Icon(
              Icons.check_outlined,
              color: Colors.black,
              size: 20,
            ),
            getTile(selectedScheme),
          ],
        ),
      );
    }

    return getTile(colorScheme);
  }

  Widget getTile(ColorScheme colorScheme) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: GridTile(
        footer: ColoredBox(
          color: colorScheme.primary.withAlpha(150),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              muscle.name.capitalize(),
              style: TextStyle(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        child: ColoredBox(
            color: colorScheme.secondary.withAlpha(50),
            child: Icon(Icons.wallet)),
      ),
    );
  }
}
