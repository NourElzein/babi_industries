import 'package:babi_industries/controllers/logistics_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogisticsDashboardView extends StatelessWidget {
  LogisticsDashboardView({super.key});

  // Color Scheme for Logistics
  static const kPrimaryColor = Color(0xFF2E7D32); // Green for logistics
  static const kSecondaryColor = Color(0xFF388E3C);
  static const kAccentColor = Color(0xFF4CAF50);
  static const kWarningColor = Color(0xFFFF9800);
  static const kErrorColor = Color(0xFFF44336);
  static const kInfoColor = Color(0xFF2196F3);
  static const kSuccessColor = Color(0xFF4CAF50);
  static const kBackgroundColor = Color(0xFFF8F9FA);
  static const kCardRadius = 12.0;
  static const kPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LogisticsDashboardController());
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isTablet = size.width >= 768 && size.width < 1024;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: _buildResponsiveAppBar(controller, isMobile),
      drawer: isMobile ? _buildMobileDrawer(controller) : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: kPrimaryColor),
                SizedBox(height: 16),
                Text('Loading logistics data...'),
              ],
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorView(controller);
        }

        return isMobile
            ? _buildMobileView(controller)
            : isTablet
                ? _buildTabletView(controller)
                : _buildDesktopView(controller);
      }),
      bottomNavigationBar: isMobile ? _buildMobileBottomNav(controller) : null,
      floatingActionButton: _buildFloatingActionButton(context, controller),
    );
  }

  AppBar _buildResponsiveAppBar(LogisticsDashboardController controller, bool isMobile) {
    final user = controller.authController.currentUser.value;
    
    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      titleSpacing: isMobile ? 8 : 16,
      title: isMobile 
          ? _buildMobileAppBarTitle(user)
          : _buildDesktopAppBarTitle(user),
      actions: _buildResponsiveAppBarActions(controller, isMobile),
    );
  }

  Widget _buildMobileAppBarTitle(dynamic user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          user?.name?.split(' ').first ?? "Coordinator",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const Text(
          'Logistics Dashboard',
          style: TextStyle(
            fontSize: 10,
            color: Colors.white70,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDesktopAppBarTitle(dynamic user) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.local_shipping, color: Colors.white, size: 28),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.name ?? "Logistics Coordinator",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Logistics Operations • ${user?.company ?? 'Babi Industries'}",
                style: const TextStyle(
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

  List<Widget> _buildResponsiveAppBarActions(LogisticsDashboardController controller, bool isMobile) {
    return [
      IconButton(
        icon: Stack(
          children: [
            const Icon(Icons.notifications, color: Colors.white),
            if (controller.criticalAlerts.value > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: kErrorColor,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    controller.criticalAlerts.value.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        onPressed: () => _showNotifications(controller),
      ),
      IconButton(
        icon: const Icon(Icons.map, color: Colors.white),
        onPressed: () => controller.navigateToTrackingMap(),
      ),
      IconButton(
        icon: const Icon(Icons.refresh, color: Colors.white),
        onPressed: controller.refreshData,
      ),
      if (!isMobile) 
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) => _handleAppBarMenuAction(value, controller),
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(value: 'tracking', child: Text('Live Tracking')),
            const PopupMenuItem(value: 'routes', child: Text('Route Optimization')),
            const PopupMenuItem(value: 'reports', child: Text('Export Reports')),
            const PopupMenuItem(value: 'settings', child: Text('Dashboard Settings')),
          ],
        ),
      const SizedBox(width: 8),
    ];
  }

  Widget _buildErrorView(LogisticsDashboardController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kPadding),
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
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }

  // Mobile View with IndexedStack Navigation
  Widget _buildMobileView(LogisticsDashboardController controller) {
    return IndexedStack(
      index: controller.selectedIndex.value,
      children: [
        _buildDashboardContent(controller),
        _buildShipmentsView(controller),
        _buildTrackingView(controller),
        _buildRoutesView(controller),
        _buildVehiclesView(controller),
      ],
    );
  }

  Widget _buildTabletView(LogisticsDashboardController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(controller),
          const SizedBox(height: 24),
          _buildKpiGrid(controller, crossAxisCount: 3),
          const SizedBox(height: 24),
          _buildTabletContentGrid(controller),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildDesktopView(LogisticsDashboardController controller) {
    return Row(
      children: [
        _buildSidebar(controller),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(controller),
                const SizedBox(height: 24),
                _buildKpiGrid(controller, crossAxisCount: 4),
                const SizedBox(height: 24),
                _buildMainContentGrid(controller),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardContent(LogisticsDashboardController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(controller),
          const SizedBox(height: 20),
          _buildKpiGrid(controller, crossAxisCount: 2),
          const SizedBox(height: 20),
          _buildCriticalAlerts(controller),
          const SizedBox(height: 20),
          _buildActiveShipments(controller),
          const SizedBox(height: 20),
          _buildLiveTracking(controller),
          const SizedBox(height: 20),
          _buildRecentActivity(controller),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(LogisticsDashboardController controller) {
    final user = controller.authController.currentUser.value;
    
    return Container(
      padding: const EdgeInsets.all(kPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimaryColor, kSecondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(kCardRadius),
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

  Widget _buildKpiGrid(LogisticsDashboardController controller, {int crossAxisCount = 2}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int actualCrossAxisCount = crossAxisCount;
        double childAspectRatio = 1.0;
        
        if (constraints.maxWidth < 400) {
          actualCrossAxisCount = 2;
          childAspectRatio = 1.1;
        } else if (constraints.maxWidth < 768) {
          actualCrossAxisCount = 3;
          childAspectRatio = 1.0;
        }
        
        return GridView.count(
          crossAxisCount: actualCrossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: childAspectRatio,
          children: [
            _buildKpiCard(
              "Active Shipments",
              controller.activeShipments.value.toString(),
              Icons.local_shipping,
              kPrimaryColor,
              "${controller.inTransit.value} in transit",
              onTap: () => controller.navigateToShipmentManagement(),
            ),
            _buildKpiCard(
              "Delivered Today",
              controller.completedToday.value.toString(),
              Icons.check_circle,
              kSuccessColor,
              "On schedule",
              onTap: () => _showTodayDeliveries(controller),
            ),
            _buildKpiCard(
              "Delayed Shipments",
              controller.delayed.value.toString(),
              Icons.access_time,
              kErrorColor,
              "Need attention",
              onTap: () => _showDelayedShipments(controller),
            ),
            _buildKpiCard(
              "Pending Pickup",
              controller.pendingPickup.value.toString(),
              Icons.schedule,
              kWarningColor,
              "Ready to ship",
              onTap: () => _showPendingPickups(controller),
            ),
            _buildKpiCard(
              "On-Time Rate",
              controller.onTimeDeliveryRate.value,
              Icons.trending_up,
              kAccentColor,
              "This month",
              onTap: () => _showPerformanceMetrics(controller),
            ),
            _buildKpiCard(
              "Avg Delivery Time",
              controller.avgDeliveryTime.value,
              Icons.timer,
              kInfoColor,
              "Current average",
              onTap: () => _showDeliveryAnalytics(controller),
            ),
            if (actualCrossAxisCount >= 3) ...[
              _buildKpiCard(
                "Customer Satisfaction",
                controller.customerSatisfaction.value,
                Icons.star,
                Colors.amber,
                "Average rating",
                onTap: () => _showCustomerFeedback(controller),
              ),
              _buildKpiCard(
                "Route Efficiency",
                controller.routeOptimization.value,
                Icons.route,
                kSecondaryColor,
                "Optimized routes",
                onTap: () => controller.navigateToRouteOptimization(),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color, String subtitle, {VoidCallback? onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kCardRadius),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 120;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(isSmall ? 8 : 12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: isSmall ? 20 : 24),
                  ),
                  SizedBox(height: isSmall ? 4 : 8),
                  Flexible(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: isSmall ? 16 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: isSmall ? 2 : 4),
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: isSmall ? 10 : 11,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Flexible(
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: color,
                        fontSize: isSmall ? 8 : 9,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      )
    );
  }

  Widget _buildCriticalAlerts(LogisticsDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Text(
                    "Critical Alerts & Notifications",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: controller.criticalAlerts.value > 0 
                            ? kErrorColor.withOpacity(0.1) 
                            : kSuccessColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${controller.criticalAlerts.value} alerts",
                        style: TextStyle(
                          color: controller.criticalAlerts.value > 0 ? kErrorColor : kSuccessColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.settings, size: 20),
                      onPressed: () => _showAlertSettings(controller),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => controller.notifications.isEmpty 
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(Icons.check_circle, color: kSuccessColor, size: 48),
                        SizedBox(height: 8),
                        Text("All shipments on track"),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.notifications.length > 5 ? 5 : controller.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    final priority = notification['priority'] ?? 'medium';
                    final color = priority == 'high' ? kErrorColor : 
                                 priority == 'medium' ? kWarningColor : kInfoColor;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: color.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(_getNotificationIcon(notification['type']), color: color, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  notification['title'] ?? 'Notification',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (notification['action_required'] == true)
                                TextButton(
                                  onPressed: () => _handleNotificationAction(notification),
                                  child: const Text('Act'),
                                ),
                              Text(
                                notification['time'] ?? 'Now',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification['message'] ?? 'No message',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (notification['shipment_id'] != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.info_outline, size: 14, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Text(
                                  'Shipment: ${notification['shipment_id']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => controller.trackShipment(notification['shipment_id']),
                                  child: const Text('Track'),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
            ),
            if (controller.notifications.length > 5)
              TextButton(
                onPressed: () => _showAllNotifications(controller),
                child: Text('View all ${controller.notifications.length} notifications'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveShipments(LogisticsDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Text(
                    "Active Shipments",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showCreateShipment(controller),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('New'),
                    ),
                    TextButton(
                      onPressed: () => controller.navigateToShipmentManagement(),
                      child: const Text("View All"),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => controller.shipments.isEmpty 
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No active shipments"),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.shipments.length > 5 ? 5 : controller.shipments.length,
                  itemBuilder: (context, index) {
                    final shipment = controller.shipments[index];
                    Color statusColor = _getStatusColor(shipment['status'] ?? 'pending');
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          shipment['shipment_id'] ?? 'SHP-000',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (shipment['priority'] == 'high' || shipment['priority'] == 'urgent')
                                          const Padding(
                                            padding: EdgeInsets.only(left: 8),
                                            child: Icon(Icons.priority_high, color: kErrorColor, size: 16),
                                          ),
                                        if (shipment['gps_enabled'] == true)
                                          const Padding(
                                            padding: EdgeInsets.only(left: 4),
                                            child: Icon(Icons.gps_fixed, color: kSuccessColor, size: 14),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      shipment['customer'] ?? 'Unknown Customer',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on, size: 12, color: Colors.grey.shade600),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            "${shipment['origin']} → ${shipment['destination']}",
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _getStatusDisplayText(shipment['status'] ?? 'pending'),
                                      style: TextStyle(
                                        color: statusColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (shipment['progress'] != null)
                                    Text(
                                      "${shipment['progress']}% complete",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  if (shipment['estimated_delivery'] != null)
                                    Text(
                                      "ETA: ${_formatTime(shipment['estimated_delivery'])}",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          if (shipment['driver'] != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.person, size: 14, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Text(
                                  "Driver: ${shipment['driver']}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(Icons.local_shipping, size: 14, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Text(
                                  shipment['vehicle'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () => _contactCustomer(shipment),
                                      icon: const Icon(Icons.phone, size: 16),
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(4),
                                    ),
                                    IconButton(
                                      onPressed: () => controller.trackShipment(shipment['id']),
                                      icon: const Icon(Icons.map, size: 16),
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(4),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                          if (shipment['progress'] != null && shipment['progress'] > 0) ...[
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: shipment['progress'] / 100.0,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                                minHeight: 4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveTracking(LogisticsDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Live Tracking",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => controller.navigateToTrackingMap(),
                  icon: const Icon(Icons.fullscreen, size: 16),
                  label: const Text('Full Map'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kPrimaryColor.withOpacity(0.1), kSecondaryColor.withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 64, color: kPrimaryColor),
                        SizedBox(height: 8),
                        Text(
                          "Live GPS Tracking Map",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Real-time vehicle positions",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: kSuccessColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: kSuccessColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Obx(() => Text(
                            "${controller.liveShipments.length} Live",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => Column(
              children: controller.liveShipments.take(3).map((shipment) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kSuccessColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: kSuccessColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shipment['id'] ?? 'Unknown',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "${shipment['speed'] ?? 'N/A'} • ${shipment['heading'] ?? 'N/A'}",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Live",
                        style: const TextStyle(
                          fontSize: 10,
                          color: kSuccessColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(LogisticsDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recent Activity",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => controller.recentActivities.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No recent activity"),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.recentActivities.length > 5
                        ? 5
                        : controller.recentActivities.length,
                    itemBuilder: (context, index) {
                      final activity = controller.recentActivities[index];
                      return ListTile(
                        leading: Icon(
                          _getActivityIcon(activity['type']),
                          color: kPrimaryColor,
                        ),
                        title: Text(activity['title'] ?? 'Activity'),
                        subtitle: Text(activity['description'] ?? ''),
                        trailing: Text(
                          activity['time'] ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                      );
                    },
                  )),
            if (controller.recentActivities.length > 5)
              TextButton(
                onPressed: () => _showAllActivities(controller),
                child: const Text('View all activities'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildShipmentsView(LogisticsDashboardController controller) {
    return Center(child: Text("Shipments View - Coming Soon"));
  }

  Widget _buildTrackingView(LogisticsDashboardController controller) {
    return Center(child: Text("Tracking View - Coming Soon"));
  }

  Widget _buildRoutesView(LogisticsDashboardController controller) {
    return Center(child: Text("Routes View - Coming Soon"));
  }

  Widget _buildVehiclesView(LogisticsDashboardController controller) {
    return Center(child: Text("Vehicles View - Coming Soon"));
  }

  Widget _buildTabletContentGrid(LogisticsDashboardController controller) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildCriticalAlerts(controller),
        _buildActiveShipments(controller),
        _buildLiveTracking(controller),
        _buildRecentActivity(controller),
      ],
    );
  }

  Widget _buildMainContentGrid(LogisticsDashboardController controller) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildCriticalAlerts(controller),
        _buildActiveShipments(controller),
        _buildLiveTracking(controller),
        _buildRecentActivity(controller),
      ],
    );
  }

  Widget _buildSidebar(LogisticsDashboardController controller) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: kPrimaryColor,
            child: Row(
              children: [
                const Icon(Icons.local_shipping, color: Colors.white),
                const SizedBox(width: 12),
                const Text(
                  "Logistics",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSidebarItem(
                  Icons.dashboard,
                  "Dashboard",
                  isSelected: true,
                  onTap: () {},
                ),
                _buildSidebarItem(
                  Icons.local_shipping,
                  "Shipments",
                  onTap: () => controller.navigateToShipmentManagement(),
                ),
                _buildSidebarItem(
                  Icons.map,
                  "Tracking",
                  onTap: () => controller.navigateToTrackingMap(),
                ),
                _buildSidebarItem(
                  Icons.route,
                  "Routes",
                  onTap: () => controller.navigateToRouteOptimization(),
                ),
                _buildSidebarItem(
                  Icons.directions_car,
                  "Vehicles",
                  onTap: () {},
                ),
                _buildSidebarItem(
                  Icons.analytics,
                  "Analytics",
                  onTap: () {},
                ),
                _buildSidebarItem(
                  Icons.report,
                  "Reports",
                  onTap: () {},
                ),
                _buildSidebarItem(
                  Icons.settings,
                  "Settings",
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title,
      {bool isSelected = false, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon,
          color: isSelected ? kPrimaryColor : Colors.grey.shade700),
      title: Text(title,
          style: TextStyle(
              color: isSelected ? kPrimaryColor : Colors.grey.shade700,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      selected: isSelected,
      onTap: onTap,
    );
  }

  Widget _buildMobileBottomNav(LogisticsDashboardController controller) {
    return Obx(() => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping),
              label: 'Shipments',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Tracking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.route),
              label: 'Routes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car),
              label: 'Vehicles',
            ),
          ],
        ));
  }

  Widget _buildMobileDrawer(LogisticsDashboardController controller) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: kPrimaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.local_shipping, size: 40, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  controller.authController.currentUser.value?.name ??
                      "Coordinator",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Logistics Dashboard",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.dashboard, "Dashboard", onTap: () {}),
          _buildDrawerItem(
              Icons.local_shipping, "Shipments",
              onTap: () => controller.navigateToShipmentManagement()),
          _buildDrawerItem(
              Icons.map, "Tracking",
              onTap: () => controller.navigateToTrackingMap()),
          _buildDrawerItem(
              Icons.route, "Routes",
              onTap: () => controller.navigateToRouteOptimization()),
          _buildDrawerItem(Icons.directions_car, "Vehicles", onTap: () {}),
          _buildDrawerItem(Icons.analytics, "Analytics", onTap: () {}),
          _buildDrawerItem(Icons.report, "Reports", onTap: () {}),
          _buildDrawerItem(Icons.settings, "Settings", onTap: () {}),
          const Divider(),
          _buildDrawerItem(Icons.logout, "Logout",
              onTap: () => controller.authController.logout()),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title,
      {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: kPrimaryColor),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildFloatingActionButton(
      BuildContext context, LogisticsDashboardController controller) {
    return FloatingActionButton(
      onPressed: () => _showCreateShipment(controller),
      backgroundColor: kPrimaryColor,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  // Helper methods
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'delay':
        return Icons.access_time;
      case 'arrival':
        return Icons.location_on;
      case 'issue':
        return Icons.warning;
      case 'completion':
        return Icons.check_circle;
      default:
        return Icons.notifications;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'shipment_created':
        return Icons.add_circle;
      case 'shipment_updated':
        return Icons.edit;
      case 'status_changed':
        return Icons.sync;
      case 'delivery_completed':
        return Icons.check_circle;
      default:
        return Icons.history;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return kWarningColor;
      case 'in_transit':
        return kInfoColor;
      case 'delivered':
        return kSuccessColor;
      case 'delayed':
        return kErrorColor;
      case 'cancelled':
        return Colors.grey;
      default:
        return kPrimaryColor;
    }
  }

  String _getStatusDisplayText(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'in_transit':
        return 'In Transit';
      case 'delivered':
        return 'Delivered';
      case 'delayed':
        return 'Delayed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  String _formatTime(String timestamp) {
    // Simple time formatting - in a real app, use a proper date formatting library
    try {
      return timestamp.substring(0, 10);
    } catch (e) {
      return timestamp;
    }
  }

  // Action handlers
  void _showNotifications(LogisticsDashboardController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Notifications",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = controller.notifications[index];
                      return ListTile(
                        leading: Icon(_getNotificationIcon(notification['type'])),
                        title: Text(notification['title'] ?? 'Notification'),
                        subtitle: Text(notification['message'] ?? ''),
                        trailing: Text(notification['time'] ?? ''),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAppBarMenuAction(
      String value, LogisticsDashboardController controller) {
    switch (value) {
      case 'tracking':
        controller.navigateToTrackingMap();
        break;
      case 'routes':
        controller.navigateToRouteOptimization();
        break;
      case 'reports':
        // Handle reports
        break;
      case 'settings':
        // Handle settings
        break;
    }
  }

  void _showTodayDeliveries(LogisticsDashboardController controller) {
    Get.dialog(const AlertDialog(
      title: Text("Today's Deliveries"),
      content: Text("Feature coming soon"),
    ));
  }

  void _showDelayedShipments(LogisticsDashboardController controller) {
    Get.dialog(const AlertDialog(
      title: Text("Delayed Shipments"),
      content: Text("Feature coming soon"),
    ));
  }

  void _showPendingPickups(LogisticsDashboardController controller) {
    Get.dialog(const AlertDialog(
      title: Text("Pending Pickups"),
      content: Text("Feature coming soon"),
    ));
  }

  void _showPerformanceMetrics(LogisticsDashboardController controller) {
    Get.dialog(const AlertDialog(
      title: Text("Performance Metrics"),
      content: Text("Feature coming soon"),
    ));
  }

  void _showDeliveryAnalytics(LogisticsDashboardController controller) {
    Get.dialog(const AlertDialog(
      title: Text("Delivery Analytics"),
      content: Text("Feature coming soon"),
    ));
  }

  void _showCustomerFeedback(LogisticsDashboardController controller) {
    Get.dialog(const AlertDialog(
      title: Text("Customer Feedback"),
      content: Text("Feature coming soon"),
    ));
  }

  void _showAlertSettings(LogisticsDashboardController controller) {
    Get.dialog(const AlertDialog(
      title: Text("Alert Settings"),
      content: Text("Feature coming soon"),
    ));
  }

  void _showAllNotifications(LogisticsDashboardController controller) {
    Get.toNamed('/notifications');
  }

  void _showAllActivities(LogisticsDashboardController controller) {
    Get.toNamed('/activities');
  }

  void _showCreateShipment(LogisticsDashboardController controller) {
    Get.toNamed('/create-shipment');
  }

  void _handleNotificationAction(Map<String, dynamic> notification) {
    // Handle notification action
  }

  void _contactCustomer(Map<String, dynamic> shipment) {
    // Handle customer contact
  }
}