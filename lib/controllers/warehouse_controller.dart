import 'package:flutter/material.dart' show Color, Colors;
import 'package:get/get.dart';
import 'package:babi_industries/models/warehouse_item.dart';

class WarehouseController extends GetxController {
  // Dashboard KPIs
  var totalItems = 0.obs;
  var criticalStock = 0.obs;
  var scansToday = 0.obs;
  var movementsToday = 0.obs;
  var totalValue = 0.0.obs;
  var itemsToExpire = 0.obs;

  // Performance metrics
  var scanAccuracy = 98.5.obs;
  var inventoryAccuracy = 95.2.obs;
  var pickingEfficiency = 87.3.obs;

  // Low stock alerts
  var lowStockAlerts = <Map<String, dynamic>>[].obs;

  // Recent movements
  var recentMovements = <Map<String, dynamic>>[].obs;

  // Inventory data
  var inventoryItems = <WarehouseItem>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Navigation
  var selectedBottomNavIndex = 0.obs;

  // Storage locations
  var storageLocations = ['Aisle 1', 'Aisle 2', 'Aisle 3', 'Aisle 4', 'Aisle 5', 'Receiving', 'Dispatch'].obs;

  // Filter and search
  var searchQuery = ''.obs;
  var selectedLocation = 'All'.obs;
  var selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  void fetchDashboardData() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      // TODO: Replace with actual API/Firebase call
      await Future.delayed(const Duration(milliseconds: 800));

      // Set dashboard KPIs
      totalItems.value = 2340;
      criticalStock.value = 8;
      scansToday.value = 145;
      movementsToday.value = 32;
      totalValue.value = 125430.75;
      itemsToExpire.value = 15;

      // Set performance metrics
      scanAccuracy.value = 98.5;
      inventoryAccuracy.value = 95.2;
      pickingEfficiency.value = 87.3;

      // Set low stock alerts
      lowStockAlerts.assignAll([
        {
          "product": "Engine Belt (P-341)", 
          "message": "Critical: Only 2 left!", 
          "color": "red",
          "sku": "P-341",
          "currentStock": 2,
          "minStock": 10,
          "location": "Aisle 3, Shelf B2"
        },
        {
          "product": "Hydraulic Pump (HP-98)", 
          "message": "Low: 7 remaining", 
          "color": "orange",
          "sku": "HP-98",
          "currentStock": 7,
          "minStock": 15,
          "location": "Aisle 1, Shelf C4"
        },
        {
          "product": "Spare Filter (SF-22)", 
          "message": "Critical: 1 left!", 
          "color": "red",
          "sku": "SF-22",
          "currentStock": 1,
          "minStock": 5,
          "location": "Aisle 2, Shelf A1"
        },
        {
          "product": "Coolant Hose (CH-456)", 
          "message": "Low: 8 remaining", 
          "color": "orange",
          "sku": "CH-456",
          "currentStock": 8,
          "minStock": 20,
          "location": "Aisle 4, Shelf D3"
        },
      ]);

      // Set recent movements
      recentMovements.assignAll([
        {
          "title": "GRN #12345", 
          "details": "Received • 50 Units • Aisle 3", 
          "color": "green",
          "type": "receipt",
          "quantity": 50,
          "sku": "P-341",
          "timestamp": DateTime.now().subtract(Duration(hours: 2)),
          "user": "Jean-Baptiste K."
        },
        {
          "title": "Shipment #456", 
          "details": "Dispatched • 20 Units • Aisle 5", 
          "color": "red",
          "type": "dispatch",
          "quantity": 20,
          "sku": "HP-98",
          "timestamp": DateTime.now().subtract(Duration(hours: 5)),
          "user": "Awa K."
        },
        {
          "title": "Adjustment #77", 
          "details": "Added • 10 Units (Cycle Count)", 
          "color": "blue",
          "type": "adjustment",
          "quantity": 10,
          "sku": "SF-22",
          "timestamp": DateTime.now().subtract(Duration(days: 1)),
          "user": "Inventory Team"
        },
        {
          "title": "Transfer #892", 
          "details": "Transferred • 15 Units to Aisle 2", 
          "color": "orange",
          "type": "transfer",
          "quantity": 15,
          "sku": "CH-456",
          "timestamp": DateTime.now().subtract(Duration(days: 2)),
          "user": "Warehouse Staff"
        },
      ]);

