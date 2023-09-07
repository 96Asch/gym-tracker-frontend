import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/model/entity/exercise/exercise.dart';
import 'package:namer_app/model/entity/exercise/exercisefilteroptions.dart';
import 'package:namer_app/service/exerciseservice.dart';

final exerciseApiProvider =
    AsyncNotifierProvider<ExerciseApiList, List<Exercise>>(ExerciseApiList.new);

class ExerciseApiList extends AsyncNotifier<List<Exercise>> {
  @override
  FutureOr<List<Exercise>> build() {
    return ref.read(exerciseServiceProvider).get(ExerciseFilterOptions());
  }

  Future<void> addExercise(Exercise exercise) async {
    final currExercises = state.value ?? [];
    state = AsyncLoading();
    state = await AsyncValue.guard(() async {
      final createdExercise =
          await ref.read(exerciseServiceProvider).create(exercise);
      return [...currExercises, createdExercise];
    });
  }
}
