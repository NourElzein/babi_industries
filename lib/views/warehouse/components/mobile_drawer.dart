import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/warehouse_controller.dart';
import 'package:babi_industries/theme/warehouse_colors.dart';

class MobileDrawer extends StatelessWidget {
  final WarehouseController controller;

  const MobileDrawer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: WarehouseColors.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.warehouse, color: Colors.white, size: 40),
                SizedBox(height: 12),
                Text(
                  'Warehouse Menu',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed('/dashboard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Inventory'),
            onTap: () {
              Navigator.pop(context);
              controller.navigateToInventory();
            },
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Movements'),
            onTap: () {
              Navigator.pop(context);
              controller.navigateToMovements();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed('/settings');
            },
          ),
        ],
      ),
    );
  }
}