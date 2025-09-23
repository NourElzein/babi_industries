import 'package:babi_industries/controllers/manager_dashboard_controller.dart';
import 'package:babi_industries/views/dashboard/manager_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FloatingActionComponent {
  static Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showQuickActions(context),
      backgroundColor: ManagerDashboardView.kPrimaryColor,
      icon: const Icon(Icons.add),
      label: const Text('Quick Action'),
    );
  }

  // Quick Actions Bottom Sheet
  static void _showQuickActions(BuildContext context) {
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

  static final List<Map<String, dynamic>> _quickActions = [
    {"title": "Create Order", "icon": Icons.add_shopping_cart, "color": ManagerDashboardView.kPrimaryColor},
    {"title": "Add Supplier", "icon": Icons.business, "color": ManagerDashboardView.kAccentColor},
    {"title": "Stock Report", "icon": Icons.inventory, "color": ManagerDashboardView.kWarningColor},
    {"title": "Performance", "icon": Icons.assessment, "color": ManagerDashboardView.kSecondaryColor},
    {"title": "Forecast", "icon": Icons.trending_up, "color": ManagerDashboardView.kPurpleColor},
    {"title": "Analytics", "icon": Icons.analytics, "color": ManagerDashboardView.kTealColor},
    {"title": "Track Shipment", "icon": Icons.local_shipping, "color": ManagerDashboardView.kPrimaryColor},
    {"title": "New Contract", "icon": Icons.description, "color": ManagerDashboardView.kPurpleColor},
    {"title": "Export Data", "icon": Icons.download, "color": ManagerDashboardView.kSecondaryColor},
  ];

  // Individual Quick Action Item
  static Widget _quickActionItem(String title, IconData icon, Color color) {
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

  static void _handleQuickAction(String actionTitle) {
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

  static void _showCreateOrder(ManagerDashboardController controller) => _showFeatureDialog("Create Order");
  static void _showAddSupplier(ManagerDashboardController controller) => _showFeatureDialog("Add Supplier");
  static void _showStockReport(ManagerDashboardController controller) => _showFeatureDialog("Stock Report");
  static void _showPerformanceDetail(ManagerDashboardController controller) => _showFeatureDialog("Performance Analytics");
  static void _showPredictiveAnalytics(ManagerDashboardController controller) => _showFeatureDialog("Predictive Analytics");
  static void _showLogisticsTracking(ManagerDashboardController controller) => _showFeatureDialog("Logistics Tracking");
  static void _showCreateContract(ManagerDashboardController controller) => _showFeatureDialog("Create Contract");
  static void _showExportOptions(ManagerDashboardController controller) => _showFeatureDialog("Export Options");

  static void _showFeatureDialog(String featureName) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: ManagerDashboardView.kPrimaryColor),
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
  }