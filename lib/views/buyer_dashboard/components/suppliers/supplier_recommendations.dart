import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/theme/app_colors.dart';
import 'package:babi_industries/controllers/buyer_dashboard_controller.dart';
import 'package:babi_industries/views/buyer_dashboard/utils/dialog_utils.dart';

class SupplierRecommendations extends StatelessWidget {
  final BuyerDashboardController controller;
  final bool showExplore;

  const SupplierRecommendations({
    Key? key,
    required this.controller,
    this.showExplore = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildSupplierRecommendations(controller);
  }

  Widget _buildSupplierRecommendations(BuyerDashboardController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.kCardRadius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Determine if we're on mobile based on available width
          final isMobile = constraints.maxWidth < 600;
          final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
          
          return Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "Recommended Suppliers",
                        style: TextStyle(
                          fontSize: isMobile ? 14 : (isTablet ? 16 : 18),
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (showExplore)
                      TextButton(
                        onPressed: () => controller.navigateToSuppliers(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 8 : 12,
                            vertical: isMobile ? 4 : 8,
                          ),
                          minimumSize: Size(isMobile ? 60 : 80, isMobile ? 32 : 40),
                        ),
                        child: Text(
                          isMobile ? "View" : "Explore",
                          style: TextStyle(
                            color: AppColors.kPrimaryColor,
                            fontSize: isMobile ? 12 : 14,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: isMobile ? 8 : 16),

                // Suppliers List
                Obx(() {
                  if (controller.isLoadingSuppliers.value) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(isMobile ? 16 : 20),
                        child: SizedBox(
                          width: isMobile ? 20 : 24,
                          height: isMobile ? 20 : 24,
                          child: const CircularProgressIndicator(
                            color: AppColors.kPrimaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    );
                  }

                  if (controller.suggestedSuppliers.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(isMobile ? 12 : 20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.business_outlined,
                              size: isMobile ? 28 : 40,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: isMobile ? 4 : 8),
                            Text(
                              "No supplier recommendations available",
                              style: TextStyle(
                                fontSize: isMobile ? 11 : 14,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Calculate responsive dimensions
                  final itemHeight = isMobile ? 70.0 : (isTablet ? 85.0 : 100.0);
                  final maxItems = isMobile ? 3 : 4;
                  final itemCount = controller.suggestedSuppliers.length > maxItems 
                      ? maxItems 
                      : controller.suggestedSuppliers.length;
                  final separatorHeight = isMobile ? 8.0 : 12.0;
                  final calculatedHeight = (itemHeight * itemCount) + ((itemCount - 1) * separatorHeight);
                  final maxHeight = isMobile ? 220.0 : (isTablet ? 280.0 : 320.0);
                  final containerHeight = calculatedHeight > maxHeight ? maxHeight : calculatedHeight;

                  return SizedBox(
                    height: containerHeight,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: itemCount,
                      separatorBuilder: (context, index) => SizedBox(height: separatorHeight),
                      itemBuilder: (context, index) {
                        final supplier = controller.suggestedSuppliers[index];
                        return _buildSupplierRecommendationTile(
                          supplier.name,
                          supplier.category,
                          supplier.badge,
                          supplier.badgeColor,
                          supplier.performance,
                          supplier.totalOrders,
                          isMobile: isMobile,
                          isTablet: isTablet,
                          onTap: () => _showSupplierDetails(supplier),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          );
        },
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
    bool isMobile = false,
    bool isTablet = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 10 : (isTablet ? 14 : 16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
          border: Border.all(
            color: Colors.grey.shade200,
            width: isMobile ? 0.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(isMobile ? 0.08 : 0.1),
              blurRadius: isMobile ? 2 : 4,
              offset: Offset(0, isMobile ? 1 : 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name + Badge Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 12 : (isTablet ? 13 : 14),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: isMobile ? 1 : 2,
                      ),
                      SizedBox(height: isMobile ? 2 : 4),
                      Text(
                        category,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: isMobile ? 10 : (isTablet ? 11 : 12),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isMobile ? 6 : 8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 6 : 8,
                    vertical: isMobile ? 2 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(isMobile ? 4 : 6),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      color: badgeColor,
                      fontSize: isMobile ? 8 : 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 6 : (isTablet ? 8 : 12)),

            // Performance + Orders Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Text(
                    "$performance performance",
                    style: TextStyle(
                      fontSize: isMobile ? 10 : (isTablet ? 11 : 12),
                      fontWeight: FontWeight.w500,
                      color: isMobile ? Colors.grey.shade700 : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: isMobile ? 4 : 8),
                Flexible(
                  child: Text(
                    orders,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isMobile ? 9 : (isTablet ? 10 : 12),
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSupplierDetails(supplier) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Supplier Details',
          style: TextStyle(
            fontSize: Get.width < 600 ? 16 : 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction, 
              size: Get.width < 600 ? 36 : 48, 
              color: Colors.orange.shade400,
            ),
            SizedBox(height: Get.width < 600 ? 12 : 16),
            Text(
              'Supplier details view is currently under development.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Get.width < 600 ? 12 : 14,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kPrimaryColor,
              minimumSize: Size(Get.width < 600 ? 60 : 80, Get.width < 600 ? 36 : 40),
            ),
            child: Text(
              'OK',
              style: TextStyle(
                color: Colors.white,
                fontSize: Get.width < 600 ? 12 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}