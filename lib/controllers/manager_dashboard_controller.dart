import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../controllers/auth_controller.dart';

class ForecastItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String timeframe;
  final VoidCallback? onTap;

  ForecastItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.timeframe,
    this.onTap,
  });
}

class ManagerDashboardController extends GetxController {
  var suppliers = [].obs;
  var orders = [].obs;
  var alerts = [].obs;
  var activities = [].obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final AuthController authController = Get.find<AuthController>();

  // KPI values
  var totalSuppliers = 0.obs;
  var activeOrders = 0.obs;
  var pendingOrders = 0.obs;
  var delayedOrders = 0.obs;
  var lowStockItems = 0.obs;
  var criticalAlerts = 0.obs;
  var stockHealth = ''.obs;
  var monthlyOrderValue = ''.obs;
  var supplierPerformanceScore = ''.obs;
  var onTimeDeliveryRate = ''.obs;
  var inventoryTurnover = ''.obs;

  var delayedShipments = 0.obs;
  var activeContracts = 0.obs;
  var pendingRenewals = 0.obs;
  var expiringContracts = 0.obs;
  var inTransitShipments = 0.obs;
  var deliveredToday = 0.obs;
  var potentialSavings = 0.0.obs;
  var supplierRisks = 0.obs;
  var reorderAlerts = 0.obs;
  var demandForecast = 0.obs;
  var outOfStockItems = 0.obs;
  var totalInventoryItems = 0.obs;
  var processingOrders = 0.obs;
  var deliveredOrders = 0.obs;
  var contractAlerts = 0.obs;
  var avgDeliveryTime = ''.obs;
  var inventoryTurnoverTrend = ''.obs;
  var supplierScoreTrend = ''.obs;
  var monthlyValueTrend = ''.obs;
  var onTimeDeliveryTrend = ''.obs;

  var notifications = <Map<String, dynamic>>[].obs;

  var forecastData = <ForecastItem>[].obs;
  var isLoadingForecast = false.obs;

  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final token = authController.currentUser.value?.token ?? '';

      await Future.wait([
        fetchKpis(token),
        fetchSuppliers(token),
        fetchOrders(token),
        fetchAlerts(token),
        fetchActivities(token),
        fetchNotifications(token),
        fetchForecastData(token),
      ]);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchKpis(String token) async {
    try {
      final kpis = await ApiService.fetchKpis(token);
      totalSuppliers.value = kpis['total_suppliers'] ?? 0;
      activeOrders.value = kpis['active_orders'] ?? 0;
      pendingOrders.value = kpis['pending_orders'] ?? 0;
      delayedOrders.value = kpis['delayed_orders'] ?? 0;
      lowStockItems.value = kpis['low_stock_items'] ?? 0;
      criticalAlerts.value = kpis['critical_alerts'] ?? 0;
      stockHealth.value = kpis['stock_health'] ?? 'N/A';
      monthlyOrderValue.value = kpis['monthly_order_value'] ?? 'XOF 0';
      supplierPerformanceScore.value = kpis['supplier_performance_score'] ?? '0%';
      onTimeDeliveryRate.value = kpis['on_time_delivery_rate'] ?? '0%';
      inventoryTurnover.value = kpis['inventory_turnover'] ?? '0x';
      delayedShipments.value = kpis['delayed_shipments'] ?? 0;
      activeContracts.value = kpis['active_contracts'] ?? 0;
      pendingRenewals.value = kpis['pending_renewals'] ?? 0;
      expiringContracts.value = kpis['expiring_contracts'] ?? 0;
      inTransitShipments.value = kpis['in_transit_shipments'] ?? 0;
      deliveredToday.value = kpis['delivered_today'] ?? 0;
      potentialSavings.value = (kpis['potential_savings'] ?? 0).toDouble();
      supplierRisks.value = kpis['supplier_risks'] ?? 0;
      reorderAlerts.value = kpis['reorder_alerts'] ?? 0;
      demandForecast.value = kpis['demand_forecast'] ?? 0;
      outOfStockItems.value = kpis['out_of_stock_items'] ?? 0;
      totalInventoryItems.value = kpis['total_inventory_items'] ?? 0;
      processingOrders.value = kpis['processing_orders'] ?? 0;
      deliveredOrders.value = kpis['delivered_orders'] ?? 0;
      contractAlerts.value = kpis['contract_alerts'] ?? 0;
      avgDeliveryTime.value = kpis['avg_delivery_time'] ?? 'N/A';
      inventoryTurnoverTrend.value = kpis['inventory_turnover_trend'] ?? '';
      supplierScoreTrend.value = kpis['supplier_score_trend'] ?? '';
      monthlyValueTrend.value = kpis['monthly_value_trend'] ?? '';
      onTimeDeliveryTrend.value = kpis['on_time_delivery_trend'] ?? '';
    } catch (e) {
      print('Error fetching KPIs: $e');
    }
  }

  Future<void> fetchSuppliers(String token) async {
    suppliers.value = await ApiService.fetchSuppliers(token);
  }

  Future<void> fetchOrders(String token) async {
    orders.value = await ApiService.fetchOrders(token);
  }

  Future<void> fetchAlerts(String token) async {
    alerts.value = await ApiService.fetchAlerts(token);
  }

  Future<void> fetchActivities(String token) async {
    activities.value = await ApiService.fetchActivities(token);
  }

  Future<void> fetchNotifications(String token) async {
    notifications.value =
        (await ApiService.fetchNotifications(token)).cast<Map<String, dynamic>>();
  }

  /// --- CLEANED FORECAST FETCH ---
  Future<void> fetchForecastData(String token) async {
    try {
      isLoadingForecast.value = true;
      final forecastResponse = await ApiService.fetchForecast(token);

      final List<dynamic> items = forecastResponse['forecast_items'] ?? [];

      forecastData.value = items.map((item) {
        return ForecastItem(
          title: item['title'] ?? 'Untitled',
          description: item['description'] ?? '',
          icon: _mapIcon(item['icon']),
          color: _mapColor(item['color']),
          timeframe: item['timeframe'] ?? '',
          onTap: () => Get.snackbar(item['title'], item['description']),
        );
      }).toList();

      if (forecastData.isEmpty) {
        print("No forecast items returned from API.");
      }
    } catch (e) {
      print('Error fetching forecast: $e');
      forecastData.clear(); // clear stale data if error
    } finally {
      isLoadingForecast.value = false;
    }
  }

  IconData _mapIcon(String? iconName) {
    switch (iconName) {
      case "inventory":
        return Icons.inventory_2;
      case "trending_up":
        return Icons.trending_up;
      case "warning":
        return Icons.warning_amber;
      case "savings":
        return Icons.savings;
      default:
        return Icons.info_outline;
    }
  }

  Color _mapColor(String? colorName) {
    switch (colorName) {
      case "orange":
        return Colors.orange;
      case "blue":
        return Colors.blue;
      case "red":
        return Colors.red;
      case "green":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void refreshData() => fetchDashboardData();

  // Navigation
  void navigateToSupplierManagement() => Get.toNamed('/suppliers');
  void navigateToOrderManagement() => Get.toNamed('/orders');
  void navigateToInventoryManagement() => Get.toNamed('/inventory');
  void navigateToAnalytics() => Get.toNamed('/analytics');
  void navigateToReports() => Get.toNamed('/reports');
}
