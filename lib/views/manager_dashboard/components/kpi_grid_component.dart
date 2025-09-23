import 'package:babi_industries/controllers/manager_dashboard_controller.dart';
import 'package:babi_industries/views/dashboard/manager_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KpiGridComponent {
static Widget buildResponsiveKpiGrid(
    ManagerDashboardController controller, {int crossAxisCount = 2}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      int actualCrossAxisCount = crossAxisCount;
      double childAspectRatio = 1.0;

      // Adjust crossAxisCount and childAspectRatio for different widths
      if (constraints.maxWidth < 400) {
        actualCrossAxisCount = 2;
        childAspectRatio = 0.95; // slightly taller cards for mobile
      } else if (constraints.maxWidth < 768) {
        actualCrossAxisCount = 3;
        childAspectRatio = 1.0;
      } else {
        actualCrossAxisCount = 4;
        childAspectRatio = 1.0;
      }

      return GridView.count(
        crossAxisCount: actualCrossAxisCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: childAspectRatio,
        children: [
          _buildKpiCard(
            "Total Suppliers",
            controller.totalSuppliers.value.toString(),
            Icons.business,
            ManagerDashboardView.kAccentColor,
            "Active partnerships",
            onTap: () => controller.navigateToSupplierManagement(),
          ),
          _buildKpiCard(
            "Active Orders",
            controller.activeOrders.value.toString(),
            Icons.shopping_cart,
            ManagerDashboardView.kPrimaryColor,
            "${controller.pendingOrders.value} pending",
            onTap: () => controller.navigateToOrderManagement(),
          ),
          _buildKpiCard(
            "Delayed Orders",
            controller.delayedOrders.value.toString(),
            Icons.access_time,
            ManagerDashboardView.kErrorColor,
            "Needs attention",
            onTap: () => _showDelayedOrdersDetail(controller),
          ),
          _buildKpiCard(
            "Low Stock Items",
            controller.lowStockItems.value.toString(),
            Icons.inventory,
            ManagerDashboardView.kWarningColor,
            "Reorder required",
            onTap: () => controller.navigateToInventoryManagement(),
          ),
          _buildKpiCard(
            "Stock Health",
            controller.stockHealth.value,
            Icons.health_and_safety,
            ManagerDashboardView.kAccentColor,
            "Overall status",
            onTap: () => _showStockHealthDetail(controller),
          ),
          _buildKpiCard(
            "Performance Score",
            controller.supplierPerformanceScore.value,
            Icons.trending_up,
            ManagerDashboardView.kPrimaryColor,
            "Supplier avg",
            onTap: () => _showPerformanceDetail(controller),
          ),
          _buildKpiCard(
            "On-Time Delivery",
            controller.onTimeDeliveryRate.value,
            Icons.schedule,
            ManagerDashboardView.kAccentColor,
            "This month",
            onTap: () => _showDeliveryMetrics(controller),
          ),
          _buildKpiCard(
            "Monthly Value",
            controller.monthlyOrderValue.value,
            Icons.monetization_on,
            ManagerDashboardView.kSecondaryColor,
            "Order volume",
            onTap: () => _showFinancialMetrics(controller),
          ),
          if (actualCrossAxisCount >= 3) ...[
            _buildKpiCard(
              "Active Contracts",
              controller.activeContracts.value.toString(),
              Icons.description,
              ManagerDashboardView.kPurpleColor,
              "Under management",
              onTap: () => _showContractManagement(controller),
            ),
            _buildKpiCard(
              "In Transit",
              controller.inTransitShipments.value.toString(),
              Icons.local_shipping,
              ManagerDashboardView.kTealColor,
              "Shipments",
              onTap: () => _showLogisticsTracking(controller),
            ),
          ],
        ],
      );
    },
  );
}

  static Widget _buildKpiCard(String title, String value, IconData icon, Color color, String subtitle, {VoidCallback? onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManagerDashboardView.kCardRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ManagerDashboardView.kCardRadius),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 120;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(isSmall ? 8 : 12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: isSmall ? 20 : 24),
                  ),
                  SizedBox(height: isSmall ? 4 : 8),
                  Flexible(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: isSmall ? 16 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: isSmall ? 2 : 4),
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: isSmall ? 10 : 11,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Flexible(
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: color,
                        fontSize: isSmall ? 8 : 9,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  static void _showDelayedOrdersDetail(ManagerDashboardController controller) => _showFeatureDialog("Delayed Orders Analysis");
  static void _showStockHealthDetail(ManagerDashboardController controller) => _showFeatureDialog("Stock Health Dashboard");
  static void _showPerformanceDetail(ManagerDashboardController controller) => _showFeatureDialog("Performance Analytics");
  static void _showDeliveryMetrics(ManagerDashboardController controller) => _showFeatureDialog("Delivery Metrics");
  static void _showFinancialMetrics(ManagerDashboardController controller) => _showFeatureDialog("Financial Analytics");
  static void _showContractManagement(ManagerDashboardController controller) => _showFeatureDialog("Contract Management");
  static void _showLogisticsTracking(ManagerDashboardController controller) => _showFeatureDialog("Logistics Tracking");

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