import 'package:babi_industries/controllers/manager_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/views/dashboard/manager_dashboard_view.dart';


class WelcomeSectionComponent {
  static Widget buildWelcomeSection(ManagerDashboardController controller) {
    final user = controller.authController.currentUser.value;
    
    return Container(
      padding: const EdgeInsets.all(ManagerDashboardView.kPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ManagerDashboardView.kPrimaryColor, ManagerDashboardView.kSecondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ManagerDashboardView.kCardRadius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 300;
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back, ${user?.name?.split(' ').first ?? 'Manager'}!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmall ? 18 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Here's your supply chain overview for ${user?.company ?? 'your company'}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: isSmall ? 12 : 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildWelcomeMetric("Active Suppliers", controller.totalSuppliers.value.toString()),
                        const SizedBox(width: 16),
                        _buildWelcomeMetric("Pending Orders", controller.pendingOrders.value.toString()),
                      ],
                    ),
                  ],
                ),
              ),
              if (constraints.maxWidth > 250)
                Column(
                  children: [
                    Icon(
                      Icons.business_center,
                      color: Colors.white.withOpacity(0.8),
                      size: isSmall ? 32 : 48,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  static Widget _buildWelcomeMetric(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}