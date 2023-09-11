import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/config.dart';
import 'package:namer_app/model/entity/mappable.dart';
import 'package:namer_app/model/entity/program/programexercise.dart';
import 'package:namer_app/model/repository/repository.dart';
import 'package:namer_app/presentation/state/repository.dart';
import 'package:namer_app/repository/neterror.dart';

final programExerciseRepoProvider = Provider((ref) =>
    DioProgramExerciseRepository(
        client: ref.read(dioProvider),
        path: '${Config.serverUrl}/programexercises'));

class DioProgramExerciseRepository implements Repository<ProgramExercise> {
  final Dio client;
  final String path;

  const DioProgramExerciseRepository(
      {required this.client, required this.path});

  @override
  FutureOr<List<ProgramExercise>> get(Mappable options) async {
    try {
      final Response response = await client.get(
        path,
        queryParameters: options.toMap(),
      );
      final programExerciseJson =
          (response.data as Map<String, dynamic>)['programExercises'];
      final programExercises = (programExerciseJson as List)
          .map((json) => ProgramExercise.fromJson(json))
          .toList();

      return programExercises;
    } catch (e) {
      throw parseNetworkError(e);
    }
  }

  @override
  FutureOr<ProgramExercise> post(ProgramExercise model) async {
    try {
      final response = await client.post(path, data: {
        "order": model.order,
        "programId": model.programId,
        "exerciseId": model.exercise.id,
      });
      final programExercise =
          ProgramExercise.fromJson(response.data['programExercise']);

      return programExercise;
    } catch (e) {
      throw parseNetworkError(e);
    }
  }

  @override
  FutureOr<ProgramExercise> update(ProgramExercise model) async {
    try {
      final response = await client.put('$path/${model.id}', data: {
        "order": model.order,
      });
      final programExercise =
          ProgramExercise.fromJson(response.data['programExercise']);

      return programExercise;
    } catch (e) {
      throw parseNetworkError(e);
    }
  }

  @override
  FutureOr<void> delete(Mappable options) async {
    try {
      await client.delete(
        path,
        queryParameters: options.toMap(),
      );
    } catch (e) {
      throw parseNetworkError(e);
    }
  }

  @override
  FutureOr<List<ProgramExercise>> postBulk(List<ProgramExercise> models) async {
    print("PostBulk");
    try {
      final body = models
          .map((model) => {
                "order": model.order,
                "programId": model.programId,
                "exerciseId": model.exercise.id,
              })
          .toList();
      final response = await client.post(path, data: {
        'programExercises': body,
      });

      final programExerciseJson =
          (response.data as Map<String, dynamic>)['programExercises'];
      final programExercises = (programExerciseJson as List)
          .map((json) => ProgramExercise.fromJson(json))
          .toList();

      return programExercises;
    } catch (e) {
      throw parseNetworkError(e);
    }
  }
}
