import 'package:babi_industries/controllers/BuyerDashboardController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerDashboardView extends StatelessWidget {
  const BuyerDashboardView({Key? key}) : super(key: key);

  // Color scheme for buyer dashboard
  static const kPrimaryColor = Color(0xFF2E7D32);
  static const kSecondaryColor = Color(0xFF4CAF50);
  static const kAccentColor = Color(0xFF66BB6A);
  static const kWarningColor = Color(0xFFFF9800);
  static const kErrorColor = Color(0xFFF44336);
  static const kInfoColor = Color(0xFF2196F3);
  static const kPurpleColor = Color(0xFF9C27B0);
  static const kBackgroundColor = Color(0xFFF5F7FA);
  static const kCardRadius = 16.0;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BuyerDashboardController());
    final Size size = MediaQuery.of(context).size;
    final bool isLargeScreen = size.width > 600;
    final bool isTablet = size.width >= 768 && size.width < 1024;
    final bool isMobile = size.width < 768;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: _buildAppBar(controller),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: kPrimaryColor),
                SizedBox(height: 16),
                Text('Loading procurement data...'),
              ],
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorView(controller);
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeHeader(controller),
              const SizedBox(height: 24),
              _buildKPIGrid(isLargeScreen, isTablet, controller),
              const SizedBox(height: 32),
              if (!isMobile) _buildTabletDesktopContent(controller) else _buildMobileContent(controller),
            ],
          ),
        );
      }),
      bottomNavigationBar: isMobile ? _buildBottomNavigation(controller) : null,
      floatingActionButton: _buildFloatingActionButton(controller),
    );
  }

  Widget _buildErrorView(BuyerDashboardController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
              onPressed: controller.refreshData,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuyerDashboardController controller) {
    return AppBar(
      title: Row(
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buyer Dashboard',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
              ),
              Text(
                'Moussa Traoré • Procurement',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: kPrimaryColor,
      elevation: 0,
      actions: [
        Obx(() => Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () => _showNotifications(controller),
            ),
            if (controller.urgentIssues.value > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: kErrorColor,
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
        )),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () => _showSearchDialog(controller),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: () => _showProfileMenu(controller),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'MT',
                style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeHeader(BuyerDashboardController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kSecondaryColor, kAccentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: [
          BoxShadow(
            color: kSecondaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(Icons.person_outline, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome back, Moussa!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Ready to streamline your procurement process?",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Obx(() => Row(
                  children: [
                    _buildHeaderStat(controller.activeSuppliers.value.toString(), "Active Suppliers"),
                    const SizedBox(width: 20),
                    _buildHeaderStat(controller.weeklyOrderCount.value.toString(), "Orders This Week"),
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String value, String label) {
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

  Widget _buildKPIGrid(bool isLargeScreen, bool isTablet, BuyerDashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Procurement Overview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => _showDetailedMetrics(controller),
              icon: const Icon(Icons.analytics_outlined, size: 16),
              label: const Text("View Analytics"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => GridView.count(
          crossAxisCount: isLargeScreen ? 4 : (isTablet ? 3 : 2),
          shrinkWrap: true,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.0,
          children: [
            _buildAdvancedKpiCard(
              Icons.shopping_cart_outlined,
              "Total Orders",
              controller.totalOrders.value.toString(),
              "+${controller.weeklyOrderCount.value} this week",
              kPrimaryColor,
              onTap: () => controller.navigateToOrders(),
            ),
            _buildAdvancedKpiCard(
              Icons.pending_actions_outlined,
              "Pending Orders",
              controller.pendingOrders.value.toString(),
              "${controller.urgentIssues.value} urgent",
              kWarningColor,
              onTap: () => _showPendingOrders(controller),
            ),
            _buildAdvancedKpiCard(
              Icons.local_shipping_outlined,
              "In Transit",
              controller.inTransitOrders.value.toString(),
              "On schedule",
              kInfoColor,
              onTap: () => _trackShipments(controller),
            ),
            _buildAdvancedKpiCard(
              Icons.check_circle_outline,
              "Delivered",
              controller.deliveredOrders.value.toString(),
              "This month",
              kAccentColor,
              onTap: () => _showDeliveredOrders(controller),
            ),
            _buildAdvancedKpiCard(
              Icons.business_outlined,
              "Active Suppliers",
              controller.activeSuppliers.value.toString(),
              "3 new this month",
              kSecondaryColor,
              onTap: () => controller.navigateToSuppliers(),
            ),
            _buildAdvancedKpiCard(
              Icons.trending_up_outlined,
              "Avg Delivery",
              controller.avgDeliveryTime.value,
              controller.deliveryTimeTrend.value,
              kPurpleColor,
              onTap: () => _showDeliveryMetrics(controller),
            ),
            _buildAdvancedKpiCard(
              Icons.monetization_on_outlined,
              "Monthly Spend",
              controller.monthlySpend.value,
              "Within budget",
              kAccentColor,
              onTap: () => _showSpendAnalysis(controller),
            ),
            _buildAdvancedKpiCard(
              Icons.warning_amber_outlined,
              "Issues",
              controller.urgentIssues.value.toString(),
              "Need attention",
              kErrorColor,
              onTap: () => _showIssues(controller),
            ),
          ],
        )),
      ],
    );
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kCardRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey.shade400),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
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
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileContent(BuyerDashboardController controller) {
    return Column(
      children: [
        _buildQuickActions(controller),
        const SizedBox(height: 24),
        _buildRecentOrders(controller),
        const SizedBox(height: 24),
        _buildSupplierRecommendations(controller),
        const SizedBox(height: 24),
        _buildUrgentAlerts(controller),
      ],
    );
  }

  Widget _buildTabletDesktopContent(BuyerDashboardController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildQuickActions(controller),
              const SizedBox(height: 24),
              _buildRecentOrders(controller),
              const SizedBox(height: 24),
              _buildOrderTimeline(controller),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildSupplierRecommendations(controller),
              const SizedBox(height: 24),
              _buildUrgentAlerts(controller),
              const SizedBox(height: 24),
              _buildPerformanceInsights(controller),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuyerDashboardController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flash_on, color: kPrimaryColor),
                const SizedBox(width: 8),
                const Text(
                  "Quick Actions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _showAllActions(controller),
                  child: const Text("More", style: TextStyle(color: kPrimaryColor)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              children: [
                _buildQuickActionItem(
                  Icons.add_shopping_cart,
                  "Create Order",
                  kPrimaryColor,
                  () => _createNewOrder(controller),
                ),
                _buildQuickActionItem(
                  Icons.content_copy,
                  "Duplicate Order",
                  kSecondaryColor,
                  () => _duplicateOrder(controller),
                ),
                _buildQuickActionItem(
                  Icons.business_center,
                  "Find Suppliers",
                  kInfoColor,
                  () => _searchSuppliers(controller),
                ),
                _buildQuickActionItem(
                  Icons.compare_arrows,
                  "Compare Prices",
                  kPurpleColor,
                  () => controller.navigateToPriceComparison(),
                ),
                _buildQuickActionItem(
                  Icons.receipt_long,
                  "Generate Report",
                  kWarningColor,
                  () => controller.navigateToReports(),
                ),
                _buildQuickActionItem(
                  Icons.chat,
                  "Contact Supplier",
                  kAccentColor,
                  () => _contactSupplier(controller),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrders(BuyerDashboardController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _filterOrders(controller),
                      icon: const Icon(Icons.filter_list, size: 20),
                    ),
                    TextButton(
                      onPressed: () => controller.navigateToOrders(),
                      child: const Text("View All", style: TextStyle(color: kPrimaryColor)),
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
                    child: CircularProgressIndicator(color: kPrimaryColor),
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
                    onTap: () => _showOrderDetails(order),
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
                Text(
                  orderId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
                Text(
                  amount,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: kPrimaryColor,
                  ),
                ),
                Row(
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

  Widget _buildSupplierRecommendations(BuyerDashboardController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recommended Suppliers",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => controller.navigateToSuppliers(),
                  child: const Text("Explore", style: TextStyle(color: kPrimaryColor)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.isLoadingSuppliers.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: kPrimaryColor),
                  ),
                );
              }

              if (controller.suggestedSuppliers.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No supplier recommendations available"),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.suggestedSuppliers.length > 4 ? 4 : controller.suggestedSuppliers.length,
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
                    onTap: () => _showSupplierDetails(supplier),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierRecommendationTile(
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

  Widget _buildUrgentAlerts(BuyerDashboardController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber, color: kWarningColor),
                const SizedBox(width: 8),
                const Text(
                  "Urgent Alerts",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: kErrorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${controller.alerts.length} alerts",
                    style: const TextStyle(
                      color: kErrorColor,
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
                        Icon(Icons.check_circle, color: kAccentColor, size: 48),
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
                    onTap: () => _showAlertDetails(alert),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(IconData icon, String title, String subtitle, Color color, {VoidCallback? onTap}) {
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
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
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

  Widget _buildOrderTimeline(BuyerDashboardController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
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
              kAccentColor,
            ),
            _buildTimelineItem(
              "Order Confirmed",
              "Supplier confirmed delivery date",
              "1 hour ago",
              true,
              kAccentColor,
            ),
            _buildTimelineItem(
              "Processing",
              "Order is being prepared",
              "In progress",
              false,
              kWarningColor,
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

  Widget _buildTimelineItem(
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

  Widget _buildPerformanceInsights(BuyerDashboardController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Performance Insights",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(() => Column(
              children: controller.insights.map((insight) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildInsightItem(
                    insight.icon,
                    insight.title,
                    insight.description,
                    insight.color,
                  ),
                );
              }).toList(),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(IconData icon, String title, String subtitle, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
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
      ],
    );
  }

  Widget _buildBottomNavigation(BuyerDashboardController controller) {
    return Obx(() => BottomNavigationBar(
      currentIndex: controller.selectedBottomNavIndex.value,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: kPrimaryColor,
      unselectedItemColor: Colors.grey.shade600,
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 10,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
          label: "Orders",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business_outlined),
          activeIcon: Icon(Icons.business),
          label: "Suppliers",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.compare_arrows_outlined),
          activeIcon: Icon(Icons.compare_arrows),
          label: "Compare",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
      onTap: (index) {
        controller.selectedBottomNavIndex.value = index;
        _handleBottomNavTap(index, controller);
      },
    ));
  }

  Widget _buildFloatingActionButton(BuyerDashboardController controller) {
    return FloatingActionButton.extended(
      onPressed: () => _showQuickOrderDialog(controller),
      backgroundColor: kPrimaryColor,
      icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
      label: const Text(
        'Quick Order',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Helper methods
  Color _getOrderStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return kWarningColor;
      case 'processing':
        return kInfoColor;
      case 'shipped':
      case 'in_transit':
        return kSecondaryColor;
      case 'delivered':
        return kAccentColor;
      case 'cancelled':
        return kErrorColor;
      default:
        return Colors.grey;
    }
  }

  // Action handlers
  void _handleBottomNavTap(int index, BuyerDashboardController controller) {
    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        controller.navigateToOrders();
        break;
      case 2:
        controller.navigateToSuppliers();
        break;
      case 3:
        controller.navigateToPriceComparison();
        break;
      case 4:
        _showProfileMenu(controller);
        break;
    }
  }

  void _showNotifications(BuyerDashboardController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Notifications'),
        content: SizedBox(
          width: double.maxFinite,
          child: Obx(() {
            if (controller.notifications.isEmpty) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_none, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("No notifications available"),
                ],
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                final notification = controller.notifications[index];
                return _buildNotificationItem(
                  notification['title'] ?? '',
                  notification['message'] ?? '',
                  notification['time'] ?? '',
                  _getNotificationColor(notification['color']),
                );
              },
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _showFeatureDialog('All Notifications');
            },
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            child: const Text('View All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String message, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
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
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  message,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getNotificationColor(String? colorString) {
    switch ((colorString ?? '').toLowerCase()) {
      case 'error':
      case 'red':
        return kErrorColor;
      case 'warning':
      case 'orange':
        return kWarningColor;
      case 'accent':
      case 'green':
        return kAccentColor;
      case 'secondary':
      case 'blue':
        return kSecondaryColor;
      default:
        return kPrimaryColor;
    }
  }

  void _showSearchDialog(BuyerDashboardController controller) {
    String searchQuery = '';
    Get.dialog(
      AlertDialog(
        title: const Text('Search'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search orders, suppliers, or products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => searchQuery = value,
            ),
            const SizedBox(height: 16),
            const Text('Recent Searches:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('ABC Corp'), backgroundColor: kPrimaryColor.withOpacity(0.1)),
                Chip(label: Text('Office supplies'), backgroundColor: kSecondaryColor.withOpacity(0.1)),
                Chip(label: Text('ORD-2020'), backgroundColor: kAccentColor.withOpacity(0.1)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              if (searchQuery.isNotEmpty) {
                controller.searchSuppliers(searchQuery);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            child: const Text('Search', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showQuickOrderDialog(BuyerDashboardController controller) {
    final formKey = GlobalKey<FormState>();
    String selectedSupplier = '';
    String product = '';
    String quantity = '';
    String expectedPrice = '';

    Get.dialog(
      AlertDialog(
        title: const Text('Quick Order'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create a new order quickly:'),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Supplier',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                items: ['ABC Corp', 'XYZ Ltd', 'Global Foods', 'FreshMart']
                    .map((supplier) => DropdownMenuItem(value: supplier, child: Text(supplier)))
                    .toList(),
                onChanged: (value) => selectedSupplier = value ?? '',
                validator: (value) => value == null || value.isEmpty ? 'Please select a supplier' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Product/Service',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (value) => product = value,
                validator: (value) => value == null || value.isEmpty ? 'Please enter product' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => quantity = value,
                      validator: (value) => value == null || value.isEmpty ? 'Enter quantity' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Expected Price',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => expectedPrice = value,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Get.back();
                controller.createQuickOrder({
                  'supplier': selectedSupplier,
                  'product': product,
                  'quantity': quantity,
                  'expected_price': expectedPrice,
                });
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            child: const Text('Create Order', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showProfileMenu(BuyerDashboardController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: kPrimaryColor,
              child: Text('MT', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Moussa Traoré',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Senior Buyer • Yopougon, Côte d\'Ivoire',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile Settings'),
              onTap: () => _showFeatureDialog('Profile Settings'),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification Preferences'),
              onTap: () => _showFeatureDialog('Notification Settings'),
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              onTap: () => _showFeatureDialog('Help & Support'),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: kErrorColor),
              title: const Text('Logout', style: TextStyle(color: kErrorColor)),
              onTap: () => _showLogoutDialog(controller),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuyerDashboardController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout from your account?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.back();
              // Handle logout logic here
              Get.snackbar('Logged Out', 'You have been logged out successfully');
            },
            style: ElevatedButton.styleFrom(backgroundColor: kErrorColor),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showFeatureDialog(String feature) {
    Get.dialog(
      AlertDialog(
        title: Text(feature),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction, size: 48, color: Colors.orange.shade400),
            const SizedBox(height: 16),
            Text(
              '$feature is currently under development and will be available soon.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Feature method stubs with controller integration
  void _createNewOrder(BuyerDashboardController controller) => _showQuickOrderDialog(controller);
  void _duplicateOrder(BuyerDashboardController controller) => _showFeatureDialog('Duplicate Order');
  void _searchSuppliers(BuyerDashboardController controller) => _showSearchDialog(controller);
  void _contactSupplier(BuyerDashboardController controller) => _showFeatureDialog('Contact Supplier');
  void _showDetailedMetrics(BuyerDashboardController controller) => _showFeatureDialog('Detailed Analytics');
  void _showPendingOrders(BuyerDashboardController controller) => _showFeatureDialog('Pending Orders');
  void _trackShipments(BuyerDashboardController controller) => _showFeatureDialog('Shipment Tracking');
  void _showDeliveredOrders(BuyerDashboardController controller) => _showFeatureDialog('Delivered Orders');
  void _showDeliveryMetrics(BuyerDashboardController controller) => _showFeatureDialog('Delivery Analytics');
  void _showSpendAnalysis(BuyerDashboardController controller) => _showFeatureDialog('Spend Analysis');
  void _showIssues(BuyerDashboardController controller) => _showFeatureDialog('Issues & Alerts');
  void _showAllActions(BuyerDashboardController controller) => _showFeatureDialog('All Quick Actions');
  void _filterOrders(BuyerDashboardController controller) => _showFeatureDialog('Order Filters');
  void _showOrderDetails(Map<String, dynamic> order) => _showFeatureDialog('Order Details');
  void _showSupplierDetails(SupplierRecommendation supplier) => _showFeatureDialog('Supplier Details');
  void _showAlertDetails(BuyerAlert alert) => _showFeatureDialog('Alert Details');
}