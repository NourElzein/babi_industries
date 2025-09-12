import 'package:get/get.dart';
import 'app_routes.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';
import '../views/home/home_view.dart';
import '../views/dashboard/manager_dashboard_view.dart';
import '../views/dashboard/buyer_dashboard_view.dart';
import '../views/dashboard/warehouse_dashboard_view.dart';
import '../views/dashboard/logistics_dashboard_view.dart';
import '../bindings/auth_binding.dart';

class AppPages {
  AppPages._();

  static final routes = [
    // Auth routes
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegisterView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),

    // Home
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),

    // Dashboards by role
    GetPage(
      name: AppRoutes.DASHBOARD_MANAGER,
      page: () => ManagerDashboardView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.DASHBOARD_BUYER,
      page: () => BuyerDashboardView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.DASHBOARD_WAREHOUSE,
      page: () => WarehouseDashboardView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.DASHBOARD_LOGISTICS,
      page: () => LogisticsDashboardView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
