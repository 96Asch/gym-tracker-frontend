import 'dart:async';

import 'package:namer_app/model/entity/exercise/exercise.dart';
import 'package:namer_app/model/entity/exercise/exercisefilteroptions.dart';

abstract class IExerciseService {
  FutureOr<Exercise> create(Exercise exercise);
  FutureOr<List<Exercise>> get(ExerciseFilterOptions options);
  FutureOr<Exercise> update(Exercise exercise);
  FutureOr<void> delete(ExerciseFilterOptions options);
}
