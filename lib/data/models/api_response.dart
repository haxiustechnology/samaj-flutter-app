/// Unified API Response Model
/// All API responses should follow this structure:
/// {
///   "code": 1,
///   "message": "Success or error message",
///   "data": <any>
/// }
///
/// Response Codes:
/// - 1 = Success
/// - 0 = Generic Error
/// - 401 = Unauthorized (Invalid or expired token)

class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;

  // Common response codes
  static const int SUCCESS = 1;
  static const int ERROR = 0;
  static const int UNAUTHORIZED = 401;

  ApiResponse({
    required this.code,
    required this.message,
    this.data,
  });

  /// Check if response is successful (code == 1)
  bool get isSuccess => code == SUCCESS;

  /// Check if response is an error (code != 1)
  bool get isError => code != SUCCESS;

  /// Check if response is unauthorized (code == 401)
  bool get isUnauthorized => code == UNAUTHORIZED;

  /// Factory constructor to parse from JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic)? dataParser,
  }) {
    return ApiResponse(
      code: json['code'] as int? ?? 1,
      message: json['message'] as String? ?? 'Unknown error',
      data: json['data'] != null && dataParser != null
          ? dataParser(json['data'])
          : json['data'] as T?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      if (data != null) 'data': data,
    };
  }

  /// Create a success response
  factory ApiResponse.success({
    required T? data,
    String message = 'Success',
  }) {
    return ApiResponse(
      code: 1,
      message: message,
      data: data,
    );
  }

  /// Create an error response
  factory ApiResponse.error({
    required String message,
    int code = 0,
    T? data,
  }) {
    return ApiResponse(
      code: code,
      message: message,
      data: data,
    );
  }

  @override
  String toString() => 'ApiResponse(code: $code, message: $message, data: $data)';
}
