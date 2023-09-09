import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/model/entity/program/programexercise.dart';
import 'package:namer_app/model/entity/set/set.dart';
import 'package:namer_app/model/entity/set/setfilteroptions.dart';
import 'package:namer_app/presentation/state/programexerciseapi.dart';
import 'package:namer_app/service/setservice.dart';

final setApiProvider =
    AsyncNotifierProvider<SetApiList, List<Set>>(SetApiList.new);

class SetApiList extends AsyncNotifier<List<Set>> {
  final List<int> loadedSets = [];

  @override
  FutureOr<List<Set>> build() {
    return [];
  }

  Future<void> loadSet(int programExerciseId, {bool force = false}) async {
    if (force || (!loadedSets.contains(programExerciseId))) {
      final currentSets = state.value ?? [];
      state = AsyncLoading();
      state = await AsyncValue.guard(() async {
        final programs = await ref
            .read(setServiceProvider)
            .get(SetFilterOptions(programExerciseIds: [programExerciseId]));
        loadedSets.add(programExerciseId);

        return [
          ...currentSets
              .where(
                  (element) => (element.programExerciseId != programExerciseId))
              .toList(),
          ...programs
        ];
      });
      print(state.value!.length);
    }
    return Future(() => null);
  }

  Future<void> addSet(ProgramExercise pe, Set model) async {
    final currSets = state.value ?? [];
    state = AsyncLoading();
    state = await AsyncValue.guard(() async {
      final createdSet = await ref.read(setServiceProvider).create(model);
      await ref
          .read(programExerciseApiProvider.notifier)
          .addSet(pe.programId, createdSet);
      return [...currSets, createdSet];
    });
  }
}
