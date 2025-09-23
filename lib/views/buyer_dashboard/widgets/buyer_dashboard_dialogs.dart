import 'package:babi_industries/controllers/buyer_dashboard_controller.dart';
import 'package:babi_industries/routes/app_routes.dart';
import 'package:babi_industries/views/buyer_dashboard/buyer_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerDashboardDialogs {
  static void showNotifications(BuyerDashboardController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Notifications'),
        content: SizedBox(
          width: double.maxFinite,
          child: Obx(() {
            if (controller.notifications.isEmpty) {
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
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                final notification = controller.notifications[index];
                return _buildNotificationItem(
                  notification.title ?? 'Notification',
                  notification.message ?? '',
                  notification.time ?? '',
                  _getNotificationColor(notification.color as String?),
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
              showFeatureDialog('All Notifications');
            },
            style: ElevatedButton.styleFrom(backgroundColor: BuyerDashboardView.kPrimaryColor),
            child: const Text('View All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  static Widget _buildNotificationItem(String title, String message, String time, Color color) {
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

  static Color _getNotificationColor(String? colorString) {
    switch ((colorString ?? '').toLowerCase()) {
      case 'error':
      case 'red':
        return BuyerDashboardView.kErrorColor;
      case 'warning':
      case 'orange':
        return BuyerDashboardView.kWarningColor;
      case 'accent':
      case 'green':
        return BuyerDashboardView.kAccentColor;
      case 'secondary':
      case 'blue':
        return BuyerDashboardView.kSecondaryColor;
      default:
        return BuyerDashboardView.kPrimaryColor;
    }
  }

  static void showSearchDialog(BuyerDashboardController controller) {
    String searchQuery = '';
    Get.dialog(
      AlertDialog(
        title: const Text('Search'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search orders, suppliers, or products...',
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
                Chip(label: const Text('ABC Corp'), backgroundColor: BuyerDashboardView.kPrimaryColor.withOpacity(0.1)),
                Chip(label: const Text('Office supplies'), backgroundColor: BuyerDashboardView.kSecondaryColor.withOpacity(0.1)),
                Chip(label: const Text('ORD-2020'), backgroundColor: BuyerDashboardView.kAccentColor.withOpacity(0.1)),
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
                controller.searchSuppliers(searchQuery);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: BuyerDashboardView.kPrimaryColor),
            child: const Text('Search', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  static void showQuickOrderDialog(BuyerDashboardController controller) {
    final formKey = GlobalKey<FormState>();
    String selectedSupplier = '';
    String product = '';
    String quantity = '';
    String expectedPrice = '';

    Get.dialog(
      AlertDialog(
        title: const Text('Quick Order'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create a new order quickly:'),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Supplier',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                items: ['ABC Corp', 'XYZ Ltd', 'Global Foods', 'FreshMart']
                    .map((supplier) => DropdownMenuItem(value: supplier, child: Text(supplier)))
                    .toList(),
                onChanged: (value) => selectedSupplier = value ?? '',
                validator: (value) => value == null || value.isEmpty ? 'Please select a supplier' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Product/Service',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (value) => product = value,
                validator: (value) => value == null || value.isEmpty ? 'Please enter product' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => quantity = value,
                      validator: (value) => value == null || value.isEmpty ? 'Enter quantity' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Expected Price',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => expectedPrice = value,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Get.back();
                controller.createQuickOrder({
                  'supplier': selectedSupplier,
                  'product': product,
                  'quantity': quantity,
                  'expected_price': expectedPrice,
                });
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: BuyerDashboardView.kPrimaryColor),
            child: const Text('Create Order', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  static void showProfileMenu(BuyerDashboardController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: BuyerDashboardView.kPrimaryColor,
              child: Text('B', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            const Text(
              'buyer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Senior Buyer • Yopougon, Côte d\'Ivoire',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile Settings'),
              onTap: () => showFeatureDialog('Profile Settings'),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification Preferences'),
              onTap: () => showFeatureDialog('Notification Settings'),
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              onTap: () => showFeatureDialog('Help & Support'),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: BuyerDashboardView.kErrorColor),
              title: const Text('Logout', style: TextStyle(color: BuyerDashboardView.kErrorColor)),
              onTap: () => showLogoutDialog(controller),
            ),
          ],
        ),
      ),
    );
  }

  static void showLogoutDialog(BuyerDashboardController controller) {
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
            style: ElevatedButton.styleFrom(backgroundColor: BuyerDashboardView.kErrorColor),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

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
            style: ElevatedButton.styleFrom(backgroundColor: BuyerDashboardView.kPrimaryColor),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}