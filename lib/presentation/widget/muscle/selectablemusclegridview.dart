import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:namer_app/model/entity/muscle/muscle.dart';
import 'package:namer_app/presentation/state/selectablemuscle.dart';
import 'package:namer_app/presentation/widget/muscle/muscletile.dart';

class SelectableMuscleGridView extends ConsumerWidget {
  final List<Muscle> muscles;
  final int numTilesPerRow;

  const SelectableMuscleGridView(
      {required this.muscles, required this.numTilesPerRow});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Muscle> selected = ref.watch(selectableMuscleProvider);

    return ScrollShadow(
      size: 10,
      child: GridView.count(
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: numTilesPerRow,
        children: muscles
            .map(
              (muscle) => GestureDetector(
                onTap: () {
                  selected.contains(muscle)
                      ? ref
                          .read(selectableMuscleProvider.notifier)
                          .remove(muscle)
                      : ref.read(selectableMuscleProvider.notifier).add(muscle);
                },
                child: MuscleTile(
                  muscle: muscle,
                  isSelected: selected.contains(muscle),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
