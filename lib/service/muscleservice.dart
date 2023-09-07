import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/model/entity/muscle/muscle.dart';
import 'package:namer_app/model/entity/muscle/musclefilteroptions.dart';
import 'package:namer_app/model/repository/repository.dart';
import 'package:namer_app/model/service/muscle.dart';
import 'package:namer_app/repository/musclerepository.dart';

final muscleServiceProvider = Provider<MuscleService>(
    (ref) => MuscleService(repository: ref.read(muscleRepoProvider)));

class MuscleService implements IMuscleService {
  final Repository<Muscle> repository;

  MuscleService({required this.repository});

  @override
  FutureOr<Muscle> create(String name) async {
    if (name.isEmpty) {
      throw Exception('name cannot be empty');
    }

    if (name.contains(RegExp(r'[^A-Za-z\s]'))) {
      throw Exception('name can only contain letters');
    }

    return await repository.post(Muscle(id: 0, name: name));
  }

  @override
  FutureOr<List<Muscle>> get() async {
    return await repository.get(MuscleFilterOptions());
  }

  @override
  FutureOr<Muscle> update(Muscle muscle) async {
    if (muscle.id == 0) {
      throw Exception('must select a valid muscle');
    }

    if (muscle.name.isEmpty) {
      throw Exception('name cannot be empty');
    }

    if (muscle.name.contains(RegExp(r'[^A-Za-z\s]'))) {
      throw Exception('name can only contain letters');
    }

    return await repository.update(muscle);
  }

  @override
  FutureOr<void> delete(List<int> ids) async {
    await repository.delete(MuscleFilterOptions(ids: ids));
  }
}
