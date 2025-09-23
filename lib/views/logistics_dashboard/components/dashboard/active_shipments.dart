import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/logistics_dashboard_controller.dart';
import 'package:babi_industries/theme/logistics_theme.dart';

class ActiveShipments extends StatelessWidget {
  final LogisticsDashboardController controller;

  const ActiveShipments({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final double cardPadding = isWide ? 20 : 12;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(LogisticsTheme.kCardRadius),
          ),
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          "Active Shipments",
                          style: LogisticsTheme.cardTitleStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          TextButton.icon(
                            onPressed: () => _showCreateShipment(),
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
                  Obx(() {
                    if (controller.shipments.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("No active shipments"),
                        ),
                      );
                    }

                    final shipmentsToShow = controller.shipments.length > 5
                        ? controller.shipments.sublist(0, 5)
                        : controller.shipments;

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: shipmentsToShow.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final shipment = shipmentsToShow[index];
                        Color statusColor = _getStatusColor(shipment['status'] ?? 'pending');

                        return Container(
                          padding: EdgeInsets.all(isWide ? 16 : 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                shipment['shipment_id'] ?? 'SHP-000',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (shipment['priority'] == 'high' ||
                                                shipment['priority'] == 'urgent')
                                              const Padding(
                                                padding: EdgeInsets.only(left: 6),
                                                child: Icon(Icons.priority_high,
                                                    color: LogisticsTheme.kErrorColor, size: 16),
                                              ),
                                            if (shipment['gps_enabled'] == true)
                                              const Padding(
                                                padding: EdgeInsets.only(left: 4),
                                                child: Icon(Icons.gps_fixed,
                                                    color: LogisticsTheme.kSuccessColor, size: 14),
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
                                            Icon(Icons.location_on,
                                                size: 12,
                                                color: Colors.grey.shade600),
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
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          _getStatusDisplayText(
                                              shipment['status'] ?? 'pending'),
                                          style: TextStyle(
                                            color: statusColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      if (shipment['progress'] != null)
                                        Text(
                                          "${shipment['progress']}% complete",
                                          style: const TextStyle(
                                              fontSize: 11, color: Colors.grey),
                                        ),
                                      if (shipment['estimated_delivery'] != null)
                                        Text(
                                          "ETA: ${_formatTime(shipment['estimated_delivery'])}",
                                          style: const TextStyle(
                                              fontSize: 11, color: Colors.grey),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              if (shipment['driver'] != null) ...[
                                const SizedBox(height: 8),
                                Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  runSpacing: 4,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.person,
                                            size: 14, color: Colors.grey.shade600),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Driver: ${shipment['driver']}",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Icon(Icons.local_shipping,
                                            size: 14, color: Colors.grey.shade600),
                                        const SizedBox(width: 4),
                                        Text(
                                          shipment['vehicle'] ?? 'N/A',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
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
                                          onPressed: () =>
                                              controller.trackShipment(shipment['id']),
                                          icon: const Icon(Icons.map, size: 16),
                                          constraints: const BoxConstraints(),
                                          padding: const EdgeInsets.all(4),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                              if (shipment['progress'] != null &&
                                  shipment['progress'] > 0) ...[
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: shipment['progress'] / 100.0,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(statusColor),
                                    minHeight: 4,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return LogisticsTheme.kWarningColor;
      case 'in_transit':
        return LogisticsTheme.kInfoColor;
      case 'delivered':
        return LogisticsTheme.kSuccessColor;
      case 'delayed':
        return LogisticsTheme.kErrorColor;
      case 'cancelled':
        return Colors.grey;
      default:
        return LogisticsTheme.kPrimaryColor;
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
    try {
      return timestamp.substring(0, 10);
    } catch (e) {
      return timestamp;
    }
  }

  void _showCreateShipment() {
    Get.toNamed('/create-shipment');
  }

  void _contactCustomer(Map<String, dynamic> shipment) {
    // Handle customer contact
  }
}