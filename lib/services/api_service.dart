import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://55f7713f-f73a-4a94-8072-fa79e3ba67b6.mock.pstmn.io";

  static Future<Map<String, dynamic>> fetchKpis(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/manager/kpis'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body);
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch KPIs: ${response.statusCode}');
  }

  static Future<List<dynamic>> fetchSuppliers(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/suppliers'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body)['suppliers'];
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch suppliers: ${response.statusCode}');
  }

  static Future<List<dynamic>> fetchOrders(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body)['orders'];
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch orders: ${response.statusCode}');
  }

  static Future<List<dynamic>> fetchAlerts(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/alerts'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body)['alerts'];
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch alerts: ${response.statusCode}');
  }

  static Future<List<dynamic>> fetchActivities(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/activities'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body)['activities'];
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch activities: ${response.statusCode}');
  }

  static Future<List<dynamic>> fetchNotifications(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notifications'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body)['notifications'];
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch notifications: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> fetchForecast(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/manager/forecast'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body);
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch forecast: ${response.statusCode}');
  }

  /// Reset password directly without email verification
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'newPassword': newPassword,
      }),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      return responseBody;
    }
    
    // Handle specific error cases
    if (response.statusCode == 404) {
      throw Exception('No account found with this email address');
    }
    
    if (response.statusCode == 400) {
      throw Exception(responseBody['message'] ?? 'Invalid password requirements');
    }
    
    throw Exception('Failed to reset password: ${response.statusCode}');
  }

  static Map<String, String> _headers(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }
}