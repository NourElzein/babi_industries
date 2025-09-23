import 'package:flutter/material.dart';
import 'package:babi_industries/theme/app_colors.dart';

class OrderTimeline extends StatelessWidget {
  const OrderTimeline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.kCardRadius)),
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
              AppColors.kAccentColor,
            ),
            _buildTimelineItem(
              "Order Confirmed",
              "Supplier confirmed delivery date",
              "1 hour ago",
              true,
              AppColors.kAccentColor,
            ),
            _buildTimelineItem(
              "Processing",
              "Order is being prepared",
              "In progress",
              false,
              AppColors.kWarningColor,
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
}