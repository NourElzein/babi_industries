// ============= auth_controller.dart (SECURE & COMPLETE VERSION) =============
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart'; // for password hashing
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  /// Observables
  var isLoggedIn = false.obs;
  var currentUser = Rx<UserModel?>(null);
  var token = ''.obs;
  var isLoading = false.obs;

  /// Offline user data
  final registeredUsers = <String, Map<String, dynamic>>{}.obs;
  late Box usersBox;

  /// Secure token storage
  final _secureStorage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  /// API base URL (replace with your production endpoint)
  final String baseUrl =
      'https://55f7713f-f73a-4a94-8072-fa79e3ba67b6.mock.pstmn.io';

  @override
  void onInit() async {
    super.onInit();
    // 1) Open Hive for offline users
    usersBox = await Hive.openBox('usersBox');
    _loadUsersFromHive();

    // 2) Try to restore token from secure storage
    await _restoreSession();
  }

  /// Load users from Hive to memory
  void _loadUsersFromHive() {
    for (var key in usersBox.keys) {
      registeredUsers[key] = Map<String, dynamic>.from(usersBox.get(key));
    }
  }

  /// Securely hash password before saving locally
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  /// Try to restore session on app start
  Future<void> _restoreSession() async {
    final savedToken = await _secureStorage.read(key: _tokenKey);
    if (savedToken != null) {
      token.value = savedToken;
      isLoggedIn.value = true;
      // Optionally reload user data if needed
    }
  }

  /// Save token securely
  Future<void> _persistToken(String newToken) async {
    token.value = newToken;
    await _secureStorage.write(key: _tokenKey, value: newToken);
  }

  /// Delete token securely (on logout)
  Future<void> _clearToken() async {
    token.value = '';
    await _secureStorage.delete(key: _tokenKey);
  }

  /// LOGIN with offline fallback
  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;

      // Check local user existence
      if (!registeredUsers.containsKey(email)) {
        Get.snackbar('Error', 'This email is not registered. Please register first.',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }

      final userData = registeredUsers[email]!;

      // Verify hashed password locally
      final hashedInput = _hashPassword(password);
      if (userData['password_hash'] != hashedInput) {
        Get.snackbar('Error', 'Invalid password. Please try again.',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }

      // Try online login
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          currentUser.value = UserModel.fromJson(userData);
          final newToken = responseData['token'] ??
              'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
          await _persistToken(newToken);
          isLoggedIn.value = true;
          return true;
        } else {
          // Fallback to offline login
          currentUser.value = UserModel.fromJson(userData);
          final offlineToken =
              'offline_token_${DateTime.now().millisecondsSinceEpoch}';
          await _persistToken(offlineToken);
          isLoggedIn.value = true;
          return true;
        }
      } catch (e) {
        // Offline mode login
        currentUser.value = UserModel.fromJson(userData);
        final offlineToken =
            'offline_token_${DateTime.now().millisecondsSinceEpoch}';
        await _persistToken(offlineToken);
        isLoggedIn.value = true;
        return true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// REGISTER user with offline storage support
  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
    String company = 'Babi Industries',
  }) async {
    try {
      isLoading.value = true;

      if (registeredUsers.containsKey(email)) {
        Get.snackbar('Error',
            'This email is already registered. Please login instead.',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }

      final hashedPassword = _hashPassword(password);

      try {
        final response = await http.post(
          Uri.parse('$baseUrl/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
            'role': role,
            'company': company,
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body);
          final userJson = {
            'id': data['user']['id'] ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            'name': name,
            'email': email,
            'password_hash': hashedPassword,
            'role': role,
            'company': company,
            'created_at': DateTime.now().toIso8601String(),
            'last_login_at': DateTime.now().toIso8601String(),
          };

          registeredUsers[email] = userJson;
          await usersBox.put(email, userJson);

          currentUser.value = UserModel.fromJson(userJson);
          final newToken = data['token'] ??
              'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
          await _persistToken(newToken);
          isLoggedIn.value = true;
          return true;
        } else {
          Get.snackbar('Error', 'Registration failed: ${response.body}',
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
      } catch (e) {
        // Offline registration fallback
        final userJson = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'name': name,
          'email': email,
          'password_hash': hashedPassword,
          'role': role,
          'company': company,
          'created_at': DateTime.now().toIso8601String(),
          'last_login_at': DateTime.now().toIso8601String(),
        };

        registeredUsers[email] = userJson;
        await usersBox.put(email, userJson);

        currentUser.value = UserModel.fromJson(userJson);
        final offlineToken =
            'offline_token_${DateTime.now().millisecondsSinceEpoch}';
        await _persistToken(offlineToken);
        isLoggedIn.value = true;
        return true;
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// LOGOUT and clear secure token
  Future<void> logout() async {
    isLoggedIn.value = false;
    currentUser.value = null;
    await _clearToken();
    Get.offAllNamed('/login');
  }

  /// Get dashboard route based on role
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
        return '/dashboard/manager';
      default:
        return '/home';
    }
  }
}
