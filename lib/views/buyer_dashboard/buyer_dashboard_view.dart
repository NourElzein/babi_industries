import 'package:babi_industries/controllers/buyer_dashboard_controller.dart';
import 'package:babi_industries/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import all separated widgets
import '../buyer_dashboard/widgets/buyer_dashboard_appbar.dart';
import '../buyer_dashboard/widgets/buyer_dashboard_sidebar.dart';
import '../buyer_dashboard/widgets/buyer_dashboard_bottom_nav.dart';
import '../buyer_dashboard/widgets/buyer_dashboard_content.dart';
import '../buyer_dashboard/widgets/buyer_dashboard_error_view.dart';
import '../buyer_dashboard/widgets/buyer_dashboard_loading_view.dart';
import '../buyer_dashboard/widgets/buyer_dashboard_dialogs.dart';

class BuyerDashboardView extends StatelessWidget {
  const BuyerDashboardView({Key? key}) : super(key: key);

  // Color scheme for buyer dashboard
  static const kPrimaryColor = Color(0xFF2E7D32);
  static const kSecondaryColor = Color(0xFF4CAF50);
  static const kAccentColor = Color(0xFF66BB6A);
  static const kWarningColor = Color(0xFFFF9800);
  static const kErrorColor = Color(0xFFF44336);
  static const kInfoColor = Color(0xFF2196F3);
  static const kPurpleColor = Color(0xFF9C27B0);
  static const kBackgroundColor = Color(0xFFF5F7FA);
  static const kCardRadius = 16.0;
  static const kPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BuyerDashboardController());
    final Size size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 768;
    final bool isTablet = size.width >= 768 && size.width < 1024;
    final bool isDesktop = size.width >= 1024;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: isMobile ? BuyerDashboardAppBar.buildMobileAppBar(controller) : null,
      drawer: isMobile ? BuyerDashboardSidebar.buildMobileDrawer(controller) : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const BuyerDashboardLoadingView();
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return BuyerDashboardErrorView(controller: controller);
        }

        return isMobile 
            ? BuyerDashboardContent.buildMobileView(controller)
            : isDesktop
                ? BuyerDashboardContent.buildDesktopView(controller)
                : BuyerDashboardContent.buildTabletView(controller);
      }),
      bottomNavigationBar: isMobile ? BuyerDashboardBottomNav.buildBottomNavigation(controller) : null,
      floatingActionButton: BuyerDashboardContent.buildFloatingActionButton(controller),
    );
  }
}