import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/theme/warehouse_colors.dart';
import 'package:babi_industries/controllers/warehouse_controller.dart';
import 'package:babi_industries/routes/app_routes.dart';

class DialogService {
  static void showFeatureDialog(String feature) {
    Get.dialog(
      AlertDialog(
        title: Text(feature),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction, size: 48, color: Colors.orange.shade400),
            const SizedBox(height: 16),
            Text(
              '$feature is currently under development and will be available soon.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(backgroundColor: WarehouseColors.primaryColor),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  static void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout from your account?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed(AppRoutes.LOGIN);
              Get.snackbar(
                'Logged Out',
                'You have been logged out successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.grey[800],
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: WarehouseColors.errorColor),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  static void showQRScannerDialog(WarehouseController controller) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Scan QR Code',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: WarehouseColors.primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_scanner, size: 60, color: Colors.teal),
                        SizedBox(height: 16),
                        Text('Scanner Interface', style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Point camera at product QR code', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _handleScanResult('SKU-12345', controller);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: WarehouseColors.primaryColor),
                      child: const Text('Simulate Scan', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static void _handleScanResult(String scanResult, WarehouseController controller) {
    controller.scansToday.value += 1;
    Get.snackbar(
      'Scan Successful',
      'Scanned: $scanResult',
      backgroundColor: WarehouseColors.primaryColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.toNamed('/product/$scanResult');
  }

  static void showMovementDialog(WarehouseController controller) {
    Get.bottomSheet(
      MovementDialog(controller: controller),
      isScrollControlled: true,
    );
  }

  static void showSearchDialog(WarehouseController controller) {
    Get.dialog(SearchDialog(controller: controller));
  }

  static void showNotificationsDialog(WarehouseController controller) {
    Get.dialog(NotificationsDialog(controller: controller));
  }

  static void showProfileMenu(WarehouseController controller) {
    Get.bottomSheet(
      ProfileMenu(controller: controller),
      isScrollControlled: true,
    );
  }
}

class MovementDialog extends StatefulWidget {
  final WarehouseController controller;

  const MovementDialog({super.key, required this.controller});

  @override
  State<MovementDialog> createState() => _MovementDialogState();
}

class _MovementDialogState extends State<MovementDialog> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _movementData = {
    'productId': '',
    'type': 'in',
    'quantity': 0,
    'fromLocation': '',
    'toLocation': '',
    'reference': '',
    'notes': '',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New Stock Movement',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Product SKU',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.inventory),
                  ),
                  onSaved: (value) => _movementData['productId'] = value ?? '',
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: 'Movement Type',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.swap_vert),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'in', child: Text('Stock In')),
                    DropdownMenuItem(value: 'out', child: Text('Stock Out')),
                    DropdownMenuItem(value: 'transfer', child: Text('Transfer')),
                    DropdownMenuItem(value: 'adjustment', child: Text('Adjustment')),
                  ],
                  onChanged: (value) => _movementData['type'] = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _movementData['quantity'] = int.tryParse(value ?? '0') ?? 0,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'From Location',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  onSaved: (value) => _movementData['fromLocation'] = value ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'To Location',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  onSaved: (value) => _movementData['toLocation'] = value ?? '',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveMovement,
                  style: ElevatedButton.styleFrom(backgroundColor: WarehouseColors.primaryColor),
                  child: const Text('Save Movement', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveMovement() {
    _formKey.currentState?.save();
    
    widget.controller.movementsToday.value += 1;
    widget.controller.recentMovements.insert(0, {
      "title": "New Stock Movement",
      "details": "SKU-12345 • 10 units • Receiving → Shelf A1",
      "color": "green",
      "type": "in",
      "timestamp": DateTime.now()
    });
    
    Get.back();
    Get.snackbar(
      'Movement Recorded',
      'Stock movement has been successfully recorded',
      backgroundColor: WarehouseColors.primaryColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class SearchDialog extends StatefulWidget {
  final WarehouseController controller;

  const SearchDialog({super.key, required this.controller});

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Search'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search inventory, movements, or products...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) => searchQuery = value,
          ),
          const SizedBox(height: 16),
          const Text('Recent Searches:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: const Text('SKU-12345'), backgroundColor: WarehouseColors.primaryColor.withOpacity(0.1)),
              Chip(label: const Text('Section A'), backgroundColor: WarehouseColors.secondaryColor.withOpacity(0.1)),
              Chip(label: const Text('MOV-2020'), backgroundColor: WarehouseColors.accentColor.withOpacity(0.1)),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Get.back();
            if (searchQuery.isNotEmpty) {
              widget.controller.searchQuery.value = searchQuery;
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: WarehouseColors.primaryColor),
          child: const Text('Search', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class NotificationsDialog extends StatelessWidget {
  final WarehouseController controller;

  const NotificationsDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Notifications'),
      content: SizedBox(
        width: double.maxFinite,
        child: Obx(() {
          if (controller.lowStockAlerts.isEmpty) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.notifications_none, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text("No notifications available"),
              ],
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: controller.lowStockAlerts.length,
            itemBuilder: (context, index) {
              final alert = controller.lowStockAlerts[index];
              return _buildNotificationItem(
                alert["product"] ?? "Alert",
                alert["message"] ?? "",
                "Just now",
                _getAlertColor(alert["color"]),
              );
            },
          );
        }),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            DialogService.showFeatureDialog('All Notifications');
          },
          style: ElevatedButton.styleFrom(backgroundColor: WarehouseColors.primaryColor),
          child: const Text('View All', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildNotificationItem(String title, String message, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  message,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getAlertColor(String? colorString) {
    switch ((colorString ?? '').toLowerCase()) {
      case 'red': return WarehouseColors.errorColor;
      case 'orange': return WarehouseColors.warningColor;
      default: return WarehouseColors.warningColor;
    }
  }
}

class ProfileMenu extends StatelessWidget {
  final WarehouseController controller;

  const ProfileMenu({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: WarehouseColors.primaryColor,
              child: Text(
                'W',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Warehouse Manager',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Senior Manager • Yopougon, Côte d\'Ivoire',
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile Settings'),
              onTap: () => DialogService.showFeatureDialog('Profile Settings'),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification Preferences'),
              onTap: () => DialogService.showFeatureDialog('Notification Settings'),
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              onTap: () => DialogService.showFeatureDialog('Help & Support'),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: WarehouseColors.errorColor),
              title: const Text('Logout', style: TextStyle(color: WarehouseColors.errorColor)),
              onTap: DialogService.showLogoutDialog,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}