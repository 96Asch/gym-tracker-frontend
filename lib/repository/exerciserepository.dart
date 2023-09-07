import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/config.dart';
import 'package:namer_app/model/entity/exercise/exercise.dart';
import 'package:namer_app/model/entity/mappable.dart';
import 'package:namer_app/model/repository/repository.dart';
import 'package:namer_app/presentation/state/repository.dart';

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
    } on DioException catch (e) {
      print(e);

      var errorMessage = e.message;
      if (e.response != null) {
        errorMessage = (e.response!.data as Map<String, dynamic>)['error'];
      }

      throw Exception(errorMessage);
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
    } on DioException catch (e) {
      var errorMessage = e.message;
      if (e.response != null) {
        errorMessage = (e.response!.data as Map<String, dynamic>)['error'];
      }

      throw Exception(errorMessage);
    }
  }

  @override
  FutureOr<void> delete(Mappable options) async {
    try {
      await client.delete(
        path,
        queryParameters: options.toMap(),
      );
    } on DioException catch (e) {
      var errorMessage = e.message;
      if (e.response != null) {
        errorMessage = (e.response!.data as Map<String, dynamic>)['error'];
      }

      throw Exception(errorMessage);
    }
  }

  @override
  FutureOr<Exercise> update(Exercise exercise) async {
    try {
      final response = await client.patch(
        path,
        data: {
          'name': exercise.name,
          'muscleIds': exercise.muscles.map((muscle) => muscle.id),
        },
      );

      final createdExercise = Exercise.fromJson(response.data['exercise']);

      return createdExercise;
    } on DioException catch (e) {
      var errorMessage = e.message;
      if (e.response != null) {
        errorMessage = (e.response!.data as Map<String, dynamic>)['error'];
      }

      throw Exception(errorMessage);
    }
  }
}
