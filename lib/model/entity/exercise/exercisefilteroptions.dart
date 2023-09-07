import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:namer_app/model/entity/mappable.dart';

part 'exercisefilteroptions.freezed.dart';

@freezed
class ExerciseFilterOptions with _$ExerciseFilterOptions implements Mappable {
  const ExerciseFilterOptions._();

  const factory ExerciseFilterOptions({
    @Default([]) List<int> ids,
    @Default('') String name,
    @Default([]) List<int> muscleIds,
  }) = _ExerciseFilterOptions;

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (ids.isNotEmpty) {
      map['ids'] = ids;
    }

    if (name.isNotEmpty) {
      map['name'] = name;
    }

    if (muscleIds.isNotEmpty) {
      map['muscleIds'] = muscleIds;
    }

    return map;
  }
}
