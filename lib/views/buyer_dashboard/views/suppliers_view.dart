import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/theme/app_colors.dart';
import 'package:babi_industries/controllers/buyer_dashboard_controller.dart';
import 'package:babi_industries/views/buyer_dashboard/components/suppliers/supplier_recommendations.dart';
import 'package:babi_industries/views/buyer_dashboard/utils/dialog_utils.dart';

class SuppliersView extends StatelessWidget {
  final BuyerDashboardController controller;

  const SuppliersView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      appBar: AppBar(
        title: const Text("Suppliers"),
        backgroundColor: AppColors.kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => DialogUtils.showSearchDialog(controller),
          ),
          IconButton(
            icon: const Icon(Icons.add_business),
            onPressed: () => DialogUtils.showFeatureDialog("Add Supplier"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildSupplierMetrics(controller),
            const SizedBox(height: 11),
            Expanded(child: SupplierRecommendations(controller: controller, showExplore: false)),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierMetrics(BuyerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Supplier Metrics", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Obx(() => Column(
              children: [
                _buildMetricRow("Total Suppliers", controller.activeSuppliers.value.toString(), Icons.business),
                const SizedBox(height: 8),
                _buildMetricRow("Performance Score", "87%", Icons.trending_up),
                const SizedBox(height: 8),
                _buildMetricRow("Average Rating", "4.2/5", Icons.star),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontSize: 14)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}