# Standardized API Response Structure

## Overview

All API responses in the Samaj app follow a unified structure to ensure consistency across all endpoints.

## Standard Response Format

```json
{
  "code": 1,
  "message": "Success or error message",
  "data": null
}
```

### Fields:

- **code** (int): Response status code
  - `1` = Success
  - `0` = Generic Error
  - `401` = Unauthorized (Invalid or expired token)

- **message** (string): Human-readable message describing the response

- **data** (any): Response payload (can be any type - object, array, string, null, etc.)

## Response Model

The `ApiResponse<T>` generic class handles all API responses:

```dart
class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;

  // Common response codes
  static const int SUCCESS = 1;
  static const int ERROR = 0;
  static const int UNAUTHORIZED = 401;

  // Getters
  bool get isSuccess => code == 1;
  bool get isError => code != 1;
  bool get isUnauthorized => code == 401;

  // Factory constructors
  factory ApiResponse.fromJson(Map<String, dynamic> json, {T Function(dynamic)? dataParser});
  factory ApiResponse.success({required T? data, String message = 'Success'});
  factory ApiResponse.error({required String message, int code = 0, T? data});
}
```

## Usage Examples

### Example 1: Basic Usage with Status Check

```dart
final response = await authRepository.login({'mobile': '9876543210'});

if (response.isSuccess) {
  print('Login successful: ${response.message}');
  final token = response.data?['token'];
} else {
  print('Login failed: ${response.message}');
}
```

### Example 2: Using the Fold Pattern

```dart
final response = await authRepository.register({
  'name': 'John Doe',
  'mobile': '9876543210',
});

response.fold(
  (message, code) {
    // Handle error
    emit(AuthError(message: message));
  },
  (data, message) {
    // Handle success
    emit(OtpSent(mobile: mobile, message: message));
  },
);
```

### Example 3: Response with Error Code Description

```dart
final response = await authRepository.verifyOtp({
  'mobile': '9876543210',
  'otp': '123456',
});

if (response.isError) {
  final description = response.getCodeDescription();
  print('$description: ${response.message}');
  // Output: "Invalid or expired token: Token has expired"
}
```

### Example 4: Safe Data Access

```dart
final response = await authRepository.login(data);

final token = response.getDataOrNull()?['token'];
if (token != null) {
  await SharedPrefs.saveToken(token);
}
```

### Example 5: Handling Unauthorized Response

```dart
final response = await authRepository.getUserProfile();

if (response.isUnauthorized) {
  // Token expired or invalid - redirect to login
  emit(AuthError(message: response.message));
  // Clear stored token
  await SharedPrefs.clearToken();
  // Navigate to login screen
} else if (response.isSuccess) {
  // Process user data
  emit(ProfileLoaded(user: response.data));
} else {
  // Generic error
  emit(AuthError(message: response.message));
}
```

## Repository Implementation Pattern

All repositories should follow this pattern:

```dart
class YourRepository {
  Future<ApiResponse<Map<String, dynamic>>> yourMethod(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.dio.post(
        ApiEndpoints.endpoint,
        data: data,
      );
      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        dataParser: (data) => data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? e.message ?? 'Request failed',
        code: e.response?.statusCode ?? 500,
      );
    }
  }
}
```

## BLoC Implementation Pattern

Handle responses in your BLoC like this:

```dart
Future<void> _onEvent(YourEvent event, Emitter<YourState> emit) async {
  emit(Loading());
  try {
    final response = await repository.yourMethod(data);
    
    if (response.isSuccess) {
      // Handle successful response
      emit(Success(data: response.data));
    } else {
      // Handle error response
      emit(Error(message: response.message));
    }
  } catch (e) {
    emit(Error(message: e.toString()));
  }
}
```

## API Response Examples

### Success Response

```json
{
  "code": 1,
  "message": "OTP sent successfully",
  "data": {
    "expiresIn": 300
  }
}
```

### Error Response (Invalid Token)

```json
{
  "code": 401,
  "message": "અમાન્ય અથવા સમાપ્ત ટોકન",
  "data": null
}
```

### Error Response (Validation Failed)

```json
{
  "code": 0,
  "message": "Mobile number already registered",
  "data": {
    "field": "mobile",
    "value": "9876543210"
  }
}
```

### Complex Data Response

```json
{
  "code": 1,
  "message": "User data retrieved successfully",
  "data": {
    "id": 1,
    "name": "John Doe",
    "mobile": "9876543210",
    "email": "john@example.com",
    "token": "eyJhbGciOiJIUzI1NiIs..."
  }
}

## File Uploads and Image Fields

- For endpoints that accept member images (e.g. `member/addMember`, `member/editMember`), the client currently sends image data as a base64-encoded string inside the JSON body using the key `profile_image`.
- If your server prefers multipart/form-data, you can change the client to send a `profile_image` file field instead, or update the server to decode `profile_image` from JSON and save it.

```

## Error Codes Reference

| Code | Status | Description |
|------|--------|-------------|
| 1 | Success | Request was successful |
| 0 | Error | Generic error response |
| 401 | Unauthorized | Invalid or expired token |

## Best Practices

1. **Always use `ApiResponse<T>` for repository return types** - This ensures consistency across your codebase

2. **Check `isSuccess` before accessing data** - Use the helper getter instead of checking status codes manually

3. **Use meaningful error messages** - The `message` field should clearly describe what went wrong

4. **Utilize the `fold` pattern in BLoCs** - It provides a clean way to handle both success and error cases

5. **Extract data safely** - Use `response.getDataOrNull()` to avoid null pointer exceptions

6. **Document custom error codes** - If adding app-specific codes, document them clearly

## Migration Guide

If updating existing code to use `ApiResponse`:

### Before
```dart
final response = await authRepository.login(data);
if (response.statusCode == 200 || response.statusCode == 201) {
  final token = response.data['token'];
} else {
  final error = response.data['message'];
}
```

### After
```dart
final response = await authRepository.login(data);
if (response.isSuccess) {  // Now checks if code == 1
  final token = response.data?['token'];
} else {
  final error = response.message;
}
```

## Files Modified

- `lib/data/models/api_response.dart` - Core response model
- `lib/data/api/response_handler.dart` - Helper extensions
- `lib/data/repositories/auth_repository.dart` - Repository implementation
- `lib/features/auth/bloc/auth_bloc.dart` - BLoC handler implementation
