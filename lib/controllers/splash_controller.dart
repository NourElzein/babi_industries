import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'auth_controller.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    print("⏳ Splash screen started... waiting 3 seconds");
    await Future.delayed(Duration(seconds: 3));

    try {
      final AuthController authController = Get.find<AuthController>();
      print("✅ AuthController found. isLoggedIn = ${authController.isLoggedIn.value}");

      if (authController.isLoggedIn.value) {
        print("➡️ Navigating to HOME");
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        print("➡️ Navigating to LOGIN");
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    } catch (e) {
      print("❌ AuthController not found: $e");
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
