import 'package:babi_industries/controllers/buyer_dashboard_controller.dart';
import 'package:babi_industries/views/buyer_dashboard/buyer_dashboard_view.dart';
import 'package:babi_industries/views/buyer_dashboard/widgets/buyer_dashboard_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerDashboardComponents {
  static Widget buildWelcomeHeader(BuyerDashboardController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [BuyerDashboardView.kSecondaryColor, BuyerDashboardView.kAccentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(BuyerDashboardView.kCardRadius),
        boxShadow: [
          BoxShadow(
            color: BuyerDashboardView.kSecondaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 400;
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.person_outline, color: Colors.white, size: isSmall ? 24 : 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back, buyer!",
                      style: TextStyle(
                        fontSize: isSmall ? 16 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Ready to streamline your procurement process?",
                      style: TextStyle(fontSize: isSmall ? 12 : 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => Wrap(
                      spacing: isSmall ? 12 : 20,
                      children: [
                        _buildHeaderStat(controller.activeSuppliers.value.toString(), "Active Suppliers"),
                        _buildHeaderStat(controller.weeklyOrderCount.value.toString(), "Orders This Week"),
                      ],
                    )),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static Widget _buildHeaderStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  static Widget buildResponsiveKPIGrid(BuyerDashboardController controller, bool isTablet) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        double childAspectRatio = 1.0;
        
        if (constraints.maxWidth < 400) {
          crossAxisCount = 2;
          childAspectRatio = 1.1;
        } else if (constraints.maxWidth < 768) {
          crossAxisCount = 3;
          childAspectRatio = 1.0;
        } else if (constraints.maxWidth < 1024) {
          crossAxisCount = 4;
          childAspectRatio = 0.9;
        } else {
          crossAxisCount = 4;
          childAspectRatio = 1.0;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Text(
                    "Procurement Overview",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => BuyerDashboardDialogs.showFeatureDialog("Detailed Analytics"),
                  icon: const Icon(Icons.analytics_outlined, size: 16),
                  label: const Text("View Details"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: childAspectRatio,
              children: [
                _buildAdvancedKpiCard(
                  Icons.shopping_cart_outlined,
                  "Total Orders",
                  controller.totalOrders.value.toString(),
                  "+${controller.weeklyOrderCount.value} this week",
                  BuyerDashboardView.kPrimaryColor,
                  onTap: () => controller.navigateToOrders(),
                ),
                _buildAdvancedKpiCard(
                  Icons.pending_actions_outlined,
                  "Pending Orders",
                  controller.pendingOrders.value.toString(),
                  "${controller.urgentIssues.value} urgent",
                  BuyerDashboardView.kWarningColor,
                  onTap: () => BuyerDashboardDialogs.showFeatureDialog("Pending Orders"),
                ),
                _buildAdvancedKpiCard(
                  Icons.local_shipping_outlined,
                  "In Transit",
                  controller.inTransitOrders.value.toString(),
                  "On schedule",
                  BuyerDashboardView.kInfoColor,
                  onTap: () => BuyerDashboardDialogs.showFeatureDialog("Shipment Tracking"),
                ),
                _buildAdvancedKpiCard(
                  Icons.check_circle_outline,
                  "Delivered",
                  controller.deliveredOrders.value.toString(),
                  "This month",
                  BuyerDashboardView.kAccentColor,
                  onTap: () => BuyerDashboardDialogs.showFeatureDialog("Delivered Orders"),
                ),
                if (crossAxisCount >= 4) ...[
                  _buildAdvancedKpiCard(
                    Icons.business_outlined,
                    "Active Suppliers",
                    controller.activeSuppliers.value.toString(),
                    "3 new this month",
                    BuyerDashboardView.kSecondaryColor,
                    onTap: () => controller.navigateToSuppliers(),
                  ),
                  _buildAdvancedKpiCard(
                    Icons.trending_up_outlined,
                    "Avg Delivery",
                    controller.avgDeliveryTime.value,
                    controller.deliveryTimeTrend.value,
                    BuyerDashboardView.kPurpleColor,
                    onTap: () => BuyerDashboardDialogs.showFeatureDialog("Delivery Analytics"),
                  ),
                  _buildAdvancedKpiCard(
                    Icons.monetization_on_outlined,
                    "Monthly Spend",
                    controller.monthlySpend.value,
                    "Within budget",
                    BuyerDashboardView.kAccentColor,
                    onTap: () => BuyerDashboardDialogs.showFeatureDialog("Spend Analysis"),
                  ),
                  _buildAdvancedKpiCard(
                    Icons.warning_amber_outlined,
                    "Issues",
                    controller.urgentIssues.value.toString(),
                    "Need attention",
                    BuyerDashboardView.kErrorColor,
                    onTap: () => BuyerDashboardDialogs.showFeatureDialog("Issues & Alerts"),
                  ),
                ],
              ],
            )),
          ],
        );
      },
    );
  }

  static Widget _buildAdvancedKpiCard(
    IconData icon,
    String title,
    String value,
    String subtitle,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BuyerDashboardView.kCardRadius)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(BuyerDashboardView.kCardRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 120;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(isSmall ? 8 : 10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: color, size: isSmall ? 16 : 20),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey.shade400),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: isSmall ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: isSmall ? 10 : 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: color,
                        fontSize: isSmall ? 8 : 10,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  static Widget buildQuickActions(BuyerDashboardController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BuyerDashboardView.kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flash_on, color: BuyerDashboardView.kPrimaryColor),
                const SizedBox(width: 8),
                const Flexible(
                  child: Text(
                    "Quick Actions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => BuyerDashboardDialogs.showFeatureDialog("All Quick Actions"),
                  child: const Text("More", style: TextStyle(color: BuyerDashboardView.kPrimaryColor)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 3;
                if (constraints.maxWidth < 400) {
                  crossAxisCount = 2;
                } else if (constraints.maxWidth < 600) {
                  crossAxisCount = 3;
                } else {
                  crossAxisCount = 4;
                }
                
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.2,
                  children: [
                    _buildQuickActionItem(
                      Icons.add_shopping_cart,
                      "Create Order",
                      BuyerDashboardView.kPrimaryColor,
                      () => BuyerDashboardDialogs.showQuickOrderDialog(controller),
                    ),
                    _buildQuickActionItem(
                      Icons.content_copy,
                      "Duplicate Order",
                      BuyerDashboardView.kSecondaryColor,
                      () => BuyerDashboardDialogs.showFeatureDialog("Duplicate Order"),
                    ),
                    _buildQuickActionItem(
                      Icons.business_center,
                      "Find Suppliers",
                      BuyerDashboardView.kInfoColor,
                      () => BuyerDashboardDialogs.showSearchDialog(controller),
                    ),
                    _buildQuickActionItem(
                      Icons.compare_arrows,
                      "Compare Prices",
                      BuyerDashboardView.kPurpleColor,
                      () => controller.navigateToPriceComparison(),
                    ),
                    _buildQuickActionItem(
                      Icons.receipt_long,
                      "Generate Report",
                      BuyerDashboardView.kWarningColor,
                      () => controller.navigateToReports(),
                    ),
                    _buildQuickActionItem(
                      Icons.chat,
                      "Contact Supplier",
                      BuyerDashboardView.kAccentColor,
                      () => BuyerDashboardDialogs.showFeatureDialog("Contact Supplier"),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildQuickActionItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmall = constraints.maxWidth < 80;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: isSmall ? 20 : 24),
                SizedBox(height: isSmall ? 4 : 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: isSmall ? 9 : 11,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static Widget buildRecentOrders(BuyerDashboardController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BuyerDashboardView.kCardRadius)),
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => BuyerDashboardDialogs.showFeatureDialog("Order Filters"),
                      icon: const Icon(Icons.filter_list, size: 20),
                    ),
                    TextButton(
                      onPressed: () => controller.navigateToOrders(),
                      child: const Text("View All", style: TextStyle(color: BuyerDashboardView.kPrimaryColor)),
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
                    child: CircularProgressIndicator(color: BuyerDashboardView.kPrimaryColor),
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
                    onTap: () => BuyerDashboardDialogs.showFeatureDialog('Order Details'),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  static Widget _buildAdvancedOrderTile(
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
                      color: BuyerDashboardView.kPrimaryColor,
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

static Widget buildSupplierRecommendations(BuyerDashboardController controller) {
  return LayoutBuilder(
    builder: (context, constraints) {
      // Default to some responsive bounds
      final cardWidth = constraints.maxWidth > 0 ? constraints.maxWidth : 400.0;
      final cardHeight = constraints.maxHeight > 0 ? constraints.maxHeight : 400.0;

      return SizedBox(
        width: cardWidth,
        height: cardHeight.clamp(200.0, 500.0), // min/max bounds
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BuyerDashboardView.kCardRadius),
          ),
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
                        "Recommended Suppliers",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () => controller.navigateToSuppliers(),
                      child: const Text(
                        "Explore",
                        style: TextStyle(color: BuyerDashboardView.kPrimaryColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoadingSuppliers.value) {
                      return const Center(
                        child: CircularProgressIndicator(color: BuyerDashboardView.kPrimaryColor),
                      );
                    }

                    if (controller.suggestedSuppliers.isEmpty) {
                      return const Center(
                        child: Text("No supplier recommendations available"),
                      );
                    }

                    final itemCount = controller.suggestedSuppliers.length > 4
                        ? 4
                        : controller.suggestedSuppliers.length;

                    return ListView.separated(
                      physics: const ClampingScrollPhysics(),
                      itemCount: itemCount,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final supplier = controller.suggestedSuppliers[index];
                        return _buildSupplierRecommendationTile(
                          supplier.name,
                          supplier.category,
                          supplier.badge,
                          supplier.badgeColor,
                          supplier.performance,
                          supplier.totalOrders,
                          onTap: () => BuyerDashboardDialogs.showFeatureDialog('Supplier Details'),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

 
  static Widget _buildSupplierRecommendationTile(
    String name,
    String category,
    String badge,
    Color badgeColor,
    String performance,
    String orders, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      color: badgeColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$performance performance",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  orders,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildUrgentAlerts(BuyerDashboardController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BuyerDashboardView.kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber, color: BuyerDashboardView.kWarningColor),
                const SizedBox(width: 8),
                const Flexible(
                  child: Text(
                    "Urgent Alerts",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: BuyerDashboardView.kErrorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${controller.alerts.length} alerts",
                    style: const TextStyle(
                      color: BuyerDashboardView.kErrorColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.alerts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(Icons.check_circle, color: BuyerDashboardView.kAccentColor, size: 48),
                        SizedBox(height: 8),
                        Text("All systems running smoothly"),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.alerts.length > 3 ? 3 : controller.alerts.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final alert = controller.alerts[index];
                  return _buildAlertItem(
                    alert.icon,
                    alert.title,
                    alert.message,
                    alert.color,
                    onTap: () => BuyerDashboardDialogs.showFeatureDialog('Alert Details'),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  static Widget _buildAlertItem(IconData icon, String title, String subtitle, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  static Widget buildOrderTimeline(BuyerDashboardController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BuyerDashboardView.kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Timeline",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTimelineItem(
              "Order Placed",
              "ORD-2024 submitted to Supplier ABC",
              "2 hours ago",
              true,
              BuyerDashboardView.kAccentColor,
            ),
            _buildTimelineItem(
              "Order Confirmed",
              "Supplier confirmed delivery date",
              "1 hour ago",
              true,
              BuyerDashboardView.kAccentColor,
            ),
            _buildTimelineItem(
              "Processing",
              "Order is being prepared",
              "In progress",
              false,
              BuyerDashboardView.kWarningColor,
            ),
            _buildTimelineItem(
              "Shipping",
              "Expected to ship tomorrow",
              "Pending",
              false,
              Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildTimelineItem(
    String title,
    String subtitle,
    String time,
    bool completed,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: completed ? color : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: completed ? Colors.black87 : Colors.grey.shade600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildOrderStatusSummary(BuyerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BuyerDashboardView.kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Order Status Summary", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Obx(() => Row(
              children: [
                Expanded(child: _buildStatusChip("Pending", controller.pendingOrders.value.toString(), BuyerDashboardView.kWarningColor)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatusChip("In Transit", controller.inTransitOrders.value.toString(), BuyerDashboardView.kInfoColor)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatusChip("Delivered", controller.deliveredOrders.value.toString(), BuyerDashboardView.kAccentColor)),
              ],
            )),
          ],
        ),
      ),
    );
  }

  static Widget _buildStatusChip(String label, String value, Color color) {
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

  static Widget buildSupplierMetrics(BuyerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BuyerDashboardView.kCardRadius)),
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

  static Widget _buildMetricRow(String title, String value, IconData icon) {
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

  static Widget buildProcurementInsights(BuyerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BuyerDashboardView.kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Procurement Insights", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInsightItem("Cost Savings", "15% savings available with Supplier XYZ", BuyerDashboardView.kAccentColor),
            const SizedBox(height: 12),
            _buildInsightItem("Delivery Alert", "3 orders may be delayed this week", BuyerDashboardView.kWarningColor),
            const SizedBox(height: 12),
            _buildInsightItem("Best Price", "Office supplies - 20% below market rate", BuyerDashboardView.kInfoColor),
          ],
        ),
      ),
    );
  }

  static Widget _buildInsightItem(String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  static Color _getOrderStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return BuyerDashboardView.kWarningColor;
      case 'processing':
        return BuyerDashboardView.kInfoColor;
      case 'shipped':
      case 'in_transit':
        return BuyerDashboardView.kSecondaryColor;
      case 'delivered':
        return BuyerDashboardView.kAccentColor;
      case 'cancelled':
        return BuyerDashboardView.kErrorColor;
      default:
        return Colors.grey;
    }
  }
}