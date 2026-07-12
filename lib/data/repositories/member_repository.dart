import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/api_response.dart';
import '../models/member_model.dart';
import '../models/village_model.dart';

/// MemberRepository
///
/// Notes:
/// - When sending an image from the client as part of the JSON payload, the
///   image will be encoded as a base64 string under the key `profile_image`
///   so the server receives plain JSON and can access `req.body` directly.
class MemberRepository {
  // ─── Helpers ────────────────────────────────────────────────────────────────

  String _mimeFor(String ext) {
    if (ext.contains('png')) return 'image/png';
    if (ext.contains('webp')) return 'image/webp';
    if (ext.contains('gif')) return 'image/gif';
    return 'image/jpeg';
  }

  String _encodeImage(File imageFile) {
    final bytes = imageFile.readAsBytesSync();
    final b64 = base64Encode(bytes);
    final ext = p.extension(imageFile.path).toLowerCase();
    return 'data:${_mimeFor(ext)};base64,$b64';
  }

  // ─── Add Member ─────────────────────────────────────────────────────────────

  Future<ApiResponse<Map<String, dynamic>>> addMember(
    Map<String, dynamic> body, {
    File? imageFile,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final jsonBody = Map<String, dynamic>.from(body);
      if (imageFile != null) jsonBody['profile_image'] = _encodeImage(imageFile);
      final resp = await ApiClient.dio.post(
        ApiEndpoints.addMember,
        data: jsonBody,
        onSendProgress: onSendProgress,
      );
      return ApiResponse<Map<String, dynamic>>.fromJson(
        resp.data as Map<String, dynamic>,
        dataParser: (d) => d as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? e.message ?? 'Add member failed',
        code: e.response?.statusCode ?? 500,
      );
    }
  }

  // ─── Edit Member ─────────────────────────────────────────────────────────────

  Future<ApiResponse<Map<String, dynamic>>> editMember(
    int id,
    Map<String, dynamic> body, {
    File? imageFile,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final endpoint = '${ApiEndpoints.editMember}/$id';
      final jsonBody = Map<String, dynamic>.from(body);
      if (imageFile != null) jsonBody['profile_image'] = _encodeImage(imageFile);
      final resp = await ApiClient.dio.put(
        endpoint,
        data: jsonBody,
        onSendProgress: onSendProgress,
      );
      return ApiResponse<Map<String, dynamic>>.fromJson(
        resp.data as Map<String, dynamic>,
        dataParser: (d) => d as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? e.message ?? 'Edit member failed',
        code: e.response?.statusCode ?? 500,
      );
    }
  }

  // ─── My Members ──────────────────────────────────────────────────────────────

  Future<ApiResponse<List<Member>>> myMembers() async {
    try {
      final resp = await ApiClient.dio.get(ApiEndpoints.myMembers);
      return ApiResponse<List<Member>>.fromJson(
        resp.data as Map<String, dynamic>,
        dataParser: (data) {
          final list = data as List<dynamic>;
          return list.map((e) => Member.fromJson(e as Map<String, dynamic>)).toList();
        },
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? e.message ?? 'Failed to fetch my members',
        code: e.response?.statusCode ?? 500,
      );
    }
  }

  // ─── All Members — Cursor Pagination + Filters ───────────────────────────────

