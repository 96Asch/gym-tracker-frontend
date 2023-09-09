import 'dart:async';

import 'package:namer_app/model/entity/set/setfilteroptions.dart';
import 'package:namer_app/model/entity/set/set.dart';

abstract class ISetService {
  FutureOr<Set> create(Set model);
  FutureOr<List<Set>> get(SetFilterOptions options);
  FutureOr<Set> update(Set model);
  FutureOr<void> delete(List<int> ids);
}
