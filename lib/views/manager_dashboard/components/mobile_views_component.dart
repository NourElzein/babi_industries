import 'package:babi_industries/controllers/manager_dashboard_controller.dart';
import 'package:babi_industries/views/dashboard/manager_dashboard_view.dart';
import 'package:babi_industries/views/manager_dashboard/components/critical_alerts_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/kpi_grid_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/recent_activity_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/welcome_section_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/views/manager_dashboard/components/predictive_analytics_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/quick_stats_component.dart';


class MobileViewsComponent {
  static List<Widget> buildMobileViews(ManagerDashboardController controller) {
    return [
      _buildDashboardContent(controller),
      _buildSuppliersView(controller),
      _buildOrdersView(controller),
      _buildInventoryView(controller),
      _buildAnalyticsView(controller),
      _buildLogisticsView(controller),
      _buildContractsView(controller),
    ];
  }

  static Widget _buildDashboardContent(ManagerDashboardController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ManagerDashboardView.kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeSectionComponent.buildWelcomeSection(controller),
          const SizedBox(height: 20),
          KpiGridComponent.buildResponsiveKpiGrid(controller, crossAxisCount: 2),
          const SizedBox(height: 20),
          CriticalAlertsComponent.buildCriticalAlerts(controller),
          const SizedBox(height: 20),
          RecentActivityComponent.buildRecentActivity(controller),
          const SizedBox(height: 20),
          QuickStatsComponent.buildQuickStats(controller),
          const SizedBox(height: 20),
          PredictiveAnalyticsComponent.buildPredictiveAnalytics(controller),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  static Widget _buildSuppliersView(ManagerDashboardController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Suppliers Management"),
        backgroundColor: ManagerDashboardView.kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.compare),
            onPressed: () => _showSupplierComparison(controller),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddSupplier(controller),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTopSuppliers(controller),
           
            
          ],
        ),
      ),
    );
  }

  static Widget _buildOrdersView(ManagerDashboardController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders Management"),
        backgroundColor: ManagerDashboardView.kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showOrderFilters(controller),
          ),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () => _showCreateOrder(controller),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildOrderStatusSummary(controller),
            const SizedBox(height: 16),
            Expanded(
              child: _buildRecentOrders(controller),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildInventoryView(ManagerDashboardController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory Management"),
        backgroundColor: ManagerDashboardView.kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => _showBarcodeScanner(controller),
          ),
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () => _showAddInventory(controller),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInventorySummary(controller),
            const SizedBox(height: 16),
            Expanded(
              child: _buildLowStockAlerts(controller),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildAnalyticsView(ManagerDashboardController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics & Reports"),
        backgroundColor: ManagerDashboardView.kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showAnalyticsSettings(controller),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _showExportOptions(controller),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAnalyticsSummary(controller),
            const SizedBox(height: 16),
            Expanded(
              child: PredictiveAnalyticsComponent.buildPredictiveAnalytics(controller),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildLogisticsView(ManagerDashboardController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logistics Tracking"),
        backgroundColor: ManagerDashboardView.kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => _showShipmentMap(controller),
          ),
          IconButton(
            icon: const Icon(Icons.local_shipping),
            onPressed: () => _showCreateShipment(controller),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLogisticsOverview(controller),
            const SizedBox(height: 16),
            Expanded(
              child: _buildShipmentTracking(controller),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildContractsView(ManagerDashboardController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contract Management"),
        backgroundColor: ManagerDashboardView.kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showContractSearch(controller),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateContract(controller),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildContractsSummary(controller),
            const SizedBox(height: 16),
            Expanded(
              child: _buildContractsList(controller),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widgets for Mobile Views

  static Widget _buildTopSuppliers(ManagerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManagerDashboardView.kCardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ManagerDashboardView.kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Text(
                    "Top Suppliers",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleSupplierAction(value, controller),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'compare', child: Text('Compare Suppliers')),
                    const PopupMenuItem(value: 'add', child: Text('Add New Supplier')),
                    const PopupMenuItem(value: 'viewall', child: Text('View All')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => controller.suppliers.isEmpty 
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No suppliers data"),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.suppliers.length > 5 ? 5 : controller.suppliers.length,
                  itemBuilder: (context, index) {
                    final supplier = controller.suppliers[index];
                    final performance = int.tryParse(supplier['performance']?.toString() ?? '0') ?? 0;
                    final performanceColor = performance >= 90 ? ManagerDashboardView.kAccentColor :
                                           performance >= 70 ? ManagerDashboardView.kWarningColor : ManagerDashboardView.kErrorColor;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      supplier['name'] ?? supplier['supplier_name'] ?? 'Supplier',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (supplier['category'] != null)
                                      Text(
                                        supplier['category'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: performanceColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "${supplier['performance'] ?? supplier['performance_score'] ?? '0'}%",
                                      style: TextStyle(
                                        color: performanceColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: List.generate(5, (i) => Icon(
                                      Icons.star,
                                      size: 12,
                                      color: i < (performance / 20).floor() 
                                          ? Colors.orange 
                                          : Colors.grey.shade300,
                                    )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${supplier['total_orders'] ?? supplier['orders_count'] ?? '0'} orders",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                supplier['total_value'] ?? supplier['order_value'] ?? 'XOF 0',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Last delivery: ${supplier['last_delivery'] ?? 'N/A'}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              if (supplier['contract_expires'] != null)
                                Text(
                                  "Contract: ${supplier['contract_expires']}",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ),
          ],
        ),
      ),
    );
  }


  static Widget _buildOrderStatusSummary(ManagerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ManagerDashboardView.kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Status Summary",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(() => Row(
              children: [
                Expanded(child: _buildStatusChip("Pending", controller.pendingOrders.value.toString(), ManagerDashboardView.kWarningColor)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatusChip("Processing", controller.processingOrders.value.toString(), ManagerDashboardView.kPrimaryColor)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatusChip("Delivered", controller.deliveredOrders.value.toString(), ManagerDashboardView.kAccentColor)),
              ],
            )),
          ],
        ),
      ),
    );
  }

  static Widget _buildStatusChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

 static Widget _buildRecentOrders(ManagerDashboardController controller) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(ManagerDashboardView.kCardRadius),
    ),
    child: Padding(
      padding: const EdgeInsets.all(ManagerDashboardView.kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  "Recent Orders",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton.icon(
                    onPressed: () => _showCreateOrder(controller),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('New'),
                  ),
                  TextButton(
                    onPressed: () => controller.navigateToOrderManagement(),
                    child: const Text("View All"),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Make the list flexible to avoid overflow
          Expanded(
            child: Obx(() {
              if (controller.orders.isEmpty) {
                return const Center(
                  child: Text("No recent orders"),
                );
              }
              return ListView.builder(
                itemCount: controller.orders.length > 5
                    ? 5
                    : controller.orders.length,
                itemBuilder: (context, index) {
                  final order = controller.orders[index];
                  Color statusColor = _getStatusColor(order['status'] ?? 'pending');

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        order['order_id'] ?? order['id'] ?? 'ORD-000',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (order['priority'] == 'high')
                                        const Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Icon(Icons.priority_high,
                                              color: ManagerDashboardView.kErrorColor, size: 16),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    order['supplier_name'] ?? order['supplier'] ?? 'Unknown Supplier',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        order['total_value'] ?? order['value'] ?? 'XOF 0',
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "• ${order['items_count'] ?? '0'} items",
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    order['status'] ?? 'pending',
                                    style: TextStyle(
                                        color: statusColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  order['created_at'] ?? order['order_date'] ?? 'Today',
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                                if (order['expected_delivery'] != null)
                                  Text(
                                    "ETA: ${order['expected_delivery']}",
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        if (order['tracking_number'] != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.local_shipping, size: 14, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(
                                "Tracking: ${order['tracking_number']}",
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () => _showOrderDetails(order),
                                child: const Text('Track'),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    ),
  );
}

  static Widget _buildInventorySummary(ManagerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ManagerDashboardView.kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Inventory Health",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(() => Column(
              children: [
                _buildInventoryMetric("Total Items", controller.totalInventoryItems.value.toString(), Icons.inventory),
                const SizedBox(height: 8),
                _buildInventoryMetric("Low Stock", controller.lowStockItems.value.toString(), Icons.warning),
                const SizedBox(height: 8),
                _buildInventoryMetric("Out of Stock", controller.outOfStockItems.value.toString(), Icons.error),
              ],
            )),
          ],
        ),
      ),
    );
  }

  static Widget _buildInventoryMetric(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontSize: 14)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  static Widget _buildLowStockAlerts(ManagerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ManagerDashboardView.kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Low Stock Alerts",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() => controller.lowStockItems.value == 0
                  ? const Center(child: Text("All items are well stocked"))
                  : ListView.builder(
                      itemCount: 5, // Mock data
                      itemBuilder: (context, index) => ListTile(
                        leading: const Icon(Icons.warning, color: ManagerDashboardView.kWarningColor),
                        title: Text("Product ${index + 1}"),
                        subtitle: Text("Current stock: ${10 - index * 2}"),
                        trailing: ElevatedButton(
                          onPressed: () => _showReorderProduct(index),
                          child: const Text("Reorder"),
                        ),
                      ),
                    )),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildAnalyticsSummary(ManagerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ManagerDashboardView.kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Key Insights",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInsightItem("Best Performing Supplier", "Supplier ABC - 95% on-time", ManagerDashboardView.kAccentColor),
            const SizedBox(height: 8),
            _buildInsightItem("Cost Savings Opportunity", "Switch to Supplier XYZ for 15% savings", ManagerDashboardView.kPrimaryColor),
            const SizedBox(height: 8),
            _buildInsightItem("Peak Demand Period", "Increase in orders expected next week", ManagerDashboardView.kWarningColor),
          ],
        ),
      ),
    );
  }

  static Widget _buildInsightItem(String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      )
    );
  }

  static Widget _buildLogisticsOverview(ManagerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManagerDashboardView.kCardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ManagerDashboardView.kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Logistics & Shipments",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showLogisticsTracking(controller),
                  icon: const Icon(Icons.map, size: 16),
                  label: const Text('Track All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildLogisticsStat(
                        "In Transit",
                        controller.inTransitShipments.value.toString(),
                        Icons.local_shipping,
                        ManagerDashboardView.kPrimaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildLogisticsStat(
                        "Delivered Today",
                        controller.deliveredToday.value.toString(),
                        Icons.check_circle,
                        ManagerDashboardView.kAccentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildLogisticsStat(
                        "Delayed",
                        controller.delayedShipments.value.toString(),
                        Icons.access_time,
                        ManagerDashboardView.kErrorColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildLogisticsStat(
                        "Avg Delivery",
                        controller.avgDeliveryTime.value,
                        Icons.schedule,
                        ManagerDashboardView.kSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  static Widget _buildLogisticsStat(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static Widget _buildShipmentTracking(ManagerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ManagerDashboardView.kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Active Shipments",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() => controller.inTransitShipments.value == 0
                  ? const Center(child: Text("No active shipments"))
                  : ListView.builder(
                      itemCount: controller.inTransitShipments.value,
                      itemBuilder: (context, index) => _buildShipmentItem(index),
                    )),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildShipmentItem(int index) {
    return ListTile(
      leading: const Icon(Icons.local_shipping, color: ManagerDashboardView.kPrimaryColor),
      title: Text("Shipment #${1000 + index}"),
      subtitle: Text("From Supplier ${index + 1} • ETA: ${index + 1} days"),
      trailing: TextButton(
        onPressed: () => _showShipmentDetails(index),
        child: const Text("Track"),
      ),
    );
  }

  static Widget _buildContractsSummary(ManagerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManagerDashboardView.kCardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ManagerDashboardView.kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Contract Management",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => _showContractManagement(controller),
                  child: const Text("View All"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => Column(
              children: [
                _buildContractStat(
                  "Active Contracts",
                  controller.activeContracts.value.toString(),
                  Icons.description,
                  ManagerDashboardView.kAccentColor,
                ),
                const SizedBox(height: 8),
                _buildContractStat(
                  "Expiring Soon",
                  controller.expiringContracts.value.toString(),
                  Icons.schedule,
                  ManagerDashboardView.kWarningColor,
                ),
                const SizedBox(height: 8),
                _buildContractStat(
                  "Pending Renewal",
                  controller.pendingRenewals.value.toString(),
                  Icons.refresh,
                  ManagerDashboardView.kPrimaryColor,
                ),
                const SizedBox(height: 12),
                if (controller.contractAlerts.value > 0)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ManagerDashboardView.kWarningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: ManagerDashboardView.kWarningColor, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "${controller.contractAlerts.value} contracts need attention",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  static Widget _buildContractStat(String title, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildContractsList(ManagerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ManagerDashboardView.kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recent Contracts",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() => controller.activeContracts.value == 0
                  ? const Center(child: Text("No active contracts"))
                  : ListView.builder(
                      itemCount: controller.activeContracts.value,
                      itemBuilder: (context, index) => _buildContractItem(index),
                    )),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildContractItem(int index) {
    return ListTile(
      leading: const Icon(Icons.description, color: ManagerDashboardView.kPurpleColor),
      title: Text("Contract with Supplier ${index + 1}"),
      subtitle: Text("Expires: ${DateTime.now().add(Duration(days: 30 + index * 10)).toString().split(' ')[0]}"),
      trailing: PopupMenuButton<String>(
        onSelected: (value) => _handleContractAction(value, index),
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'view', child: Text('View Details')),
          const PopupMenuItem(value: 'renew', child: Text('Renew')),
          const PopupMenuItem(value: 'modify', child: Text('Modify')),
        ],
      ),
    );
  }

  static Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'completed':
        return ManagerDashboardView.kAccentColor;
      case 'in_transit':
      case 'shipping':
      case 'in transit':
        return ManagerDashboardView.kPrimaryColor;
      case 'pending':
      case 'processing':
        return ManagerDashboardView.kWarningColor;
      case 'delayed':
      case 'overdue':
        return ManagerDashboardView.kErrorColor;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey.shade400;
    }
  }

  static void _handleSupplierAction(String value, ManagerDashboardController controller) {
    switch (value) {
      case 'compare':
        _showSupplierComparison(controller);
        break;
      case 'add':
        _showAddSupplier(controller);
        break;
      case 'viewall':
        controller.navigateToSupplierManagement();
        break;
    }
  }

  static void _handleContractAction(String value, int index) {
    switch (value) {
      case 'view':
        _showContractDetails(index);
        break;
      case 'renew':
        _showContractRenewal(index);
        break;
      case 'modify':
        _showContractModification(index);
        break;
    }
  }

  static void _showSupplierComparison(ManagerDashboardController controller) => _showFeatureDialog("Supplier Comparison");
  static void _showAddSupplier(ManagerDashboardController controller) => _showFeatureDialog("Add Supplier");
  static void _showOrderFilters(ManagerDashboardController controller) => _showFeatureDialog("Order Filters");
  static void _showCreateOrder(ManagerDashboardController controller) => _showFeatureDialog("Create Order");
  static void _showBarcodeScanner(ManagerDashboardController controller) => _showFeatureDialog("Barcode Scanner");
  static void _showAddInventory(ManagerDashboardController controller) => _showFeatureDialog("Add Inventory");
  static void _showAnalyticsSettings(ManagerDashboardController controller) => _showFeatureDialog("Analytics Settings");
  static void _showExportOptions(ManagerDashboardController controller) => _showFeatureDialog("Export Options");
  static void _showShipmentMap(ManagerDashboardController controller) => _showFeatureDialog("Shipment Map");
  static void _showCreateShipment(ManagerDashboardController controller) => _showFeatureDialog("Create Shipment");
  static void _showContractSearch(ManagerDashboardController controller) => _showFeatureDialog("Contract Search");
  static void _showCreateContract(ManagerDashboardController controller) => _showFeatureDialog("Create Contract");
  static void _showLogisticsTracking(ManagerDashboardController controller) => _showFeatureDialog("Logistics Tracking");
  static void _showContractManagement(ManagerDashboardController controller) => _showFeatureDialog("Contract Management");
  static void _showOrderDetails(Map<String, dynamic> order) => _showFeatureDialog("Order Details");
  static void _showReorderProduct(int index) => _showFeatureDialog("Reorder Product");
  static void _showShipmentDetails(int index) => _showFeatureDialog("Shipment Details");
  static void _showContractDetails(int index) => _showFeatureDialog("Contract Details");
  static void _showContractRenewal(int index) => _showFeatureDialog("Contract Renewal");
  static void _showContractModification(int index) => _showFeatureDialog("Contract Modification");

  static void _showFeatureDialog(String featureName) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: ManagerDashboardView.kPrimaryColor),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                featureName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction, size: 48, color: Colors.orange.shade400),
            const SizedBox(height: 16),
            Text(
              "$featureName feature is currently under development and will be available in the next update.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}