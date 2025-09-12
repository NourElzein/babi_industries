// ============= auth_controller.dart =============
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  var isLoggedIn = false.obs;
  var currentUser = Rx<UserModel?>(null);
  var token = ''.obs;
  var isLoading = false.obs;

  // Store registered users locally for mock validation
  final registeredUsers = <String, Map<String, dynamic>>{}.obs;

  final String baseUrl = 'https://55f7713f-f73a-4a94-8072-fa79e3ba67b6.mock.pstmn.io';

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    // In a real app, load user & token from secure storage
    isLoggedIn.value = false;
  }

  // Login function connected to Postman
  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;

      // Check if user is registered (in a real app, this would be server-side)
      if (!registeredUsers.containsKey(email)) {
        Get.snackbar(
          'Error',
          'This email is not registered. Please register first.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      // Verify password (in a real app, this would be server-side)
      final userData = registeredUsers[email]!;
      if (userData['password'] != password) {
        Get.snackbar(
          'Error',
          'Invalid password. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Use the stored user data with the response token
        final responseData = jsonDecode(response.body);
        
        // Create user model from registered data
        final userJson = {
          'id': userData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
          'name': userData['name'],
          'email': userData['email'],
          'role': userData['role'],
          'company': userData['company'] ?? 'Babi Industries',
          'profile_image': null,
          'created_at': userData['created_at'] ?? DateTime.now().toIso8601String(),
          'last_login_at': DateTime.now().toIso8601String(),
        };
        
        currentUser.value = UserModel.fromJson(userJson);
        token.value = responseData['token'] ?? 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
        isLoggedIn.value = true;
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Login failed: ${response.body}',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e', snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Register function connected to Postman
  Future<bool> registerUser({
    required String name,
    required String email,
    required String phone,
    required String employeeId,
    required String password,
    required String role,
    String company = 'Babi Industries',
  }) async {
    try {
      isLoading.value = true;

      // Check if email already exists
      if (registeredUsers.containsKey(email)) {
        Get.snackbar(
          'Error',
          'This email is already registered. Please login instead.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'employeeId': employeeId,
          'password': password,
          'role': role,
          'company': company,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        // Store user data locally for login validation
        registeredUsers[email] = {
          'id': data['user']['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
          'name': name,
          'email': email,
          'phone': phone,
          'employeeId': employeeId,
          'password': password, // In real app, never store plain passwords
          'role': role,
          'company': company,
          'created_at': DateTime.now().toIso8601String(),
        };
        
        currentUser.value = UserModel.fromJson(data['user']);
        token.value = data['token'] ?? 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
        isLoggedIn.value = true;
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Registration failed: ${response.body}',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Registration failed: $e', snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    isLoggedIn.value = false;
    currentUser.value = null;
    token.value = '';
    Get.offAllNamed('/login');
  }
  
  // Helper method to get dashboard route based on role
  String getDashboardRouteForRole(String role) {
    switch (role.toLowerCase()) {
      case 'supply chain manager':
      case 'supply_chain_manager':
        return '/dashboard/manager';
      case 'buyer':
      case 'senior buyer':
      case 'senior_buyer':
      case 'purchasing agent':
        return '/dashboard/buyer';
      case 'warehouse manager':
      case 'warehouse_manager':
        return '/dashboard/warehouse';
      case 'logistics coordinator':
      case 'logistics_coordinator':
        return '/dashboard/logistics';
      case 'administrator':
        return '/dashboard/manager'; // Admin gets manager dashboard
      default:
        return '/home';
    }
  }
}