import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/model/entity/program/programfilter.dart';

final programFilterProvider =
    StateProvider.autoDispose<ProgramFilter>((ref) => ProgramFilter());
