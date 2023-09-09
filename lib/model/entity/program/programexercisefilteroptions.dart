import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:namer_app/model/entity/mappable.dart';

part 'programexercisefilteroptions.freezed.dart';

@freezed
class ProgramExerciseFilterOptions
    with _$ProgramExerciseFilterOptions
    implements Mappable {
  const ProgramExerciseFilterOptions._();

  const factory ProgramExerciseFilterOptions({
    @Default([]) List<int> ids,
    @Default([]) List<int> programIds,
    @Default([]) List<int> exerciseIds,
  }) = _ProgramExerciseFilterOptions;

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (ids.isNotEmpty) {
      map['ids'] = ids.join(',');
    }

    if (programIds.isNotEmpty) {
      map['programIds'] = programIds.join(',');
    }

    if (ids.isNotEmpty) {
      map['exerciseIds'] = exerciseIds.join(',');
    }

    return map;
  }
}
