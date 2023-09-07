import 'dart:async';

import 'package:namer_app/model/entity/program/program.dart';
import 'package:namer_app/model/entity/program/programfilteroptions.dart';

abstract class IProgramService {
  FutureOr<Program> create(Program program);
  FutureOr<List<Program>> get(ProgramFilterOptions options);
  FutureOr<Program> update(Program program);
  FutureOr<void> delete(List<int> ids);
}
