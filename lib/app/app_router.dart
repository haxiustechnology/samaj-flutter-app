import 'package:auto_route/auto_route.dart';
import '../features/auth/view/login_page.dart';
import '../features/auth/view/verify_otp_page.dart';
import '../features/auth/view/register_page.dart';
import '../features/splash/view/splash_page.dart';
import '../features/home/view/home_screen.dart';
import '../features/home/view/news_page.dart';
import '../features/home/view/gallery_page.dart';
import '../features/home/view/upcoming_events_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
// extend the generated private router
class AppRouter  extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: VerifyOtpRoute.page),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: NewsRoute.page),
    AutoRoute(page: GalleryRoute.page),
    AutoRoute(page: UpcomingEventsRoute.page),
  ];
}
