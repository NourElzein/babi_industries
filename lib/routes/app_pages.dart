import 'package:babi_industries/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'app_routes.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';
import '../views/dashboard/manager_dashboard_view.dart';
import '../views/buyer_dashboard/buyer_dashboard_view.dart';
import '../views/dashboard/warehouse_dashboard_view.dart';
import '../views/dashboard/logistics_dashboard_view.dart';
import '../bindings/auth_binding.dart';

class AppPages {
  AppPages._();

  static final routes = [
    // Auth routes - LoginView now doesn't need LoginController binding
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginView(),
      binding: BindingsBuilder(() {
        // Only bind AuthController, not LoginController
        Get.put<AuthController>(AuthController(), permanent: true);
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => const RegisterView(),
      binding: BindingsBuilder(() {
        // Only bind AuthController for registration
        Get.put<AuthController>(AuthController(), permanent: true);
      }),
      transition: Transition.rightToLeft,
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