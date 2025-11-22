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

       // ---------------------------------------------------------
  // 🔥 NEW: classify error types
  // ---------------------------------------------------------
  bool get isNetworkError {
    final e = dioException;

    if (e == null) return false;

    // no internet, host lookup failure, timeouts, DNS, SSL, etc.
    return e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.badCertificate ||
        e.type == DioExceptionType.unknown;
  }

  bool get isBackendError {
    // backend returned HTTP status (400, 403, 500, etc)
    return !isNetworkError && statusCode != null;
  }

  String get detailedMessage {
  final e = dioException;

  if (e == null) return message;

  final buffer = StringBuffer();

  // user-friendly message first
  buffer.writeln("❗ $message");

  // ---------------------------------------------------
  // Backend responded (meaning server error / validation)
  // ---------------------------------------------------
  if (e.response != null) {
    buffer.writeln("Status: ${e.response?.statusCode}");
    buffer.writeln("URL: ${e.requestOptions.uri}");
    buffer.writeln("Response Data: ${e.response?.data}");
  }

  // ---------------------------------------------------
  // Network or unknown error
  // ---------------------------------------------------
  if (e.response == null) {
    buffer.writeln("Type: ${e.type}");
    buffer.writeln("Reason: ${e.message}");
    buffer.writeln("URL: ${e.requestOptions.uri}");
  }

  return buffer.toString();
}

}
