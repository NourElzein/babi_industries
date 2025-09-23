import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/logistics_dashboard_controller.dart';
import 'package:babi_industries/theme/logistics_theme.dart';

class MobileDrawer extends StatelessWidget {
  final LogisticsDashboardController controller;

  const MobileDrawer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: LogisticsTheme.kPrimaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.local_shipping, size: 40, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  controller.authController.currentUser.value?.name ??
                      "Coordinator",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Logistics Dashboard",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.dashboard, "Dashboard", onTap: () {}),
          _buildDrawerItem(
              Icons.local_shipping, "Shipments",
              onTap: () => controller.navigateToShipmentManagement()),
          _buildDrawerItem(
              Icons.map, "Tracking",
              onTap: () => controller.navigateToTrackingMap()),
          _buildDrawerItem(
              Icons.route, "Routes",
              onTap: () => controller.navigateToRouteOptimization()),
          _buildDrawerItem(Icons.directions_car, "Vehicles", onTap: () {}),
          _buildDrawerItem(Icons.analytics, "Analytics", onTap: () {}),
          _buildDrawerItem(Icons.report, "Reports", onTap: () {}),
          _buildDrawerItem(Icons.settings, "Settings", onTap: () {}),
          const Divider(),
          _buildDrawerItem(Icons.logout, "Logout",
              onTap: () => controller.authController.logout()),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: LogisticsTheme.kPrimaryColor),
      title: Text(title),
      onTap: onTap,
    );
  }
}