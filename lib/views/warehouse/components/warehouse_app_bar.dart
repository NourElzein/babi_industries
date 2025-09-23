import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/warehouse_controller.dart';
import 'package:babi_industries/theme/warehouse_colors.dart';
import 'package:babi_industries/services/dialog_service.dart';

class WarehouseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final WarehouseController controller;

  const WarehouseAppBar({super.key, required this.controller});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _buildTitle(),
      backgroundColor: WarehouseColors.primaryColor,
      elevation: 0,
      actions: _buildActions(),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.warehouse, size: 20, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Warehouse Dashboard',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Warehouse • Inventory Management',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActions() {
    return [
      _buildNotificationButton(),
      IconButton(
        icon: const Icon(Icons.search, color: Colors.white),
        onPressed: () => DialogService.showSearchDialog(controller),
      ),
      _buildProfileAvatar(),
    ];
  }

  Widget _buildNotificationButton() {
    return Obx(() => Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () => DialogService.showNotificationsDialog(controller),
        ),
        if (controller.lowStockAlerts.isNotEmpty)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: WarehouseColors.errorColor,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                controller.lowStockAlerts.length.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    ));
  }

  Widget _buildProfileAvatar() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        onTap: () => DialogService.showProfileMenu(controller),
        child: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            'W',
            style: TextStyle(color: WarehouseColors.primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}