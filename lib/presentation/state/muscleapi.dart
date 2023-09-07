import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/model/entity/muscle/muscle.dart';
import 'package:namer_app/service/muscleservice.dart';

final muscleApiProvider =
    AsyncNotifierProvider<MuscleApiList, List<Muscle>>(MuscleApiList.new);

class MuscleApiList extends AsyncNotifier<List<Muscle>> {
  @override
  FutureOr<List<Muscle>> build() {
    return ref.read(muscleServiceProvider).get();
  }

  Future<void> addMuscle(String name,
      {Function(String message)? onError}) async {
    final currMuscles = state.value ?? [];
    state = AsyncLoading();
    state = await AsyncValue.guard(() async {
      final createdMuscle = await ref.read(muscleServiceProvider).create(name);
      return [...currMuscles, createdMuscle];
    });
    if (state.hasError && onError != null) {
      onError(state.error.toString());
    }
  }
}
