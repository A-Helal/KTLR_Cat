import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  
  ApiException(this.message, [this.statusCode]);
  
  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Connection timeout. Please try again.', null);
      
      case DioExceptionType.badResponse:
        return ApiException(
          _handleStatusCode(error.response?.statusCode),
          error.response?.statusCode,
        );
      
      case DioExceptionType.cancel:
        return ApiException('Request cancelled', null);
      
      case DioExceptionType.connectionError:
        return ApiException(
          'No internet connection. Please check your network.',
          null,
        );
      
      default:
        return ApiException('Something went wrong. Please try again.', null);
    }
  }
  
  static String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized access.';
      case 403:
        return 'Access forbidden.';
      case 404:
        return 'Resource not found.';
      case 500:
        return 'Internal server error.';
      default:
        return 'Request failed with status code: $statusCode';
    }
  }
  
  @override
  String toString() => message;
}


