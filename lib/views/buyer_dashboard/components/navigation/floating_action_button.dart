import 'package:flutter/material.dart';
import 'package:babi_industries/theme/app_colors.dart';
import 'package:babi_industries/views/buyer_dashboard/utils/dialog_utils.dart';
import 'package:babi_industries/controllers/buyer_dashboard_controller.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final BuyerDashboardController controller;

  const CustomFloatingActionButton({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => DialogUtils.showQuickOrderDialog(controller),
      backgroundColor: AppColors.kPrimaryColor,
      icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
      label: const Text(
        'Quick Order',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}