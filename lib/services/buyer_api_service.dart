
// buyer_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class BuyerApiService {
  static const String baseUrl = "https://55f7713f-f73a-4a94-8072-fa79e3ba67b6.mock.pstmn.io";

  static Future<Map<String, dynamic>> fetchBuyerKpis(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/buyer/kpis'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body);
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch buyer KPIs: ${response.statusCode}');
  }

  static Future<List<dynamic>> fetchBuyerOrders(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/buyer/orders'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body)['orders'];
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch orders: ${response.statusCode}');
  }

  static Future<List<dynamic>> fetchSuggestedSuppliers(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/buyer/suppliers/suggested'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body)['suppliers'];
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch suggested suppliers: ${response.statusCode}');
  }

  static Future<List<dynamic>> fetchBuyerAlerts(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/buyer/alerts'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body)['alerts'];
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch buyer alerts: ${response.statusCode}');
  }

  static Future<List<dynamic>> fetchBuyerActivities(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/buyer/activities'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body)['activities'];
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch activities: ${response.statusCode}');
  }

  static Future<List<dynamic>> fetchBuyerNotifications(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/buyer/notifications'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body)['notifications'];
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch notifications: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> fetchPriceComparisons(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/buyer/price-comparisons'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body);
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch price comparisons: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> fetchBuyerInsights(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/buyer/insights'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body);
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch buyer insights: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> createQuickOrder(String token, Map<String, dynamic> orderData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/buyer/orders/quick'),
      headers: _headers(token),
      body: json.encode(orderData),
    );

    if (response.statusCode == 201) return json.decode(response.body);
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to create order: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> duplicateOrder(String token, String orderId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/buyer/orders/$orderId/duplicate'),
      headers: _headers(token),
    );

    if (response.statusCode == 201) return json.decode(response.body);
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to duplicate order: ${response.statusCode}');
  }

  static Future<List<dynamic>> searchSuppliers(String token, String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/buyer/suppliers/search?q=$query'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body)['suppliers'];
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to search suppliers: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> getSupplierDetails(String token, String supplierId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/buyer/suppliers/$supplierId'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body);
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch supplier details: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> updateOrderStatus(String token, String orderId, String status) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/buyer/orders/$orderId/status'),
      headers: _headers(token),
      body: json.encode({'status': status}),
    );

    if (response.statusCode == 200) return json.decode(response.body);
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to update order status: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> contactSupplier(String token, String supplierId, Map<String, dynamic> message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/buyer/suppliers/$supplierId/contact'),
      headers: _headers(token),
      body: json.encode(message),
    );

    if (response.statusCode == 200) return json.decode(response.body);
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to contact supplier: ${response.statusCode}');
  }

  static Future<List<dynamic>> getOrderTimeline(String token, String orderId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/buyer/orders/$orderId/timeline'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body)['timeline'];
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch order timeline: ${response.statusCode}');
  }

  static Map<String, String> _headers(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }
}