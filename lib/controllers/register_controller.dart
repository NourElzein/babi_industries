import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

  // Hive box for offline storage
  late Box registerBox;

  @override
  void onInit() {
    super.onInit();
    _initHive();
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();
    registerBox = await Hive.openBox('registerBox');

    // Load cached form data if available
    nameController.text = registerBox.get('name', defaultValue: '');
    emailController.text = registerBox.get('email', defaultValue: '');
    phoneController.text = registerBox.get('phone', defaultValue: '');
    employeeIdController.text = registerBox.get('employeeId', defaultValue: '');
    companyController.text = registerBox.get('company', defaultValue: 'Babi Industries');
    selectedRole.value = registerBox.get('selectedRole', defaultValue: 'Supply Chain Manager');
  }

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
  void setSelectedRole(String role) {
    selectedRole.value = role;
    registerBox.put('selectedRole', role); // save selection offline
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    // Save form data offline before registering
    registerBox.put('name', nameController.text.trim());
    registerBox.put('email', emailController.text.trim());
    registerBox.put('company', companyController.text.trim());

    isLoading.value = true;

    final success = await authController.registerUser(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      role: selectedRole.value,
      company: companyController.text.trim(),
    );

    if (success) {
      Get.snackbar(
        'Success',
        'Registration successful! Please login with your credentials.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      // Clear cached form data on successful registration
      registerBox.clear();

      // Navigate to login page instead of dashboard
      Get.offAllNamed(AppRoutes.LOGIN);
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
