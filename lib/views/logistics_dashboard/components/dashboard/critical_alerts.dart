import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/logistics_dashboard_controller.dart';
import 'package:babi_industries/theme/logistics_theme.dart';

class CriticalAlerts extends StatelessWidget {
  final LogisticsDashboardController controller;

  const CriticalAlerts({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LogisticsTheme.kCardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(LogisticsTheme.kPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text(
                      "Critical Alerts & Notifications",
                      style: LogisticsTheme.cardTitleStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: controller.criticalAlerts.value > 0
                                  ? LogisticsTheme.kErrorColor.withOpacity(0.1)
                                  : LogisticsTheme.kSuccessColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${controller.criticalAlerts.value} alerts",
                              style: TextStyle(
                                color: controller.criticalAlerts.value > 0
                                    ? LogisticsTheme.kErrorColor
                                    : LogisticsTheme.kSuccessColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.settings, size: 20),
                        onPressed: () => _showAlertSettings(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(() => controller.notifications.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(Icons.check_circle,
                                color: LogisticsTheme.kSuccessColor, size: 48),
                            SizedBox(height: 8),
                            Text("All shipments on track"),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.notifications.length > 5
                          ? 5
                          : controller.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = controller.notifications[index];
                        final priority = notification['priority'] ?? 'medium';
                        final color = priority == 'high'
                            ? LogisticsTheme.kErrorColor
                            : priority == 'medium'
                                ? LogisticsTheme.kWarningColor
                                : LogisticsTheme.kInfoColor;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: color.withOpacity(0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                      _getNotificationIcon(
                                          notification['type']),
                                      color: color,
                                      size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      notification['title'] ??
                                          'Notification',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: color,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (notification['action_required'] == true)
                                    TextButton(
                                      onPressed: () =>
                                          _handleNotificationAction(
                                              notification),
                                      child: const Text('Act'),
                                    ),
                                  Text(
                                    notification['time'] ?? 'Now',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notification['message'] ?? 'No message',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (notification['shipment_id'] != null) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.info_outline,
                                        size: 14,
                                        color: Colors.grey.shade600),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Shipment: ${notification['shipment_id']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () => controller.trackShipment(
                                          notification['shipment_id']),
                                      child: const Text('Track'),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    )),
              if (controller.notifications.length > 5)
                TextButton(
                  onPressed: () => _showAllNotifications(),
                  child: Text(
                      'View all ${controller.notifications.length} notifications'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'delay':
        return Icons.access_time;
      case 'arrival':
        return Icons.location_on;
      case 'issue':
        return Icons.warning;
      case 'completion':
        return Icons.check_circle;
      default:
        return Icons.notifications;
    }
  }

  void _handleNotificationAction(Map<String, dynamic> notification) {
    // Handle notification action
  }

  void _showAlertSettings() {
    Get.dialog(const AlertDialog(
      title: Text("Alert Settings"),
      content: Text("Feature coming soon"),
    ));
  }

  void _showAllNotifications() {
    Get.toNamed('/notifications');
  }
}