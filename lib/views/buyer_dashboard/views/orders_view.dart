import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/theme/app_colors.dart';
import 'package:babi_industries/controllers/buyer_dashboard_controller.dart';
import 'package:babi_industries/views/buyer_dashboard/components/orders/recent_orders.dart';
import 'package:babi_industries/views/buyer_dashboard/utils/dialog_utils.dart';

class OrdersView extends StatelessWidget {
  final BuyerDashboardController controller;

  const OrdersView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      appBar: AppBar(
        title: const Text("Orders Management"),
        backgroundColor: AppColors.kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => DialogUtils.showFeatureDialog('Order Filters'),
          ),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () => DialogUtils.showQuickOrderDialog(controller),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildOrderStatusSummary(controller),
            const SizedBox(height: 16),
            Expanded(child: RecentOrders(controller: controller, showViewAll: false)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusSummary(BuyerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Order Status Summary", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Obx(() => Row(
              children: [
                Expanded(child: _buildStatusChip("Pending", controller.pendingOrders.value.toString(), AppColors.kWarningColor)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatusChip("In Transit", controller.inTransitOrders.value.toString(), AppColors.kInfoColor)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatusChip("Delivered", controller.deliveredOrders.value.toString(), AppColors.kAccentColor)),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}