import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/model/entity/program/programexercise.dart';
import 'package:namer_app/model/entity/program/programexercisefilteroptions.dart';
import 'package:namer_app/model/repository/repository.dart';
import 'package:namer_app/model/service/programexercise.dart';
import 'package:namer_app/repository/programexerciserepository.dart';

final programExerciseServiceProvider = Provider(
  (ref) => ProgramExerciseService(
    repository: ref.read(programExerciseRepoProvider),
  ),
);

class ProgramExerciseService implements IProgramExerciseService {
  final Repository<ProgramExercise> repository;

  const ProgramExerciseService({required this.repository});

  @override
  FutureOr<List<ProgramExercise>> create(List<ProgramExercise> models) async {
    final List<int> chosenOrders = [];

    for (final model in models) {
      if (model.programId == 0) {
        throw Exception('programId cannot be 0');
      }

      if (model.exercise.id == 0) {
        throw Exception('exercise is invalid');
      }

      if (chosenOrders.contains(model.order)) {
        throw Exception('cannot have exercises with the same order');
      }

      chosenOrders.add(model.order);
      if (model.order < 0) {
        throw Exception('order cannot be negative');
      }
    }

    return await repository.postBulk(models);
  }

  @override
  FutureOr<void> delete(List<int> ids) async {
    return await repository.delete(ProgramExerciseFilterOptions(ids: ids));
  }

  @override
  FutureOr<List<ProgramExercise>> get(
      ProgramExerciseFilterOptions options) async {
    return await repository.get(options);
  }

  @override
  FutureOr<ProgramExercise> update(ProgramExercise model) async {
    if (model.id < 0) {
      throw Exception('id cannot be empty');
    }

    if (model.order < 0) {
      throw Exception('order cannot be negative');
    }

    return await repository.update(model);
  }
}
