import 'package:flutter/material.dart';
import 'package:babi_industries/controllers/warehouse_controller.dart';
import 'package:babi_industries/theme/warehouse_colors.dart';
import 'package:babi_industries/utils/responsive_utils.dart';
import 'package:babi_industries/services/dialog_service.dart';
import 'kpi_card.dart';

class KpiGrid extends StatelessWidget {
  final WarehouseController controller;
  final bool isLargeScreen;
  final bool isTablet;

  const KpiGrid({
    super.key,
    required this.controller,
    required this.isLargeScreen,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildGrid(context),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Warehouse Overview",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton.icon(
          onPressed: () => DialogService.showFeatureDialog('Detailed Analytics'),
          icon: const Icon(Icons.analytics_outlined, size: 10),
          label: const Text("View "),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: _getCrossAxisCount(context),
      shrinkWrap: true,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.0,
      children: _buildKpiCards(),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    if (ResponsiveUtils.isDesktop(context)) return 4;
    if (ResponsiveUtils.isTablet(context)) return 3;
    return 2;
  }

  List<Widget> _buildKpiCards() {
    return [
      KpiCard(
        icon: Icons.inventory_2_outlined,
        title: "Total Inventory",
        value: controller.totalItems.value.toString(),
        subtitle: "${controller.totalValue.value} XOF",
        color: WarehouseColors.primaryColor,
        onTap: () => controller.navigateToInventory(),
      ),
      KpiCard(
        icon: Icons.swap_horiz_outlined,
        title: "Movements Today",
        value: controller.movementsToday.value.toString(),
        subtitle: "${controller.recentMovements.length} total",
        color: WarehouseColors.warningColor,
        onTap: () => DialogService.showFeatureDialog('Movement History'),
      ),
      KpiCard(
        icon: Icons.qr_code_scanner_outlined,
        title: "Scans Today",
        value: controller.scansToday.value.toString(),
        subtitle: "${controller.scanAccuracy.value}% accuracy",
        color: WarehouseColors.infoColor,
        onTap: () => DialogService.showFeatureDialog('Scan History'),
      ),
      KpiCard(
        icon: Icons.check_circle_outline,
        title: "Items to Expire",
        value: controller.itemsToExpire.value.toString(),
        subtitle: "This month",
        color: WarehouseColors.accentColor,
        onTap: () => DialogService.showFeatureDialog('Expiring Items'),
      ),
      KpiCard(
        icon: Icons.warning_amber_outlined,
        title: "Critical Stock",
        value: controller.criticalStock.value.toString(),
        subtitle: "Needs attention",
        color: WarehouseColors.errorColor,
        onTap: () => controller.navigateToCriticalStock(),
      ),
      KpiCard(
        icon: Icons.trending_up_outlined,
        title: "Inventory Accuracy",
        value: "${controller.inventoryAccuracy.value}%",
        subtitle: "Target: 98%",
        color: WarehouseColors.purpleColor,
        onTap: () => DialogService.showFeatureDialog('Accuracy Metrics'),
      ),
      KpiCard(
        icon: Icons.local_shipping_outlined,
        title: "Picking Efficiency",
        value: "${controller.pickingEfficiency.value}%",
        subtitle: "Weekly average",
        color: WarehouseColors.secondaryColor,
        onTap: () => DialogService.showFeatureDialog('Efficiency Metrics'),
      ),
      KpiCard(
        icon: Icons.outbox_outlined,
        title: "Low Stock Alerts",
        value: controller.lowStockAlerts.length.toString(),
        subtitle: "Action needed",
        color: WarehouseColors.errorColor,
        onTap: () => DialogService.showFeatureDialog('Low Stock Alerts'),
      ),
    ];
  }
}