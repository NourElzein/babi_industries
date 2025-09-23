import 'package:flutter/material.dart';
import 'package:babi_industries/theme/app_colors.dart';

class KpiGrid extends StatelessWidget {
  final int totalOrders;
  final int pendingOrders;
  final int inTransitOrders;
  final int deliveredOrders;
  final int activeSuppliers;
  final String avgDeliveryTime;
  final String deliveryTimeTrend;
  final String monthlySpend;
  final int urgentIssues;
  final int weeklyOrderCount;
  final Function()? onOrdersTap;
  final Function()? onPendingOrdersTap;
  final Function()? onShipmentsTap;
  final Function()? onDeliveredTap;
  final Function()? onSuppliersTap;
  final Function()? onDeliveryMetricsTap;
  final Function()? onSpendAnalysisTap;
  final Function()? onIssuesTap;
  final Function()? onViewDetailsTap;

  const KpiGrid({
    Key? key,
    required this.totalOrders,
    required this.pendingOrders,
    required this.inTransitOrders,
    required this.deliveredOrders,
    required this.activeSuppliers,
    required this.avgDeliveryTime,
    required this.deliveryTimeTrend,
    required this.monthlySpend,
    required this.urgentIssues,
    required this.weeklyOrderCount,
    this.onOrdersTap,
    this.onPendingOrdersTap,
    this.onShipmentsTap,
    this.onDeliveredTap,
    this.onSuppliersTap,
    this.onDeliveryMetricsTap,
    this.onSpendAnalysisTap,
    this.onIssuesTap,
    this.onViewDetailsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
        double childAspectRatio = _getChildAspectRatio(constraints.maxWidth);

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
                  onPressed: onViewDetailsTap,
                  icon: const Icon(Icons.analytics_outlined, size: 16),
                  label: const Text("View Details"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: childAspectRatio,
              children: _buildKpiCards(context),
            ),
          ],
        );
      },
    );
  }

  int _getCrossAxisCount(double width) {
    if (width < 400) return 2;
    if (width < 768) return 3;
    if (width < 1024) return 4;
    return 4;
  }

  double _getChildAspectRatio(double width) {
    if (width < 400) return 1.1;
    if (width < 768) return 1.0;
    if (width < 1024) return 0.9;
    return 1.0;
  }

  List<Widget> _buildKpiCards(BuildContext context) {
    final cards = [
      _buildAdvancedKpiCard(
        Icons.shopping_cart_outlined,
        "Total Orders",
        totalOrders.toString(),
        "+$weeklyOrderCount this week",
        AppColors.kPrimaryColor,
        onTap: onOrdersTap,
      ),
      _buildAdvancedKpiCard(
        Icons.pending_actions_outlined,
        "Pending Orders",
        pendingOrders.toString(),
        "$urgentIssues urgent",
        AppColors.kWarningColor,
        onTap: onPendingOrdersTap,
      ),
      _buildAdvancedKpiCard(
        Icons.local_shipping_outlined,
        "In Transit",
        inTransitOrders.toString(),
        "On schedule",
        AppColors.kInfoColor,
        onTap: onShipmentsTap,
      ),
      _buildAdvancedKpiCard(
        Icons.check_circle_outline,
        "Delivered",
        deliveredOrders.toString(),
        "This month",
        AppColors.kAccentColor,
        onTap: onDeliveredTap,
      ),
      _buildAdvancedKpiCard(
        Icons.business_outlined,
        "Active Suppliers",
        activeSuppliers.toString(),
        "3 new this month",
        AppColors.kSecondaryColor,
        onTap: onSuppliersTap,
      ),
      _buildAdvancedKpiCard(
        Icons.trending_up_outlined,
        "Avg Delivery",
        avgDeliveryTime,
        deliveryTimeTrend,
        AppColors.kPurpleColor,
        onTap: onDeliveryMetricsTap,
      ),
      _buildAdvancedKpiCard(
        Icons.monetization_on_outlined,
        "Monthly Spend",
        monthlySpend,
        "Within budget",
        AppColors.kAccentColor,
        onTap: onSpendAnalysisTap,
      ),
      _buildAdvancedKpiCard(
        Icons.warning_amber_outlined,
        "Issues",
        urgentIssues.toString(),
        "Need attention",
        AppColors.kErrorColor,
        onTap: onIssuesTap,
      ),
    ];

    return cards;
  }

  Widget _buildAdvancedKpiCard(
    IconData icon,
    String title,
    String value,
    String subtitle,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.kCardRadius)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.kCardRadius),
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
}