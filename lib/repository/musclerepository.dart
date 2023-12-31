import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/config.dart';
import 'package:namer_app/model/entity/mappable.dart';
import 'package:namer_app/model/entity/muscle/muscle.dart';
import 'package:namer_app/model/repository/repository.dart';
import 'package:namer_app/presentation/state/repository.dart';
import 'package:namer_app/repository/neterror.dart';

final muscleRepoProvider = Provider((ref) => DioMuscleRepository(
      path: '${Config.serverUrl}/muscles',
      client: ref.read(dioProvider),
    ));

class DioMuscleRepository implements Repository<Muscle> {
  final Dio client;
  final String path;

  const DioMuscleRepository({required this.client, required this.path});

  @override
  FutureOr<List<Muscle>> get(Mappable options) async {
    try {
      final Response response = await client.get(
        path,
        queryParameters: options.toMap(),
      );
      final musclesJson = (response.data as Map<String, dynamic>)['muscles'];
      final muscles =
          (musclesJson as List).map((json) => Muscle.fromJson(json)).toList();

      return muscles;
    } catch (e) {
      throw parseNetworkError(e);
    }
  }

  @override
  FutureOr<Muscle> post(Muscle model) async {
    try {
      final response = await client.post(path, data: {
        "name": model.name,
      });
      final muscle = Muscle.fromJson(response.data['muscle']);

      return muscle;
    } catch (e) {
      throw parseNetworkError(e);
    }
  }

  @override
  FutureOr<Muscle> update(Muscle model) async {
    try {
      final response = await client.put('$path/${model.id}', data: {
        "name": model.name,
      });
      final muscle = Muscle.fromJson(response.data['muscle']);

      return muscle;
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
  FutureOr<List<Muscle>> postBulk(List<Muscle> models) {
    return [];
  }
}
