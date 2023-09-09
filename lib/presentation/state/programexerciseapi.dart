import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/model/entity/program/programexercise.dart';
import 'package:namer_app/model/entity/program/programexercisefilteroptions.dart';
import 'package:namer_app/service/programexercise.dart';
import 'package:namer_app/model/entity/set/set.dart';

final programExerciseApiProvider = AsyncNotifierProvider<ProgramExerciseApiList,
    Map<int, List<ProgramExercise>>>(ProgramExerciseApiList.new);

class ProgramExerciseApiList
    extends AsyncNotifier<Map<int, List<ProgramExercise>>> {
  @override
  Map<int, List<ProgramExercise>> build() {
    return <int, List<ProgramExercise>>{};
  }

  Future<void> loadProgramExercises(int programId, {bool force = false}) async {
    final Map<int, List<ProgramExercise>> currentProgramExercises =
        state.valueOrNull ?? <int, List<ProgramExercise>>{};

    if (force || !currentProgramExercises.containsKey(programId)) {
      state = AsyncLoading();
      state = await AsyncValue.guard(() async {
        final programExercises = await ref
            .read(programExerciseServiceProvider)
            .get(ProgramExerciseFilterOptions(programIds: [programId]))
          ..sort(
            (a, b) => a.order.compareTo(b.order),
          );

        return {
          ...currentProgramExercises
            ..removeWhere((key, value) => key == programId),
          programId: programExercises,
        };
      });
    }
    return Future(() => null);
  }

  Future<void> addProgramExercises(
      int programId, List<ProgramExercise> exercises) async {
    final Map<int, List<ProgramExercise>> currentProgramExercises =
        state.valueOrNull ?? <int, List<ProgramExercise>>{};

    state = AsyncLoading();
    state = await AsyncValue.guard(() async {
      final programExercises =
          await ref.read(programExerciseServiceProvider).create(exercises);

      return {
        ...currentProgramExercises,
        programId: programExercises,
      };
    });
    return Future(() => null);
  }

  Future<void> addSet(int programId, Set model) async {
    final Map<int, List<ProgramExercise>> currentPeMap =
        state.valueOrNull ?? <int, List<ProgramExercise>>{};

    if (currentPeMap.containsKey(programId)) {
      state = AsyncLoading();
      final peIndex = currentPeMap[programId]!
          .indexWhere((element) => element.id == model.programExerciseId);

      if (peIndex != -1) {
        final programExercise = currentPeMap[programId]![peIndex].copyWith(
            sets: [...currentPeMap[programId]![peIndex].sets, model]
              ..sort((a, b) => a.createdAt!.compareTo(b.createdAt!)));

        final programExercises = [
          ...currentPeMap[programId]!
              .where((element) => element.id != programExercise.id),
          programExercise
        ]..sort((a, b) => a.order.compareTo(b.order));

        final filteredPeMap = currentPeMap..remove(programExercise.programId);

        state = AsyncData({
          ...filteredPeMap,
          ...{programId: programExercises}
        });
      } else {
        state = AsyncError("could not insert the set", StackTrace.current);
      }

      print("newState");
    }
  }
}
