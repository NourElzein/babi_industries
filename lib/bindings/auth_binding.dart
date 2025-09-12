import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/login_controller.dart';
import '../controllers/register_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(),
      fenix: true,
    );
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
    Get.lazyPut<RegisterController>(
      () => RegisterController(),
    );
  }
}