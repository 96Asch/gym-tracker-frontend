import 'dart:async';

import 'package:namer_app/model/entity/muscle/muscle.dart';

abstract class IMuscleService {
  FutureOr<Muscle> create(String name);
  FutureOr<List<Muscle>> get();
  FutureOr<Muscle> update(Muscle muscle);
  FutureOr<void> delete(List<int> ids);
}
