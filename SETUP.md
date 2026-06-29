# Samaj App - Setup Guide

## Project Structure

This Flutter app follows an industry-grade folder structure:

```
lib/
├── main.dart
├── app/                    # App-level configuration
│   ├── app_router.dart     # AutoRoute setup
│   ├── app_bloc_observer.dart
│   └── app.dart
├── core/                   # Core utilities and widgets
│   ├── constants/
│   ├── utils/
│   └── widgets/
├── data/                   # Data layer
│   ├── api/
│   ├── models/
│   └── repositories/
├── features/               # Feature modules
│   ├── auth/
│   ├── splash/
│   ├── home/
│   └── profile/
└── l10n/                   # Localization files
```

## Setup Instructions

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Generate Code

Generate AutoRoute code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Generate localization code:
```bash
flutter pub run intl_utils:generate
```

### 3. Firebase Setup (Optional)

If you want to use Firebase:
1. Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
2. Update Firebase configuration in `main.dart`

### 4. API Configuration

Update the base URL in `lib/core/constants/app_config.dart`:
```dart
static const String baseUrl = 'http://your-api-url.com/api/';
```

## Features

- ✅ Authentication (Login, Register, OTP Verification)
- ✅ Multi-language support (English, Hindi, Gujarati)
- ✅ State Management with BLoC
- ✅ API Integration with Dio
- ✅ AutoRoute Navigation
- ✅ Responsive UI with ScreenUtil
- ✅ Splash Screen
- ✅ Profile Screen
- ✅ Bottom Navigation

## API Endpoints

All API endpoints are defined in `lib/data/api/endpoints.dart`:

- `POST /api/auth/register` - Register user
- `POST /api/auth/login` - Login (send OTP)
- `POST /api/auth/verify-otp` - Verify OTP
- `POST /api/auth/resend-otp` - Resend OTP
- `GET /api/home` - Get home data (protected)

## Running the App

```bash
flutter run
```

## Building

### Android
```bash
flutter build apk
```

### iOS
```bash
flutter build ios
```


