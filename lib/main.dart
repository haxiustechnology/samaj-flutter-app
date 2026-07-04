import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'app/app.dart';
import 'app/app_router.dart';
import 'app/app_bloc_observer.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'data/repositories/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp();

    // Request notification permissions for FCM
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('🔥 User granted notification permission status: ${settings.authorizationStatus}');

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 Foreground FCM Message received: ${message.notification?.title} - ${message.notification?.body}');
      if (message.data.containsKey('otp')) {
        debugPrint('🔑 OTP parsed from foreground FCM data payload: ${message.data['otp']}');
      }
    });
  } catch (e) {
    // Firebase initialization failed, continue without it
    debugPrint('Firebase initialization/permission failed: $e');
  }
  
  // Set up global Bloc observer
  Bloc.observer = AppBlocObserver();
  
  // Initialize app router
  final appRouter = AppRouter();

  // Provide top-level AuthBloc for the whole app and initialize ScreenUtil
  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      builder: (context, child) {
        return BlocProvider(
          create: (_) => AuthBloc(authRepository: AuthRepository()),
          child: App(appRouter: appRouter),
        );
      },
    ),
  );
}
