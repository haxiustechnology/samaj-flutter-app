/// Response Handler Extension
/// 
/// Use this to safely extract data from ApiResponse objects
/// and handle different response codes with ease.

import '../models/api_response.dart';

/// Extension to handle ApiResponse more efficiently
extension ApiResponseExt<T> on ApiResponse<T> {
  /// Execute different callbacks based on response status
  /// Returns the result of the matching callback
  R fold<R>(
    R Function(String message, int code) onError,
    R Function(T? data, String message) onSuccess,
  ) {
    if (isSuccess) {
      return onSuccess(data, message);
    } else {
      return onError(message, code);
    }
  }

  /// Safe data access with fallback
  T? getDataOrNull() => data;

  /// Get error code description
  String getCodeDescription() {
    switch (code) {
      case 1:
        return 'Success';
      case 0:
        return 'Error';
      case 401:
        return 'Unauthorized - Invalid or expired token';
      default:
        return 'Unknown status (Code: $code)';
    }
  }
}

/// Usage Examples:
/// 
/// Example 1: Using fold pattern
/// ```dart
/// final response = await authRepository.login(data);
/// response.fold(
///   (message, code) {
///     print('Error: $message (Code: $code)');
///   },
///   (data, message) {
///     print('Success: $message');
///     print('Data: $data');
///   },
/// );
/// ```
///
/// Example 2: Direct check
/// ```dart
/// final response = await authRepository.login(data);
/// if (response.isSuccess) {
///   print('Token: ${response.data?['token']}');
/// } else {
///   print('Error: ${response.message}');
/// }
/// ```
///
/// Example 3: With code description
/// ```dart
/// final response = await authRepository.login(data);
/// if (response.isError) {
///   print('${response.getCodeDescription()}: ${response.message}');
/// }
/// ```
