import 'package:babi_industries/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class LogisticsDashboardView extends StatelessWidget {
  const LogisticsDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Logistics Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {}, // no action
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
              "Welcome, ${Get.find<AuthController>().currentUser.value?.name ?? 'Coordinator'}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            /// KPI Overview
            const Text(
              "Logistics Overview",
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
                _buildKpiCard(Icons.local_shipping, "Active Shipments", "8", Colors.deepPurple),
                _buildKpiCard(Icons.pending_actions, "Delayed", "2", Colors.orange),
                _buildKpiCard(Icons.check_circle, "Delivered", "15", Colors.green),
                _buildKpiCard(Icons.warning_amber_rounded, "Incidents", "1", Colors.red),
              ],
            ),

            const SizedBox(height: 24),

            /// Map & Tracking (static placeholder)
            const Text(
              "Live Tracking Snapshot",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(Icons.map, size: 80, color: Colors.deepPurple),
              ),
            ),

            const SizedBox(height: 24),

            /// Recent Shipments
            const Text(
              "Recent Shipments",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildShipmentTile("Shipment #541", "In Transit • ETA: 2h", Colors.deepPurple),
            _buildShipmentTile("Shipment #536", "Delivered • On Time", Colors.green),
            _buildShipmentTile("Shipment #530", "Delayed • Traffic Incident", Colors.orange),
          ],
        ),
      ),

      /// Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) {}, // no action
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping), label: "Shipments"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Tracking"),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: "Reports"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  /// KPI card widget
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

  /// Shipment list tile
  static Widget _buildShipmentTile(String shipmentId, String status, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.local_shipping, color: color),
        title: Text(shipmentId),
        subtitle: Text(status),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
