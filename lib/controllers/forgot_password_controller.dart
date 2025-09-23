import 'dart:convert';
import 'dart:math';
import 'package:babi_industries/services/api_service.dart' show ApiService;
import 'package:flutter/material.dart' show Colors;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'auth_controller.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find<ForgotPasswordController>();

  // Reactive variables for UI state management
  final email = ''.obs;
  final newPassword = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final successMessage = ''.obs;

  // For password reset verification (kept for legacy support)
  final _resetTokens = <String, Map<String, dynamic>>{};

  @override
  void onInit() {
    super.onInit();
    _cleanupExpiredTokens();
  }

  /// Clear all messages
  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }

  /// Direct password reset using API service (Option 1)
  Future<bool> resetPasswordDirect({
    required String email,
    required String newPassword,
  }) async {
    isLoading.value = true;
    clearMessages();

    try {
      // Validate input locally first
      if (email.trim().isEmpty) {
        errorMessage.value = 'Email is required';
        return false;
      }

      if (newPassword.trim().isEmpty) {
        errorMessage.value = 'New password is required';
        return false;
      }

      if (!_isValidPassword(newPassword)) {
        errorMessage.value = 'Password must be at least 6 characters long';
        return false;
      }

      // Call the API service
      final response = await ApiService.resetPassword(
        email: email.trim().toLowerCase(),
        newPassword: newPassword.trim(),
      );

      // Update local storage if API call is successful
      await _updateLocalPassword(email.trim().toLowerCase(), newPassword.trim());

      successMessage.value = response['message'] ?? 'Password updated successfully!';
      return true;

    } catch (e) {
      // Handle different error types
      String errorMsg = e.toString().replaceFirst('Exception: ', '');
      
      if (errorMsg.contains('No account found')) {
        errorMessage.value = 'No account found with this email address';
      } else if (errorMsg.contains('Invalid password')) {
        errorMessage.value = 'Password must be at least 6 characters long';
      } else if (errorMsg.contains('Failed to reset password: 400')) {
        errorMessage.value = 'Invalid request. Please check your input';
      } else if (errorMsg.contains('Failed to reset password: 500')) {
        errorMessage.value = 'Server error. Please try again later';
      } else {
        errorMessage.value = 'Failed to update password. Please try again';
      }
      
      print('Direct password reset error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Legacy method for backwards compatibility with old dialog
  Future<void> resetPassword() async {
    final emailValue = email.value.trim();
    final newPasswordValue = newPassword.value.trim();

    final success = await resetPasswordDirect(
      email: emailValue,
      newPassword: newPasswordValue,
    );

    if (success) {
      Get.snackbar(
        'Success',
        successMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear fields
      email.value = '';
      newPassword.value = '';
    } else {
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Send password reset email (kept for Option 2 if needed later)
  Future<bool> sendPasswordResetEmail(String emailAddress) async {
    isLoading.value = true;
    clearMessages();

    try {
      final authController = AuthController.instance;
      final emailValue = emailAddress.trim().toLowerCase();

      // Validate email exists in registered users
      if (!authController.registeredUsers.containsKey(emailValue)) {
        errorMessage.value = 'No account found with this email address.';
        return false;
      }

      // Generate a reset token (simulate real-world token generation)
      final resetToken = _generateResetToken();
      final expirationTime = DateTime.now().add(const Duration(hours: 1));

      // Store reset token with expiration
      _resetTokens[emailValue] = {
        'token': resetToken,
        'expires': expirationTime,
        'used': false,
      };

      // Simulate API call to send email
      await _sendResetEmailToServer(emailValue, resetToken);

      successMessage.value = 'Password reset instructions sent to your email.';
      
      // Log the token for testing purposes (remove in production)
      print('Reset token for $emailValue: $resetToken (expires: $expirationTime)');

      return true;
    } catch (e) {
      errorMessage.value = 'Unable to send reset email. Please try again.';
      print('Reset email error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update local storage after successful API call
  Future<void> _updateLocalPassword(String email, String newPassword) async {
    try {
      final authController = AuthController.instance;
      
      // Update offline storage if user exists locally
      if (authController.registeredUsers.containsKey(email)) {
        final user = authController.registeredUsers[email]!;
        user['password'] = newPassword;
        user['passwordUpdatedAt'] = DateTime.now().toIso8601String();
        
        await authController.usersBox.put(email, user);
        authController.registeredUsers[email] = user;
        
        print('Local password updated for $email');
      }
    } catch (e) {
      print('Failed to update local password: $e');
      // Don't throw error here as API call was successful
    }
  }

  /// Verify reset token and update password (kept for Option 2)
  Future<bool> resetPasswordWithToken({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    isLoading.value = true;
    clearMessages();

    try {
      final emailValue = email.trim().toLowerCase();

      // Check if token exists and is valid
      if (!_resetTokens.containsKey(emailValue)) {
        errorMessage.value = 'Invalid or expired reset link.';
        return false;
      }

      final tokenData = _resetTokens[emailValue]!;
      
      // Verify token hasn't been used
      if (tokenData['used'] == true) {
        errorMessage.value = 'This reset link has already been used.';
        return false;
      }

      // Verify token hasn't expired
      if (DateTime.now().isAfter(tokenData['expires'])) {
        errorMessage.value = 'Reset link has expired. Please request a new one.';
        _resetTokens.remove(emailValue);
        return false;
      }

      // Verify token matches
      if (tokenData['token'] != token) {
        errorMessage.value = 'Invalid reset link.';
        return false;
      }

      // Validate new password
      if (!_isValidPassword(newPassword)) {
        errorMessage.value = 'Password must be at least 6 characters long.';
        return false;
      }

      // Update password
      await _updateUserPassword(emailValue, newPassword);

      // Mark token as used
      tokenData['used'] = true;

      successMessage.value = 'Password updated successfully! You can now log in with your new password.';
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to update password. Please try again.';
      print('Password reset error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Generate a secure reset token
  String _generateResetToken() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return String.fromCharCodes(
      List.generate(32, (index) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  /// Simulate sending reset email to server
  Future<void> _sendResetEmailToServer(String email, String token) async {
    try {
      final authController = AuthController.instance;
      await http.post(
        Uri.parse('${authController.baseUrl}/send-reset-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'resetToken': token,
          'expiresAt': DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
        }),
      );
    } catch (e) {
      print('Offline mode: Reset email would be sent to $email');
    }
  }

  /// Update user password in storage and server (legacy method)
  Future<void> _updateUserPassword(String email, String newPassword) async {
    final authController = AuthController.instance;

    // Update offline storage
    final user = authController.registeredUsers[email]!;
    user['password'] = newPassword;
    user['passwordUpdatedAt'] = DateTime.now().toIso8601String();
    
    await authController.usersBox.put(email, user);
    authController.registeredUsers[email] = user;

    // Update server if available
    try {
      await http.put(
        Uri.parse('${authController.baseUrl}/update-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': newPassword,
          'updatedAt': DateTime.now().toIso8601String(),
        }),
      );
    } catch (e) {
      print('Offline mode: Password updated locally for $email');
    }
  }

  /// Validate password strength
  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Clean up expired reset tokens
  void _cleanupExpiredTokens() {
    final now = DateTime.now();
    _resetTokens.removeWhere((email, tokenData) => 
        now.isAfter(tokenData['expires'] as DateTime));
  }

  /// Check if a reset token is valid (for testing purposes)
  bool isTokenValid(String email, String token) {
    final emailValue = email.trim().toLowerCase();
    if (!_resetTokens.containsKey(emailValue)) return false;
    
    final tokenData = _resetTokens[emailValue]!;
    return tokenData['token'] == token &&
           !tokenData['used'] &&
           DateTime.now().isBefore(tokenData['expires']);
  }

  /// Get all active tokens (for testing/debugging)
  Map<String, Map<String, dynamic>> getActiveTokens() {
    _cleanupExpiredTokens();
    return Map.from(_resetTokens);
  }

  @override
  void onClose() {
    _resetTokens.clear();
    super.onClose();
  }
}