import 'package:babi_industries/controllers/buyer_dashboard_controller.dart';
import 'package:babi_industries/views/buyer_dashboard/buyer_dashboard_view.dart';
import 'package:babi_industries/views/buyer_dashboard/widgets/buyer_dashboard_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerDashboardAppBar {
  static AppBar buildMobileAppBar(BuyerDashboardController controller) {
    return AppBar(
      backgroundColor: BuyerDashboardView.kPrimaryColor,
      elevation: 0,
      titleSpacing: 8,
      title: _buildMobileAppBarTitle(),
      actions: _buildMobileAppBarActions(controller),
    );
  }

  static AppBar buildDesktopAppBar(BuyerDashboardController controller) {
    return AppBar(
      backgroundColor: BuyerDashboardView.kPrimaryColor,
      elevation: 0,
      titleSpacing: 16,
      title: _buildDesktopAppBarTitle(),
      actions: _buildDesktopAppBarActions(controller),
    );
  }

  static Widget _buildMobileAppBarTitle() {
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

  static Widget _buildDesktopAppBarTitle() {
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

  static List<Widget> _buildMobileAppBarActions(BuyerDashboardController controller) {
    return [
      _buildNotificationBadge(controller),
      IconButton(
        icon: const Icon(Icons.search, color: Colors.white),
        onPressed: () => BuyerDashboardDialogs.showSearchDialog(controller),
      ),
    ];
  }

  static List<Widget> _buildDesktopAppBarActions(BuyerDashboardController controller) {
    return [
      _buildNotificationBadge(controller),
      IconButton(
        icon: const Icon(Icons.search, color: Colors.white),
        onPressed: () => BuyerDashboardDialogs.showSearchDialog(controller),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: GestureDetector(
          onTap: () => BuyerDashboardDialogs.showProfileMenu(controller),
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              'B',
              style: TextStyle(color: BuyerDashboardView.kPrimaryColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    ];
  }

  static Widget _buildNotificationBadge(BuyerDashboardController controller) {
    return Obx(() => Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () => BuyerDashboardDialogs.showNotifications(controller),
        ),
        if (controller.urgentIssues.value > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: BuyerDashboardView.kErrorColor,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                controller.urgentIssues.value.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    ));
  }
}