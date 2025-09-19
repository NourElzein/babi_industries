import 'package:babi_industries/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarehouseDashboardView extends StatelessWidget {
  const WarehouseDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isLargeScreen = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Warehouse Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.grey.shade800),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Greeting
            Text(
              "Welcome, ${Get.find<AuthController>().currentUser.value?.name ?? 'Warehouse Manager'}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            /// KPI Section
            const Text(
              "Inventory Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: isLargeScreen ? 4 : 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.1,
              children: [
                _buildKpiCard(Icons.inventory_2, "Total Items", "2,340", Colors.teal),
                _buildKpiCard(Icons.warning, "Low Stock", "14", Colors.orange),
                _buildKpiCard(Icons.local_shipping, "Incoming", "7", Colors.blue),
                _buildKpiCard(Icons.outbox, "Outgoing", "12", Colors.red),
              ],
            ),
            const SizedBox(height: 28),

            /// Low Stock Alerts
            const Text(
              "Low Stock Alerts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildStockTile("Product A", "Only 5 left in stock!", Colors.orange),
            _buildStockTile("Product B", "Critical: Only 2 left!", Colors.red),
            _buildStockTile("Product C", "Low: 8 remaining", Colors.orange),
            const SizedBox(height: 28),

            /// Recent Stock Movements
            const Text(
              "Recent Stock Movements",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildMovementTile("Shipment #123", "Received • 50 Units", Colors.green),
            _buildMovementTile("Shipment #119", "Dispatched • 30 Units", Colors.red),
            _buildMovementTile("Adjustment", "Added • 10 Units (Inventory Correction)", Colors.blue),
          ],
        ),
      ),

      /// Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.teal.shade700,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_outlined), label: "Inventory"),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz_outlined), label: "Movements"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: "Reports"),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "Settings"),
        ],
      ),
    );
  }

  /// KPI Card Widget
  static Widget _buildKpiCard(IconData icon, String title, String value, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 14),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  /// Low Stock Tile
  static Widget _buildStockTile(String productName, String message, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Icon(Icons.warning, color: color, size: 28),
        title: Text(productName, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(message, style: TextStyle(color: Colors.grey.shade600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }

  /// Recent Movement Tile
  static Widget _buildMovementTile(String title, String details, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Icon(Icons.swap_vert, color: color, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(details, style: TextStyle(color: Colors.grey.shade600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}
