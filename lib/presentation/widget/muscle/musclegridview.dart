import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:namer_app/model/entity/muscle/muscle.dart';
import 'package:namer_app/presentation/state/muscleapi.dart';
import 'package:namer_app/presentation/widget/muscle/muscletile.dart';

class MuscleGridView extends ConsumerStatefulWidget {
  final List<Muscle> muscles;
  final int numTilesPerRow;

  const MuscleGridView({required this.muscles, required this.numTilesPerRow});

  @override
  ConsumerState<MuscleGridView> createState() => _MuscleGridViewState();
}

class _MuscleGridViewState extends ConsumerState<MuscleGridView> {
  final List<Muscle> _selectedMuscles = [];
  bool inMultiSelect = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 4;
    final double itemWidth = size.width / 2;

    return RefreshIndicator(
      onRefresh: () {
        ref.invalidate(muscleApiProvider);
        return Future(() => null);
      },
      child: ScrollShadow(
        size: 10,
        child: GridView.count(
          childAspectRatio: itemWidth / itemHeight,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          crossAxisCount: widget.numTilesPerRow,
          children: widget.muscles
              .map(
                (muscle) => GestureDetector(
                  onTap: () {
                    if (inMultiSelect) {
                      setState(() {
                        _selectedMuscles.contains(muscle)
                            ? _selectedMuscles.remove(muscle)
                            : _selectedMuscles.add(muscle);
                      });
                    }
                  },
                  child: MuscleTile(
                    muscle: muscle,
                    isSelected: _selectedMuscles.contains(muscle),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
