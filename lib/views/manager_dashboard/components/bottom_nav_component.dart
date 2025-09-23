import 'package:babi_industries/controllers/manager_dashboard_controller.dart';
import 'package:babi_industries/views/dashboard/manager_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavComponent {
  static Obx buildMobileBottomNav(ManagerDashboardController controller) {
    return Obx(() => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value > 4 ? 4 : controller.selectedIndex.value,
          selectedItemColor: ManagerDashboardView.kPrimaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.business), label: "Suppliers"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Orders"),
            BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Inventory"),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Analytics"),
          ],
          onTap: (index) => controller.selectedIndex.value = index,
        ));
  }
}