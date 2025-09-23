import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/logistics_dashboard_controller.dart';
import 'package:babi_industries/theme/logistics_theme.dart';

class RecentActivity extends StatelessWidget {
  final LogisticsDashboardController controller;

  const RecentActivity({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LogisticsTheme.kCardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(LogisticsTheme.kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recent Activity",
              style: LogisticsTheme.cardTitleStyle,
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.recentActivities.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text("No recent activity")),
                );
              }

              return SizedBox(
                height: 180,
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemCount: controller.recentActivities.length,
                    itemBuilder: (context, index) {
                      final activity = controller.recentActivities[index];
                      return ListTile(
                        leading: Icon(
                          _getActivityIcon(activity['type']),
                          color: LogisticsTheme.kPrimaryColor,
                        ),
                        title: Text(activity['title'] ?? 'Activity'),
                        subtitle: Text(activity['description'] ?? ''),
                        trailing: Text(
                          activity['time'] ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                      );
                    },
                  ),
                )
              );
            }),
            if (controller.recentActivities.length > 5)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showAllActivities(),
                  child: const Text('View all activities'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'shipment_created':
        return Icons.add_circle;
      case 'shipment_updated':
        return Icons.edit;
      case 'status_changed':
        return Icons.sync;
      case 'delivery_completed':
        return Icons.check_circle;
      default:
        return Icons.history;
    }
  }

  void _showAllActivities() {
    Get.toNamed('/activities');
  }
}