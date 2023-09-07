import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'muscle.freezed.dart';
part 'muscle.g.dart';

@freezed
class Muscle with _$Muscle {
  const factory Muscle({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
  }) = _Muscle;

  factory Muscle.fromJson(Map<String, Object?> json) => _$MuscleFromJson(json);
}
