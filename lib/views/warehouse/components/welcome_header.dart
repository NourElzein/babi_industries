import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babi_industries/controllers/warehouse_controller.dart';
import 'package:babi_industries/theme/warehouse_colors.dart';

class WelcomeHeader extends StatelessWidget {
  final WarehouseController controller;

  const WelcomeHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: _buildDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIcon(),
          const SizedBox(width: 20),
          _buildContent(),
        ],
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [WarehouseColors.secondaryColor, WarehouseColors.accentColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(WarehouseColors.cardRadius),
      boxShadow: [
        BoxShadow(
          color: WarehouseColors.secondaryColor.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Icon(Icons.warehouse_outlined, color: Colors.white, size: 32),
    );
  }

  Widget _buildContent() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: 8),
          _buildSubtitle(),
          const SizedBox(height: 12),
          _buildStats(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        "Welcome back, warehouse manager!",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return const FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        "Ready to optimize your inventory management?",
        style: TextStyle(fontSize: 14, color: Colors.white70),
      ),
    );
  }

  Widget _buildStats() {
    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatItem(controller.movementsToday.value.toString(), "Movements Today"),
          const SizedBox(width: 20),
          _buildStatItem(controller.scansToday.value.toString(), "Scans Today"),
        ],
      ),
    ));
  }

  Widget _buildStatItem(String value, String label) {
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