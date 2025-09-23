import 'package:flutter/material.dart';
import 'package:babi_industries/theme/logistics_theme.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: LogisticsTheme.kPrimaryColor),
          SizedBox(height: 16),
          Text('Loading logistics data...'),
        ],
      ),
    );
  }
}