import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BuyerApiService {
  static const String baseUrl = "https://55f7713f-f73a-4a94-8072-fa79e3ba67b6.mock.pstmn.io";

  static Map<String, String> _headers(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // -------------------- Fetch Data --------------------
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

    if (response.statusCode == 200) return json.decode(response.body) as List<dynamic>;
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch orders: ${response.statusCode}');
  }

  static Future<List<dynamic>> fetchBuyerNotifications(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/buyer/notifications'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['notifications'] as List<dynamic>; // fix: access key
    }
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch notifications: ${response.statusCode}');
  }

  static Future<List<dynamic>> fetchBuyerInsights(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/buyer/insights'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body) as List<dynamic>;
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to fetch buyer insights: ${response.statusCode}');
  }

  // -------------------- Buyer Actions --------------------
  static Future<Map<String, dynamic>> createQuickOrder(
      String token, Map<String, dynamic> orderData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/buyer/orders/quick'),
      headers: _headers(token),
      body: json.encode(orderData),
    );

    if (response.statusCode == 201) return json.decode(response.body);
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to create quick order: ${response.statusCode}');
  }

  static Future<List<dynamic>> searchSuppliers(String token, String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/buyer/suppliers/search?q=$query'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return json.decode(response.body)['suppliers'] as List<dynamic>;
    if (response.statusCode == 401) throw Exception('User not authenticated');
    throw Exception('Failed to search suppliers: ${response.statusCode}');
  }
}
