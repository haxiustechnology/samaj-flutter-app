import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'app/app.dart';
import 'app/app_router.dart';
import 'app/app_bloc_observer.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'data/repositories/auth_repository.dart';
import 'data/api/api_client.dart';

// Global FlutterLocalNotificationsPlugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Android high importance channel definition
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.max,
  playSound: true,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp();

    // Initialize local notifications for foreground alerts
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(settings: initializationSettings);

    // Create the high-importance notification channel
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Configure foreground presentation options for iOS
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Request notification permissions for FCM
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('🔥 User granted notification permission status: ${settings.authorizationStatus}');

    // Handle foreground notifications (displays heads-up banners on Android/iOS)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 Foreground FCM Message received: ${message.notification?.title} - ${message.notification?.body}');
      if (message.data.containsKey('otp')) {
        debugPrint('🔑 OTP parsed from foreground FCM data payload: ${message.data['otp']}');
      }

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
            ),
          ),
        );
      }
    });
  } catch (e) {
    debugPrint('Firebase initialization/permission/notification failed: $e');
  }
  
  // Set up global Bloc observer
  Bloc.observer = AppBlocObserver();
  
  // Initialize app router
  final appRouter = AppRouter();

  final authBloc = AuthBloc(authRepository: AuthRepository());

  // Listen to 401 Unauthorized errors to automatically log out user
  ApiClient.onUnauthorized = (message) {
    authBloc.add(ForceLogoutEvent(message: message));
  };

  // Provide top-level AuthBloc for the whole app and initialize ScreenUtil
  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      builder: (context, child) {
        return BlocProvider.value(
          value: authBloc,
          child: App(appRouter: appRouter),
        );
      },
    ),
  );
}
