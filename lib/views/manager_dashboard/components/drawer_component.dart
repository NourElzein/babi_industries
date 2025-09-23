import 'package:babi_industries/controllers/manager_dashboard_controller.dart';
import 'package:babi_industries/views/dashboard/manager_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerComponent {
  static Drawer buildMobileDrawer(ManagerDashboardController controller) {
    final user = controller.authController.currentUser.value;

    // Make sure to return the Drawer
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: ManagerDashboardView.kPrimaryColor),
            accountName: Text(user?.name ?? "Manager"),
            accountEmail: Text(user?.email ?? "manager@babi.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user?.profileImage != null
                  ? NetworkImage(user!.profileImage!)
                  : null,
              child: user?.profileImage == null
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _sidebarItem("Dashboard", Icons.dashboard, true, () => Get.back()),
                _sidebarItem("Suppliers", Icons.business, false, () {
                  Get.back();
                  controller.selectedIndex.value = 1;
                }),
                _sidebarItem("Orders", Icons.shopping_cart, false, () {
                  Get.back();
                  controller.selectedIndex.value = 2;
                }),
                _sidebarItem("Inventory", Icons.inventory, false, () {
                  Get.back();
                  controller.selectedIndex.value = 3;
                }),
                _sidebarItem("Analytics", Icons.analytics, false, () {
                  Get.back();
                  controller.selectedIndex.value = 4;
                }),
                _sidebarItem("Logistics", Icons.local_shipping, false, () {
                  Get.back();
                  controller.selectedIndex.value = 5;
                }),
                _sidebarItem("Contracts", Icons.description, false, () {
                  Get.back();
                  controller.selectedIndex.value = 6;
                }),
                const Divider(),
                _sidebarItem("Settings", Icons.settings, false, () {
                  Get.back();
                  _showDashboardSettings(controller);
                }),
                _sidebarItem("Logout", Icons.logout, false, () {
                  Get.back();
                  controller.authController.logout();
                }),
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

  static void _showDashboardSettings(ManagerDashboardController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text("Dashboard Settings"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Customize your dashboard:"),
            SizedBox(height: 16),
            Text("• Rearrange KPI cards"),
            Text("• Set alert thresholds"),
            Text("• Choose default views"),
            Text("• Configure notifications"),
            Text("• Export preferences"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _showFeatureDialog("Dashboard Customization");
            },
            child: const Text("Customize"),
          ),
        ],
      ),
    );
  }

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
