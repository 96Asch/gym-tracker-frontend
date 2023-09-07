import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:namer_app/model/entity/mappable.dart';

part 'musclefilteroptions.freezed.dart';

@freezed
class MuscleFilterOptions with _$MuscleFilterOptions implements Mappable {
  const MuscleFilterOptions._();

  const factory MuscleFilterOptions({
    @Default([]) List<int> ids,
    @Default('') String name,
  }) = _MuscleFilterOptions;

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (ids.isNotEmpty) {
      map['ids'] = ids;
    }

    if (name.isNotEmpty) {
      map['name'] = name;
    }

    return map;
  }
}
