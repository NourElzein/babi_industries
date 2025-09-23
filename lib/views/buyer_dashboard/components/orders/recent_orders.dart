import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/theme/app_colors.dart';
import 'package:babi_industries/controllers/buyer_dashboard_controller.dart';
import 'package:babi_industries/views/buyer_dashboard/utils/dialog_utils.dart';

class RecentOrders extends StatelessWidget {
  final BuyerDashboardController controller;
  final bool showViewAll;

  const RecentOrders({
    Key? key,
    required this.controller,
    this.showViewAll = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Text(
                    "Recent Orders",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showViewAll)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => DialogUtils.showFeatureDialog('Order Filters'),
                      icon: const Icon(Icons.filter_list, size: 20),
                    ),
                    TextButton(
                      onPressed: () => controller.navigateToOrders(),
                      child: const Text("View All", style: TextStyle(color: AppColors.kPrimaryColor)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.isLoadingOrders.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: AppColors.kPrimaryColor),
                  ),
                );
              }

              if (controller.orders.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No recent orders found"),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.orders.length > 5 ? 5 : controller.orders.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final order = controller.orders[index];
                  return _buildAdvancedOrderTile(
                    order['order_id'] ?? 'ORD-000',
                    "${order['items_count'] ?? 0} items",
                    order['status'] ?? 'unknown',
                    _getOrderStatusColor(order['status']),
                    order['supplier_name'] ?? 'Unknown Supplier',
                    order['total_value'] ?? 'XOF 0',
                    order['created_at'] ?? 'Unknown',
                    onTap: () => DialogUtils.showFeatureDialog('Order Details'),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedOrderTile(
    String orderId,
    String items,
    String status,
    Color statusColor,
    String supplier,
    String amount,
    String date, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    orderId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.business, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    supplier,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  items,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    amount,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.kPrimaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey.shade400),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getOrderStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return AppColors.kWarningColor;
      case 'processing':
        return AppColors.kInfoColor;
      case 'shipped':
      case 'in_transit':
        return AppColors.kSecondaryColor;
      case 'delivered':
        return AppColors.kAccentColor;
      case 'cancelled':
        return AppColors.kErrorColor;
      default:
        return Colors.grey;
    }
  }
}