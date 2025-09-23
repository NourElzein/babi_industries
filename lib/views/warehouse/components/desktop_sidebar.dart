import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/warehouse_controller.dart';
import 'package:babi_industries/theme/warehouse_colors.dart';

class DesktopSidebar extends StatelessWidget {
  final WarehouseController controller;

  const DesktopSidebar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: WarehouseColors.primaryColor,
      child: Column(
        children: [
          const SizedBox(height: 32),
          const Icon(Icons.warehouse, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Warehouse',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.white),
            title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
            onTap: () => Get.toNamed('/dashboard'),
          ),
          ListTile(
            leading: const Icon(Icons.inventory, color: Colors.white),
            title: const Text('Inventory', style: TextStyle(color: Colors.white)),
            onTap: () => controller.navigateToInventory(),
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz, color: Colors.white),
            title: const Text('Movements', style: TextStyle(color: Colors.white)),
            onTap: () => controller.navigateToMovements(),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: () => Get.toNamed('/settings'),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}