import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/model/entity/program/program.dart';
import 'package:namer_app/model/entity/program/programfilteroptions.dart';
import 'package:namer_app/service/programservice.dart';

final programApiProvider =
    AsyncNotifierProvider<ProgramApiList, List<Program>>(ProgramApiList.new);

class ProgramApiList extends AsyncNotifier<List<Program>> {
  @override
  FutureOr<List<Program>> build() {
    return ref
        .read(programServiceProvider)
        .get(ProgramFilterOptions(nested: false));
  }

  Future<void> addProgram(Program program) async {
    final currPrograms = state.value ?? [];
    state = AsyncLoading();
    state = await AsyncValue.guard(() async {
      final createdProgram =
          await ref.read(programServiceProvider).create(program);
      return [...currPrograms, createdProgram];
    });
  }
}
