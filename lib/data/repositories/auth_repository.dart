import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/api_response.dart';


class AuthRepository {
  /// Register user
  /// Returns [ApiResponse] with status code, message, and data
  Future<ApiResponse<Map<String, dynamic>>> register(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.dio.post(
        ApiEndpoints.register,
        data: data,
      );
      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        dataParser: (data) => data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? e.message ?? 'Register failed',
        code: e.response?.statusCode ?? 500,
      );
    }
  }

  /// Login user (send OTP)
  /// Returns [ApiResponse] with status code, message, and data
  Future<ApiResponse<Map<String, dynamic>>> login(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.dio.post(
        ApiEndpoints.login,
        data: data,
      );
      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        dataParser: (data) => data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? e.message ?? 'Login failed',
        code: e.response?.statusCode ?? 500,
      );
    }
  }

  /// Verify OTP
  /// Returns [ApiResponse] with user data and token
  Future<ApiResponse<Map<String, dynamic>>> verifyOtp(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.dio.post(
        ApiEndpoints.verifyOtp,
        data: data,
      );
      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        dataParser: (data) => data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? e.message ?? 'OTP verification failed',
        code: e.response?.statusCode ?? 500,
      );
    }
  }

  /// Resend OTP
  /// Returns [ApiResponse] with status code and message
  Future<ApiResponse<Map<String, dynamic>>> resendOtp(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.dio.post(
        ApiEndpoints.resendOtp,
        data: data,
      );
      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        dataParser: (data) => data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? e.message ?? 'Resend OTP failed',
        code: e.response?.statusCode ?? 500,
      );
    }
  }

  /// Logout user
  /// Returns [ApiResponse] with logout status
  Future<ApiResponse<Map<String, dynamic>>> logout() async {
    try {
      final response = await ApiClient.dio.post(
        ApiEndpoints.logout,
      );
      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        dataParser: (data) => data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? e.message ?? 'Logout failed',
        code: e.response?.statusCode ?? 500,
      );
    }
  }

  /// Edit profile
  Future<ApiResponse<Map<String, dynamic>>> editProfile(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.dio.post(
        ApiEndpoints.editProfile,
        data: data,
      );
      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        dataParser: (data) => data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? e.message ?? 'Edit profile failed',
        code: e.response?.statusCode ?? 500,
      );
    }
  }

  /// Delete account
  Future<ApiResponse<Map<String, dynamic>>> deleteAccount() async {
    try {
      final response = await ApiClient.dio.post(
        ApiEndpoints.deleteAccount,
      );
      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        dataParser: (data) => data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? e.message ?? 'Delete account failed',
        code: e.response?.statusCode ?? 500,
      );
    }
  }
}


