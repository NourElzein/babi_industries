import 'package:get/get.dart';
import 'package:babi_industries/controllers/auth_controller.dart';

class LogisticsDashboardController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  // Observable variables
  var isLoading = true.obs;
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
        // Add more mock data as needed
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
      ]);
      
      // Mock live tracking data
      liveShipments([
        {
          'id': 'SHP-001',
          'speed': '65 km/h',
          'heading': 'North-East',
          'location': 'Lat: 40.7128, Long: -74.0060'
        },
        {
          'id': 'SHP-004',
          'speed': '55 km/h',
          'heading': 'South',
          'location': 'Lat: 34.0522, Long: -118.2437'
        },
      ]);
      
      // Mock recent activities
      recentActivities([
        {
          'title': 'New Shipment Created',
          'description': 'Shipment SHP-005 created for DEF Company',
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
          'description': 'Shipment SHP-006 delivered successfully',
          'type': 'delivery_completed',
          'time': '09:30 AM'
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

  void navigateToShipmentManagement() {
    Get.toNamed('/shipments');
  }

  void navigateToTrackingMap() {
    Get.toNamed('/tracking-map');
  }

  void navigateToRouteOptimization() {
    Get.toNamed('/route-optimization');
  }

  void trackShipment(String shipmentId) {
    Get.toNamed('/track-shipment/$shipmentId');
  }

  // Additional methods for handling specific actions
  void acknowledgeAlert(int alertId) {
    // Handle alert acknowledgement
    criticalAlerts(criticalAlerts.value - 1);
  }

  void updateShipmentStatus(String shipmentId, String newStatus) {
    // Handle status update
  }

  void assignDriverToShipment(String shipmentId, String driverId) {
    // Handle driver assignment
  }

  void optimizeRoute(String routeId) {
    // Handle route optimization
  }

  void generateReport(DateTime startDate, DateTime endDate) {
    // Handle report generation
  }
}