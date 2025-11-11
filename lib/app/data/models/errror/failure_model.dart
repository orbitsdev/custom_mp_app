import 'package:dio/dio.dart';

class FailureModel {
  final String message; // readable message
  final String? code; // optional backend code
  final int? statusCode; // HTTP code
  final Map<String, dynamic>? errors; // validation errors
  final DioException? dioException; // raw exception for deep debugging

  const FailureModel({
    required this.message,
    this.code,
    this.statusCode,
    this.errors,
    this.dioException,
  });

  /// Factory for building from DioException safely
  factory FailureModel.fromDio(DioException e) {
    String message = 'Something went wrong';
    String? code;
    int? statusCode = e.response?.statusCode;
    Map<String, dynamic>? errors;

    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      message = data['message'] ??
          data['error_description'] ??
          e.message ??
          'Request failed';
      code = data['code'];
      if (data['errors'] is Map<String, dynamic>) {
        errors = Map<String, dynamic>.from(data['errors']);
      }
    } else if (data is String) {
      // Sometimes backend sends plain text or HTML
      message = data;
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      message = 'Connection timed out. Please check your internet.';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'No internet connection.';
    }

    return FailureModel(
      message: message,
      code: code,
      statusCode: statusCode,
      errors: errors,
      dioException: e,
    );
  }

  /// Optional convenience constructor for manual failures
  factory FailureModel.manual(String message, {String? code}) {
    return FailureModel(message: message, code: code);
  }

  @override
  String toString() =>
      'Failure(status: $statusCode, code: $code, message: $message, errors: $errors)';
}
