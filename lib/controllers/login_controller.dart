import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  final AuthController authController = Get.find();

  // Keep controllers alive with the controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  @override
  void onClose() {
    // Only dispose if you are sure the controller will not be used again
    // Otherwise, use fenix:true in the binding to automatically recreate
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    final success = await authController.login(
      emailController.text.trim(),
      passwordController.text,
    );

    if (success) {
      Get.snackbar(
        'Success',
        'Login successful! Welcome back ${authController.currentUser.value?.name}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to role-based dashboard
      final role = authController.currentUser.value?.role ?? '';
      final route = getDashboardRouteForRole(role);
      Get.offAllNamed(route);
    } else {
      Get.snackbar(
        'Error',
        'Invalid credentials. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    isLoading.value = false;
  }

  void goToRegister() => Get.toNamed(AppRoutes.REGISTER);

  void forgotPassword() {
    Get.snackbar(
      'Info',
      'Password reset functionality will be implemented soon.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Validators
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(value)) return 'Please enter a valid email';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  // Role-based dashboard routing
  String getDashboardRouteForRole(String role) {
    switch (role) {
      case 'Supply Chain Manager':
        return AppRoutes.DASHBOARD_MANAGER;
      case 'Buyer':
        return AppRoutes.DASHBOARD_BUYER;
      case 'Warehouse Manager':
        return AppRoutes.DASHBOARD_WAREHOUSE;
      case 'Logistics Coordinator':
        return AppRoutes.DASHBOARD_LOGISTICS;
      default:
        return AppRoutes.HOME;
    }
  }
}
