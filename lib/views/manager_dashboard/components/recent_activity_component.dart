import 'package:babi_industries/controllers/manager_dashboard_controller.dart';
import 'package:babi_industries/views/dashboard/manager_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecentActivityComponent {
  static Widget buildRecentActivity(ManagerDashboardController controller) {
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
                  "Recent Activity",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list, size: 20),
                  onPressed: () => _showActivityFilters(controller),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => controller.activities.isEmpty 
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No recent activities"),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.activities.length > 8 ? 8 : controller.activities.length,
                  itemBuilder: (context, index) {
                    final activity = controller.activities[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: _getActivityColor(activity['type']).withOpacity(0.1),
                        child: Icon(
                          _getActivityIcon(activity['type'] ?? 'default'),
                          color: _getActivityColor(activity['type']),
                          size: 20,
                        ),
                      ),
                      title: Text(
                        activity['title'] ?? activity['action'] ?? 'Activity',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity['description'] ?? activity['message'] ?? 'No description',
                            style: const TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                activity['created_at'] ?? activity['time'] ?? 'Now',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              if (activity['user'] != null)
                                Text(
                                  'by ${activity['user']}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      trailing: activity['status'] != null
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(activity['status']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                activity['status'],
                                style: TextStyle(
                                  color: _getStatusColor(activity['status']),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : null,
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

  static IconData _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'order':
      case 'order_created':
        return Icons.shopping_cart;
      case 'supplier':
      case 'supplier_added':
        return Icons.business;
      case 'inventory':
      case 'stock_update':
        return Icons.inventory;
      case 'alert':
      case 'warning':
        return Icons.warning;
      case 'delivery':
      case 'shipment':
        return Icons.local_shipping;
      case 'performance':
        return Icons.assessment;
      case 'forecast':
        return Icons.trending_up;
      case 'analytics':
        return Icons.analytics;
      case 'contract':
        return Icons.description;
      default:
        return Icons.notifications;
    }
  }

  static Color _getActivityColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'order':
        return ManagerDashboardView.kPrimaryColor;
      case 'supplier':
        return ManagerDashboardView.kAccentColor;
      case 'inventory':
        return ManagerDashboardView.kWarningColor;
      case 'alert':
        return ManagerDashboardView.kErrorColor;
      case 'delivery':
        return ManagerDashboardView.kSecondaryColor;
      case 'contract':
        return ManagerDashboardView.kPurpleColor;
      default:
        return ManagerDashboardView.kPrimaryColor;
    }
  }

  static void _showActivityFilters(ManagerDashboardController controller) => _showFeatureDialog("Activity Filters");

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