  /// Fetch all members with cursor-based pagination and optional filters.
  ///
  /// - [lastId] — cursor (last seen member id). Pass 0 for the first page.
  /// - [limit]  — number of items to fetch per page.
  /// - [search] — filters by first_name or surname.
  /// - [villageId] — filters by village id.
  /// - [gender] — 'male' | 'female' | 'other'.
  /// - [jobType] — 'private' | 'government' | 'none'.
  ///
  /// Returns a Map with keys: `members` (List), `next_cursor` (int?), `has_more` (bool).
  Future<ApiResponse<Map<String, dynamic>>> allMembers({
    int lastId = 0,
    int limit = 10,
    String? search,
    int? villageId,
    String? gender,
    String? jobType,
    bool? isDoingJob,
    String? jobPost,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'last_id': lastId,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
        if (villageId != null) 'village_id': villageId,
        if (gender != null) 'gender': gender,
        if (jobType != null) 'job_type': jobType,
        if (isDoingJob != null) 'is_doing_job': isDoingJob ? 1 : 0,
        if (jobPost != null && jobPost.isNotEmpty) 'job_post': jobPost,
      };
      final resp = await ApiClient.dio.get(
        ApiEndpoints.allMembers,
        queryParameters: queryParams,
      );
      return ApiResponse<Map<String, dynamic>>.fromJson(
        resp.data as Map<String, dynamic>,
        dataParser: (data) => data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? e.message ?? 'Failed to fetch members',
        code: e.response?.statusCode ?? 500,
      );
    }
  }

  // ─── Villages ────────────────────────────────────────────────────────────────

  Future<ApiResponse<List<Village>>> getVillages() async {
    try {
      final resp = await ApiClient.dio.get(ApiEndpoints.villages);
      return ApiResponse<List<Village>>.fromJson(
        resp.data as Map<String, dynamic>,
        dataParser: (data) {
          final list = data as List<dynamic>;
          return list.map((e) => Village.fromJson(e as Map<String, dynamic>)).toList();
        },
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? e.message ?? 'Failed to fetch villages',
        code: e.response?.statusCode ?? 500,
      );
    }
  }

  // ─── Member Detail ───────────────────────────────────────────────────────────

  Future<ApiResponse<Member>> memberDetail(int id) async {
    try {
      final endpoint = '${ApiEndpoints.memberDetail}/$id';
      final resp = await ApiClient.dio.get(endpoint);
      return ApiResponse<Member>.fromJson(
        resp.data as Map<String, dynamic>,
        dataParser: (data) {
          final d = data is Map<String, dynamic> ? data['data'] ?? data : data;
          final map = d as Map<String, dynamic>;
          final education = map['education'] as Map<String, dynamic>?;
          if (education != null) {
            map['ssc_school']           = education['ssc_school'];
            map['ssc_percentage']       = education['ssc_percentage'];
            map['hsc_school']           = education['hsc_school'];
            map['hsc_percentage']       = education['hsc_percentage'];
            map['bachelor_degree']      = education['bachelor_degree'];
            map['bachelor_percentage']  = education['bachelor_percentage'];
            map['master_degree']        = education['master_degree'];
            map['master_percentage']    = education['master_percentage'];
          }
          return Member.fromJson(map);
        },
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? e.message ?? 'Failed to fetch member detail',
        code: e.response?.statusCode ?? 500,
      );
    }
  }

  // ─── FCM Push Notification Tokens ────────────────────────────────────────────

  /// Save (upsert) the device FCM token for the current user.
  /// Call this after successful OTP verification.
  Future<ApiResponse<Map<String, dynamic>>> saveFcmToken(
    String fcmToken, {
    String? deviceInfo,
  }) async {
    try {
      final resp = await ApiClient.dio.post(
        ApiEndpoints.fcmToken,
        data: {
          'fcm_token': fcmToken,
          if (deviceInfo != null) 'device_info': deviceInfo,
        },
      );
      return ApiResponse<Map<String, dynamic>>.fromJson(
        resp.data as Map<String, dynamic>,
        dataParser: (data) => data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? e.message ?? 'Failed to save FCM token',
        code: e.response?.statusCode ?? 500,
      );
    }
  }

  /// Delete the device FCM token (call on logout or notification opt-out).
  /// Pass null [fcmToken] to remove ALL tokens for the user.
  Future<ApiResponse<Map<String, dynamic>>> deleteFcmToken({
    String? fcmToken,
  }) async {
    try {
      final resp = await ApiClient.dio.delete(
        ApiEndpoints.fcmToken,
        data: {
          if (fcmToken != null) 'fcm_token': fcmToken,
        },
      );
      return ApiResponse<Map<String, dynamic>>.fromJson(
        resp.data as Map<String, dynamic>,
        dataParser: (data) => data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? e.message ?? 'Failed to delete FCM token',
        code: e.response?.statusCode ?? 500,
      );
    }
  }
}
