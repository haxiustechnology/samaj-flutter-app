import 'dart:io';

class AppConfig {
  static const String appName = 'Samaj';
  static const String appVersion = '1.0.0';

  // Production (Live API)
  static const String baseUrl = 'https://samaj-api-e98e.onrender.com/api/';

  // Local Development
  // static const String baseUrl = 'http://192.168.12.13:3000/api/';

  // API Headers Keys
  static const String headerLanguageCode = 'language-code';
  static const String headerAppVersion = 'app-version';
  static const String headerPlatform = 'platform';
  static const String headerAuthorization = 'Authorization';
  
  // Default Values
  static const String defaultLanguage = 'en';
  static const String defaultPlatform = 'A';
  
  // Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  static String detectPlatform() {
     if (Platform.isAndroid) {
      return 'A';
    } else if (Platform.isIOS) {
      return 'I';
    } else {
      return defaultPlatform;
    }
  }
}


