import '../../../data/models/user_model.dart';

class AuthResponse {
  final bool success;
  final String? message;
  final String? token;
  final UserModel? user;

  AuthResponse({
    required this.success,
    this.message,
    this.token,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'],
      token: json['token'] ?? json['data']?['token'],
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : json['data']?['user'] != null
              ? UserModel.fromJson(json['data']['user'])
              : null,
    );
  }
}


