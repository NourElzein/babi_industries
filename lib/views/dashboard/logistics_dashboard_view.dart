import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/logistics_dashboard_controller.dart';
import 'package:babi_industries/views/logistics_dashboard/components/responsive_layout.dart';
import 'package:babi_industries/views/logistics_dashboard/components/loading_view.dart';
import 'package:babi_industries/views/logistics_dashboard/components/error_view.dart';
import 'package:babi_industries/views/logistics_dashboard/components/dashboard/welcome_section.dart';
import 'package:babi_industries/views/logistics_dashboard/components/dashboard/kpi_grid.dart';
import 'package:babi_industries/views/logistics_dashboard/components/dashboard/critical_alerts.dart';
import 'package:babi_industries/views/logistics_dashboard/components/dashboard/active_shipments.dart';
import 'package:babi_industries/views/logistics_dashboard/components/dashboard/live_tracking.dart';
import 'package:babi_industries/views/logistics_dashboard/components/dashboard/recent_activity.dart';
import 'package:babi_industries/views/logistics_dashboard/components/sidebar/sidebar.dart';

class LogisticsDashboardView extends StatelessWidget {
  LogisticsDashboardView({super.key});

  final LogisticsDashboardController controller = Get.put(LogisticsDashboardController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isTablet = size.width >= 768 && size.width < 1100;

    return ResponsiveLogisticsLayout(
      controller: controller,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingView();
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return ErrorView(controller: controller);
        }

        return isMobile
            ? _buildMobileView(controller)
            : isTablet
                ? _buildTabletView(controller)
                : _buildDesktopView(controller);
      }),
    );
  }

  Widget _buildMobileView(LogisticsDashboardController controller) {
    return IndexedStack(
      index: controller.selectedIndex.value,
      children: [
        _buildDashboardContent(controller),
        _buildShipmentsView(controller),
        _buildTrackingView(controller),
        _buildRoutesView(controller),
        _buildVehiclesView(controller),
      ],
    );
  }

  Widget _buildTabletView(LogisticsDashboardController controller) {
    return Row(
      children: [
        // Sidebar for tablet
        Container(
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Sidebar(onItemSelected: _handleSidebarSelection),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WelcomeSection(controller: controller),
                const SizedBox(height: 24),
                KpiGrid(controller: controller, crossAxisCount: 3),
                const SizedBox(height: 24),
                _buildTabletContentGrid(controller),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopView(LogisticsDashboardController controller) {
    return Row(
      children: [
        // Sidebar for desktop
        Container(
          width: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Sidebar(onItemSelected: _handleSidebarSelection),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WelcomeSection(controller: controller),
                const SizedBox(height: 24),
                KpiGrid(controller: controller, crossAxisCount: 4),
                const SizedBox(height: 24),
                _buildMainContentGrid(controller),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardContent(LogisticsDashboardController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeSection(controller: controller),
          const SizedBox(height: 20),
          KpiGrid(controller: controller, crossAxisCount: 2),
          const SizedBox(height: 20),
          CriticalAlerts(controller: controller),
          const SizedBox(height: 20),
          ActiveShipments(controller: controller),
          const SizedBox(height: 20),
          LiveTracking(controller: controller),
          const SizedBox(height: 20),
          RecentActivity(controller: controller),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildTabletContentGrid(LogisticsDashboardController controller) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        CriticalAlerts(controller: controller),
        ActiveShipments(controller: controller),
        LiveTracking(controller: controller),
        RecentActivity(controller: controller),
      ],
    );
  }

  Widget _buildMainContentGrid(LogisticsDashboardController controller) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        CriticalAlerts(controller: controller),
        ActiveShipments(controller: controller),
        LiveTracking(controller: controller),
        RecentActivity(controller: controller),
      ],
    );
  }

  Widget _buildShipmentsView(LogisticsDashboardController controller) {
    return Center(child: Text("Shipments View - Coming Soon"));
  }

  Widget _buildTrackingView(LogisticsDashboardController controller) {
    return Center(child: Text("Tracking View - Coming Soon"));
  }

  Widget _buildRoutesView(LogisticsDashboardController controller) {
    return Center(child: Text("Routes View - Coming Soon"));
  }

  Widget _buildVehiclesView(LogisticsDashboardController controller) {
    return Center(child: Text("Vehicles View - Coming Soon"));
  }

  void _handleSidebarSelection(String item) {
    switch (item.toLowerCase()) {
      case 'dashboard':
        controller.changeTab(0);
        break;
      case 'shipments':
        controller.changeTab(1);
        break;
      case 'tracking':
        controller.changeTab(2);
        break;
      case 'routes':
        controller.changeTab(3);
        break;
      case 'vehicles':
        controller.changeTab(4);
        break;
      case 'analytics':
        // Handle analytics navigation
        break;
      case 'reports':
        // Handle reports navigation
        break;
      case 'settings':
        // Handle settings navigation
        break;
    }
  }
}