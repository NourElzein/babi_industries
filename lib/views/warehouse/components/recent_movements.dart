import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/warehouse_controller.dart';
import 'package:babi_industries/theme/warehouse_colors.dart';
import 'package:babi_industries/services/dialog_service.dart';

class RecentMovements extends StatelessWidget {
  final WarehouseController controller;

  const RecentMovements({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WarehouseColors.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildMovementsList(),
          ],
        ),
      ),
    );
  }

Widget _buildHeader() {
  return Row(
    children: [
      // Title on the left
      Expanded(
        child: Text(
          "Recent Movements",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis, // prevents overflow
        ),
      ),

      // Buttons on the right
      Row(
        mainAxisSize: MainAxisSize.min, // shrink to fit content
        children: [
          IconButton(
            onPressed: () => DialogService.showFeatureDialog('Movement Filters'),
            icon: const Icon(Icons.filter_list, size: 20),
            padding: EdgeInsets.zero, // optional: reduce extra padding
            constraints: const BoxConstraints(), // optional: tighter sizing
          ),
          TextButton(
            onPressed: () => controller.navigateToMovements(),
            child: const Text(
              "View All",
              style: TextStyle(color: WarehouseColors.primaryColor),
            ),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildMovementsList() {
    return Obx(() {
      if (controller.recentMovements.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text("No recent movements found"),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.recentMovements.length > 5 ? 5 : controller.recentMovements.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final movement = controller.recentMovements[index];
          return _buildMovementTile(
            movement["title"] ?? 'Movement',
            movement["details"] ?? 'No details',
            _getMovementColor(movement["color"]),
            movement["timestamp"] != null 
                ? _formatDateTime(movement["timestamp"]) 
                : 'Unknown',
            onTap: () => DialogService.showFeatureDialog('Movement Details'),
          );
        },
      );
    });
  }

  Widget _buildMovementTile(
    String title,
    String details,
    Color statusColor,
    String time, {
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
                  title,
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
                    "Movement",
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
            Text(
              details,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey.shade400),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getMovementColor(String? colorString) {
    switch ((colorString ?? '').toLowerCase()) {
      case 'green': return WarehouseColors.accentColor;
      case 'red': return WarehouseColors.errorColor;
      case 'blue': return WarehouseColors.infoColor;
      case 'orange': return WarehouseColors.warningColor;
      default: return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) return "Just now";
    if (difference.inHours < 1) return "${difference.inMinutes} min ago";
    if (difference.inHours < 24) return "${difference.inHours} hours ago";
    return "${difference.inDays} days ago";
  }
}