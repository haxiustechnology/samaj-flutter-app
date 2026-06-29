import 'package:dio/dio.dart';
import '../../core/utils/shared_prefs.dart';
import '../../core/constants/app_config.dart';
import '../../core/utils/logger.dart';
import 'dart:io' show Platform;

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: Duration(milliseconds: AppConfig.connectTimeout),
      receiveTimeout: Duration(milliseconds: AppConfig.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SharedPrefs.getToken();
          final languageCode = await SharedPrefs.getLanguage();
          
          options.headers.addAll({
            AppConfig.headerLanguageCode: languageCode,
            AppConfig.headerAppVersion: AppConfig.appVersion,
            AppConfig.headerPlatform: AppConfig.detectPlatform(),
            if (token != null) AppConfig.headerAuthorization: 'Bearer $token',
          });
          
          AppLogger.info('Request: ${options.method} ${options.path}');
          AppLogger.debug('Headers: ${options.headers}');
          AppLogger.debug('Data: ${options.data}');
          
          handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.info('Response: ${response.statusCode} ${response.requestOptions.path}');
          AppLogger.debug('Data: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          AppLogger.error(
            'Error: ${error.requestOptions.method} ${error.requestOptions.path}',
            error.response?.data,
            error.stackTrace,
          );
          handler.next(error);
        },
      ),
    );

  static Dio get dio => _dio;
}


