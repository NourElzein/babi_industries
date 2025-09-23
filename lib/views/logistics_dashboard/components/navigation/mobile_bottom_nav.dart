import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/logistics_dashboard_controller.dart';
import 'package:babi_industries/theme/logistics_theme.dart';

class MobileBottomNav extends StatelessWidget {
  final LogisticsDashboardController controller;

  const MobileBottomNav({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: LogisticsTheme.kPrimaryColor,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping),
              label: 'Shipments',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Tracking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.route),
              label: 'Routes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car),
              label: 'Vehicles',
            ),
          ],
        ));
  }
}