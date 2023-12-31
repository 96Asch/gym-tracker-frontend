import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/config.dart';
import 'package:namer_app/model/entity/exercise/exercise.dart';
import 'package:namer_app/model/entity/mappable.dart';
import 'package:namer_app/model/repository/repository.dart';
import 'package:namer_app/presentation/state/repository.dart';
import 'package:namer_app/repository/neterror.dart';

final exerciseRepoProvider = Provider(
  (ref) => DioExerciseRepository(
    client: ref.read(dioProvider),
    path: '${Config.serverUrl}/exercises',
  ),
);

class DioExerciseRepository implements Repository<Exercise> {
  final Dio client;
  final String path;

  const DioExerciseRepository({required this.client, required this.path});

  @override
  FutureOr<Exercise> post(Exercise exercise) async {
    try {
      final response = await client.post(
        path,
        data: {
          'name': exercise.name,
          'muscleIds': exercise.muscles.map((muscle) => muscle.id).toList(),
        },
      );

      final createdExercise = Exercise.fromJson(response.data['exercise']);

      return createdExercise;
    } catch (e) {
      throw parseNetworkError(e);
    }
  }

  @override
  FutureOr<List<Exercise>> get(Mappable options) async {
    try {
      final response = await client.get(
        path,
        queryParameters: options.toMap(),
      );

      final jsonList = response.data['exercises'] as List;
      final exercises = jsonList.map((json) => Exercise.fromJson(json));

      return exercises.toList();
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
  FutureOr<Exercise> update(Exercise exercise) async {
    try {
      final response = await client.patch(
        '$path/${exercise.id}',
        data: {
          'name': exercise.name,
          'muscleIds': exercise.muscles.map((muscle) => muscle.id),
        },
      );

      final createdExercise = Exercise.fromJson(response.data['exercise']);

      return createdExercise;
    } catch (e) {
      throw parseNetworkError(e);
    }
  }

  @override
  FutureOr<List<Exercise>> postBulk(List<Exercise> models) {
    return [];
  }
}
