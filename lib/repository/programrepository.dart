import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/config.dart';
import 'package:namer_app/model/entity/mappable.dart';
import 'package:namer_app/model/entity/program/program.dart';
import 'package:namer_app/model/repository/repository.dart';
import 'package:namer_app/presentation/state/repository.dart';
import 'package:namer_app/repository/neterror.dart';

final programRepoProvider = Provider((ref) => DioProgramRepository(
      path: '${Config.serverUrl}/programs',
      client: ref.read(dioProvider),
    ));

class DioProgramRepository implements Repository<Program> {
  final String path;
  final Dio client;

  const DioProgramRepository({required this.path, required this.client});

  @override
  FutureOr<List<Program>> get(Mappable options) async {
    try {
      final Response response = await client.get(
        path,
        queryParameters: options.toMap(),
      );
      final programJson = (response.data as Map<String, dynamic>)['programs'];
      final programs =
          (programJson as List).map((json) => Program.fromJson(json)).toList();

      return programs;
    } catch (e) {
      throw parseNetworkError(e);
    }
  }

  @override
  FutureOr<Program> post(Program model) async {
    try {
      final response = await client.post(path, data: {
        "name": model.name,
        "endDate": model.endDate.toString(),
      });
      final muscle = Program.fromJson(response.data['program']);

      return muscle;
    } catch (e) {
      throw parseNetworkError(e);
    }
  }

  @override
  FutureOr<Program> update(Program model) async {
    try {
      final response = await client.post(
        '$path/${model.id}',
        data: {
          "name": model.name,
          "endDate": model.endDate.toString(),
        },
      );
      final muscle = Program.fromJson(response.data['program']);

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
  FutureOr<List<Program>> postBulk(List<Program> models) {
    return [];
  }
}
