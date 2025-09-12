import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Only manage AuthController - let StatefulWidgets manage their own TextControllers
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}