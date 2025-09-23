import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/theme/app_colors.dart';
import 'package:babi_industries/controllers/buyer_dashboard_controller.dart';
import 'package:babi_industries/views/buyer_dashboard/utils/dialog_utils.dart';

class BottomNavigation extends StatelessWidget {
  final BuyerDashboardController controller;

  const BottomNavigation({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
      currentIndex: controller.selectedBottomNavIndex.value,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.kPrimaryColor,
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

void _handleBottomNavTap(int index, BuyerDashboardController controller) {
  controller.selectedBottomNavIndex.value = index;

  switch (index) {
    case 1:
      if (Get.isRegistered<BuyerDashboardController>() && Get.routing.current != '/buyer/orders') {
        Get.toNamed('/buyer/orders');
      }
      break;
    case 2:
      if (Get.isRegistered<BuyerDashboardController>() && Get.routing.current != '/buyer/suppliers') {
        Get.toNamed('/buyer/suppliers');
      }
      break;
    case 3:
      if (Get.isRegistered<BuyerDashboardController>() && Get.routing.current != '/buyer/price-comparison') {
        Get.toNamed('/buyer/price-comparison');
      }
      break;
    case 4:
      // Show profile menu
      DialogUtils.showProfileMenu(controller);
      break;
  }
}
}