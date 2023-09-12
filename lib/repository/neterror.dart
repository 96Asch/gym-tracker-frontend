import 'dart:io';

import 'package:dio/dio.dart';
import 'package:namer_app/model/entity/appmessage.dart';

AppMessage parseNetworkError(e) {
  late AppMessage message;
  const type = MessageType.error;

  if (e is SocketException) {
    final host = e.address?.host;
    message = AppMessage(message: 'Could not connect to: $host', type: type);
  } else if (e is DioException) {
    switch (e.type) {
      case DioExceptionType.badResponse:
        switch (e.response!.statusCode) {
          case 400:
          case 409:
            message =
                AppMessage(message: e.response!.data['error'], type: type);
            break;
          case 301:
            AppMessage(message: e.message!, type: type);
            break;
          default:
            AppMessage(message: "Unimplemented Error message", type: type);
            break;
        }
        break;
      default:
        final error = e.error;
        if (error != null && error is SocketException) {
          final host = (e.error as SocketException).address?.host;
          message =
              AppMessage(message: 'Could not connect to: $host', type: type);
        } else {
          message = AppMessage(
              message: 'Error has occurred when connecting to the server',
              type: type);
        }
    }
  } else {
    message = AppMessage(message: '', type: MessageType.error);
  }

  return message;
}
