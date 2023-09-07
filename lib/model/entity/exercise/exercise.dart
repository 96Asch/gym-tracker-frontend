import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:namer_app/model/entity/muscle/muscle.dart';

part 'exercise.freezed.dart';
part 'exercise.g.dart';

@freezed
class Exercise with _$Exercise {
  const factory Exercise({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'Muscles') required List<Muscle> muscles,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, Object?> json) =>
      _$ExerciseFromJson(json);
}
