import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:namer_app/model/entity/mappable.dart';

part 'programfilteroptions.freezed.dart';

@freezed
class ProgramFilterOptions with _$ProgramFilterOptions implements Mappable {
  const ProgramFilterOptions._();

  const factory ProgramFilterOptions({
    @Default([]) List<int> ids,
    @Default(null) DateTime? before,
    @Default(null) bool? finished,
    @Default(null) bool? nested,
  }) = _ProgramFilterOptions;

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (ids.isNotEmpty) {
      map['ids'] = ids.join(',');
    }

    if (before != null) {
      map['before'] = before.toString();
    }

    if (finished != null) {
      map['finished'] = finished;
    }

    if (nested != null) {
      map['nested'] = nested;
    }

    return map;
  }
}
