import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/logistics_dashboard_controller.dart';
import 'package:babi_industries/theme/logistics_theme.dart';
import 'app_bar_actions.dart';

class DesktopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final LogisticsDashboardController controller;

  const DesktopAppBar({super.key, required this.controller});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final user = controller.authController.currentUser.value;
    
    return AppBar(
      backgroundColor: LogisticsTheme.kPrimaryColor,
      elevation: 0,
      titleSpacing: 16,
      title: _buildDesktopAppBarTitle(user),
      actions: AppBarActions.buildResponsiveActions(controller, false),
    );
  }

  Widget _buildDesktopAppBarTitle(dynamic user) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.local_shipping, color: Colors.white, size: 28),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.name ?? "Logistics Coordinator",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Logistics Operations • ${user?.company ?? 'Babi Industries'}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}