      // Load sample inventory items
      inventoryItems.assignAll([
        WarehouseItem(
          id: '1',
          sku: 'P-341',
          name: 'Engine Belt',
          description: 'High-performance engine belt for industrial machinery',
          category: 'Engine Parts',
          currentStock: 52,
          minStock: 10,
          maxStock: 100,
          location: 'Aisle 3, Shelf B2',
          value: 45.99,
          lastUpdated: DateTime.now().subtract(Duration(hours: 2)),
          supplier: 'AutoParts Inc.'
        ),
        WarehouseItem(
          id: '2',
          sku: 'HP-98',
          name: 'Hydraulic Pump',
          description: 'Industrial grade hydraulic pump',
          category: 'Hydraulic Systems',
          currentStock: 27,
          minStock: 15,
          maxStock: 50,
          location: 'Aisle 1, Shelf C4',
          value: 289.50,
          lastUpdated: DateTime.now().subtract(Duration(days: 1)),
          supplier: 'HydroTech Ltd.'
        ),
        WarehouseItem(
          id: '3',
          sku: 'SF-22',
          name: 'Spare Filter',
          description: 'Replacement filter for cooling systems',
          category: 'Filters',
          currentStock: 11,
          minStock: 5,
          maxStock: 30,
          location: 'Aisle 2, Shelf A1',
          value: 22.75,
          lastUpdated: DateTime.now().subtract(Duration(days: 3)),
          supplier: 'Filtration Experts'
        ),
        WarehouseItem(
          id: '4',
          sku: 'CH-456',
          name: 'Coolant Hose',
          description: 'Reinforced coolant hose for high temperatures',
          category: 'Cooling Systems',
          currentStock: 23,
          minStock: 20,
          maxStock: 60,
          location: 'Aisle 4, Shelf D3',
          value: 34.25,
          lastUpdated: DateTime.now().subtract(Duration(hours: 12)),
          supplier: 'Cooling Solutions'
        ),
      ]);
    } catch (e) {
      errorMessage.value = 'Failed to load warehouse data: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Navigation methods
  void navigateToInventory() {
    selectedBottomNavIndex.value = 1;
    Get.toNamed('/inventory');
  }

  void navigateToCriticalStock() {
    Get.toNamed('/inventory', arguments: {'filter': 'critical'});
  }

  void navigateToReports() {
    Get.toNamed('/reports');
  }

  void navigateToMovements() {
    selectedBottomNavIndex.value = 2;
    Get.toNamed('/movements');
  }

  void navigateToPriceComparison() {
    Get.toNamed('/price-comparison');
  }

  void navigateToSuppliers() {
    Get.toNamed('/suppliers');
  }

  // Filter inventory based on search and filters
  List<WarehouseItem> get filteredInventory {
    return inventoryItems.where((item) {
      final matchesSearch = searchQuery.isEmpty || 
          item.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.sku.toLowerCase().contains(searchQuery.toLowerCase());
      
      final matchesLocation = selectedLocation.value == 'All' || 
          item.location.contains(selectedLocation.value);
      
      final matchesCategory = selectedCategory.value == 'All' || 
          item.category == selectedCategory.value;
      
      return matchesSearch && matchesLocation && matchesCategory;
    }).toList();
  }

  // Get critical stock items
  List<WarehouseItem> get criticalStockItems {
    return inventoryItems.where((item) => item.currentStock <= item.minStock).toList();
  }

  // Get items that need reordering
  List<WarehouseItem> get reorderItems {
    return inventoryItems.where((item) => 
        item.currentStock <= item.minStock * 1.5).toList();
  }

  // Record a new stock movement
  void recordMovement(StockMovement movement) {
    // Update the item stock
    final item = inventoryItems.firstWhere((item) => item.sku == movement.sku);
    
    if (movement.type == MovementType.receipt) {
      item.currentStock += movement.quantity;
    } else if (movement.type == MovementType.dispatch) {
      item.currentStock -= movement.quantity;
    } else if (movement.type == MovementType.adjustment) {
      item.currentStock = movement.quantity;
    }
    
    // Update last updated timestamp
    item.lastUpdated = DateTime.now();
    
    // Add to recent movements
    recentMovements.insert(0, {
      "title": movement.reference,
      "details": "${movement.type.toString().split('.').last} • ${movement.quantity} Units • ${movement.location}",
      "color": _getMovementColor(movement.type),
      "type": movement.type.toString(),
      "quantity": movement.quantity,
      "sku": movement.sku,
      "timestamp": DateTime.now(),
      "user": movement.user
    });
    
    // Update movements count
    movementsToday.value += 1;
    
    // Refresh the list
    inventoryItems.refresh();
    
    // Show confirmation
    Get.snackbar(
      'Success',
      'Stock movement recorded for ${movement.sku}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Process a QR scan
  void processQRScan(String scanData) {
    // Increment scan count
    scansToday.value += 1;
    
    // Parse scan data (assuming format: "SKU:XXX,LOCATION:YYY")
    final parts = scanData.split(',');
    String sku = '';
    String location = '';
    
    for (var part in parts) {
      if (part.startsWith('SKU:')) {
        sku = part.substring(4);
      } else if (part.startsWith('LOCATION:')) {
        location = part.substring(9);
      }
    }
    
    if (sku.isNotEmpty) {
      // Find the item
      try {
        final item = inventoryItems.firstWhere((item) => item.sku == sku);
        Get.toNamed('/inventory/$sku', arguments: item);
      } catch (e) {
        Get.snackbar(
          'Not Found',
          'Item with SKU $sku not found in inventory',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    }
  }

  // Get color for movement type
  String _getMovementColor(MovementType type) {
    switch (type) {
      case MovementType.receipt:
        return "green";
      case MovementType.dispatch:
        return "red";
      case MovementType.adjustment:
        return "blue";
      case MovementType.transfer:
        return "orange";
      default:
        return "grey";
    }
  }

  // Refresh data
  void refreshData() {
    fetchDashboardData();
  }

  // Clear filters
  void clearFilters() {
    searchQuery.value = '';
    selectedLocation.value = 'All';
    selectedCategory.value = 'All';
  }

  // Get all categories
  List<String> get categories {
    final allCategories = inventoryItems.map((item) => item.category).toSet().toList();
    allCategories.insert(0, 'All');
    return allCategories;
  }

  // Search suppliers (placeholder for buyer dashboard compatibility)
  void searchSuppliers(String query) {
    // This is a placeholder method to match the buyer dashboard interface
    Get.snackbar(
      'Search',
      'Searching suppliers for: $query',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  // Create quick order (placeholder for buyer dashboard compatibility)
  void createQuickOrder(Map<String, dynamic> orderData) {
    // This is a placeholder method to match the buyer dashboard interface
    Get.snackbar(
      'Quick Order',
      'Creating quick order for ${orderData['product']}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}

// Warehouse Item Model
class WarehouseItem {
  final String id;
  final String sku;
  final String name;
  final String description;
  final String category;
  int currentStock;
  final int minStock;
  final int maxStock;
  final String location;
  final double value;
  DateTime lastUpdated;
  final String supplier;

  WarehouseItem({
    required this.id,
    required this.sku,
    required this.name,
    required this.description,
    required this.category,
    required this.currentStock,
    required this.minStock,
    required this.maxStock,
    required this.location,
    required this.value,
    required this.lastUpdated,
    required this.supplier,
  });

  // Check if stock is critical
  bool get isCritical => currentStock <= minStock;

  // Check if stock is low
  bool get isLow => currentStock <= minStock * 1.5;

  // Get stock status color
  Color get statusColor {
    if (isCritical) return Colors.red;
    if (isLow) return Colors.orange;
    return Colors.green;
  }
}

// Stock Movement Model
class StockMovement {
  final String id;
  final String sku;
  final MovementType type;
  final int quantity;
  final String location;
  final String reference;
  final String user;
  final DateTime timestamp;
  final String? notes;

  StockMovement({
    required this.id,
    required this.sku,
    required this.type,
    required this.quantity,
    required this.location,
    required this.reference,
    required this.user,
    required this.timestamp,
    this.notes,
  });
}

// Movement Types
enum MovementType {
  receipt,
  dispatch,
  adjustment,
  transfer,
}