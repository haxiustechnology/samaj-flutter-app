import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user_model.dart';

import '../../../core/utils/shared_prefs.dart';
import '../../../core/utils/logger.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<CompleteRegistrationEvent>(_onCompleteRegistration);
    on<LogoutEvent>(_onLogout);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<ForceLogoutEvent>(_onForceLogout);
  }

  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        AppLogger.error('Failed to get FCM token', e);
      }

      final response = await authRepository.register({
        'name': event.name,
        'mobile': event.mobile,
        'fcm_token': fcmToken,
      });

      if (response.isSuccess) {
        emit(OtpSent(
          mobile: event.mobile,
          message: response.message,
        ));
      } else {
        emit(AuthError(message: response.message));
      }
    } catch (e) {
      AppLogger.error('Register error', e);
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.editProfile(event.data);

      if (response.isSuccess) {
        final data = response.data as Map<String, dynamic>?;
        final userData = data?['data'] ?? data;
        if (userData != null && userData is Map<String, dynamic>) {
          final user = UserModel.fromJson(userData);
          // Save updated user data as a single UserModel
          await SharedPrefs.saveUserModel(user);
          emit(AuthSuccess(user: user, message: response.message));
        } else {
          emit(AuthSuccess(message: response.message));
        }
      } else {
        emit(AuthError(message: response.message));
      }
    } catch (e) {
      AppLogger.error('Update profile error', e);
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        AppLogger.error('Failed to get FCM token', e);
      }

      final response = await authRepository.login({
        'mobile': event.mobile,
        'fcm_token': fcmToken,
      });

      if (response.isSuccess) {
        emit(OtpSent(
          mobile: event.mobile,
          message: response.message,
        ));
      } else {
        emit(AuthError(message: response.message));
      }
    } catch (e) {
      AppLogger.error('Login error', e);
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.verifyOtp({
        'mobile': event.mobile,
        'otp': event.otp,
      });

      if (response.isSuccess) {
        final data = response.data as Map<String, dynamic>?;
        final token = data?['token'];
        
        if (token != null) {
          // Store token
          await SharedPrefs.saveToken(token);
          
          // Store user data and set login status
          final userData = data?['user'];
          if (userData != null) {
            final user = UserModel.fromJson(userData);
            
            // Save complete user data as a single UserModel
            await SharedPrefs.saveUserModel(user);
            
            // Set login status to true
            await SharedPrefs.setLoginStatus(true);
            
            emit(OtpVerified(token: token, user: user));
          } else {
            // Even if no user data, set login status
            await SharedPrefs.setLoginStatus(true);
            emit(OtpVerified(token: token));
          }
        } else {
          emit(AuthError(message: 'Token not received'));
        }
      } else {
        emit(AuthError(message: response.message));
      }
    } catch (e) {
      AppLogger.error('Verify OTP error', e);
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onResendOtp(
    ResendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        AppLogger.error('Failed to get FCM token', e);
      }

      final response = await authRepository.resendOtp({
        'mobile': event.mobile,
        'fcm_token': fcmToken,
      });

      if (response.isSuccess) {
        emit(OtpSent(
          mobile: event.mobile,
          message: response.message,
        ));
      } else {
        emit(AuthError(message: response.message));
      }
    } catch (e) {
      AppLogger.error('Resend OTP error', e);
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onCompleteRegistration(
    CompleteRegistrationEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        AppLogger.error('Failed to get FCM token', e);
      }

      // Call register API with user data
      final response = await authRepository.register({
        'name': event.firstName,
        'mobile': event.mobile,
        'email': event.email.isNotEmpty ? event.email : null,
        'fcm_token': fcmToken,
      });

      if (response.isSuccess) {
        // On success, emit OtpSent to redirect to verify OTP screen
        emit(OtpSent(
          mobile: event.mobile,
          message: response.message,
        ));
      } else {
        emit(AuthError(message: response.message));
      }
    } catch (e) {
      AppLogger.error('Complete registration error', e);
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Call logout API
      final response = await authRepository.logout();

      if (response.isSuccess) {
        // Clear all stored data on successful logout
        await SharedPrefs.clearToken();
        await SharedPrefs.setLoginStatus(false);
        await SharedPrefs.clearAll();
        
        AppLogger.info('User logged out successfully');
        emit(LogoutSuccess(message: response.message));
        
        // Emit AuthInitial to reset the state
        emit(AuthInitial());
      } else if (response.isUnauthorized) {
        // Token already invalid, clear data anyway
        await SharedPrefs.clearToken();
        await SharedPrefs.setLoginStatus(false);
        await SharedPrefs.clearAll();
        
        AppLogger.info('Token invalid, cleared local data');
        emit(LogoutSuccess(message: 'Logged out successfully'));
        emit(AuthInitial());
      } else {
        emit(AuthError(message: response.message));
      }
    } catch (e) {
      AppLogger.error('Logout error', e);
      // Even on error, clear local data
      await SharedPrefs.clearToken();
      await SharedPrefs.setLoginStatus(false);
      await SharedPrefs.clearAll();
      
      emit(LogoutSuccess(message: 'Logged out'));
      emit(AuthInitial());
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.deleteAccount();

      if (response.isSuccess) {
        // Clear all stored data on successful deletion
        await SharedPrefs.clearToken();
        await SharedPrefs.setLoginStatus(false);
        await SharedPrefs.clearAll();
        
        AppLogger.info('User account soft deleted successfully');
        emit(LogoutSuccess(message: response.message));
        
        // Reset state
        emit(AuthInitial());
      } else {
        emit(AuthError(message: response.message));
      }
    } catch (e) {
      AppLogger.error('Delete account error', e);
      // Even on error, clear local data to keep device in clean state
      await SharedPrefs.clearToken();
      await SharedPrefs.setLoginStatus(false);
      await SharedPrefs.clearAll();
      
      emit(const LogoutSuccess(message: 'Account deleted'));
      emit(AuthInitial());
    }
  }

  Future<void> _onForceLogout(
    ForceLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await SharedPrefs.clearToken();
      await SharedPrefs.setLoginStatus(false);
      await SharedPrefs.clearAll();
      
      AppLogger.info('Force logout triggered: ${event.message}');
      emit(LogoutSuccess(message: event.message));
      emit(AuthInitial());
    } catch (e) {
      AppLogger.error('Force logout error', e);
    }
  }
}

