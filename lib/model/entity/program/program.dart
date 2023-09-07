import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:namer_app/model/entity/program/programexercise.dart';

part 'program.freezed.dart';
part 'program.g.dart';

@freezed
class Program with _$Program {
  const factory Program({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'endDate') required DateTime endDate,
    @JsonKey(name: 'ProgramExercises')
    @Default([])
    List<ProgramExercise> exercises,
  }) = _Program;

  factory Program.fromJson(Map<String, Object?> json) =>
      _$ProgramFromJson(json);
}
