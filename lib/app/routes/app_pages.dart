import 'package:get/get.dart';

import '../modules/splash/views/splash_view.dart';
import '../modules/verify_mobile/views/verify_mobile_view.dart';
import '../modules/verify_mobile/bindings/verify_mobile_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: Routes.SPLASH, page: () => const SplashView()),
    GetPage(
      name: Routes.VERIFY_MOBILE,
      page: () => const VerifyMobileView(),
      binding: VerifyMobileBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
  ];
}
