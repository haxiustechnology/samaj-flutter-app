# Quick Start Guide

## Initial Setup

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Generate AutoRoute code:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Generate localization files:**
   ```bash
   flutter pub run intl_utils:generate
   ```

4. **Update API base URL** (if needed):
   - Edit `lib/core/constants/app_config.dart`
   - Change `baseUrl` to your API endpoint

5. **Run the app:**
   ```bash
   flutter run
   ```

## Project Structure Overview

- **lib/app/** - App configuration, routing, and global setup
- **lib/core/** - Shared constants, utilities, and reusable widgets
- **lib/data/** - API client, models, and repositories
- **lib/features/** - Feature modules (auth, splash, home, profile)
- **lib/l10n/** - Localization files (English, Hindi, Gujarati)

## Key Features Implemented

✅ Complete authentication flow (Login → OTP → Register)
✅ Multi-language support (EN, HI, GU)
✅ BLoC state management
✅ API integration with Dio
✅ AutoRoute navigation
✅ Responsive UI with ScreenUtil
✅ Splash screen with custom logo
✅ Profile screen with bottom navigation
✅ Modern UI matching the design requirements

## Color Scheme

- Primary Green: `#7ED321` (Lime green)
- Primary Yellow: `#FFD700` (Bright yellow for buttons)
- Background: White and light mint green
- Navigation: Yellow for active tab

## Next Steps

1. Add your API endpoints
2. Customize the logo in splash screen
3. Add more features as needed
4. Configure Firebase (if using push notifications)


