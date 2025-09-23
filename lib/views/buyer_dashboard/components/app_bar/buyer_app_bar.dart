import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/theme/app_colors.dart';
import 'package:babi_industries/controllers/buyer_dashboard_controller.dart';
import 'package:babi_industries/views/buyer_dashboard/utils/dialog_utils.dart';

class BuyerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuyerDashboardController controller;
  final bool isMobile;

  const BuyerAppBar({
    Key? key,
    required this.controller,
    required this.isMobile,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(isMobile ? 56 : 64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.kPrimaryColor,
      elevation: 0,
      titleSpacing: isMobile ? 8 : 16,
      title: isMobile ? _buildMobileAppBarTitle() : _buildDesktopAppBarTitle(),
      actions: _buildResponsiveAppBarActions(),
    );
  }

  Widget _buildMobileAppBarTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Buyer Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          'Procurement Management',
          style: TextStyle(
            fontSize: 10,
            color: Colors.white70,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDesktopAppBarTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.shopping_bag, size: 20, color: Colors.white),
        ),
        const SizedBox(width: 12),
        const Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buyer Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Buyer • Procurement Management',
                style: TextStyle(
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

  List<Widget> _buildResponsiveAppBarActions() {
    return [
      Obx(() => Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => DialogUtils.showNotifications(controller),
          ),
          if (controller.urgentIssues.value > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: AppColors.kErrorColor,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  controller.urgentIssues.value.toString(),
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 10, 
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      )),
      IconButton(
        icon: const Icon(Icons.search, color: Colors.white),
        onPressed: () => DialogUtils.showSearchDialog(controller),
      ),
      if (!isMobile)
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: () => DialogUtils.showProfileMenu(controller),
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'B',
                style: TextStyle(color: AppColors.kPrimaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
    ];
  }
}