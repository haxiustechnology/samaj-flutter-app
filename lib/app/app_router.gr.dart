// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [GalleryPage]
class GalleryRoute extends PageRouteInfo<void> {
  const GalleryRoute({List<PageRouteInfo>? children})
    : super(GalleryRoute.name, initialChildren: children);

  static const String name = 'GalleryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GalleryPage();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return LoginPage();
    },
  );
}

/// generated route for
/// [NewsPage]
class NewsRoute extends PageRouteInfo<void> {
  const NewsRoute({List<PageRouteInfo>? children})
    : super(NewsRoute.name, initialChildren: children);

  static const String name = 'NewsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NewsPage();
    },
  );
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return RegisterPage();
    },
  );
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}

/// generated route for
/// [UpcomingEventsPage]
class UpcomingEventsRoute extends PageRouteInfo<void> {
  const UpcomingEventsRoute({List<PageRouteInfo>? children})
    : super(UpcomingEventsRoute.name, initialChildren: children);

  static const String name = 'UpcomingEventsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UpcomingEventsPage();
    },
  );
}

/// generated route for
/// [VerifyOtpPage]
class VerifyOtpRoute extends PageRouteInfo<VerifyOtpRouteArgs> {
  VerifyOtpRoute({required String mobile, List<PageRouteInfo>? children})
    : super(
        VerifyOtpRoute.name,
        args: VerifyOtpRouteArgs(mobile: mobile),
        initialChildren: children,
      );

  static const String name = 'VerifyOtpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerifyOtpRouteArgs>();
      return VerifyOtpPage(mobile: args.mobile);
    },
  );
}

class VerifyOtpRouteArgs {
  const VerifyOtpRouteArgs({required this.mobile});

  final String mobile;

  @override
  String toString() {
    return 'VerifyOtpRouteArgs{mobile: $mobile}';
  }
}
