import 'dart:async';

import 'package:namer_app/model/entity/mappable.dart';

abstract class Repository<Model> {
  FutureOr<List<Model>> get(Mappable options);
  FutureOr<Model> post(Model model);
  FutureOr<Model> update(Model model);
  FutureOr<void> delete(Mappable options);
}
