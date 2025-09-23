import 'package:babi_industries/controllers/buyer_dashboard_controller.dart';
import 'package:babi_industries/views/buyer_dashboard/buyer_dashboard_view.dart';
import 'package:babi_industries/views/buyer_dashboard/widgets/buyer_dashboard_components.dart';
import 'package:babi_industries/views/buyer_dashboard/widgets/buyer_dashboard_dialogs.dart';
import 'package:babi_industries/views/buyer_dashboard/widgets/buyer_dashboard_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerDashboardContent {
  static Widget buildMobileView(BuyerDashboardController controller) {
    return Obx(() => IndexedStack(
      index: controller.selectedBottomNavIndex.value,
      children: [
        _buildDashboardContent(controller),
        _buildOrdersView(controller),
        _buildSuppliersView(controller),
        _buildComparisonView(controller),
        _buildProfileView(controller),
      ],
    ));
  }

  static Widget buildDesktopView(BuyerDashboardController controller) {
    return Row(
      children: [
        BuyerDashboardSidebar.buildSidebar(controller),
        Expanded(child: _buildMainContent(controller, false)),
      ],
    );
  }

  static Widget buildTabletView(BuyerDashboardController controller) {
    return _buildMainContent(controller, true);
  }

  static Widget _buildMainContent(BuyerDashboardController controller, bool isTablet) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(BuyerDashboardView.kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuyerDashboardComponents.buildWelcomeHeader(controller),
          const SizedBox(height: 24),
          BuyerDashboardComponents.buildResponsiveKPIGrid(controller, isTablet),
          const SizedBox(height: 32),
          if (isTablet)
            _buildTabletContentLayout(controller)
          else
            _buildDesktopContentLayout(controller),
        ],
      ),
    );
  }

  static Widget _buildDashboardContent(BuyerDashboardController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(BuyerDashboardView.kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuyerDashboardComponents.buildWelcomeHeader(controller),
          const SizedBox(height: 20),
          BuyerDashboardComponents.buildResponsiveKPIGrid(controller, false),
          const SizedBox(height: 20),
          BuyerDashboardComponents.buildQuickActions(controller),
          const SizedBox(height: 20),
          BuyerDashboardComponents.buildRecentOrders(controller),
          const SizedBox(height: 20),
          BuyerDashboardComponents.buildSupplierRecommendations(controller),
          const SizedBox(height: 20),
          BuyerDashboardComponents.buildUrgentAlerts(controller),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  static Widget _buildTabletContentLayout(BuyerDashboardController controller) {
    return Column(
      children: [
        BuyerDashboardComponents.buildQuickActions(controller),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  BuyerDashboardComponents.buildRecentOrders(controller),
                  const SizedBox(height: 24),
                  BuyerDashboardComponents.buildOrderTimeline(controller),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  BuyerDashboardComponents.buildSupplierRecommendations(controller),
                  const SizedBox(height: 24),
                  BuyerDashboardComponents.buildUrgentAlerts(controller),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _buildDesktopContentLayout(BuyerDashboardController controller) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  BuyerDashboardComponents.buildQuickActions(controller),
                  const SizedBox(height: 24),
                  BuyerDashboardComponents.buildRecentOrders(controller),
                  const SizedBox(height: 24),
                  BuyerDashboardComponents.buildOrderTimeline(controller),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  BuyerDashboardComponents.buildSupplierRecommendations(controller),
                  const SizedBox(height: 24),
                  BuyerDashboardComponents.buildUrgentAlerts(controller),
                  const SizedBox(height: 24),
                  BuyerDashboardComponents.buildProcurementInsights(controller),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Individual View Builders
  static Widget _buildOrdersView(BuyerDashboardController controller) {
    return Scaffold(
      backgroundColor: BuyerDashboardView.kBackgroundColor,
      appBar: AppBar(
        title: const Text("Orders Management"),
        backgroundColor: BuyerDashboardView.kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => BuyerDashboardDialogs.showFeatureDialog("Order Filters"),
          ),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () => BuyerDashboardDialogs.showQuickOrderDialog(controller),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BuyerDashboardComponents.buildOrderStatusSummary(controller),
            const SizedBox(height: 16),
            Expanded(child: BuyerDashboardComponents.buildRecentOrders(controller)),
          ],
        ),
      ),
    );
  }

  static Widget _buildSuppliersView(BuyerDashboardController controller) {
    return Scaffold(
      backgroundColor: BuyerDashboardView.kBackgroundColor,
      appBar: AppBar(
        title: const Text("Suppliers"),
        backgroundColor: BuyerDashboardView.kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => BuyerDashboardDialogs.showSearchDialog(controller),
          ),
          IconButton(
            icon: const Icon(Icons.add_business),
            onPressed: () => BuyerDashboardDialogs.showFeatureDialog("Add Supplier"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BuyerDashboardComponents.buildSupplierMetrics(controller),
            const SizedBox(height: 0),
            Expanded(child: BuyerDashboardComponents.buildSupplierRecommendations(controller)),
          ],
        ),
      ),
    );
  }

  static Widget _buildComparisonView(BuyerDashboardController controller) {
    return Scaffold(
      backgroundColor: BuyerDashboardView.kBackgroundColor,
      appBar: AppBar(
        title: const Text("Price Comparison"),
        backgroundColor: BuyerDashboardView.kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.compare),
            onPressed: () => controller.navigateToPriceComparison(),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.compare_arrows, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text("Price Comparison Tool"),
              SizedBox(height: 8),
              Text("Compare prices from different suppliers"),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildProfileView(BuyerDashboardController controller) {
    return Scaffold(
      backgroundColor: BuyerDashboardView.kBackgroundColor,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: BuyerDashboardView.kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => BuyerDashboardDialogs.showFeatureDialog("Edit Profile"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: BuyerDashboardView.kPrimaryColor,
              child: Text('B', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            const Text('Buyer Portal', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Senior Buyer • Yopougon, Côte d\'Ivoire', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Profile Settings'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => BuyerDashboardDialogs.showFeatureDialog('Profile Settings'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notification Preferences'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => BuyerDashboardDialogs.showFeatureDialog('Notification Settings'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Security Settings'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => BuyerDashboardDialogs.showFeatureDialog('Security Settings'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => BuyerDashboardDialogs.showFeatureDialog('Help & Support'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: BuyerDashboardView.kErrorColor),
                    title: const Text('Logout', style: TextStyle(color: BuyerDashboardView.kErrorColor)),
                    onTap: () => BuyerDashboardDialogs.showLogoutDialog(controller),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildFloatingActionButton(BuyerDashboardController controller) {
    return FloatingActionButton.extended(
      onPressed: () => BuyerDashboardDialogs.showQuickOrderDialog(controller),
      backgroundColor: BuyerDashboardView.kPrimaryColor,
      icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
      label: const Text(
        'Quick Order',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}