import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/model/entity/exercise/exercise.dart';

final selectableExerciseProvider = StateNotifierProvider.autoDispose<
    SelectableExerciseNotifier,
    List<Exercise>>((ref) => SelectableExerciseNotifier());

class SelectableExerciseNotifier extends StateNotifier<List<Exercise>> {
  SelectableExerciseNotifier() : super([]);

  void add(Exercise exercise) {
    state = [...state, exercise];
  }

  void remove(Exercise exercise) {
    state = [
      for (final m in state)
        if (m != exercise) m
    ];
  }

  void clear() {
    state = [];
  }
}
