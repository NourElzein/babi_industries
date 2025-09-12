import 'package:flutter/material.dart';
import 'package:get/get.dart';
class BuyerDashboardView extends StatelessWidget {
  const BuyerDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Buyer Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {}, // No action
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

            /// --- KPI Section ---
            const Text(
              "Purchase Overview",
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
                _buildKpiCard(Icons.shopping_cart, "Orders", "12", Colors.green),
                _buildKpiCard(Icons.pending_actions, "Pending", "5", Colors.orange),
                _buildKpiCard(Icons.local_shipping, "Delivered", "7", Colors.blue),
                _buildKpiCard(Icons.cancel, "Cancelled", "1", Colors.red),
              ],
            ),

            const SizedBox(height: 24),

            /// --- Suggested Suppliers ---
            const Text(
              "Suggested Suppliers",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildSupplierCard("ABC Corp", "Fast Delivery"),
                  _buildSupplierCard("FreshMart", "High Quality"),
                  _buildSupplierCard("Global Foods", "Trusted Partner"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// --- Recent Orders ---
            const Text(
              "Recent Orders",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildOrderTile("Order #202", "3 items • Pending", Colors.orange),
            _buildOrderTile("Order #198", "5 items • Delivered", Colors.green),
            _buildOrderTile("Order #190", "2 items • Cancelled", Colors.red),
          ],
        ),
      ),

      /// --- Bottom Navigation Bar ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {}, // No action
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Suppliers"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Reports"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  /// --- Reusable Widgets ---
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

  static Widget _buildSupplierCard(String name, String subtitle) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.store, color: Colors.green, size: 28),
              const SizedBox(height: 8),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildOrderTile(String orderId, String status, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.receipt_long, color: color),
        title: Text(orderId),
        subtitle: Text(status),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
