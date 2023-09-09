import 'dart:async';

import 'package:namer_app/model/entity/program/programexercise.dart';
import 'package:namer_app/model/entity/program/programexercisefilteroptions.dart';

abstract class IProgramExerciseService {
  FutureOr<List<ProgramExercise>> create(List<ProgramExercise> program);
  FutureOr<List<ProgramExercise>> get(ProgramExerciseFilterOptions options);
  FutureOr<ProgramExercise> update(ProgramExercise program);
  FutureOr<void> delete(List<int> ids);
}
