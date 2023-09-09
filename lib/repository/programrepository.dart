import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/config.dart';
import 'package:namer_app/model/entity/mappable.dart';
import 'package:namer_app/model/entity/program/program.dart';
import 'package:namer_app/model/repository/repository.dart';
import 'package:namer_app/presentation/state/repository.dart';

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
    } on DioException catch (e) {
      print(e.response);
      var errorMessage = e.message;
      if (e.response != null) {
        errorMessage = (e.response!.data as Map<String, String>)['error'];
      }

      throw Exception(errorMessage);
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
    } on DioException catch (e) {
      var errorMessage = e.message;
      if (e.response != null) {
        errorMessage = (e.response!.data as Map<String, dynamic>)['error'];
      }

      throw Exception(errorMessage);
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
  FutureOr<List<Program>> postBulk(List<Program> models) {
    return [];
  }
}
