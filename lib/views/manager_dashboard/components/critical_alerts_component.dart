import 'package:babi_industries/controllers/manager_dashboard_controller.dart';
import 'package:babi_industries/views/dashboard/manager_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CriticalAlertsComponent {
  static Widget buildCriticalAlerts(ManagerDashboardController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManagerDashboardView.kCardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ManagerDashboardView.kPadding),
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
                        color: ManagerDashboardView.kErrorColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${controller.alerts.length} alerts",
                        style: const TextStyle(
                          color: ManagerDashboardView.kErrorColor,
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
                        Icon(Icons.check_circle, color: ManagerDashboardView.kAccentColor, size: 48),
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
                    final color = priority == 'high' ? ManagerDashboardView.kErrorColor : 
                                 priority == 'medium' ? ManagerDashboardView.kWarningColor : ManagerDashboardView.kAccentColor;
                    
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
                                color: ManagerDashboardView.kAccentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.lightbulb_outline, color: ManagerDashboardView.kAccentColor, size: 16),
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

  static IconData _getAlertIcon(String? type) {
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

  static void _handleAlertAction(Map<String, dynamic> alert) {
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

  static void _showAlertSettings(ManagerDashboardController controller) => _showFeatureDialog("Alert Configuration");
  static void _showAllAlerts(ManagerDashboardController controller) => _showFeatureDialog("All System Alerts");
  static void _showReorderProduct(int index) => _showFeatureDialog("Reorder Product");
  static void _showContactSupplier(String? supplierId) => _showFeatureDialog("Contact Supplier");
  static void _showContractDetails(dynamic contractId) => _showFeatureDialog("Contract Details");
  static void _showAlertDetails(Map<String, dynamic> alert) => _showFeatureDialog("Alert Details");

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