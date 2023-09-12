import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:namer_app/model/entity/program/program.dart';
import 'package:namer_app/model/entity/program/programsort.dart';

part 'programfilter.freezed.dart';

@freezed
class ProgramFilter with _$ProgramFilter {
  const ProgramFilter._();

  const factory ProgramFilter({
    @Default(ProgramSortType.none) ProgramSortType sortBy,
    @Default(ProgramStatus.all) ProgramStatus status,
  }) = _ProgramFilter;

  List<Program> filter(List<Program> programs) {
    print(programs.length);
    List<Program> filteredPrograms = List.from(programs);

    switch (status) {
      case ProgramStatus.ongoing:
        filteredPrograms
            .removeWhere((element) => element.endDate.isBefore(DateTime.now()));
        break;
      case ProgramStatus.finished:
        filteredPrograms
            .removeWhere((element) => element.endDate.isAfter(DateTime.now()));
        break;
      default:
        print("all");
        break;
    }

    switch (sortBy) {
      case ProgramSortType.date:
        filteredPrograms.sort(
          (a, b) => a.endDate.compareTo(b.endDate),
        );
        break;
      case ProgramSortType.name:
        filteredPrograms.sort(
          (a, b) => a.name.compareTo(b.name),
        );
        break;
      default:
        break;
    }

    return filteredPrograms;
  }
}
