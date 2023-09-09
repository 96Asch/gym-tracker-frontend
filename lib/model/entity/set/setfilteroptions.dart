import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:namer_app/model/entity/mappable.dart';

part 'setfilteroptions.freezed.dart';

@freezed
class SetFilterOptions with _$SetFilterOptions implements Mappable {
  const SetFilterOptions._();

  const factory SetFilterOptions({
    @Default([]) List<int> ids,
    @Default(0) int repetitions,
    @Default([]) List<int> programExerciseIds,
    @Default(null) bool? isDouble,
    @Default(null) bool? nested,
  }) = _SetFilterOptions;

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (ids.isNotEmpty) {
      map['ids'] = ids.join(',');
    }

    if (repetitions > 0) {
      map['repetitions'] = repetitions;
    }

    if (programExerciseIds.isNotEmpty) {
      map['programExerciseIds'] = programExerciseIds.join(',');
    }

    if (isDouble != null) {
      map['nested'] = isDouble;
    }

    if (nested != null) {
      map['nested'] = nested;
    }

    return map;
  }
}
