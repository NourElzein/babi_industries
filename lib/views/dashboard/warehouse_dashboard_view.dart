import 'package:babi_industries/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class WarehouseDashboardView extends StatelessWidget {
  const WarehouseDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Warehouse Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {}, // no click action
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.grey.shade700),
          ),
          const SizedBox(width: 12),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
              crossAxisCount: size.width > 500 ? 4 : 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildKpiCard(Icons.inventory_2, "Total Items", "2,340", Colors.teal),
                _buildKpiCard(Icons.warning, "Low Stock", "14", Colors.orange),
                _buildKpiCard(Icons.local_shipping, "Incoming", "7", Colors.blue),
                _buildKpiCard(Icons.outbox, "Outgoing", "12", Colors.red),
              ],
            ),

            const SizedBox(height: 24),

            /// Stock Alert Section
            const Text(
              "Low Stock Alerts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildStockTile("Product A", "Only 5 left in stock!", Colors.orange),
            _buildStockTile("Product B", "Critical: Only 2 left!", Colors.red),
            _buildStockTile("Product C", "Low: 8 remaining", Colors.orange),

            const SizedBox(height: 24),

            /// Recent Movements
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
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) {}, // no click action
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Inventory"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Movements"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Reports"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  /// KPI Card Widget
  static Widget _buildKpiCard(IconData icon, String title, String value, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  /// Low Stock Tile
  static Widget _buildStockTile(String productName, String message, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.warning, color: color),
        title: Text(productName),
        subtitle: Text(message),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  /// Recent Movement Tile
  static Widget _buildMovementTile(String title, String details, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.swap_vert, color: color),
        title: Text(title),
        subtitle: Text(details),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
