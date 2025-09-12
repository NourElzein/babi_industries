// ============= register_controller.dart =============
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'auth_controller.dart';

class RegisterController extends GetxController {
  final AuthController authController = Get.find();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final employeeIdController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final companyController = TextEditingController(text: 'Babi Industries');
  final formKey = GlobalKey<FormState>();

  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var isLoading = false.obs;
  var selectedRole = 'Supply Chain Manager'.obs;

  final List<String> roles = [
    'Supply Chain Manager',
    'Purchasing Agent',
    'Warehouse Manager',
    'Logistics Coordinator',
    'Administrator',
    'Buyer',
  ];

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    employeeIdController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    companyController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  void setSelectedRole(String role) => selectedRole.value = role;

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    final success = await authController.registerUser(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      employeeId: employeeIdController.text.trim().isEmpty 
          ? 'EMP${DateTime.now().millisecondsSinceEpoch}' 
          : employeeIdController.text.trim(),
      password: passwordController.text,
      role: selectedRole.value,
      company: companyController.text.trim(),
    );

    if (success) {
      Get.snackbar(
        'Success',
        'Registration successful! Welcome ${nameController.text.trim()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate to role-based dashboard
      final route = authController.getDashboardRouteForRole(selectedRole.value);
      Get.offAllNamed(route);
    }

    isLoading.value = false;
  }

  void goToLogin() => Get.back();
  
  // Validators
  String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    if (value.length < 2) return 'Name must be at least 2 characters';
    return null;
  }
  
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(value)) return 'Please enter a valid email';
    return null;
  }
  
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone is required';
    if (value.length < 10) return 'Please enter a valid phone number';
    return null;
  }
  
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
  
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }
}