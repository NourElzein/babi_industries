import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/warehouse_controller.dart';
import 'package:babi_industries/theme/warehouse_colors.dart';
import 'package:babi_industries/services/dialog_service.dart';

class LowStockAlerts extends StatelessWidget {
  final WarehouseController controller;

  const LowStockAlerts({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WarehouseColors.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildAlertsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Low Stock Alerts",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () => controller.navigateToCriticalStock(),
          child: const Text("View All", style: TextStyle(color: WarehouseColors.primaryColor)),
        ),
      ],
    );
  }

  Widget _buildAlertsList() {
    return Obx(() {
      if (controller.lowStockAlerts.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.check_circle, color: WarehouseColors.accentColor, size: 48),
                SizedBox(height: 8),
                Text("All stock levels are good"),
              ],
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.lowStockAlerts.length > 4 ? 4 : controller.lowStockAlerts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final alert = controller.lowStockAlerts[index];
          return _buildAlertItem(
            Icons.warning,
            alert["product"] ?? "Unknown Product",
            alert["message"] ?? "Low stock",
            _getAlertColor(alert["color"]),
            onTap: () => DialogService.showFeatureDialog('Alert Details'),
          );
        },
      );
    });
  }

  Widget _buildAlertItem(IconData icon, String title, String subtitle, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey.shade400),
          ],
        ),
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