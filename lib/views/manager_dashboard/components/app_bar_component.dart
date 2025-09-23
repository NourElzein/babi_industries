import 'package:babi_industries/controllers/manager_dashboard_controller.dart';
import 'package:babi_industries/views/dashboard/warehouse_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/views/dashboard/manager_dashboard_view.dart';
class AppBarComponent {
  static AppBar buildAppBar(ManagerDashboardController controller, bool isMobile) {
    final user = controller.authController.currentUser.value;
    
    return AppBar(
      backgroundColor: ManagerDashboardView.kPrimaryColor,
      elevation: 0,
      titleSpacing: isMobile ? 8 : 16,
      title: isMobile 
          ? _buildMobileAppBarTitle(user)
          : _buildDesktopAppBarTitle(user),
      actions: _buildResponsiveAppBarActions(controller, isMobile),
    );
  }

  static Widget _buildMobileAppBarTitle(dynamic user) {
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

static Widget _buildDesktopAppBarTitle(dynamic user) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircleAvatar(
        radius: 20,
        backgroundImage: user?.profileImage != null
            ? NetworkImage(user!.profileImage!) // use image if available
            : null, // no image
        child: user?.profileImage == null
            ? const Icon(Icons.person, size: 20) // fallback icon
            : null,
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

  static List<Widget> _buildResponsiveAppBarActions(ManagerDashboardController controller, bool isMobile) {
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
                    color: ManagerDashboardView.kErrorColor,
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

  static void _handleAppBarMenuAction(String value, ManagerDashboardController controller) {
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

  // Dialog and Sheet Methods
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

  static void _showExportOptions(ManagerDashboardController controller) {
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

  static void _exportReport(String format, ManagerDashboardController controller) {
    Get.back();
    Get.snackbar(
      "Export Started",
      "Your $format report is being generated and will be downloaded shortly.",
      backgroundColor: ManagerDashboardView.kAccentColor,
      colorText: Colors.white,
      icon: const Icon(Icons.download, color: Colors.white),
    );
  }

  static void _showDashboardSettings(ManagerDashboardController controller) {
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

  // Responsive Notifications Dialog
  static void _showResponsiveNotifications(BuildContext context, ManagerDashboardController controller) {
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
                  color: ManagerDashboardView.kPrimaryColor,
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
                        style: ElevatedButton.styleFrom(backgroundColor: ManagerDashboardView.kPrimaryColor),
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
                    color: ManagerDashboardView.kPrimaryColor,
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
                        style: ElevatedButton.styleFrom(backgroundColor: ManagerDashboardView.kPrimaryColor),
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
  static Color _getNotificationColor(String? colorString) {
    switch ((colorString ?? '').toLowerCase()) {
      case 'error':
      case 'red':
        return ManagerDashboardView.kErrorColor;
      case 'warning':
      case 'orange':
        return ManagerDashboardView.kWarningColor;
      case 'accent':
      case 'green':
        return ManagerDashboardView.kAccentColor;
      case 'secondary':
      case 'blue':
        return ManagerDashboardView.kSecondaryColor;
      default:
        return ManagerDashboardView.kPrimaryColor;
    }
  }
}