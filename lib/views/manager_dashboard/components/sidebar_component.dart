import 'package:babi_industries/controllers/manager_dashboard_controller.dart';
import 'package:babi_industries/views/dashboard/manager_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SidebarComponent {
  static Widget buildSidebar(ManagerDashboardController controller) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: ManagerDashboardView.kPadding),
            child: Text(
              "Supply Chain Management",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _sidebarItem("Dashboard", Icons.dashboard, true, () {}),
                _sidebarItem("Suppliers", Icons.business, false, controller.navigateToSupplierManagement),
                _sidebarItem("Orders", Icons.shopping_cart, false, controller.navigateToOrderManagement),
                _sidebarItem("Inventory", Icons.inventory, false, controller.navigateToInventoryManagement),
                _sidebarItem("Contracts", Icons.description, false, () => _showContractManagement(controller)),
                _sidebarItem("Logistics", Icons.local_shipping, false, () => _showLogisticsTracking(controller)),
                _sidebarItem("Warehouse", Icons.warehouse, false, () => _showFeatureDialog("Warehouse Management")),
                _sidebarItem("Analytics", Icons.analytics, false, controller.navigateToAnalytics),
                _sidebarItem("Reports", Icons.assessment, false, controller.navigateToReports),
                _sidebarItem("Forecasting", Icons.trending_up, false, () => _showPredictiveAnalytics(controller)),
                const Divider(),
                _sidebarItem("Settings", Icons.settings, false, () => _showDashboardSettings(controller)),
                _sidebarItem("Help & Support", Icons.help, false, () => _showFeatureDialog("Help & Support")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _sidebarItem(String title, IconData icon, [bool isActive = false, VoidCallback? onTap]) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? ManagerDashboardView.kPrimaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? ManagerDashboardView.kPrimaryColor : Colors.grey.shade600,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? ManagerDashboardView.kPrimaryColor : Colors.grey.shade700,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: onTap ?? () {},
      ),
    );
  }

  static void _showContractManagement(ManagerDashboardController controller) => _showFeatureDialog("Contract Management");
  static void _showLogisticsTracking(ManagerDashboardController controller) => _showFeatureDialog("Logistics Tracking");
  static void _showPredictiveAnalytics(ManagerDashboardController controller) => _showFeatureDialog("Predictive Analytics");
  static void _showDashboardSettings(ManagerDashboardController controller) => _showFeatureDialog("Dashboard Settings");

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