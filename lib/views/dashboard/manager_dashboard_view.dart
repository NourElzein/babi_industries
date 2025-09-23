import 'package:babi_industries/controllers/manager_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import all extracted components
import 'package:babi_industries/views/manager_dashboard/components/app_bar_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/drawer_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/bottom_nav_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/error_view_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/loading_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/welcome_section_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/kpi_grid_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/critical_alerts_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/recent_activity_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/quick_stats_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/predictive_analytics_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/sidebar_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/tablet_content_grid_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/main_content_grid_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/mobile_views_component.dart';
import 'package:babi_industries/views/manager_dashboard/components/floating_action_component.dart';

class ManagerDashboardView extends StatelessWidget {
  ManagerDashboardView({Key? key}) : super(key: key);

  static const kPrimaryColor = Color(0xFF1976D2);
  static const kSecondaryColor = Color(0xFF42A5F5);
  static const kAccentColor = Color(0xFF4CAF50);
  static const kWarningColor = Color(0xFFFF9800);
  static const kErrorColor = Color(0xFFF44336);
  static const kPurpleColor = Color(0xFF9C27B0);
  static const kTealColor = Color(0xFF009688);
  static const kBackgroundColor = Color(0xFFF5F6FA);
  static const kCardRadius = 16.0;
  static const kPadding = 16.0;

  final ManagerDashboardController controller = Get.put(ManagerDashboardController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isTablet = size.width >= 768 && size.width < 1024;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBarComponent.buildAppBar(controller, isMobile),
      drawer: isMobile ? DrawerComponent.buildMobileDrawer(controller) : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingComponent();
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return ErrorViewComponent.buildErrorView(controller);
        }

        return isMobile
            ? _buildMobileView(controller)
            : isTablet
                ? _buildTabletView(controller)
                : _buildDesktopView(controller);
      }),
      bottomNavigationBar: isMobile ? BottomNavComponent.buildMobileBottomNav(controller) : null,
      floatingActionButton: FloatingActionComponent.buildFloatingActionButton(context),
    );
  }

  Widget _buildTabletView(ManagerDashboardController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeSectionComponent.buildWelcomeSection(controller),
          const SizedBox(height: 24),
          KpiGridComponent.buildResponsiveKpiGrid(controller, crossAxisCount: 3),
          const SizedBox(height: 24),
          TabletContentGridComponent.buildTabletContentGrid(controller),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildDesktopView(ManagerDashboardController controller) {
    return Row(
      children: [
        SidebarComponent.buildSidebar(controller),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WelcomeSectionComponent.buildWelcomeSection(controller),
                const SizedBox(height: 24),
                KpiGridComponent.buildResponsiveKpiGrid(controller, crossAxisCount: 4),
                const SizedBox(height: 24),
                MainContentGridComponent.buildMainContentGrid(controller),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileView(ManagerDashboardController controller) {
    return IndexedStack(
      index: controller.selectedIndex.value,
      children: MobileViewsComponent.buildMobileViews(controller),
    );
  }
}