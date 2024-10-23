import 'package:dio/dio.dart';

abstract class Failure {
  final String errorMessage;
  const Failure({required this.errorMessage});
}

class ServerError extends Failure {
  ServerError({required super.errorMessage});
  factory ServerError.fromDioError(DioException e) {
    // one of these has a response with a message so search for this case and return a good message
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ServerError(errorMessage: 'connection ended');
      case DioExceptionType.sendTimeout:
        return ServerError(errorMessage: 'connection ended');
      case DioExceptionType.receiveTimeout:
        return ServerError(errorMessage: 'connection ended');
      case DioExceptionType.badCertificate:
        return ServerError(errorMessage: 'bad certificate');
      case DioExceptionType.badResponse:
        return ServerError(errorMessage: 'connection ended');
      case DioExceptionType.cancel:
        return ServerError(errorMessage: 'connection ended');
      case DioExceptionType.connectionError:
        return ServerError(errorMessage: 'connection ended');
      case DioExceptionType.unknown:
        return ServerError(errorMessage: 'connection ended');
    }
  }
}
