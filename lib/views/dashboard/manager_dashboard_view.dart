import 'package:babi_industries/controllers/manager_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerDashboardView extends StatelessWidget {
   ManagerDashboardView({Key? key}) : super(key: key);

  static const kPrimaryColor = Color(0xFF1976D2);
  static const kSecondaryColor = Color(0xFF42A5F5);
  static const kAccentColor = Color(0xFF4CAF50);
  static const kWarningColor = Color(0xFFFF9800);
  static const kErrorColor = Color(0xFFF44336);
  static const kPurpleColor = Color(0xFF9C27B0);
  static const kTealColor = Color(0xFF009688);
  static const kBackgroundColor = Color(0xFFF5F6FA);
  static const kCardRadius = 16.0;
  static const kPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ManagerDashboardController());
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
                Text('Loading dashboard data...'),
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
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  AppBar _buildResponsiveAppBar(ManagerDashboardController controller, bool isMobile) {
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
          user?.name?.split(' ').first ?? "Manager",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          user?.company ?? 'Babi Industries',
          style: const TextStyle(
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
        CircleAvatar(
          backgroundImage: user?.profileImage != null 
              ? NetworkImage(user!.profileImage!) 
              : const AssetImage('assets/avatar.png') as ImageProvider,
          radius: 20,
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.name ?? "Manager",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "${user?.role ?? 'Supply Chain Manager'} • ${user?.company ?? 'Babi Industries'}",
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

  List<Widget> _buildResponsiveAppBarActions(ManagerDashboardController controller, bool isMobile) {
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
        onPressed: () => _showResponsiveNotifications(Get.context!, controller),
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
            const PopupMenuItem(value: 'export', child: Text('Export Reports')),
            const PopupMenuItem(value: 'settings', child: Text('Dashboard Settings')),
            const PopupMenuItem(value: 'help', child: Text('Help & Support')),
          ],
        ),
      const SizedBox(width: 8),
    ];
  }

  Widget _buildErrorView(ManagerDashboardController controller) {
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

  Widget _buildTabletView(ManagerDashboardController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(controller),
          const SizedBox(height: 24),
          _buildResponsiveKpiGrid(controller, crossAxisCount: 3),
          const SizedBox(height: 24),
          _buildTabletContentGrid(controller),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildDesktopView(ManagerDashboardController controller) {
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
                _buildResponsiveKpiGrid(controller, crossAxisCount: 4),
                const SizedBox(height: 24),
                _buildMainContentGrid(controller),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileView(ManagerDashboardController controller) {
    return IndexedStack(
      index: controller.selectedIndex.value,
      children: [
        _buildDashboardContent(controller),
        _buildSuppliersView(controller),
        _buildOrdersView(controller),
        _buildInventoryView(controller),
        _buildAnalyticsView(controller),
        _buildLogisticsView(controller),
        _buildContractsView(controller),
      ],
    );
  }

  Widget _buildDashboardContent(ManagerDashboardController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(controller),
          const SizedBox(height: 20),
          _buildResponsiveKpiGrid(controller, crossAxisCount: 2),
          const SizedBox(height: 20),
          _buildCriticalAlerts(controller),
          const SizedBox(height: 20),
          _buildRecentActivity(controller),
          const SizedBox(height: 20),
          _buildQuickStats(controller),
          const SizedBox(height: 20),
          _buildPredictiveAnalytics(controller),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSidebar(ManagerDashboardController controller) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding),
            child: Text(
              "Supply Chain Management",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _sidebarItem("Dashboard", Icons.dashboard, true, () {}),
                _sidebarItem("Suppliers", Icons.business, false, controller.navigateToSupplierManagement),
                _sidebarItem("Orders", Icons.shopping_cart, false, controller.navigateToOrderManagement),
                _sidebarItem("Inventory", Icons.inventory, false, controller.navigateToInventoryManagement),
                _sidebarItem("Contracts", Icons.description, false, () => _showContractManagement(controller)),
                _sidebarItem("Logistics", Icons.local_shipping, false, () => _showLogisticsTracking(controller)),
                _sidebarItem("Warehouse", Icons.warehouse, false, () => _showFeatureDialog("Warehouse Management")),
                _sidebarItem("Analytics", Icons.analytics, false, controller.navigateToAnalytics),
                _sidebarItem("Reports", Icons.assessment, false, controller.navigateToReports),
                _sidebarItem("Forecasting", Icons.trending_up, false, () => _showPredictiveAnalytics(controller)),
                const Divider(),
                _sidebarItem("Settings", Icons.settings, false, () => _showDashboardSettings(controller)),
                _sidebarItem("Help & Support", Icons.help, false, () => _showFeatureDialog("Help & Support")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer(ManagerDashboardController controller) {
    final user = controller.authController.currentUser.value;
    
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: kPrimaryColor),
            accountName: Text(user?.name ?? "Manager"),
            accountEmail: Text(user?.email ?? "manager@babi.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user?.profileImage != null 
                  ? NetworkImage(user!.profileImage!) 
                  : const AssetImage('assets/avatar.png') as ImageProvider,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _sidebarItem("Dashboard", Icons.dashboard, true, () => Get.back()),
                _sidebarItem("Suppliers", Icons.business, false, () {
                  Get.back();
                  controller.selectedIndex.value = 1;
                }),
                _sidebarItem("Orders", Icons.shopping_cart, false, () {
                  Get.back();
                  controller.selectedIndex.value = 2;
                }),
                _sidebarItem("Inventory", Icons.inventory, false, () {
                  Get.back();
                  controller.selectedIndex.value = 3;
                }),
                _sidebarItem("Analytics", Icons.analytics, false, () {
                  Get.back();
                  controller.selectedIndex.value = 4;
                }),
                _sidebarItem("Logistics", Icons.local_shipping, false, () {
                  Get.back();
                  controller.selectedIndex.value = 5;
                }),
                _sidebarItem("Contracts", Icons.description, false, () {
                  Get.back();
                  controller.selectedIndex.value = 6;
                }),
                const Divider(),
                _sidebarItem("Settings", Icons.settings, false, () {
                  Get.back();
                  _showDashboardSettings(controller);
                }),
                _sidebarItem("Logout", Icons.logout, false, () {
                  Get.back();
                  controller.authController.logout();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(String title, IconData icon, [bool isActive = false, VoidCallback? onTap]) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? kPrimaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? kPrimaryColor : Colors.grey.shade600,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? kPrimaryColor : Colors.grey.shade700,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: onTap ?? () {},
      ),
    );
  }

  Widget _buildMobileBottomNav(ManagerDashboardController controller) {
    return Obx(() => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value > 4 ? 4 : controller.selectedIndex.value,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.business), label: "Suppliers"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Orders"),
            BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Inventory"),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Analytics"),
          ],
          onTap: (index) => controller.selectedIndex.value = index,
        ));
  }

  Widget _buildWelcomeSection(ManagerDashboardController controller) {
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

  Widget _buildResponsiveKpiGrid(ManagerDashboardController controller, {int crossAxisCount = 2}) {
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
              "Total Suppliers",
              controller.totalSuppliers.value.toString(),
              Icons.business,
              kAccentColor,
              "Active partnerships",
              onTap: () => controller.navigateToSupplierManagement(),
            ),
            _buildKpiCard(
              "Active Orders",
              controller.activeOrders.value.toString(),
              Icons.shopping_cart,
              kPrimaryColor,
              "${controller.pendingOrders.value} pending",
              onTap: () => controller.navigateToOrderManagement(),
            ),
            _buildKpiCard(
              "Delayed Orders",
              controller.delayedOrders.value.toString(),
              Icons.access_time,
              kErrorColor,
              "Needs attention",
              onTap: () => _showDelayedOrdersDetail(controller),
            ),
            _buildKpiCard(
              "Low Stock Items",
              controller.lowStockItems.value.toString(),
              Icons.inventory,
              kWarningColor,
              "Reorder required",
              onTap: () => controller.navigateToInventoryManagement(),
            ),
            _buildKpiCard(
              "Stock Health",
              controller.stockHealth.value,
              Icons.health_and_safety,
              kAccentColor,
              "Overall status",
              onTap: () => _showStockHealthDetail(controller),
            ),
            _buildKpiCard(
              "Performance Score",
              controller.supplierPerformanceScore.value,
              Icons.trending_up,
              kPrimaryColor,
              "Supplier avg",
              onTap: () => _showPerformanceDetail(controller),
            ),
            _buildKpiCard(
              "On-Time Delivery",
              controller.onTimeDeliveryRate.value,
              Icons.schedule,
              kAccentColor,
              "This month",
              onTap: () => _showDeliveryMetrics(controller),
            ),
            _buildKpiCard(
              "Monthly Value",
              controller.monthlyOrderValue.value,
              Icons.monetization_on,
              kSecondaryColor,
              "Order volume",
              onTap: () => _showFinancialMetrics(controller),
            ),
            if (actualCrossAxisCount >= 3) ...[
              _buildKpiCard(
                "Active Contracts",
                controller.activeContracts.value.toString(),
                Icons.description,
                kPurpleColor,
                "Under management",
                onTap: () => _showContractManagement(controller),
              ),
              _buildKpiCard(
                "In Transit",
                controller.inTransitShipments.value.toString(),
                Icons.local_shipping,
                kTealColor,
                "Shipments",
                onTap: () => _showLogisticsTracking(controller),
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
      ),
    );
  }

  Widget _buildTabletContentGrid(ManagerDashboardController controller) {
    return Column(
      children: [
        _buildCriticalAlerts(controller),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildRecentOrders(controller),
                  const SizedBox(height: 20),
                  _buildPredictiveAnalytics(controller),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  _buildTopSuppliers(controller),
                  const SizedBox(height: 20),
                  _buildRecentActivity(controller),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainContentGrid(ManagerDashboardController controller) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildCriticalAlerts(controller),
                  const SizedBox(height: 20),
                  _buildRecentOrders(controller),
                  const SizedBox(height: 20),
                  _buildLogisticsOverview(controller),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildTopSuppliers(controller),
                  const SizedBox(height: 20),
                  _buildRecentActivity(controller),
                  const SizedBox(height: 20),
                  _buildContractsSummary(controller),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildPredictiveAnalytics(controller),
      ],
    );
  }

  Widget _buildCriticalAlerts(ManagerDashboardController controller) {
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
                    "Critical Alerts & Recommendations",
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
                    Container(
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
                    ),
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
            Obx(() => controller.alerts.isEmpty 
              ? const Center(
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
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.alerts.length > 5 ? 5 : controller.alerts.length,
                  itemBuilder: (context, index) {
                    final alert = controller.alerts[index];
                    final priority = alert['priority'] ?? 'medium';
                    final color = priority == 'high' ? kErrorColor : 
                                 priority == 'medium' ? kWarningColor : kAccentColor;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(_getAlertIcon(alert['type']), color: color, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  alert['title'] ?? 'Alert',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (alert['actionable'] == true)
                                TextButton(
                                  onPressed: () => _handleAlertAction(alert),
                                  child: const Text('Act'),
                                ),
                              Text(
                                alert['created_at'] ?? 'Now',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            alert['message'] ?? alert['description'] ?? 'No description',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (alert['recommendation'] != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: kAccentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.lightbulb_outline, color: kAccentColor, size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Recommendation: ${alert['recommendation']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green.shade700,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
            ),
            if (controller.alerts.length > 5)
              TextButton(
                onPressed: () => _showAllAlerts(controller),
                child: Text('View all ${controller.alerts.length} alerts'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(ManagerDashboardController controller) {
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
                  "Recent Activity",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list, size: 20),
                  onPressed: () => _showActivityFilters(controller),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => controller.activities.isEmpty 
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No recent activities"),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.activities.length > 8 ? 8 : controller.activities.length,
                  itemBuilder: (context, index) {
                    final activity = controller.activities[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: _getActivityColor(activity['type']).withOpacity(0.1),
                        child: Icon(
                          _getActivityIcon(activity['type'] ?? 'default'),
                          color: _getActivityColor(activity['type']),
                          size: 20,
                        ),
                      ),
                      title: Text(
                        activity['title'] ?? activity['action'] ?? 'Activity',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity['description'] ?? activity['message'] ?? 'No description',
                            style: const TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                activity['created_at'] ?? activity['time'] ?? 'Now',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              if (activity['user'] != null)
                                Text(
                                  'by ${activity['user']}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      trailing: activity['status'] != null
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(activity['status']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                activity['status'],
                                style: TextStyle(
                                  color: _getStatusColor(activity['status']),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : null,
                    );
                  },
                ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSuppliers(ManagerDashboardController controller) {
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
                    "Top Suppliers",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleSupplierAction(value, controller),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'compare', child: Text('Compare Suppliers')),
                    const PopupMenuItem(value: 'add', child: Text('Add New Supplier')),
                    const PopupMenuItem(value: 'viewall', child: Text('View All')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => controller.suppliers.isEmpty 
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No suppliers data"),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.suppliers.length > 5 ? 5 : controller.suppliers.length,
                  itemBuilder: (context, index) {
                    final supplier = controller.suppliers[index];
                    final performance = int.tryParse(supplier['performance']?.toString() ?? '0') ?? 0;
                    final performanceColor = performance >= 90 ? kAccentColor :
                                           performance >= 70 ? kWarningColor : kErrorColor;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      supplier['name'] ?? supplier['supplier_name'] ?? 'Supplier',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (supplier['category'] != null)
                                      Text(
                                        supplier['category'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: performanceColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "${supplier['performance'] ?? supplier['performance_score'] ?? '0'}%",
                                      style: TextStyle(
                                        color: performanceColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: List.generate(5, (i) => Icon(
                                      Icons.star,
                                      size: 12,
                                      color: i < (performance / 20).floor() 
                                          ? Colors.orange 
                                          : Colors.grey.shade300,
                                    )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${supplier['total_orders'] ?? supplier['orders_count'] ?? '0'} orders",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                supplier['total_value'] ?? supplier['order_value'] ?? 'XOF 0',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Last delivery: ${supplier['last_delivery'] ?? 'N/A'}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              if (supplier['contract_expires'] != null)
                                Text(
                                  "Contract: ${supplier['contract_expires']}",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
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

  Widget _buildRecentOrders(ManagerDashboardController controller) {
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
                    "Recent Orders",
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
                      onPressed: () => _showCreateOrder(controller),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('New'),
                    ),
                    TextButton(
                      onPressed: () => controller.navigateToOrderManagement(),
                      child: const Text("View All"),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => controller.orders.isEmpty 
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No recent orders"),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.orders.length > 5 ? 5 : controller.orders.length,
                  itemBuilder: (context, index) {
                    final order = controller.orders[index];
                    Color statusColor = _getStatusColor(order['status'] ?? 'pending');
                    
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
                                          order['order_id'] ?? order['id'] ?? 'ORD-000',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (order['priority'] == 'high')
                                          const Padding(
                                            padding: EdgeInsets.only(left: 8),
                                            child: Icon(Icons.priority_high, color: kErrorColor, size: 16),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      order['supplier_name'] ?? order['supplier'] ?? 'Unknown Supplier',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          order['total_value'] ?? order['value'] ?? 'XOF 0',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "• ${order['items_count'] ?? '0'} items",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
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
                                      order['status'] ?? 'pending',
                                      style: TextStyle(
                                        color: statusColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    order['created_at'] ?? order['order_date'] ?? 'Today',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  if (order['expected_delivery'] != null)
                                    Text(
                                      "ETA: ${order['expected_delivery']}",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          if (order['tracking_number'] != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.local_shipping, size: 14, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Text(
                                  "Tracking: ${order['tracking_number']}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => _showOrderDetails(order),
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
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(ManagerDashboardController controller) {
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
                  "Performance Overview",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.tune, size: 20),
                  onPressed: () => _showCustomizeKpis(controller),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            "Monthly Value",
                            controller.monthlyOrderValue.value,
                            Icons.monetization_on,
                            kAccentColor,
                            trend: controller.monthlyValueTrend.value,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatItem(
                            "On-Time Rate",
                            controller.onTimeDeliveryRate.value,
                            Icons.schedule,
                            kPrimaryColor,
                            trend: controller.onTimeDeliveryTrend.value,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            "Inventory Turnover",
                            controller.inventoryTurnover.value,
                            Icons.rotate_right,
                            kSecondaryColor,
                            trend: controller.inventoryTurnoverTrend.value,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatItem(
                            "Supplier Score",
                            controller.supplierPerformanceScore.value,
                            Icons.trending_up,
                            kAccentColor,
                            trend: controller.supplierScoreTrend.value,
                          ),
                        ),
                      ],
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

  Widget _buildStatItem(String title, String value, IconData icon, Color color, {String? trend}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 120;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: isSmall ? 20 : 24),
                  const Spacer(),
                  if (trend != null && trend.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: trend.startsWith('+') ? kAccentColor.withOpacity(0.2) : kErrorColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        trend,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: trend.startsWith('+') ? kAccentColor : kErrorColor,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value.isEmpty ? 'N/A' : value,
                style: TextStyle(
                  fontSize: isSmall ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  fontSize: isSmall ? 10 : 11,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }

  // New Widgets for Complete Manager Dashboard

Widget _buildPredictiveAnalytics(ManagerDashboardController controller) {
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
          /// --- Header with settings ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Predictive Analytics & Forecasting",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings, size: 20),
                onPressed: () => _showForecastSettings(controller),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// --- Observe controller data ---
          Obx(() {
            if (controller.isLoadingForecast.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (controller.forecastData.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "No forecast data available.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }

            /// Dynamically generate forecast items
            return Column(
              children: controller.forecastData.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildForecastItem(
                    item.title,
                    item.description,
                    item.icon,
                    item.color,
                    item.timeframe,
                    onTap: item.onTap,
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    ),
  );
}

/// Forecast item UI (unchanged except for flexibility)
Widget _buildForecastItem(
  String title,
  String description,
  IconData icon,
  Color color,
  String timeframe, {
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    )),
                Text(description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    )),
                Text(timeframe,
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontStyle: FontStyle.italic,
                    )),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
        ],
      ),
    ),
  );
}


  Widget _buildLogisticsOverview(ManagerDashboardController controller) {
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
                  "Logistics & Shipments",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showLogisticsTracking(controller),
                  icon: const Icon(Icons.map, size: 16),
                  label: const Text('Track All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildLogisticsStat(
                        "In Transit",
                        controller.inTransitShipments.value.toString(),
                        Icons.local_shipping,
                        kPrimaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildLogisticsStat(
                        "Delivered Today",
                        controller.deliveredToday.value.toString(),
                        Icons.check_circle,
                        kAccentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildLogisticsStat(
                        "Delayed",
                        controller.delayedShipments.value.toString(),
                        Icons.access_time,
                        kErrorColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildLogisticsStat(
                        "Avg Delivery",
                        controller.avgDeliveryTime.value,
                        Icons.schedule,
                        kSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildLogisticsStat(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContractsSummary(ManagerDashboardController controller) {
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
                  "Contract Management",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => _showContractManagement(controller),
                  child: const Text("View All"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => Column(
              children: [
                _buildContractStat(
                  "Active Contracts",
                  controller.activeContracts.value.toString(),
                  Icons.description,
                  kAccentColor,
                ),
                const SizedBox(height: 8),
                _buildContractStat(
                  "Expiring Soon",
                  controller.expiringContracts.value.toString(),
                  Icons.schedule,
                  kWarningColor,
                ),
                const SizedBox(height: 8),
                _buildContractStat(
                  "Pending Renewal",
                  controller.pendingRenewals.value.toString(),
                  Icons.refresh,
                  kPrimaryColor,
                ),
                const SizedBox(height: 12),
                if (controller.contractAlerts.value > 0)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kWarningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: kWarningColor, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "${controller.contractAlerts.value} contracts need attention",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildContractStat(String title, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  // Additional Mobile Views

  Widget _buildSuppliersView(ManagerDashboardController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Suppliers Management"),
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.compare),
            onPressed: () => _showSupplierComparison(controller),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddSupplier(controller),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTopSuppliers(controller),
            const SizedBox(height: 16),
            Expanded(
              child: _buildSupplierPerformanceChart(controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersView(ManagerDashboardController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders Management"),
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showOrderFilters(controller),
          ),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () => _showCreateOrder(controller),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildOrderStatusSummary(controller),
            const SizedBox(height: 16),
            Expanded(
              child: _buildRecentOrders(controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryView(ManagerDashboardController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory Management"),
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => _showBarcodeScanner(controller),
          ),
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () => _showAddInventory(controller),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInventorySummary(controller),
            const SizedBox(height: 16),
            Expanded(
              child: _buildLowStockAlerts(controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsView(ManagerDashboardController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics & Reports"),
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showAnalyticsSettings(controller),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _showExportOptions(controller),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAnalyticsSummary(controller),
            const SizedBox(height: 16),
            Expanded(
              child: _buildPredictiveAnalytics(controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogisticsView(ManagerDashboardController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logistics Tracking"),
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => _showShipmentMap(controller),
          ),
          IconButton(
            icon: const Icon(Icons.local_shipping),
            onPressed: () => _showCreateShipment(controller),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLogisticsOverview(controller),
            const SizedBox(height: 16),
            Expanded(
              child: _buildShipmentTracking(controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractsView(ManagerDashboardController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contract Management"),
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showContractSearch(controller),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateContract(controller),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildContractsSummary(controller),
            const SizedBox(height: 16),
            Expanded(
              child: _buildContractsList(controller),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widgets for Mobile Views

  Widget _buildSupplierPerformanceChart(ManagerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Supplier Performance Trends",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    const Text("Performance Chart"),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => controller.navigateToAnalytics(),
                      child: const Text("View Detailed Analytics"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusSummary(ManagerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Status Summary",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(() => Row(
              children: [
                Expanded(child: _buildStatusChip("Pending", controller.pendingOrders.value.toString(), kWarningColor)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatusChip("Processing", controller.processingOrders.value.toString(), kPrimaryColor)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatusChip("Delivered", controller.deliveredOrders.value.toString(), kAccentColor)),
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildInventorySummary(ManagerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Inventory Health",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(() => Column(
              children: [
                _buildInventoryMetric("Total Items", controller.totalInventoryItems.value.toString(), Icons.inventory),
                const SizedBox(height: 8),
                _buildInventoryMetric("Low Stock", controller.lowStockItems.value.toString(), Icons.warning),
                const SizedBox(height: 8),
                _buildInventoryMetric("Out of Stock", controller.outOfStockItems.value.toString(), Icons.error),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryMetric(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontSize: 14)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildLowStockAlerts(ManagerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Low Stock Alerts",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() => controller.lowStockItems.value == 0
                  ? const Center(child: Text("All items are well stocked"))
                  : ListView.builder(
                      itemCount: 5, // Mock data
                      itemBuilder: (context, index) => ListTile(
                        leading: const Icon(Icons.warning, color: kWarningColor),
                        title: Text("Product ${index + 1}"),
                        subtitle: Text("Current stock: ${10 - index * 2}"),
                        trailing: ElevatedButton(
                          onPressed: () => _showReorderProduct(index),
                          child: const Text("Reorder"),
                        ),
                      ),
                    )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsSummary(ManagerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Key Insights",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInsightItem("Best Performing Supplier", "Supplier ABC - 95% on-time", kAccentColor),
            const SizedBox(height: 8),
            _buildInsightItem("Cost Savings Opportunity", "Switch to Supplier XYZ for 15% savings", kPrimaryColor),
            const SizedBox(height: 8),
            _buildInsightItem("Peak Demand Period", "Increase in orders expected next week", kWarningColor),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(String title, String description, Color color) {
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
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentTracking(ManagerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Active Shipments",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() => controller.inTransitShipments.value == 0
                  ? const Center(child: Text("No active shipments"))
                  : ListView.builder(
                      itemCount: controller.inTransitShipments.value,
                      itemBuilder: (context, index) => _buildShipmentItem(index),
                    )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShipmentItem(int index) {
    return ListTile(
      leading: const Icon(Icons.local_shipping, color: kPrimaryColor),
      title: Text("Shipment #${1000 + index}"),
      subtitle: Text("From Supplier ${index + 1} • ETA: ${index + 1} days"),
      trailing: TextButton(
        onPressed: () => _showShipmentDetails(index),
        child: const Text("Track"),
      ),
    );
  }

  Widget _buildContractsList(ManagerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recent Contracts",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() => controller.activeContracts.value == 0
                  ? const Center(child: Text("No active contracts"))
                  : ListView.builder(
                      itemCount: controller.activeContracts.value,
                      itemBuilder: (context, index) => _buildContractItem(index),
                    )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractItem(int index) {
    return ListTile(
      leading: const Icon(Icons.description, color: kPurpleColor),
      title: Text("Contract with Supplier ${index + 1}"),
      subtitle: Text("Expires: ${DateTime.now().add(Duration(days: 30 + index * 10)).toString().split(' ')[0]}"),
      trailing: PopupMenuButton<String>(
        onSelected: (value) => _handleContractAction(value, index),
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'view', child: Text('View Details')),
          const PopupMenuItem(value: 'renew', child: Text('Renew')),
          const PopupMenuItem(value: 'modify', child: Text('Modify')),
        ],
      ),
    );
  }

  // Floating Action Button
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showQuickActions(context),
      backgroundColor: kPrimaryColor,
      icon: const Icon(Icons.add),
      label: const Text('Quick Action'),
    );
  }

  // Status color helper
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'completed':
        return kAccentColor;
      case 'in_transit':
      case 'shipping':
      case 'in transit':
        return kPrimaryColor;
      case 'pending':
      case 'processing':
        return kWarningColor;
      case 'delayed':
      case 'overdue':
        return kErrorColor;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey.shade400;
    }
  }

  // Activity icon and color helpers
  IconData _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'order':
      case 'order_created':
        return Icons.shopping_cart;
      case 'supplier':
      case 'supplier_added':
        return Icons.business;
      case 'inventory':
      case 'stock_update':
        return Icons.inventory;
      case 'alert':
      case 'warning':
        return Icons.warning;
      case 'delivery':
      case 'shipment':
        return Icons.local_shipping;
      case 'performance':
        return Icons.assessment;
      case 'forecast':
        return Icons.trending_up;
      case 'analytics':
        return Icons.analytics;
      case 'contract':
        return Icons.description;
      default:
        return Icons.notifications;
    }
  }

  Color _getActivityColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'order':
        return kPrimaryColor;
      case 'supplier':
        return kAccentColor;
      case 'inventory':
        return kWarningColor;
      case 'alert':
        return kErrorColor;
      case 'delivery':
        return kSecondaryColor;
      case 'contract':
        return kPurpleColor;
      default:
        return kPrimaryColor;
    }
  }

  IconData _getAlertIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'stock':
      case 'inventory':
        return Icons.inventory;
      case 'supplier':
        return Icons.business;
      case 'delivery':
        return Icons.local_shipping;
      case 'contract':
        return Icons.description;
      case 'performance':
        return Icons.trending_down;
      default:
        return Icons.warning;
    }
  }

  // Quick Actions Bottom Sheet
  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final maxHeight = MediaQuery.of(context).size.height * 0.5;
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Manager Quick Actions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth < 300 ? 2 : 3;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _quickActions.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          final action = _quickActions[index];
                          return _quickActionItem(
                            action['title']!,
                            action['icon']!,
                            action['color']!,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  final List<Map<String, dynamic>> _quickActions = [
    {"title": "Create Order", "icon": Icons.add_shopping_cart, "color": kPrimaryColor},
    {"title": "Add Supplier", "icon": Icons.business, "color": kAccentColor},
    {"title": "Stock Report", "icon": Icons.inventory, "color": kWarningColor},
    {"title": "Performance", "icon": Icons.assessment, "color": kSecondaryColor},
    {"title": "Forecast", "icon": Icons.trending_up, "color": kPurpleColor},
    {"title": "Analytics", "icon": Icons.analytics, "color": kTealColor},
    {"title": "Track Shipment", "icon": Icons.local_shipping, "color": kPrimaryColor},
    {"title": "New Contract", "icon": Icons.description, "color": kPurpleColor},
    {"title": "Export Data", "icon": Icons.download, "color": kSecondaryColor},
  ];

  // Individual Quick Action Item
  Widget _quickActionItem(String title, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        Get.back();
        _handleQuickAction(title);
      },
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
                Icon(icon, color: color, size: isSmall ? 24 : 32),
                SizedBox(height: isSmall ? 4 : 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: isSmall ? 10 : 12,
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

  // Action Handlers

  void _handleAppBarMenuAction(String value, ManagerDashboardController controller) {
    switch (value) {
      case 'export':
        _showExportOptions(controller);
        break;
      case 'settings':
        _showDashboardSettings(controller);
        break;
      case 'help':
        _showFeatureDialog("Help & Support");
        break;
    }
  }

  void _handleQuickAction(String actionTitle) {
    switch (actionTitle) {
      case "Create Order":
        _showCreateOrder(Get.find<ManagerDashboardController>());
        break;
      case "Add Supplier":
        _showAddSupplier(Get.find<ManagerDashboardController>());
        break;
      case "Stock Report":
        _showStockReport(Get.find<ManagerDashboardController>());
        break;
      case "Performance":
        _showPerformanceDetail(Get.find<ManagerDashboardController>());
        break;
      case "Forecast":
        _showPredictiveAnalytics(Get.find<ManagerDashboardController>());
        break;
      case "Analytics":
        Get.find<ManagerDashboardController>().navigateToAnalytics();
        break;
      case "Track Shipment":
        _showLogisticsTracking(Get.find<ManagerDashboardController>());
        break;
      case "New Contract":
        _showCreateContract(Get.find<ManagerDashboardController>());
        break;
      case "Export Data":
        _showExportOptions(Get.find<ManagerDashboardController>());
        break;
      default:
        _showFeatureDialog(actionTitle);
    }
  }

  void _handleAlertAction(Map<String, dynamic> alert) {
    final action = alert['action_type'] ?? 'view';
    switch (action) {
      case 'reorder':
        _showReorderProduct(0);
        break;
      case 'contact_supplier':
        _showContactSupplier(alert['supplier_id']);
        break;
      case 'view_contract':
        _showContractDetails(alert['contract_id']);
        break;
      default:
        _showAlertDetails(alert);
    }
  }

  void _handleSupplierAction(String value, ManagerDashboardController controller) {
    switch (value) {
      case 'compare':
        _showSupplierComparison(controller);
        break;
      case 'add':
        _showAddSupplier(controller);
        break;
      case 'viewall':
        controller.navigateToSupplierManagement();
        break;
    }
  }

  void _handleContractAction(String value, int index) {
    switch (value) {
      case 'view':
        _showContractDetails(index);
        break;
      case 'renew':
        _showContractRenewal(index);
        break;
      case 'modify':
        _showContractModification(index);
        break;
    }
  }

  // Dialog and Sheet Methods

  void _showFeatureDialog(String featureName) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: kPrimaryColor),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                featureName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction, size: 48, color: Colors.orange.shade400),
            const SizedBox(height: 16),
            Text(
              "$featureName feature is currently under development and will be available in the next update.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showCreateOrder(ManagerDashboardController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text("Create New Order"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("This will open the order creation form with:"),
            SizedBox(height: 8),
            Text("• Supplier selection"),
            Text("• Product catalog"),
            Text("• Quantity and pricing"),
            Text("• Delivery preferences"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.navigateToOrderManagement();
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }

  void _showAddSupplier(ManagerDashboardController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text("Add New Supplier"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("This will open the supplier registration form with:"),
            SizedBox(height: 8),
            Text("• Company information"),
            Text("• Contact details"),
            Text("• Product categories"),
            Text("• Contract terms"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.navigateToSupplierManagement();
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }

  void _showSupplierComparison(ManagerDashboardController controller) {
    _showFeatureDialog("Supplier Comparison Tool");
  }

  void _showContractManagement(ManagerDashboardController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text("Contract Management"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Contract Overview:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Obx(() => Column(
                children: [
                  _buildContractStat("Active Contracts", controller.activeContracts.value.toString(), Icons.description, kAccentColor),
                  const SizedBox(height: 8),
                  _buildContractStat("Expiring Soon", controller.expiringContracts.value.toString(), Icons.schedule, kWarningColor),
                  const SizedBox(height: 8),
                  _buildContractStat("Pending Renewal", controller.pendingRenewals.value.toString(), Icons.refresh, kPrimaryColor),
                ],
              )),
              const SizedBox(height: 16),
              const Text("Available Actions:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("• View all contracts"),
              const Text("• Create new contract"),
              const Text("• Set renewal reminders"),
              const Text("• Export contract reports"),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Close")),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _showFeatureDialog("Full Contract Management System");
            },
            child: const Text("Open Full View"),
          ),
        ],
      ),
    );
  }

  void _showLogisticsTracking(ManagerDashboardController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text("Logistics Tracking"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Shipment Status:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Obx(() => Column(
                children: [
                  _buildLogisticsStat("In Transit", controller.inTransitShipments.value.toString(), Icons.local_shipping, kPrimaryColor),
                  const SizedBox(width: 12),
                  _buildLogisticsStat("Delivered Today", controller.deliveredToday.value.toString(), Icons.check_circle, kAccentColor),
                ],
              )),
              const SizedBox(height: 16),
              const Text("Tracking Features:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("• Real-time shipment tracking"),
              const Text("• Delivery notifications"),
              const Text("• Route optimization"),
              const Text("• Carrier integration"),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Close")),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _showFeatureDialog("Full Logistics Management System");
            },
            child: const Text("Open Tracking"),
          ),
        ],
      ),
    );
  }

  void _showPredictiveAnalytics(ManagerDashboardController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text("Predictive Analytics"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kPurpleColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: kPurpleColor),
                    SizedBox(width: 8),
                    Text("AI-Powered Insights", style: TextStyle(fontWeight: FontWeight.bold, color: kPurpleColor)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text("Current Predictions:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("• Demand forecast: ${controller.demandForecast.value}"),
                  Text("• Reorder alerts: ${controller.reorderAlerts.value} items"),
                  Text("• Supplier risks: ${controller.supplierRisks.value} flagged"),
                  Text("• Cost savings: ${controller.potentialSavings.value}"),
                ],
              )),
              const SizedBox(height: 16),
              const Text("Analytics Include:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("• Inventory forecasting"),
              const Text("• Demand pattern analysis"),
              const Text("• Supplier performance prediction"),
              const Text("• Cost optimization recommendations"),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Close")),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.navigateToAnalytics();
            },
            child: const Text("View Analytics"),
          ),
        ],
      ),
    );
  }

  void _showDashboardSettings(ManagerDashboardController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text("Dashboard Settings"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Customize your dashboard:"),
            SizedBox(height: 16),
            Text("• Rearrange KPI cards"),
            Text("• Set alert thresholds"),
            Text("• Choose default views"),
            Text("• Configure notifications"),
            Text("• Export preferences"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _showFeatureDialog("Dashboard Customization");
            },
            child: const Text("Customize"),
          ),
        ],
      ),
    );
  }

  void _showExportOptions(ManagerDashboardController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text("Export Reports"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Select export format:"),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text("PDF Report"),
              onTap: () => _exportReport('pdf', controller),
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: const Text("Excel Spreadsheet"),
              onTap: () => _exportReport('excel', controller),
            ),
            ListTile(
              leading: const Icon(Icons.code, color: Colors.blue),
              title: const Text("JSON Data"),
              onTap: () => _exportReport('json', controller),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        ],
      ),
    );
  }

  // Additional Feature Methods
  void _showDelayedOrdersDetail(ManagerDashboardController controller) => _showFeatureDialog("Delayed Orders Analysis");
  void _showStockHealthDetail(ManagerDashboardController controller) => _showFeatureDialog("Stock Health Dashboard");
  void _showPerformanceDetail(ManagerDashboardController controller) => _showFeatureDialog("Performance Analytics");
  void _showDeliveryMetrics(ManagerDashboardController controller) => _showFeatureDialog("Delivery Metrics");
  void _showFinancialMetrics(ManagerDashboardController controller) => _showFeatureDialog("Financial Analytics");
  void _showAllAlerts(ManagerDashboardController controller) => _showFeatureDialog("All System Alerts");
  void _showAlertSettings(ManagerDashboardController controller) => _showFeatureDialog("Alert Configuration");
  void _showActivityFilters(ManagerDashboardController controller) => _showFeatureDialog("Activity Filters");
  void _showOrderDetails(Map<String, dynamic> order) => _showFeatureDialog("Order Details");
  void _showReorderDetails(ManagerDashboardController controller) => _showFeatureDialog("Reorder Management");
  void _showDemandForecast(ManagerDashboardController controller) => _showFeatureDialog("Demand Forecasting");
  void _showSupplierRisks(ManagerDashboardController controller) => _showFeatureDialog("Supplier Risk Assessment");
  void _showCostOptimization(ManagerDashboardController controller) => _showFeatureDialog("Cost Optimization");
  void _showForecastSettings(ManagerDashboardController controller) => _showFeatureDialog("Forecast Settings");
  void _showCustomizeKpis(ManagerDashboardController controller) => _showFeatureDialog("Customize KPIs");
  void _showShipmentMap(ManagerDashboardController controller) => _showFeatureDialog("Shipment Map View");
  void _showCreateShipment(ManagerDashboardController controller) => _showFeatureDialog("Create Shipment");
  void _showContractSearch(ManagerDashboardController controller) => _showFeatureDialog("Contract Search");
  void _showCreateContract(ManagerDashboardController controller) => _showFeatureDialog("Create Contract");
  void _showBarcodeScanner(ManagerDashboardController controller) => _showFeatureDialog("Barcode Scanner");
  void _showAddInventory(ManagerDashboardController controller) => _showFeatureDialog("Add Inventory Item");
  void _showAnalyticsSettings(ManagerDashboardController controller) => _showFeatureDialog("Analytics Settings");
  void _showOrderFilters(ManagerDashboardController controller) => _showFeatureDialog("Order Filters");
  void _showStockReport(ManagerDashboardController controller) => _showFeatureDialog("Stock Report");
  void _showReorderProduct(int index) => _showFeatureDialog("Reorder Product");
  void _showShipmentDetails(int index) => _showFeatureDialog("Shipment Details");
  void _showContractDetails(int index) => _showFeatureDialog("Contract Details");
  void _showContractRenewal(int index) => _showFeatureDialog("Contract Renewal");
  void _showContractModification(int index) => _showFeatureDialog("Contract Modification");
  void _showAlertDetails(Map<String, dynamic> alert) => _showFeatureDialog("Alert Details");
  void _showContactSupplier(String? supplierId) => _showFeatureDialog("Contact Supplier");

  void _exportReport(String format, ManagerDashboardController controller) {
    Get.back();
    Get.snackbar(
      "Export Started",
      "Your $format report is being generated and will be downloaded shortly.",
      backgroundColor: kAccentColor,
      colorText: Colors.white,
      icon: const Icon(Icons.download, color: Colors.white),
    );
  }

  // Responsive Notifications Dialog
  void _showResponsiveNotifications(BuildContext context, ManagerDashboardController controller) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    
    if (isMobile) {
      // Show as bottom sheet on mobile
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) => Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications, color: Colors.white),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        "System Notifications",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.notifications.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text("No notifications available."),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.notifications.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final n = controller.notifications[index];
                      Color notifColor = _getNotificationColor(n['color']);

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: notifColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: notifColor.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.circle, size: 8, color: notifColor),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    n['title'] ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: notifColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Text(
                                  n['time'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              n['message'] ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("Close"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          _showFeatureDialog("All Notifications");
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
                        child: const Text("View All"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Show as dialog on desktop/tablet
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Container(
            width: size.width * 0.4,
            constraints: BoxConstraints(
              maxHeight: size.height * 0.6,
              maxWidth: 500,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications, color: Colors.white),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "System Notifications",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Obx(() {
                    if (controller.notifications.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(Icons.notifications_none, size: 48, color: Colors.grey),
                            SizedBox(height: 16),
                            Text("No notifications available."),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.notifications.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final n = controller.notifications[index];
                        Color notifColor = _getNotificationColor(n['color']);

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: notifColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      n['title'] ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: notifColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    n['time'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                n['message'] ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("Close"),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                          _showFeatureDialog("All Notifications");
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
                        child: const Text("View All"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  // Helper method to get notification color
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
}

