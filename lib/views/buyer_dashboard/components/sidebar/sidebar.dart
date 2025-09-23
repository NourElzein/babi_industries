import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/theme/app_colors.dart';
import 'package:babi_industries/controllers/buyer_dashboard_controller.dart';
import 'package:babi_industries/views/buyer_dashboard/utils/dialog_utils.dart';

class Sidebar extends StatelessWidget {
  final BuyerDashboardController controller;
  final bool isMobile;

  const Sidebar({
    Key? key,
    required this.controller,
    required this.isMobile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppColors.kSidebarWidth,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppColors.kPadding),
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
                _buildSidebarItem("Inventory", Icons.inventory, false, () => DialogUtils.showFeatureDialog("Inventory Management")),
                _buildSidebarItem("Analytics", Icons.analytics, false, () => DialogUtils.showFeatureDialog("Procurement Analytics")),
                _buildSidebarItem("Reports", Icons.assessment, false, controller.navigateToReports),
                _buildSidebarItem("Contracts", Icons.description, false, () => DialogUtils.showFeatureDialog("Contract Management")),
                const Divider(),
                _buildSidebarItem("Quick Order", Icons.add_shopping_cart, false, () => DialogUtils.showQuickOrderDialog(controller)),
                _buildSidebarItem("Favorites", Icons.favorite, false, () => DialogUtils.showFeatureDialog("Favorite Suppliers")),
                const Divider(),
                _buildSidebarItem("Settings", Icons.settings, false, () => DialogUtils.showFeatureDialog("Settings")),
                _buildSidebarItem("Help & Support", Icons.help, false, () => DialogUtils.showFeatureDialog("Help & Support")),
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