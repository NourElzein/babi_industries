import 'package:babi_industries/controllers/manager_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/views/dashboard/manager_dashboard_view.dart';

class QuickStatsComponent {
  static Widget buildQuickStats(ManagerDashboardController controller) {
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
                  "Performance Overview",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.tune, size: 20),
                  onPressed: () => _showCustomizeKpis(controller),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            "Monthly Value",
                            controller.monthlyOrderValue.value,
                            Icons.monetization_on,
                            ManagerDashboardView.kAccentColor,
                            trend: controller.monthlyValueTrend.value,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatItem(
                            "On-Time Rate",
                            controller.onTimeDeliveryRate.value,
                            Icons.schedule,
                            ManagerDashboardView.kPrimaryColor,
                            trend: controller.onTimeDeliveryTrend.value,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            "Inventory Turnover",
                            controller.inventoryTurnover.value,
                            Icons.rotate_right,
                            ManagerDashboardView.kSecondaryColor,
                            trend: controller.inventoryTurnoverTrend.value,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatItem(
                            "Supplier Score",
                            controller.supplierPerformanceScore.value,
                            Icons.trending_up,
                            ManagerDashboardView.kAccentColor,
                            trend: controller.supplierScoreTrend.value,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildStatItem(String title, String value, IconData icon, Color color, {String? trend}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 120;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: isSmall ? 20 : 24),
                  const Spacer(),
                  if (trend != null && trend.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: trend.startsWith('+') ? ManagerDashboardView.kAccentColor.withOpacity(0.2) : ManagerDashboardView.kErrorColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        trend,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: trend.startsWith('+') ? ManagerDashboardView.kAccentColor : ManagerDashboardView.kErrorColor,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value.isEmpty ? 'N/A' : value,
                style: TextStyle(
                  fontSize: isSmall ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  fontSize: isSmall ? 10 : 11,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }

  static void _showCustomizeKpis(ManagerDashboardController controller) => _showFeatureDialog("Customize KPIs");

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