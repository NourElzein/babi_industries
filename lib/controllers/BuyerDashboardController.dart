import 'package:babi_industries/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/buyer_api_service.dart';
import '../controllers/auth_controller.dart';

class SupplierRecommendation {
  final String id;
  final String name;
  final String category;
  final String badge;
  final Color badgeColor;
  final String performance;
  final String totalOrders;
  final double rating;

  SupplierRecommendation({
    required this.id,
    required this.name,
    required this.category,
    required this.badge,
    required this.badgeColor,
    required this.performance,
    required this.totalOrders,
    required this.rating,
  });
}

class BuyerAlert {
  final String id;
  final String type;
  final String title;
  final String message;
  final Color color;
  final IconData icon;
  final DateTime timestamp;
  final bool isUrgent;

  BuyerAlert({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.color,
    required this.icon,
    required this.timestamp,
    required this.isUrgent,
  });
}

class BuyerInsight {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String trend;

  BuyerInsight({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.trend,
  });
}

class BuyerDashboardController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  // ---------------- Observables ----------------
  var orders = <Map<String, dynamic>>[].obs;
  var suggestedSuppliers = <SupplierRecommendation>[].obs;
  var alerts = <BuyerAlert>[].obs;
  var notifications = <Map<String, dynamic>>[].obs;
  var insights = <BuyerInsight>[].obs;
  var orderTimelines = <String, List<Map<String, dynamic>>>{}.obs;

  // Loading states
  var isLoading = false.obs;
  var isLoadingOrders = false.obs;
  var isLoadingSuppliers = false.obs;
  var errorMessage = ''.obs;

  // ---------------- KPI Observables ----------------
  var totalOrders = 0.obs;
  var pendingOrders = 0.obs;
  var processingOrders = 0.obs;
  var inTransitOrders = 0.obs;
  var deliveredOrders = 0.obs;
  var cancelledOrders = 0.obs;
  var activeSuppliers = 0.obs;
  var avgDeliveryTime = ''.obs;
  var monthlySpend = ''.obs;
  var urgentIssues = 0.obs;
  var completionRate = ''.obs;
  var costSavings = ''.obs;
  var supplierSatisfaction = ''.obs;

  var orderEfficiencyTrend = ''.obs;
  var costSavingsTrend = ''.obs;
  var deliveryTimeTrend = ''.obs;
  var weeklyOrderCount = 0.obs;
  var monthlyOrderCount = 0.obs;

  // Navigation
  var selectedBottomNavIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  // --------------------- Fetch Data ---------------------
  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final token = authController.currentUser.value?.token ?? '';

      // Fetch all data in parallel
      await Future.wait([
        fetchManagerData(token), // Common data for buyer
        fetchBuyerSpecificData(token), // Buyer-only data
      ]);
    } catch (e) {
      errorMessage.value = e.toString();
      print('Dashboard fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------- Manager API (Common Data) ----------------
  Future<void> fetchManagerData(String token) async {
    try {
      final kpis = await ApiService.fetchKpis(token);
      activeSuppliers.value = kpis['active_suppliers'];
      avgDeliveryTime.value = kpis['avg_delivery_time'];
      costSavings.value = kpis['cost_savings'];
      supplierSatisfaction.value = kpis['supplier_satisfaction'];

      final suppliersData = await ApiService.fetchSuppliers(token);
      suggestedSuppliers.value = suppliersData.map<SupplierRecommendation>((supplier) {
        return SupplierRecommendation(
          id: supplier['id'],
          name: supplier['name'],
          category: supplier['category'] ?? 'N/A',
          badge: supplier['badge'] ?? 'N/A',
          badgeColor: _getBadgeColor(supplier['badge']),
          performance: '${supplier['performance_score']}%',
          totalOrders: '${supplier['total_orders']} orders',
          rating: supplier['rating'].toDouble(),
        );
      }).toList();

      final alertsData = await ApiService.fetchAlerts(token);
      alerts.value = alertsData.map<BuyerAlert>((alert) {
        return BuyerAlert(
          id: alert['id'],
          type: alert['type'],
          title: alert['title'],
          message: alert['message'],
          color: _getAlertColor(alert['type']),
          icon: _getAlertIcon(alert['type']),
          timestamp: DateTime.parse(alert['timestamp']),
          isUrgent: alert['is_urgent'],
        );
      }).toList();
    } catch (e) {
      print('Manager data fetch error: $e');
    }
  }

  /// ---------------- Buyer API (Buyer-Specific Data) ----------------
  Future<void> fetchBuyerSpecificData(String token) async {
    try {
      // KPIs
      final buyerKpis = await BuyerApiService.fetchBuyerKpis(token);
      totalOrders.value = buyerKpis['total_orders'];
      pendingOrders.value = buyerKpis['pending_orders'];
      processingOrders.value = buyerKpis['processing_orders'];
      inTransitOrders.value = buyerKpis['in_transit_orders'];
      deliveredOrders.value = buyerKpis['delivered_orders'];
      cancelledOrders.value = buyerKpis['cancelled_orders'];
      monthlySpend.value = buyerKpis['monthly_spend'];
      urgentIssues.value = buyerKpis['urgent_issues'];
      completionRate.value = buyerKpis['completion_rate'];

      orderEfficiencyTrend.value = buyerKpis['order_efficiency_trend'];
      costSavingsTrend.value = buyerKpis['cost_savings_trend'];
      deliveryTimeTrend.value = buyerKpis['delivery_time_trend'];
      weeklyOrderCount.value = buyerKpis['weekly_order_count'];
      monthlyOrderCount.value = buyerKpis['monthly_order_count'];

      // Orders & Notifications
      orders.value = (await BuyerApiService.fetchBuyerOrders(token)).cast<Map<String, dynamic>>();
      notifications.value = (await BuyerApiService.fetchBuyerNotifications(token)).cast<Map<String, dynamic>>();
      insights.value = (await BuyerApiService.fetchBuyerInsights(token) as List)
          .map<BuyerInsight>((insight) {
        return BuyerInsight(
          title: insight['title'],
          description: insight['description'],
          icon: _mapInsightIcon(insight['icon']),
          color: _mapInsightColor(insight['color']),
          trend: insight['trend'],
        );
      }).toList();
    } catch (e) {
      print('Buyer data fetch error: $e');
    }
  }

  // --------------------- Utilities ---------------------
  Color _getBadgeColor(String? badge) {
    switch (badge?.toLowerCase()) {
      case 'verified':
        return Colors.green;
      case 'top rated':
        return Colors.blue;
      case 'fast delivery':
        return Colors.purple;
      case 'best price':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getAlertColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'delay':
      case 'error':
        return Colors.red;
      case 'warning':
      case 'stock':
        return Colors.orange;
      case 'info':
      case 'payment':
        return Colors.blue;
      case 'success':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getAlertIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'delay':
        return Icons.access_time;
      case 'stock':
        return Icons.inventory;
      case 'payment':
        return Icons.payment;
      case 'delivery':
        return Icons.local_shipping;
      case 'supplier':
        return Icons.business;
      default:
        return Icons.info;
    }
  }

  IconData _mapInsightIcon(String? iconName) {
    switch (iconName) {
      case 'trending_up':
        return Icons.trending_up;
      case 'savings':
        return Icons.savings;
      case 'schedule':
        return Icons.schedule;
      default:
        return Icons.insights;
    }
  }

  Color _mapInsightColor(String? colorName) {
    switch (colorName?.toLowerCase()) {
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // --------------------- Buyer Actions ---------------------
  Future<void> createQuickOrder(Map<String, dynamic> orderData) async {
    try {
      final token = authController.currentUser.value?.token ?? '';
      final result = await BuyerApiService.createQuickOrder(token, orderData);

      Get.snackbar(
        'Success',
        'Order ${result['order_id']} created successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      await fetchBuyerSpecificData(token); // Refresh buyer-specific data only
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create order: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> searchSuppliers(String query) async {
    try {
      final token = authController.currentUser.value?.token ?? '';
      final results = await BuyerApiService.searchSuppliers(token, query);

      Get.toNamed('/suppliers/search', arguments: {'results': results, 'query': query});
    } catch (e) {
      Get.snackbar(
        'Error',
        'Search failed: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // --------------------- Navigation ---------------------
  void navigateToOrders() => Get.toNamed('/buyer/orders');
  void navigateToSuppliers() => Get.toNamed('/buyer/suppliers');
  void navigateToPriceComparison() => Get.toNamed('/buyer/price-comparison');
  void navigateToReports() => Get.toNamed('/buyer/reports');
  void navigateToSettings() => Get.toNamed('/buyer/settings');

  void refreshData() => fetchDashboardData();
}
