import 'package:flutter/material.dart';
import 'package:babi_industries/theme/app_colors.dart';

class WelcomeHeader extends StatelessWidget {
  final int activeSuppliers;
  final int weeklyOrderCount;

  const WelcomeHeader({
    Key? key,
    required this.activeSuppliers,
    required this.weeklyOrderCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.kSecondaryColor, AppColors.kAccentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppColors.kCardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.kSecondaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 400;
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.person_outline, color: Colors.white, size: isSmall ? 24 : 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back, buyer!",
                      style: TextStyle(
                        fontSize: isSmall ? 16 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Ready to streamline your procurement process?",
                      style: TextStyle(fontSize: isSmall ? 12 : 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: isSmall ? 12 : 20,
                      children: [
                        _buildHeaderStat(activeSuppliers.toString(), "Active Suppliers"),
                        _buildHeaderStat(weeklyOrderCount.toString(), "Orders This Week"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}