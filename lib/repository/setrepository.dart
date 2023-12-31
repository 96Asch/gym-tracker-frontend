import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/config.dart';
import 'package:namer_app/model/entity/mappable.dart';
import 'package:namer_app/model/repository/repository.dart';
import 'package:namer_app/model/entity/set/set.dart';
import 'package:namer_app/presentation/state/repository.dart';
import 'package:namer_app/repository/neterror.dart';

final setRepoProvider = Provider(
  (ref) => DioSetRepository(
    path: '${Config.serverUrl}/sets',
    client: ref.read(dioProvider),
  ),
);

class DioSetRepository implements Repository<Set> {
  final String path;
  final Dio client;

  const DioSetRepository({required this.path, required this.client});

  @override
  FutureOr<Set> post(Set model) async {
    try {
      final response = await client.post(path, data: {
        "programExerciseId": model.programExerciseId,
        "repetitions": model.repetitions,
        "double": model.isDouble,
        "weightInKg": model.weightInKg,
      });
      final newSet = Set.fromJson(response.data['set']);

      return newSet;
    } catch (e) {
      throw parseNetworkError(e);
    }
  }

  @override
  FutureOr<List<Set>> postBulk(List<Set> models) {
    return [];
  }

  @override
  FutureOr<List<Set>> get(Mappable options) async {
    try {
      final Response response = await client.get(
        path,
        queryParameters: options.toMap(),
      );
      final setJson = (response.data as Map<String, dynamic>)['sets'];
      final sets = (setJson as List).map((json) => Set.fromJson(json)).toList();

      return sets;
    } catch (e) {
      throw parseNetworkError(e);
    }
  }

  @override
  FutureOr<Set> update(Set model) async {
    try {
      final response = await client.patch(
        '$path/${model.id}',
        data: {
          "repetitions": model.repetitions,
          "double": model.isDouble,
          "weightInKg": model.weightInKg,
        },
      );
      final updatedSet = Set.fromJson(response.data['program']);

      return updatedSet;
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
}
