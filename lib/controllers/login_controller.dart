import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  final AuthController authController = Get.find();

  // Use late initialization to prevent disposal issues
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final GlobalKey<FormState> formKey;

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  // Track if controller is disposed
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers fresh each time
    emailController = TextEditingController();
    passwordController = TextEditingController();
    formKey = GlobalKey<FormState>();
    _isDisposed = false;
  }

  @override
  void onClose() {
    _isDisposed = true;
    // Safely dispose controllers
    try {
      emailController.dispose();
      passwordController.dispose();
    } catch (e) {
      // Ignore disposal errors
    }
    super.onClose();
  }

  void togglePasswordVisibility() {
    if (_isDisposed) return;
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (_isDisposed) return;
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final success = await authController.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (_isDisposed) return; // Check if disposed during async operation

      if (success) {
        Get.snackbar(
          'Success',
          'Login successful! Welcome back ${authController.currentUser.value?.name}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

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
    } catch (e) {
      if (!_isDisposed) {
        Get.snackbar(
          'Error',
          'Login failed. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      if (!_isDisposed) {
        isLoading.value = false;
      }
    }
  }

  void goToRegister() {
    if (_isDisposed) return;
    Get.toNamed(AppRoutes.REGISTER);
  }

  void forgotPassword() {
    if (_isDisposed) return;
    Get.snackbar(
      'Info',
      'Password reset functionality will be implemented soon.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

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