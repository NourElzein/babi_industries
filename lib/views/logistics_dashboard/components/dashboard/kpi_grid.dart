import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/logistics_dashboard_controller.dart';
import 'package:babi_industries/theme/logistics_theme.dart';

class KpiGrid extends StatelessWidget {
  final LogisticsDashboardController controller;
  final int crossAxisCount;

  const KpiGrid({
    super.key,
    required this.controller,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int actualCrossAxisCount = crossAxisCount;
        double childAspectRatio = 1.0;

        if (constraints.maxWidth < 400) {
          actualCrossAxisCount = 2;
          childAspectRatio = 1.2;
        } else if (constraints.maxWidth < 768) {
          actualCrossAxisCount = 3;
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
              "Active Shipments",
              controller.activeShipments.value.toString(),
              Icons.local_shipping,
              LogisticsTheme.kPrimaryColor,
              "${controller.inTransit.value} in transit",
              onTap: () => controller.navigateToShipmentManagement(),
            ),
            _buildKpiCard(
              "Delivered Today",
              controller.completedToday.value.toString(),
              Icons.check_circle,
              LogisticsTheme.kSuccessColor,
              "On schedule",
              onTap: () => _showTodayDeliveries(),
            ),
            _buildKpiCard(
              "Delayed Shipments",
              controller.delayed.value.toString(),
              Icons.access_time,
              LogisticsTheme.kErrorColor,
              "Need attention",
              onTap: () => _showDelayedShipments(),
            ),
            _buildKpiCard(
              "Pending Pickup",
              controller.pendingPickup.value.toString(),
              Icons.schedule,
              LogisticsTheme.kWarningColor,
              "Ready to ship",
              onTap: () => _showPendingPickups(),
            ),
            _buildKpiCard(
              "On-Time Rate",
              controller.onTimeDeliveryRate.value,
              Icons.trending_up,
              LogisticsTheme.kAccentColor,
              "This month",
              onTap: () => _showPerformanceMetrics(),
            ),
            _buildKpiCard(
              "Avg Delivery Time",
              controller.avgDeliveryTime.value,
              Icons.timer,
              LogisticsTheme.kInfoColor,
              "Current average",
              onTap: () => _showDeliveryAnalytics(),
            ),
            if (actualCrossAxisCount >= 3) ...[
              _buildKpiCard(
                "Customer Satisfaction",
                controller.customerSatisfaction.value,
                Icons.star,
                Colors.amber,
                "Average rating",
                onTap: () => _showCustomerFeedback(),
              ),
              _buildKpiCard(
                "Route Efficiency",
                controller.routeOptimization.value,
                Icons.route,
                LogisticsTheme.kSecondaryColor,
                "Optimized routes",
                onTap: () => controller.navigateToRouteOptimization(),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildKpiCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LogisticsTheme.kCardRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(LogisticsTheme.kCardRadius),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 150; // better for mobile
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon Circle
                  Container(
                    padding: EdgeInsets.all(isSmall ? 8 : 12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: isSmall ? 20 : 24),
                  ),
                  SizedBox(height: isSmall ? 4 : 8),

                  // KPI Number
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: isSmall ? 2 : 4),

                  // KPI Title
                  Expanded(
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

                  // KPI Subtitle
                  Expanded(
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

  void _showTodayDeliveries() {
    Get.dialog(const AlertDialog(
      title: Text("Today's Deliveries"),
      content: Text("Feature coming soon"),
    ));
  }

  void _showDelayedShipments() {
    Get.dialog(const AlertDialog(
      title: Text("Delayed Shipments"),
      content: Text("Feature coming soon"),
    ));
  }

  void _showPendingPickups() {
    Get.dialog(const AlertDialog(
      title: Text("Pending Pickups"),
      content: Text("Feature coming soon"),
    ));
  }

  void _showPerformanceMetrics() {
    Get.dialog(const AlertDialog(
      title: Text("Performance Metrics"),
      content: Text("Feature coming soon"),
    ));
  }

  void _showDeliveryAnalytics() {
    Get.dialog(const AlertDialog(
      title: Text("Delivery Analytics"),
      content: Text("Feature coming soon"),
    ));
  }

  void _showCustomerFeedback() {
    Get.dialog(const AlertDialog(
      title: Text("Customer Feedback"),
      content: Text("Feature coming soon"),
    ));
  }
}
