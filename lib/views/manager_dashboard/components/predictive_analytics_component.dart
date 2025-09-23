import 'package:babi_industries/controllers/manager_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/views/dashboard/manager_dashboard_view.dart';

class PredictiveAnalyticsComponent {
  static Widget buildPredictiveAnalytics(ManagerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManagerDashboardView.kCardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ManagerDashboardView.kPadding),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        "Predictive Analytics & Forecasting",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, size: 20),
                      onPressed: () => _showForecastSettings(controller),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Forecast List (scrollable)
                Obx(() {
                  if (controller.isLoadingForecast.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (controller.forecastData.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          "No forecast data available.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  // Use available height dynamically
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxHeight - 80, 
                      // 80 = approx header + padding height
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: controller.forecastData.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = controller.forecastData[index];
                        return _buildForecastItem(
                          item.title,
                          item.description,
                          item.icon,
                          item.color,
                          item.timeframe,
                          onTap: item.onTap,
                        );
                      },
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  static Widget _buildForecastItem(
    String title,
    String description,
    IconData icon,
    Color color,
    String timeframe, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      )),
                  Text(description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      )),
                  Text(timeframe,
                      style: TextStyle(
                        fontSize: 11,
                        color: color,
                        fontStyle: FontStyle.italic,
                      )),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  static void _showForecastSettings(ManagerDashboardController controller) =>
      _showFeatureDialog("Forecast Settings");

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
