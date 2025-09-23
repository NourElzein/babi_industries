import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/logistics_dashboard_controller.dart';
import 'package:babi_industries/theme/logistics_theme.dart';

class AppBarActions {
  static List<Widget> buildResponsiveActions(
      LogisticsDashboardController controller, bool isMobile) {
    return [
      IconButton(
        icon: Stack(
          children: [
            const Icon(Icons.notifications, color: Colors.white),
            if (controller.criticalAlerts.value > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: LogisticsTheme.kErrorColor,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    controller.criticalAlerts.value.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        onPressed: () => _showNotifications(controller),
      ),
      IconButton(
        icon: const Icon(Icons.map, color: Colors.white),
        onPressed: () => controller.navigateToTrackingMap(),
      ),
      IconButton(
        icon: const Icon(Icons.refresh, color: Colors.white),
        onPressed: controller.refreshData,
      ),
      if (!isMobile) 
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) => _handleAppBarMenuAction(value, controller),
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(value: 'tracking', child: Text('Live Tracking')),
            const PopupMenuItem(value: 'routes', child: Text('Route Optimization')),
            const PopupMenuItem(value: 'reports', child: Text('Export Reports')),
            const PopupMenuItem(value: 'settings', child: Text('Dashboard Settings')),
          ],
        ),
      const SizedBox(width: 8),
    ];
  }

  static void _showNotifications(LogisticsDashboardController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Notifications",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = controller.notifications[index];
                      return ListTile(
                        leading: Icon(_getNotificationIcon(notification['type'])),
                        title: Text(notification['title'] ?? 'Notification'),
                        subtitle: Text(notification['message'] ?? ''),
                        trailing: Text(notification['time'] ?? ''),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _getNotificationIcon(String type) {
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

  static void _handleAppBarMenuAction(String value, LogisticsDashboardController controller) {
    switch (value) {
      case 'tracking':
        controller.navigateToTrackingMap();
        break;
      case 'routes':
        controller.navigateToRouteOptimization();
        break;
      case 'reports':
        // Handle reports
        break;
      case 'settings':
        // Handle settings
        break;
    }
  }
}