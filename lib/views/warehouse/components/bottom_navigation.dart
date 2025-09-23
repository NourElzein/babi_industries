import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/warehouse_controller.dart';
import 'package:babi_industries/theme/warehouse_colors.dart';
import 'package:babi_industries/services/dialog_service.dart';

class BottomNavigation extends StatelessWidget {
  final WarehouseController controller;

  const BottomNavigation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
      currentIndex: controller.selectedBottomNavIndex.value,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: WarehouseColors.primaryColor,
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
          icon: Icon(Icons.inventory_outlined),
          activeIcon: Icon(Icons.inventory),
          label: "Inventory",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.swap_horiz_outlined),
          activeIcon: Icon(Icons.swap_horiz),
          label: "Movements",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner_outlined),
          activeIcon: Icon(Icons.qr_code_scanner),
          label: "Scan",
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

  void _handleBottomNavTap(int index, WarehouseController controller) {
    controller.selectedBottomNavIndex.value = index;
    switch (index) {
      case 0:
        break;
      case 1:
        controller.navigateToInventory();
        break;
      case 2:
        controller.navigateToMovements();
        break;
      case 3:
        DialogService.showQRScannerDialog(controller);
        break;
      case 4:
        DialogService.showProfileMenu(controller);
        break;
    }
  }
}