import 'package:babi_industries/controllers/buyer_dashboard_controller.dart';
import 'package:babi_industries/views/buyer_dashboard/buyer_dashboard_view.dart';
import 'package:babi_industries/views/buyer_dashboard/widgets/buyer_dashboard_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerDashboardBottomNav {
  static Widget buildBottomNavigation(BuyerDashboardController controller) {
    return Obx(() => BottomNavigationBar(
      currentIndex: controller.selectedBottomNavIndex.value,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: BuyerDashboardView.kPrimaryColor,
      unselectedItemColor: Colors.grey.shade600,
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 10,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
          label: "Orders",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business_outlined),
          activeIcon: Icon(Icons.business),
          label: "Suppliers",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.compare_arrows_outlined),
          activeIcon: Icon(Icons.compare_arrows),
          label: "Compare",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
      onTap: (index) => _handleBottomNavTap(index, controller),
    ));
  }

  static void _handleBottomNavTap(int index, BuyerDashboardController controller) {
    controller.selectedBottomNavIndex.value = index;
    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        controller.navigateToOrders();
        break;
      case 2:
        controller.navigateToSuppliers();
        break;
      case 3:
        controller.navigateToPriceComparison();
        break;
      case 4:
        BuyerDashboardDialogs.showProfileMenu(controller);
        break;
    }
  }
}