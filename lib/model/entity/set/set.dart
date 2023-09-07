import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'set.freezed.dart';
part 'set.g.dart';

@freezed
class Set with _$Set {
  const factory Set({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'repetitions') required int repetitions,
    @JsonKey(name: 'weightInKg') required int weightInKg,
    @JsonKey(name: 'double') required bool isDouble,
  }) = _Set;

  factory Set.fromJson(Map<String, Object?> json) => _$SetFromJson(json);
}
