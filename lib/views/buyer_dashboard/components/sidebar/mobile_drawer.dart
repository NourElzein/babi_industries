import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/theme/app_colors.dart';
import 'package:babi_industries/controllers/buyer_dashboard_controller.dart';
import 'package:babi_industries/views/buyer_dashboard/utils/dialog_utils.dart';

class MobileDrawer extends StatelessWidget {
  final BuyerDashboardController controller;

  const MobileDrawer({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.kPrimaryColor),
            accountName: Text("Buyer Portal"),
            accountEmail: Text("buyer@babi.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'B',
                style: TextStyle(color: AppColors.kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 24),
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
                  DialogUtils.showQuickOrderDialog(controller);
                }),
                _buildSidebarItem("Reports", Icons.assessment, false, () {
                  Get.back();
                  controller.navigateToReports();
                }),
                const Divider(),
                _buildSidebarItem("Settings", Icons.settings, false, () {
                  Get.back();
                  DialogUtils.showFeatureDialog("Settings");
                }),
                _buildSidebarItem("Help", Icons.help, false, () {
                  Get.back();
                  DialogUtils.showFeatureDialog("Help & Support");
                }),
                _buildSidebarItem("Logout", Icons.logout, false, () {
                  Get.back();
                  DialogUtils.showLogoutDialog(controller);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String title, IconData icon, [bool isActive = false, VoidCallback? onTap]) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? AppColors.kPrimaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? AppColors.kPrimaryColor : Colors.grey.shade600,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? AppColors.kPrimaryColor : Colors.grey.shade700,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: onTap ?? () {},
      ),
    );
  }
}