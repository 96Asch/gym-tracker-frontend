import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/model/entity/set/set.dart';
import 'package:namer_app/model/entity/set/setfilteroptions.dart';
import 'package:namer_app/model/repository/repository.dart';
import 'package:namer_app/model/service/set.dart';
import 'package:namer_app/repository/setrepository.dart';

final setServiceProvider = Provider(
  (ref) => SetService(
    repository: ref.read(setRepoProvider),
  ),
);

class SetService implements ISetService {
  final Repository<Set> repository;

  const SetService({required this.repository});

  @override
  FutureOr<Set> create(Set model) async {
    if (model.repetitions < 0) {
      throw Exception('repetitions cannot be negative');
    }

    if (model.weightInKg < 0) {
      throw Exception('weightInKg cannot be negative');
    }

    if (model.programExerciseId <= 0) {
      throw Exception('program exercise cannot be empty');
    }

    return await repository.post(model);
  }

  @override
  FutureOr<void> delete(List<int> ids) async {
    await repository.delete(SetFilterOptions(ids: ids));
  }

  @override
  FutureOr<List<Set>> get(SetFilterOptions options) async {
    return await repository.get(options);
  }

  @override
  FutureOr<Set> update(Set model) async {
    if (model.id <= 0) {
      throw Exception('id cannot be empty');
    }

    if (model.programExerciseId <= 0) {
      throw Exception('program exercise cannot be empty');
    }

    if (model.repetitions < 0) {
      throw Exception('repetitions cannot be negative');
    }

    if (model.weightInKg < 0) {
      throw Exception('weightInKg cannot be negative');
    }

    return await repository.update(model);
  }
}
