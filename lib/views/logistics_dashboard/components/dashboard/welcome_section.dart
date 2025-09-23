import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/logistics_dashboard_controller.dart';
import 'package:babi_industries/theme/logistics_theme.dart';

class WelcomeSection extends StatelessWidget {
  final LogisticsDashboardController controller;

  const WelcomeSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final user = controller.authController.currentUser.value;
    
    return Container(
      padding: const EdgeInsets.all(LogisticsTheme.kPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [LogisticsTheme.kPrimaryColor, LogisticsTheme.kSecondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(LogisticsTheme.kCardRadius),
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
                      "Welcome, ${user?.name?.split(' ').first ?? 'Coordinator'}!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmall ? 18 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Your logistics operations overview for today",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: isSmall ? 12 : 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => Row(
                      children: [
                        _buildWelcomeMetric("Active", controller.activeShipments.value.toString()),
                        const SizedBox(width: 16),
                        _buildWelcomeMetric("In Transit", controller.inTransit.value.toString()),
                        const SizedBox(width: 16),
                        _buildWelcomeMetric("Delivered", controller.delivered.value.toString()),
                      ],
                    )),
                  ],
                ),
              ),
              if (constraints.maxWidth > 250)
                Column(
                  children: [
                    Icon(
                      Icons.local_shipping,
                      color: Colors.white.withOpacity(0.8),
                      size: isSmall ? 32 : 48,
                    ),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                      controller.lastUpdate.value,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 10,
                      ),
                    )),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWelcomeMetric(String title, String value) {
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