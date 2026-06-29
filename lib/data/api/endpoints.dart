class ApiEndpoints {
  // Auth endpoints
  static const String register = 'auth/register';
  static const String login = 'auth/login';
  static const String verifyOtp = 'auth/verify-otp';
  static const String resendOtp = 'auth/resend-otp';
  static const String logout = 'auth/logout';
  static const String editProfile = 'auth/editProfile';
  
  // Protected endpoints
  static const String home = 'home';

  // FCM Push Notifications
  static const String fcmToken = 'fcm/token';

  // Guest endpoints
  static const String pragatiMandal = 'guest/pragati-mandal';
  static const String shikshanSamiti = 'guest/shikshan-samiti';
  static const String news = 'guest/news';
  static const String advertise = 'guest/advertise';
  // Member module
  static const String addMember = 'member/addMember';
  static const String editMember = 'member/editMember'; // expect "/:id" appended
  static const String myMembers = 'member/myMembers';
  static const String allMembers = 'member/allMember';
  static const String villages = 'guest/villages';
  static const String memberDetail = 'member/memberDetail';
}


