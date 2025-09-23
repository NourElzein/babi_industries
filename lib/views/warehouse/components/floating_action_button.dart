import 'package:flutter/material.dart';
import 'package:babi_industries/controllers/warehouse_controller.dart';
import 'package:babi_industries/theme/warehouse_colors.dart';
import 'package:babi_industries/services/dialog_service.dart';

class WarehouseFAB extends StatelessWidget {
  final WarehouseController controller;

  const WarehouseFAB({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => DialogService.showQRScannerDialog(controller),
      backgroundColor: WarehouseColors.primaryColor,
      icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
      label: const Text(
        'Quick Scan',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}