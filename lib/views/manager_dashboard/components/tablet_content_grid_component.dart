import 'package:babi_industries/controllers/manager_dashboard_controller.dart';
import 'package:babi_industries/views/dashboard/manager_dashboard_view.dart';
import 'package:babi_industries/views/manager_dashboard/components/critical_alerts_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/predictive_analytics_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/recent_activity_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabletContentGridComponent {
  static Widget buildTabletContentGrid(ManagerDashboardController controller) {
    return Column(
      children: [
        CriticalAlertsComponent.buildCriticalAlerts(controller),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildRecentOrders(controller),
                  const SizedBox(height: 20),
                  PredictiveAnalyticsComponent.buildPredictiveAnalytics(controller),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  _buildTopSuppliers(controller),
                  const SizedBox(height: 20),
                  RecentActivityComponent.buildRecentActivity(controller),
                ],
              ),
            ),
          ],
        ),
      ],
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
            Obx(() => controller.orders.isEmpty 
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No recent orders"),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.orders.length > 5 ? 5 : controller.orders.length,
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
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (order['priority'] == 'high')
                                          const Padding(
                                            padding: EdgeInsets.only(left: 8),
                                            child: Icon(Icons.priority_high, color: ManagerDashboardView.kErrorColor, size: 16),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      order['supplier_name'] ?? order['supplier'] ?? 'Unknown Supplier',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          order['total_value'] ?? order['value'] ?? 'XOF 0',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "• ${order['items_count'] ?? '0'} items",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      order['status'] ?? 'pending',
                                      style: TextStyle(
                                        color: statusColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    order['created_at'] ?? order['order_date'] ?? 'Today',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  if (order['expected_delivery'] != null)
                                    Text(
                                      "ETA: ${order['expected_delivery']}",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                    ),
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
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
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
                ),
            ),
          ],
        ),
      ),
    );
  }

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

  static void _showCreateOrder(ManagerDashboardController controller) => _showFeatureDialog("Create Order");
  static void _showOrderDetails(Map<String, dynamic> order) => _showFeatureDialog("Order Details");
  static void _showSupplierComparison(ManagerDashboardController controller) => _showFeatureDialog("Supplier Comparison");
  static void _showAddSupplier(ManagerDashboardController controller) => _showFeatureDialog("Add Supplier");

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