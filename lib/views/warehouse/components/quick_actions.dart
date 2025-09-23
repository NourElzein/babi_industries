import 'package:flutter/material.dart';
import 'package:babi_industries/controllers/warehouse_controller.dart';
import 'package:babi_industries/theme/warehouse_colors.dart';
import 'package:babi_industries/services/dialog_service.dart';

class QuickActions extends StatelessWidget {
  final WarehouseController controller;

  const QuickActions({super.key, required this.controller});

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
            _buildActionGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.flash_on, color: WarehouseColors.primaryColor),
        const SizedBox(width: 8),
        const Text(
          "Quick Actions",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => DialogService.showFeatureDialog('All Quick Actions'),
          child: const Text("More", style: TextStyle(color: WarehouseColors.primaryColor)),
        ),
      ],
    );
  }

  Widget _buildActionGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      children: [
        _buildQuickActionItem(
          Icons.qr_code_scanner,
          "Scan Item",
          WarehouseColors.primaryColor,
          () => DialogService.showQRScannerDialog(controller),
        ),
        _buildQuickActionItem(
          Icons.swap_horiz,
          "New Movement",
          WarehouseColors.secondaryColor,
          () => DialogService.showMovementDialog(controller),
        ),
        _buildQuickActionItem(
          Icons.inventory,
          "Check Stock",
          WarehouseColors.infoColor,
          () => controller.navigateToInventory(),
        ),
        _buildQuickActionItem(
          Icons.local_shipping,
          "Receive Goods",
          WarehouseColors.purpleColor,
          () => DialogService.showFeatureDialog('Receive Goods'),
        ),
        _buildQuickActionItem(
          Icons.outbox,
          "Prepare Order",
          WarehouseColors.warningColor,
          () => DialogService.showFeatureDialog('Prepare Order'),
        ),
        _buildQuickActionItem(
          Icons.report,
          "Generate Report",
          WarehouseColors.accentColor,
          () => controller.navigateToReports(),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}