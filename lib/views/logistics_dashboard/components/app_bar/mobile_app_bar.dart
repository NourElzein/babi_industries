import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/logistics_dashboard_controller.dart';
import 'package:babi_industries/theme/logistics_theme.dart';
import 'app_bar_actions.dart';

class MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final LogisticsDashboardController controller;

  const MobileAppBar({super.key, required this.controller});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final user = controller.authController.currentUser.value;
    
    return AppBar(
      backgroundColor: LogisticsTheme.kPrimaryColor,
      elevation: 0,
      titleSpacing: 8,
      title: _buildMobileAppBarTitle(user),
      actions: AppBarActions.buildResponsiveActions(controller, true),
    );
  }

  Widget _buildMobileAppBarTitle(dynamic user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          user?.name?.split(' ').first ?? "Coordinator",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const Text(
          'Logistics Dashboard',
          style: TextStyle(
            fontSize: 10,
            color: Colors.white70,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}