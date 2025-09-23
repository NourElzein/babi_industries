import 'package:flutter/material.dart';
import 'package:babi_industries/controllers/warehouse_controller.dart';
import 'package:babi_industries/theme/warehouse_colors.dart';

class PerformanceMetrics extends StatelessWidget {
  final WarehouseController controller;

  const PerformanceMetrics({super.key, required this.controller});

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
            const Text(
              "Performance Metrics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMetricItem(
              "Scan Accuracy",
              "${controller.scanAccuracy.value}%",
              controller.scanAccuracy.value >= 95 ? WarehouseColors.accentColor : WarehouseColors.warningColor,
            ),
            const SizedBox(height: 12),
            _buildMetricItem(
              "Inventory Accuracy",
              "${controller.inventoryAccuracy.value}%",
              controller.inventoryAccuracy.value >= 95 ? WarehouseColors.accentColor : WarehouseColors.warningColor,
            ),
            const SizedBox(height: 12),
            _buildMetricItem(
              "Picking Efficiency",
              "${controller.pickingEfficiency.value}%",
              controller.pickingEfficiency.value >= 85 ? WarehouseColors.accentColor : WarehouseColors.warningColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String title, String value, Color color) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}