import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/logistics_dashboard_controller.dart';
import 'package:babi_industries/theme/logistics_theme.dart';

class LiveTracking extends StatelessWidget {
  final LogisticsDashboardController controller;

  const LiveTracking({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LogisticsTheme.kCardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(LogisticsTheme.kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Live Tracking",
                  style: LogisticsTheme.cardTitleStyle,
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
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    LogisticsTheme.kPrimaryColor.withOpacity(0.1),
                    LogisticsTheme.kSecondaryColor.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: LogisticsTheme.kPrimaryColor.withOpacity(0.3)),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 24, color: LogisticsTheme.kPrimaryColor),
                        SizedBox(height: 5),
                        Text(
                          "Live GPS Tracking Map",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: LogisticsTheme.kPrimaryColor,
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
                        color: LogisticsTheme.kSuccessColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: LogisticsTheme.kSuccessColor,
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
            const SizedBox(height: 16),
            Obx(() {
              if (controller.liveShipments.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text("No live shipments right now."),
                  ),
                );
              }

              return SizedBox(
                height: (controller.liveShipments.length * 50.0).clamp(0, 110),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemCount: controller.liveShipments.length,
                    itemBuilder: (context, index) {
                      final shipment = controller.liveShipments[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: LogisticsTheme.kSuccessColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: LogisticsTheme.kSuccessColor,
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
                            const Text(
                              "Live",
                              style: TextStyle(
                                fontSize: 10,
                                color: LogisticsTheme.kSuccessColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}