import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/model/entity/exercise/exercise.dart';
import 'package:namer_app/model/entity/exercise/exercisefilteroptions.dart';
import 'package:namer_app/model/repository/repository.dart';
import 'package:namer_app/model/service/exercise.dart';
import 'package:namer_app/repository/exerciserepository.dart';

final exerciseServiceProvider = Provider(
  (ref) => ExerciseService(
    repository: ref.read(exerciseRepoProvider),
  ),
);

class ExerciseService implements IExerciseService {
  final Repository<Exercise> repository;

  const ExerciseService({required this.repository});

  @override
  FutureOr<Exercise> create(Exercise exercise) async {
    if (exercise.muscles.isEmpty) {
      throw Exception('must inlude at least one muscle');
    }

    if (exercise.name.isEmpty) {
      throw Exception('name cannot be empty');
    }

    return await repository.post(exercise);
  }

  @override
  FutureOr<List<Exercise>> get(ExerciseFilterOptions options) async {
    return await repository.get(options);
  }

  @override
  FutureOr<Exercise> update(Exercise exercise) async {
    if (exercise.id == 0) {
      throw Exception('must select a valid exercise');
    }

    return await repository.update(exercise);
  }

  @override
  FutureOr<void> delete(ExerciseFilterOptions options) async {
    return await repository.delete(options);
  }
}
