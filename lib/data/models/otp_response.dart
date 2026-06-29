class OtpResponse {
  final bool success;
  final String? message;
  final String? otp;
  final String? token;

  OtpResponse({
    required this.success,
    this.message,
    this.otp,
    this.token,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      success: json['success'] ?? false,
      message: json['message'],
      otp: json['otp'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (message != null) 'message': message,
      if (otp != null) 'otp': otp,
      if (token != null) 'token': token,
    };
  }
}


