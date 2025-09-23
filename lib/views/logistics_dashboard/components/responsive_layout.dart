import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/logistics_dashboard_controller.dart';
import 'package:babi_industries/theme/logistics_theme.dart';
import 'package:babi_industries/views/logistics_dashboard/components/app_bar/mobile_app_bar.dart';
import 'package:babi_industries/views/logistics_dashboard/components/app_bar/desktop_app_bar.dart';
import 'package:babi_industries/views/logistics_dashboard/components/sidebar/sidebar.dart';
import 'package:babi_industries/views/logistics_dashboard/components/navigation/mobile_bottom_nav.dart';
import 'package:babi_industries/views/logistics_dashboard/components/navigation/mobile_drawer.dart';

class ResponsiveLogisticsLayout extends StatelessWidget {
  final LogisticsDashboardController controller;
  final Widget child;

  const ResponsiveLogisticsLayout({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isTablet = size.width >= 768 && size.width < 1100;

    return Scaffold(
      backgroundColor: LogisticsTheme.kBackgroundColor,
      appBar: _buildResponsiveAppBar(controller, isMobile),
      drawer: isMobile ? MobileDrawer(controller: controller) : null,
      body: child,
      bottomNavigationBar: isMobile ? MobileBottomNav(controller: controller) : null,
      floatingActionButton: _buildFloatingActionButton(context, controller),
    );
  }

  PreferredSizeWidget _buildResponsiveAppBar(
    LogisticsDashboardController controller, bool isMobile) {
  if (isMobile) {
    return MobileAppBar(controller: controller);
  } else {
    return DesktopAppBar(controller: controller);
  }
}


  Widget _buildFloatingActionButton(BuildContext context, LogisticsDashboardController controller) {
    return FloatingActionButton(
      onPressed: () => _showCreateShipment(controller),
      backgroundColor: LogisticsTheme.kPrimaryColor,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _showCreateShipment(LogisticsDashboardController controller) {
    Get.toNamed('/create-shipment');
  }
}