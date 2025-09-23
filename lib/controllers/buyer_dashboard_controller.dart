import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/buyer_api_service.dart';
import '../services/api_service.dart';
import '../controllers/auth_controller.dart';

// -------------------- Models --------------------
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

class BuyerNotification {
  final String id;
  final String title;
  final String message;
  final String type;
  final Color color;
  final String time;

  BuyerNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.color,
    required this.time,
  });

  factory BuyerNotification.fromJson(Map<String, dynamic> json) {
    Color mapColor(String? color) {
      switch (color) {
        case 'error':
          return Colors.red;
        case 'warning':
          return Colors.orange;
        case 'accent':
          return Colors.blue;
        default:
          return Colors.grey;
      }
    }

    return BuyerNotification(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      color: mapColor(json['color']),
      time: json['time'] ?? '',
    );
  }
}

// -------------------- Controller --------------------
class BuyerDashboardController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  // Observables
  var orders = <Map<String, dynamic>>[].obs;
  var suggestedSuppliers = <SupplierRecommendation>[].obs;
  var alerts = <BuyerAlert>[].obs;
  var notifications = <BuyerNotification>[].obs;
  var insights = <BuyerInsight>[].obs;

  // Loading states
  var isLoading = false.obs;
  var isLoadingOrders = false.obs;
  var isLoadingSuppliers = false.obs;
  var errorMessage = ''.obs;

  // KPIs
  var totalOrders = 0.obs;
  var pendingOrders = 0.obs;
  var processingOrders = 0.obs;
  var inTransitOrders = 0.obs;
  var deliveredOrders = 0.obs;
  var cancelledOrders = 0.obs;
  var selectedBottomNavIndex = 0.obs;

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

  // Hive Boxes for offline storage
  late Box ordersBox;
  late Box suppliersBox;
  late Box alertsBox;
  late Box notificationsBox;
  late Box insightsBox;

  @override
  void onInit() async {
    super.onInit();

    // Initialize Hive boxes
    ordersBox = await Hive.openBox('ordersBox');
    suppliersBox = await Hive.openBox('suppliersBox');
    alertsBox = await Hive.openBox('alertsBox');
    notificationsBox = await Hive.openBox('notificationsBox');
    insightsBox = await Hive.openBox('insightsBox');

    // Load offline data first
    loadOfflineData();

    // Then try to fetch online data
    fetchDashboardData();
  }

  // ---------------- Load Offline Data ----------------
  void loadOfflineData() {
    orders.value = List<Map<String, dynamic>>.from(ordersBox.values);

    suggestedSuppliers.value = List<SupplierRecommendation>.from(
      suppliersBox.values.map((s) => SupplierRecommendation(
            id: s['id'],
            name: s['name'],
            category: s['category'],
            badge: s['badge'],
            badgeColor: Color(s['badgeColor']),
            performance: s['performance'],
            totalOrders: s['totalOrders'],
            rating: s['rating'],
          )),
    );

    alerts.value = List<BuyerAlert>.from(
      alertsBox.values.map((a) => BuyerAlert(
            id: a['id'],
            type: a['type'],
            title: a['title'],
            message: a['message'],
            color: Color(a['color']),
            icon: IconData(a['icon'], fontFamily: 'MaterialIcons'),
            timestamp: DateTime.parse(a['timestamp']),
            isUrgent: a['isUrgent'],
          )),
    );

    notifications.value = List<BuyerNotification>.from(
      notificationsBox.values.map((n) => BuyerNotification.fromJson(n)),
    );

    insights.value = List<BuyerInsight>.from(
      insightsBox.values.map((i) => BuyerInsight(
            title: i['title'],
            description: i['description'],
            icon: IconData(i['icon'], fontFamily: 'MaterialIcons'),
            color: Color(i['color']),
            trend: i['trend'],
          )),
    );
  }

  // ---------------- Fetch Dashboard ----------------
  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      final token = authController.currentUser.value?.token ?? '';
      await Future.wait([
        fetchManagerData(token),
        fetchBuyerSpecificData(token),
      ]);
    } catch (e) {
      errorMessage.value = e.toString();
      print('Dashboard fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchManagerData(String token) async {
    try {
      isLoadingSuppliers.value = true;

      final kpis = await ApiService.fetchKpis(token);
      activeSuppliers.value = kpis['active_suppliers'] ?? 0;
      avgDeliveryTime.value = kpis['avg_delivery_time'] ?? '';
      costSavings.value = kpis['cost_savings'] ?? '';
      supplierSatisfaction.value = kpis['supplier_satisfaction'] ?? '';

      final suppliersData = await ApiService.fetchSuppliers(token);
      suggestedSuppliers.value = suppliersData.map<SupplierRecommendation>((supplier) {
        return SupplierRecommendation(
          id: supplier['id'] ?? '',
          name: supplier['name'] ?? '',
          category: supplier['category'] ?? 'N/A',
          badge: supplier['badge'] ?? 'N/A',
          badgeColor: _getBadgeColor(supplier['badge']),
          performance: '${supplier['performance_score'] ?? 0}%',
          totalOrders: '${supplier['total_orders'] ?? 0} orders',
          rating: (supplier['rating'] ?? 0).toDouble(),
        );
      }).toList();

      final alertsData = await ApiService.fetchAlerts(token);
      alerts.value = alertsData.map<BuyerAlert>((alert) {
        return BuyerAlert(
          id: alert['id'] ?? '',
          type: alert['type'] ?? '',
          title: alert['title'] ?? '',
          message: alert['message'] ?? '',
          color: _getAlertColor(alert['type']),
          icon: _getAlertIcon(alert['type']),
          timestamp: DateTime.tryParse(alert['timestamp'] ?? '') ?? DateTime.now(),
          isUrgent: alert['is_urgent'] ?? false,
        );
      }).toList();

      // Save to Hive
      suppliersBox.clear();
      for (var s in suggestedSuppliers) {
        suppliersBox.put(s.id, {
          'id': s.id,
          'name': s.name,
          'category': s.category,
          'badge': s.badge,
          'badgeColor': s.badgeColor.value,
          'performance': s.performance,
          'totalOrders': s.totalOrders,
          'rating': s.rating,
        });
      }

      alertsBox.clear();
      for (var a in alerts) {
        alertsBox.put(a.id, {
          'id': a.id,
          'type': a.type,
          'title': a.title,
          'message': a.message,
          'color': a.color.value,
          'icon': a.icon.codePoint,
          'timestamp': a.timestamp.toIso8601String(),
          'isUrgent': a.isUrgent,
        });
      }

    } catch (e) {
      print('Manager fetch error: $e');
    } finally {
      isLoadingSuppliers.value = false;
    }
  }

  Future<void> fetchBuyerSpecificData(String token) async {
    try {
      isLoadingOrders.value = true;

      // KPIs
      final buyerKpis = await BuyerApiService.fetchBuyerKpis(token);
      totalOrders.value = buyerKpis['total_orders'] ?? 0;
      pendingOrders.value = buyerKpis['pending_orders'] ?? 0;
      processingOrders.value = buyerKpis['processing_orders'] ?? 0;
      inTransitOrders.value = buyerKpis['in_transit_orders'] ?? 0;
      deliveredOrders.value = buyerKpis['delivered_orders'] ?? 0;
      cancelledOrders.value = buyerKpis['cancelled_orders'] ?? 0;
      monthlySpend.value = buyerKpis['monthly_spend'] ?? '';
      urgentIssues.value = buyerKpis['urgent_issues'] ?? 0;
      completionRate.value = buyerKpis['completion_rate'] ?? '';
      orderEfficiencyTrend.value = buyerKpis['order_efficiency_trend'] ?? '';
      costSavingsTrend.value = buyerKpis['cost_savings_trend'] ?? '';
      deliveryTimeTrend.value = buyerKpis['delivery_time_trend'] ?? '';
      weeklyOrderCount.value = buyerKpis['weekly_order_count'] ?? 0;
      monthlyOrderCount.value = buyerKpis['monthly_order_count'] ?? 0;

      // Orders
      final ordersData = await BuyerApiService.fetchBuyerOrders(token);
      orders.value = ordersData.cast<Map<String, dynamic>>();

      // Notifications
      final notificationsData = await BuyerApiService.fetchBuyerNotifications(token);
      notifications.value = notificationsData.map((n) => BuyerNotification.fromJson(n)).toList();

      // Insights
      final insightsData = await BuyerApiService.fetchBuyerInsights(token);
      insights.value = insightsData.map<BuyerInsight>((insight) {
        return BuyerInsight(
          title: insight['title'] ?? '',
          description: insight['description'] ?? '',
          icon: _mapInsightIcon(insight['icon']),
          color: _mapInsightColor(insight['color']),
          trend: insight['trend'] ?? '',
        );
      }).toList();

      // Save to Hive
      ordersBox.clear();
      for (var o in orders) ordersBox.put(o['id'], o);

      notificationsBox.clear();
      for (var n in notifications) {
        notificationsBox.put(n.id, {
          'id': n.id,
          'title': n.title,
          'message': n.message,
          'type': n.type,
          'color': n.color.toString(),
          'time': n.time,
        });
      }

      insightsBox.clear();
      for (var i in insights) {
        insightsBox.put(i.title, {
          'title': i.title,
          'description': i.description,
          'icon': i.icon.codePoint,
          'color': i.color.value,
          'trend': i.trend,
        });
      }

    } catch (e) {
      print('Buyer fetch error: $e');
    } finally {
      isLoadingOrders.value = false;
    }
  }

  // ---------------- Buyer Actions ----------------
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

      await fetchBuyerSpecificData(token);
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
      isLoadingSuppliers.value = true;
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
    } finally {
      isLoadingSuppliers.value = false;
    }
  }

  // ---------------- Utilities ----------------
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

  // --------------------- Navigation ---------------------
  void navigateToOrders() => Get.toNamed('/buyer/orders');
  void navigateToSuppliers() => Get.toNamed('/buyer/suppliers');
  void navigateToPriceComparison() => Get.toNamed('/buyer/price-comparison');
  void navigateToReports() => Get.toNamed('/buyer/reports');
  void navigateToSettings() => Get.toNamed('/buyer/settings');

  void refreshData() => fetchDashboardData();
}
