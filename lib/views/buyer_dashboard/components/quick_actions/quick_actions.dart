import 'package:flutter/material.dart';
import 'package:babi_industries/theme/app_colors.dart';
import 'package:babi_industries/views/buyer_dashboard/utils/dialog_utils.dart';
import 'package:babi_industries/controllers/buyer_dashboard_controller.dart';

class QuickActions extends StatelessWidget {
  final BuyerDashboardController controller;

  const QuickActions({Key? key, required this.controller}) : super(key: key);

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
            Row(
              children: [
                const Icon(Icons.flash_on, color: AppColors.kPrimaryColor),
                const SizedBox(width: 8),
                const Flexible(
                  child: Text(
                    "Quick Actions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => DialogUtils.showFeatureDialog('All Quick Actions'),
                  child: const Text("More", style: TextStyle(color: AppColors.kPrimaryColor)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
                
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.2,
                  children: [
                    _buildQuickActionItem(
                      Icons.add_shopping_cart,
                      "Create Order",
                      AppColors.kPrimaryColor,
                      () => DialogUtils.showQuickOrderDialog(controller),
                    ),
                    _buildQuickActionItem(
                      Icons.content_copy,
                      "Duplicate Order",
                      AppColors.kSecondaryColor,
                      () => DialogUtils.showFeatureDialog('Duplicate Order'),
                    ),
                    _buildQuickActionItem(
                      Icons.business_center,
                      "Find Suppliers",
                      AppColors.kInfoColor,
                      () => DialogUtils.showSearchDialog(controller),
                    ),
                    _buildQuickActionItem(
                      Icons.compare_arrows,
                      "Compare Prices",
                      AppColors.kPurpleColor,
                      () => controller.navigateToPriceComparison(),
                    ),
                    _buildQuickActionItem(
                      Icons.receipt_long,
                      "Generate Report",
                      AppColors.kWarningColor,
                      () => controller.navigateToReports(),
                    ),
                    _buildQuickActionItem(
                      Icons.chat,
                      "Contact Supplier",
                      AppColors.kAccentColor,
                      () => DialogUtils.showFeatureDialog('Contact Supplier'),
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

  int _getCrossAxisCount(double width) {
    if (width < 400) return 2;
    if (width < 600) return 3;
    return 4;
  }

  Widget _buildQuickActionItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
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
                Icon(icon, color: color, size: isSmall ? 20 : 24),
                SizedBox(height: isSmall ? 4 : 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: isSmall ? 9 : 11,
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
}