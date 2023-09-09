import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:namer_app/model/entity/exercise/exercise.dart';
import 'package:namer_app/model/entity/set/set.dart';

part 'programexercise.freezed.dart';
part 'programexercise.g.dart';

@freezed
class ProgramExercise with _$ProgramExercise {
  const factory ProgramExercise({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'order') required int order,
    @JsonKey(name: 'programId') required int programId,
    @JsonKey(name: 'Exercise') required Exercise exercise,
    @JsonKey(name: 'Sets') required List<Set> sets,
  }) = _ProgramExercise;

  factory ProgramExercise.fromJson(Map<String, Object?> json) =>
      _$ProgramExerciseFromJson(json);
}
