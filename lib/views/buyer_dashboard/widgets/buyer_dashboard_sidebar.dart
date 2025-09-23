import 'package:babi_industries/controllers/buyer_dashboard_controller.dart';
import 'package:babi_industries/views/buyer_dashboard/buyer_dashboard_view.dart';
import 'package:babi_industries/views/buyer_dashboard/widgets/buyer_dashboard_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerDashboardSidebar {
  static Widget buildSidebar(BuyerDashboardController controller) {
    return Container(
      width: 260,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: BuyerDashboardView.kPadding),
            child: Text(
              "Buyer Portal",
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
                _buildSidebarItem("Dashboard", Icons.dashboard, true, () {}),
                _buildSidebarItem("Orders", Icons.shopping_cart, false, controller.navigateToOrders),
                _buildSidebarItem("Suppliers", Icons.business, false, controller.navigateToSuppliers),
                _buildSidebarItem("Price Comparison", Icons.compare_arrows, false, controller.navigateToPriceComparison),
                _buildSidebarItem("Inventory", Icons.inventory, false, () => BuyerDashboardDialogs.showFeatureDialog("Inventory Management")),
                _buildSidebarItem("Analytics", Icons.analytics, false, () => BuyerDashboardDialogs.showFeatureDialog("Procurement Analytics")),
                _buildSidebarItem("Reports", Icons.assessment, false, controller.navigateToReports),
                _buildSidebarItem("Contracts", Icons.description, false, () => BuyerDashboardDialogs.showFeatureDialog("Contract Management")),
                const Divider(),
                _buildSidebarItem("Quick Order", Icons.add_shopping_cart, false, () => BuyerDashboardDialogs.showQuickOrderDialog(controller)),
                _buildSidebarItem("Favorites", Icons.favorite, false, () => BuyerDashboardDialogs.showFeatureDialog("Favorite Suppliers")),
                const Divider(),
                _buildSidebarItem("Settings", Icons.settings, false, () => BuyerDashboardDialogs.showFeatureDialog("Settings")),
                _buildSidebarItem("Help & Support", Icons.help, false, () => BuyerDashboardDialogs.showFeatureDialog("Help & Support")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildMobileDrawer(BuyerDashboardController controller) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: BuyerDashboardView.kPrimaryColor),
            accountName: Text("Buyer Portal"),
            accountEmail: Text("buyer@babi.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'B',
                style: TextStyle(color: BuyerDashboardView.kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSidebarItem("Dashboard", Icons.dashboard, true, () => Get.back()),
                _buildSidebarItem("Orders", Icons.shopping_cart, false, () {
                  Get.back();
                  controller.selectedBottomNavIndex.value = 1;
                }),
                _buildSidebarItem("Suppliers", Icons.business, false, () {
                  Get.back();
                  controller.selectedBottomNavIndex.value = 2;
                }),
                _buildSidebarItem("Compare Prices", Icons.compare_arrows, false, () {
                  Get.back();
                  controller.selectedBottomNavIndex.value = 3;
                }),
                _buildSidebarItem("Quick Order", Icons.add_shopping_cart, false, () {
                  Get.back();
                  BuyerDashboardDialogs.showQuickOrderDialog(controller);
                }),
                _buildSidebarItem("Reports", Icons.assessment, false, () {
                  Get.back();
                  controller.navigateToReports();
                }),
                const Divider(),
                _buildSidebarItem("Settings", Icons.settings, false, () {
                  Get.back();
                  BuyerDashboardDialogs.showFeatureDialog("Settings");
                }),
                _buildSidebarItem("Help", Icons.help, false, () {
                  Get.back();
                  BuyerDashboardDialogs.showFeatureDialog("Help & Support");
                }),
                _buildSidebarItem("Logout", Icons.logout, false, () {
                  Get.back();
                  BuyerDashboardDialogs.showLogoutDialog(controller);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSidebarItem(String title, IconData icon, bool isActive, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? BuyerDashboardView.kPrimaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? BuyerDashboardView.kPrimaryColor : Colors.grey.shade600,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? BuyerDashboardView.kPrimaryColor : Colors.grey.shade700,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}