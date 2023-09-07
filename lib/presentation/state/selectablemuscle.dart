import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/model/entity/muscle/muscle.dart';

final selectableMuscleProvider =
    StateNotifierProvider.autoDispose<SelectableMuscleNotifier, List<Muscle>>(
        (ref) => SelectableMuscleNotifier());

class SelectableMuscleNotifier extends StateNotifier<List<Muscle>> {
  SelectableMuscleNotifier() : super([]);

  void add(Muscle muscle) {
    state = [...state, muscle];
  }

  void remove(Muscle muscle) {
    state = [
      for (final m in state)
        if (m != muscle) m
    ];
  }

  void clear() {
    state = [];
  }
}
