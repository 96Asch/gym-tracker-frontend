import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/model/entity/program/program.dart';
import 'package:namer_app/model/entity/program/programfilteroptions.dart';
import 'package:namer_app/model/repository/repository.dart';
import 'package:namer_app/model/service/program.dart';
import 'package:namer_app/repository/programrepository.dart';

final programServiceProvider = Provider(
  (ref) => ProgramService(
    repository: ref.read(programRepoProvider),
  ),
);

class ProgramService implements IProgramService {
  final Repository<Program> repository;
  const ProgramService({required this.repository});

  @override
  FutureOr<List<Program>> get(ProgramFilterOptions options) async {
    return await repository.get(options);
  }

  @override
  FutureOr<Program> create(Program program) async {
    if (program.name.isEmpty) {
      throw Exception('name cannot be empty');
    }

    if (program.endDate.isBefore(DateTime.now())) {
      throw Exception('end date cannot be earlier than now');
    }

    return await repository.post(program);
  }

  @override
  FutureOr<void> delete(List<int> ids) async {
    await repository.delete(ProgramFilterOptions(ids: ids));
  }

  @override
  FutureOr<Program> update(Program program) async {
    if (program.id == 0) {
      throw Exception('no valid program selected');
    }

    if (program.name.isEmpty) {
      throw Exception('name cannot be empty');
    }

    if (program.endDate.isBefore(DateTime.now())) {
      throw Exception('end date cannot be earlier than now');
    }

    return await repository.update(program);
  }
}
