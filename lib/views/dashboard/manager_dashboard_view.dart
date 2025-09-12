import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerDashboardView extends StatelessWidget {
  const ManagerDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Manager Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF3B82F6),
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
              "Key Metrics",
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
                _buildKpiCard(Icons.factory, "Suppliers", "50", Colors.blue),
                _buildKpiCard(Icons.inventory, "Active Orders", "23", Colors.green),
                _buildKpiCard(Icons.check_circle, "Stock Health", "78%", Colors.orange),
                _buildKpiCard(Icons.access_time, "Delayed Orders", "4", Colors.red),
              ],
            ),

            const SizedBox(height: 24),

            /// --- Charts Section ---
            const Text(
              "Performance Insights",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildChartCard(
              title: "Supplier Performance",
              description: "Top 5 suppliers based on score",
            ),
            const SizedBox(height: 12),
            _buildChartCard(
              title: "Inventory Trends",
              description: "Stock levels over time",
            ),

            const SizedBox(height: 24),

            /// --- Alerts Section ---
            const Text(
              "Alerts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildAlertCard(Icons.warning, "Low Stock", "Product A is below threshold", Colors.orange),
                  _buildAlertCard(Icons.access_time, "Late Delivery", "Order #123 is delayed", Colors.red),
                  _buildAlertCard(Icons.error_outline, "Anomaly", "Unusual order spike detected", Colors.blueGrey),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// --- Recent Activity Section ---
            const Text(
              "Recent Activity",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildActivityTile(Icons.check_circle, "Order #234 marked as shipped", "2 hours ago"),
            _buildActivityTile(Icons.factory, "New supplier added: ABC Corp", "Yesterday"),
            _buildActivityTile(Icons.inventory, "PO #56 created", "2 days ago"),
          ],
        ),
      ),

      /// --- Bottom Navigation Bar ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF3B82F6),
        unselectedItemColor: Colors.grey,
        onTap: (index) {}, // No action yet
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.factory), label: "Suppliers"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Reports"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  /// --- Widgets for Reuse ---

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

  static Widget _buildChartCard({required String title, required String description}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(description, style: const TextStyle(color: Colors.grey)),
            const Spacer(),
            Center(
              child: Icon(Icons.show_chart, color: Colors.grey.shade400, size: 60),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  static Widget _buildAlertCard(IconData icon, String title, String message, Color color) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        color: color.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Text(message, style: const TextStyle(color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildActivityTile(IconData icon, String text, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF3B82F6)),
        title: Text(text),
        subtitle: Text(time),
      ),
    );
  }
}
