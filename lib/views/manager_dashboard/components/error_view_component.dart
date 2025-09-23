import 'package:babi_industries/controllers/manager_dashboard_controller.dart';
import 'package:babi_industries/views/dashboard/manager_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorViewComponent {
  static Widget buildErrorView(ManagerDashboardController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ManagerDashboardView.kPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: controller.fetchDashboardData,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(backgroundColor: ManagerDashboardView.kPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }
} 