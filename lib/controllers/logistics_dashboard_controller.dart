import 'package:flutter/material.dart' show Color;
import 'package:get/get.dart';
import 'package:babi_industries/controllers/auth_controller.dart';

class LogisticsDashboardController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  // Observable variables
  var isLoading = true.obs;
  var isLoadingShipments = false.obs;
  var errorMessage = ''.obs;
  var selectedIndex = 0.obs;
  
  // Dashboard metrics
  var activeShipments = 0.obs;
  var inTransit = 0.obs;
  var delivered = 0.obs;
  var completedToday = 0.obs;
  var delayed = 0.obs;
  var pendingPickup = 0.obs;
  var criticalAlerts = 0.obs;
  
  // Performance metrics
  var onTimeDeliveryRate = '95%'.obs;
  var avgDeliveryTime = '2.5 days'.obs;
  var customerSatisfaction = '4.8/5'.obs;
  var routeOptimization = '87%'.obs;
  
  // Data lists
  var shipments = [].obs;
  var notifications = [].obs;
  var liveShipments = [].obs;
  var recentActivities = [].obs;
  
  // Other
  var lastUpdate = 'Updated: Just now'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading(true);
      errorMessage('');
      
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock data - replace with actual API calls
      activeShipments(12);
      inTransit(8);
      delivered(4);
      completedToday(6);
      delayed(2);
      pendingPickup(3);
      criticalAlerts(2);
      
      // Mock shipments data
      shipments([
        {
          'id': 'SHP-001',
          'shipment_id': 'SHP-001',
          'customer': 'ABC Corporation',
          'origin': 'Warehouse A',
          'destination': 'Customer Site',
          'status': 'in_transit',
          'priority': 'high',
          'gps_enabled': true,
          'progress': 65,
          'estimated_delivery': '2023-12-15 14:30',
          'driver': 'John Doe',
          'vehicle': 'Truck-102'
        },
        {
          'id': 'SHP-002',
          'shipment_id': 'SHP-002',
          'customer': 'XYZ Ltd',
          'origin': 'Warehouse B',
          'destination': 'Retail Store',
          'status': 'pending',
          'priority': 'medium',
          'gps_enabled': false,
          'progress': 0,
          'estimated_delivery': '2023-12-16 10:00',
          'driver': 'Jane Smith',
          'vehicle': 'Van-205'
        },
        {
          'id': 'SHP-003',
          'shipment_id': 'SHP-003',
          'customer': 'Tech Solutions Inc',
          'origin': 'Distribution Center',
          'destination': 'Office Complex',
          'status': 'delayed',
          'priority': 'urgent',
          'gps_enabled': true,
          'progress': 30,
          'estimated_delivery': '2023-12-15 16:00',
          'driver': 'Mike Wilson',
          'vehicle': 'Truck-108'
        },
        {
          'id': 'SHP-004',
          'shipment_id': 'SHP-004',
          'customer': 'Retail Chain',
          'origin': 'Factory',
          'destination': 'Store Network',
          'status': 'out_for_delivery',
          'priority': 'medium',
          'gps_enabled': true,
          'progress': 85,
          'estimated_delivery': '2023-12-15 12:00',
          'driver': 'Sarah Johnson',
          'vehicle': 'Van-301'
        },
        {
          'id': 'SHP-005',
          'shipment_id': 'SHP-005',
          'customer': 'Medical Supplies Co',
          'origin': 'Pharmacy Warehouse',
          'destination': 'Hospital',
          'status': 'delivered',
          'priority': 'high',
          'gps_enabled': false,
          'progress': 100,
          'estimated_delivery': '2023-12-15 09:00',
          'driver': 'David Brown',
          'vehicle': 'Truck-205'
        },
      ]);
      
      // Mock notifications
      notifications([
        {
          'title': 'Delivery Delay',
          'message': 'Shipment SHP-003 is delayed due to weather conditions',
          'type': 'delay',
          'priority': 'high',
          'time': '10:30 AM',
          'action_required': true,
          'shipment_id': 'SHP-003'
        },
        {
          'title': 'Vehicle Maintenance',
          'message': 'Truck-104 requires scheduled maintenance',
          'type': 'issue',
          'priority': 'medium',
          'time': '09:15 AM',
          'action_required': false
        },
        {
          'title': 'Route Optimized',
          'message': 'Route A-12 has been optimized, saving 15 minutes',
          'type': 'route',
          'priority': 'low',
          'time': '08:45 AM',
          'action_required': false
        },
        {
          'title': 'Driver Check-in',
          'message': 'Driver John Doe checked in at checkpoint B',
          'type': 'arrival',
          'priority': 'low',
          'time': '08:15 AM',
          'action_required': false
        },
        {
          'title': 'Emergency Delivery',
          'message': 'Urgent medical supplies delivery requested',
          'type': 'issue',
          'priority': 'critical',
          'time': '07:30 AM',
          'action_required': true,
          'shipment_id': 'SHP-006'
        },
      ]);
      
      // Mock live tracking data
      liveShipments([
        {
          'id': 'SHP-001',
          'speed': '65 km/h',
          'heading': 'North-East',
          'location': 'Highway A1, Exit 15',
        },
        {
          'id': 'SHP-004',
          'speed': '45 km/h',
          'heading': 'South',
          'location': 'City Center, Main St',
        },
        {
          'id': 'SHP-003',
          'speed': '0 km/h',
          'heading': 'Stationary',
          'location': 'Rest Stop, Mile 23',
        },
      ]);
      
      // Mock recent activities
      recentActivities([
        {
          'title': 'New Shipment Created',
          'description': 'Shipment SHP-007 created for DEF Company',
          'type': 'shipment_created',
          'time': '11:45 AM'
        },
        {
          'title': 'Status Updated',
          'description': 'Shipment SHP-001 is now in transit',
          'type': 'status_changed',
          'time': '10:20 AM'
        },
        {
          'title': 'Delivery Completed',
          'description': 'Shipment SHP-005 delivered successfully to Medical Supplies Co',
          'type': 'delivery_completed',
          'time': '09:30 AM'
        },
        {
          'title': 'Route Optimization',
          'description': 'Route A-12 optimized for better efficiency',
          'type': 'route_optimized',
          'time': '08:45 AM'
        },
        {
          'title': 'Pickup Scheduled',
          'description': 'Pickup scheduled for new order from Tech Solutions Inc',
          'type': 'pickup_scheduled',
          'time': '08:00 AM'
        },
        {
          'title': 'Driver Assignment',
          'description': 'Driver Mike Wilson assigned to SHP-003',
          'type': 'shipment_updated',
          'time': '07:30 AM'
        },
      ]);
      
      lastUpdate('Updated: ${DateTime.now().toString().substring(11, 16)}');
    } catch (e) {
      errorMessage('Failed to load dashboard data: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  void refreshData() {
    fetchDashboardData();
  }

  void changeTab(int index) {
    selectedIndex(index);
  }

  // Navigation methods
  void navigateToShipmentManagement() {
    Get.toNamed('/shipments');
  }

  void navigateToTrackingMap() {
    Get.toNamed('/tracking-map');
  }

  void navigateToRouteOptimization() {
    Get.toNamed('/route-optimization');
  }

  void trackShipment(String? shipmentId) {
    if (shipmentId != null) {
      Get.toNamed('/track-shipment/$shipmentId');
    }
  }

  // Search functionality
  void searchShipments(String query) {
    // Simulate search functionality
    Get.snackbar(
      'Search Results',
      'Searching for: $query',
      duration: const Duration(seconds: 2),
    );
    // In a real app, this would filter the shipments list
    // You could implement actual search logic here
  }

  // Shipment management methods
  void createShipment(Map<String, dynamic> shipmentData) {
    try {
      // Simulate API call
      final newShipment = {
        'id': 'SHP-${DateTime.now().millisecondsSinceEpoch}',
        'shipment_id': 'SHP-${DateTime.now().millisecondsSinceEpoch}',
        'customer': shipmentData['customer'],
        'origin': shipmentData['origin'],
        'destination': shipmentData['destination'],
        'status': 'pending',
        'priority': shipmentData['priority'] ?? 'medium',
        'gps_enabled': false,
        'progress': 0,
        'estimated_delivery': DateTime.now().add(const Duration(days: 2)).toString(),
        'driver': 'Not Assigned',
        'vehicle': 'Not Assigned'
      };

      // Add to shipments list
      shipments.insert(0, newShipment);
      activeShipments.value++;
      pendingPickup.value++;

      // Add to recent activities
      recentActivities.insert(0, {
        'title': 'New Shipment Created',
        'description': 'Shipment ${newShipment['shipment_id']} created for ${shipmentData['customer']}',
        'type': 'shipment_created',
        'time': DateTime.now().toString().substring(11, 16)
      });

      Get.snackbar(
        'Success',
        'Shipment ${newShipment['shipment_id']} created successfully',
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFFFFFF),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create shipment: ${e.toString()}',
        backgroundColor: const Color(0xFFF44336),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }

  // Alert management
  void acknowledgeAlert(int alertIndex) {
    if (alertIndex < notifications.length) {
      notifications.removeAt(alertIndex);
      if (criticalAlerts.value > 0) {
        criticalAlerts.value--;
      }
      Get.snackbar('Alert Acknowledged', 'Alert has been marked as resolved');
    }
  }

  void dismissAllAlerts() {
    notifications.clear();
    criticalAlerts(0);
    Get.snackbar('All Alerts Dismissed', 'All alerts have been cleared');
  }

  // Status update methods
  void updateShipmentStatus(String shipmentId, String newStatus) {
    try {
      final shipmentIndex = shipments.indexWhere((s) => s['id'] == shipmentId);
      if (shipmentIndex != -1) {
        shipments[shipmentIndex]['status'] = newStatus;
        shipments.refresh();

        // Update counters based on status change
        _updateCountersForStatusChange(newStatus);

        // Add to recent activities
        recentActivities.insert(0, {
          'title': 'Status Updated',
          'description': 'Shipment $shipmentId status changed to $newStatus',
          'type': 'status_changed',
          'time': DateTime.now().toString().substring(11, 16)
        });

        Get.snackbar('Status Updated', 'Shipment $shipmentId is now $newStatus');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update shipment status: ${e.toString()}');
    }
  }

  void _updateCountersForStatusChange(String newStatus) {
    // This is a simplified counter update - in a real app, you'd recalculate from the actual data
    switch (newStatus.toLowerCase()) {
      case 'in_transit':
        inTransit.value++;
        break;
      case 'delivered':
        delivered.value++;
        completedToday.value++;
        break;
      case 'delayed':
        delayed.value++;
        break;
    }
  }

  // Driver and vehicle assignment
  void assignDriverToShipment(String shipmentId, String driverId) {
    try {
      final shipmentIndex = shipments.indexWhere((s) => s['id'] == shipmentId);
      if (shipmentIndex != -1) {
        shipments[shipmentIndex]['driver'] = driverId;
        shipments.refresh();

        recentActivities.insert(0, {
          'title': 'Driver Assigned',
          'description': 'Driver $driverId assigned to shipment $shipmentId',
          'type': 'shipment_updated',
          'time': DateTime.now().toString().substring(11, 16)
        });

        Get.snackbar('Driver Assigned', 'Driver $driverId assigned to shipment $shipmentId');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to assign driver: ${e.toString()}');
    }
  }

  // Route optimization
  void optimizeRoute(String routeId) {
    try {
      // Simulate route optimization
      Get.snackbar('Route Optimization', 'Optimizing route $routeId...');
      
      Future.delayed(const Duration(seconds: 2), () {
        recentActivities.insert(0, {
          'title': 'Route Optimized',
          'description': 'Route $routeId optimized successfully, saving 12 minutes',
          'type': 'route_optimized',
          'time': DateTime.now().toString().substring(11, 16)
        });

        Get.snackbar(
          'Optimization Complete',
          'Route $routeId optimized successfully',
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xFFFFFFFF),
        );
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to optimize route: ${e.toString()}');
    }
  }

  // Report generation
  void generateReport(DateTime? startDate, DateTime? endDate) {
    try {
      final start = startDate ?? DateTime.now().subtract(const Duration(days: 30));
      final end = endDate ?? DateTime.now();
      
      Get.snackbar(
        'Generating Report',
        'Creating logistics report from ${start.toString().substring(0, 10)} to ${end.toString().substring(0, 10)}',
      );

      // Simulate report generation
      Future.delayed(const Duration(seconds: 3), () {
        Get.snackbar(
          'Report Ready',
          'Logistics report has been generated and sent to your email',
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xFFFFFFFF),
        );
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate report: ${e.toString()}');
    }
  }

  // Utility methods for data filtering and sorting
  List getShipmentsByStatus(String status) {
    return shipments.where((shipment) => shipment['status'] == status).toList();
  }

  List getShipmentsByPriority(String priority) {
    return shipments.where((shipment) => shipment['priority'] == priority).toList();
  }

  List getDelayedShipments() {
    return shipments.where((shipment) => shipment['status'] == 'delayed').toList();
  }

  List getCriticalNotifications() {
    return notifications.where((notification) => 
        notification['priority'] == 'high' || notification['priority'] == 'critical'
    ).toList();
  }

  // Performance calculation methods
  double calculateOnTimeDeliveryRate() {
    if (shipments.isEmpty) return 0.0;
    final deliveredShipments = getShipmentsByStatus('delivered');
    final onTimeDeliveries = deliveredShipments.where((s) => s['on_time'] == true).length;
    return (onTimeDeliveries / deliveredShipments.length) * 100;
  }

  void updatePerformanceMetrics() {
    // Recalculate performance metrics based on current data
    final onTimeRate = calculateOnTimeDeliveryRate();
    onTimeDeliveryRate('${onTimeRate.toStringAsFixed(1)}%');
    
    // Update last refresh time
    lastUpdate('Updated: ${DateTime.now().toString().substring(11, 16)}');
  }

  @override
  void onClose() {
    super.onClose();
    // Clean up any resources if needed
  }
}