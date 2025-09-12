import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import '../controllers/auth_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure AuthController is available
    Get.put<AuthController>(AuthController(), permanent: true);
    
    // Initialize SplashController
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );
  }
}