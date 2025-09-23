  import 'package:babi_industries/views/buyer_dashboard/buyer_dashboard_view.dart';
import 'package:flutter/material.dart';

class BuyerDashboardLoadingView extends StatelessWidget {
  const BuyerDashboardLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: BuyerDashboardView.kPrimaryColor),
          SizedBox(height: 16),
          Text('Loading procurement data...'),
        ],
      ),
    );
  }
}