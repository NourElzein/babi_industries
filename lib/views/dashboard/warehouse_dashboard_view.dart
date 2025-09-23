import 'package:babi_industries/views/warehouse/components/warehouse_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/warehouse_controller.dart';
import 'package:babi_industries/theme/warehouse_colors.dart';
import 'package:babi_industries/utils/responsive_utils.dart';
import 'package:babi_industries/views/warehouse/components/bottom_navigation.dart';
import 'package:babi_industries/views/warehouse/components/desktop_sidebar.dart';
import 'package:babi_industries/views/warehouse/components/floating_action_button.dart';
import 'package:babi_industries/views/warehouse/components/kpi_grid.dart';
import 'package:babi_industries/views/warehouse/components/low_stock_alerts.dart';
import 'package:babi_industries/views/warehouse/components/mobile_drawer.dart';
import 'package:babi_industries/views/warehouse/components/performance_metrics.dart';
import 'package:babi_industries/views/warehouse/components/quick_actions.dart';
import 'package:babi_industries/views/warehouse/components/recent_movements.dart';
import 'package:babi_industries/views/warehouse/components/welcome_header.dart';

class WarehouseDashboardView extends StatelessWidget {
  const WarehouseDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final WarehouseController controller = Get.put(WarehouseController());
    
    return Scaffold(
      backgroundColor: WarehouseColors.backgroundColor,
      appBar: WarehouseAppBar(controller: controller),
      drawer: ResponsiveUtils.isMobile(context) 
          ? MobileDrawer(controller: controller)
          : null,
      body: _buildBody(context, controller),
      bottomNavigationBar: _buildBottomNavigation(context, controller),
      floatingActionButton: WarehouseFAB(controller: controller),
    );
  }

  Widget _buildBody(BuildContext context, WarehouseController controller) {
    return Row(
      children: [
        if (ResponsiveUtils.isDesktop(context)) 
          DesktopSidebar(controller: controller),
        Expanded(
          child: Obx(() => _buildContent(context, controller)),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, WarehouseController controller) {
    if (controller.isLoading.value) {
      return _buildLoadingState();
    }

    if (controller.errorMessage.value.isNotEmpty) {
      return _buildErrorState(controller);
    }

    return _buildMainContent(context, controller);
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: WarehouseColors.primaryColor),
          SizedBox(height: 16),
          Text('Loading warehouse data...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(WarehouseController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: controller.refreshData,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: WarehouseColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, WarehouseController controller) {
    final bool isMobile = ResponsiveUtils.isMobile(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeHeader(controller: controller),
          const SizedBox(height: 24),
          KpiGrid(
            controller: controller,
            isLargeScreen: ResponsiveUtils.isLargeScreen(context),
            isTablet: ResponsiveUtils.isTablet(context),
          ),
          const SizedBox(height: 32),
          _buildContentSection(context, controller),
        ],
      ),
    );
  }

  Widget _buildContentSection(BuildContext context, WarehouseController controller) {
    if (ResponsiveUtils.isMobile(context)) {
      return _buildMobileContent(controller);
    } else {
      return _buildTabletDesktopContent(controller);
    }
  }

  Widget _buildMobileContent(WarehouseController controller) {
    return Column(
      children: [
        QuickActions(controller: controller),
        const SizedBox(height: 24),
        RecentMovements(controller: controller),
        const SizedBox(height: 24),
        LowStockAlerts(controller: controller),
        const SizedBox(height: 24),
        PerformanceMetrics(controller: controller),
      ],
    );
  }

  Widget _buildTabletDesktopContent(WarehouseController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              QuickActions(controller: controller),
              const SizedBox(height: 24),
              RecentMovements(controller: controller),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              LowStockAlerts(controller: controller),
              const SizedBox(height: 24),
              PerformanceMetrics(controller: controller),
            ],
          ),
        ),
      ],
    );
  }

  Widget? _buildBottomNavigation(BuildContext context, WarehouseController controller) {
    if (ResponsiveUtils.isMobile(context) || ResponsiveUtils.isTablet(context)) {
      return BottomNavigation(controller: controller);
    }
    return null;
  }
}