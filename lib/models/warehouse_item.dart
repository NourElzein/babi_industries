// warehouse_model.dart
import 'package:flutter/material.dart';

// Warehouse Item Model
class WarehouseItem {
  final String id;
  final String sku;
  final String name;
  final String description;
  final String category;
  final String subCategory;
  int currentStock;
  final int minStock;
  final int maxStock;
  final String location;
  final String binCode;
  final double unitCost;
  final double unitPrice;
  final String supplierId;
  final String supplierName;
  final String unitOfMeasure;
  final DateTime? expiryDate;
  final String batchNumber;
  final String barcode;
  final String qrCode;
  final double weight;
  final double dimensions; // in cubic meters
  final bool isActive;
  final bool isSerialized;
  final List<String> serialNumbers;
  DateTime lastUpdated;
  final DateTime createdAt;

  WarehouseItem({
    required this.id,
    required this.sku,
    required this.name,
    required this.description,
    required this.category,
    required this.subCategory,
    required this.currentStock,
    required this.minStock,
    required this.maxStock,
    required this.location,
    required this.binCode,
    required this.unitCost,
    required this.unitPrice,
    required this.supplierId,
    required this.supplierName,
    required this.unitOfMeasure,
    this.expiryDate,
    this.batchNumber = '',
    this.barcode = '',
    this.qrCode = '',
    this.weight = 0.0,
    this.dimensions = 0.0,
    this.isActive = true,
    this.isSerialized = false,
    this.serialNumbers = const [],
    required this.lastUpdated,
    required this.createdAt,
  });

  // Check if stock is critical
  bool get isCritical => currentStock <= minStock;

  // Check if stock is low
  bool get isLow => currentStock <= minStock * 1.5;

  // Check if item is expired
  bool get isExpired => expiryDate != null && expiryDate!.isBefore(DateTime.now());

  // Check if item will expire soon (within 30 days)
  bool get willExpireSoon {
    if (expiryDate == null) return false;
    final thirtyDaysFromNow = DateTime.now().add(const Duration(days: 30));
    return expiryDate!.isBefore(thirtyDaysFromNow) && !isExpired;
  }

  // Get stock status color
  Color get statusColor {
    if (isCritical) return Colors.red;
    if (isLow) return Colors.orange;
    if (isExpired) return Colors.purple;
    if (willExpireSoon) return Colors.amber;
    return Colors.green;
  }

  // Get stock status text
  String get statusText {
    if (isCritical) return 'Critical';
    if (isLow) return 'Low';
    if (isExpired) return 'Expired';
    if (willExpireSoon) return 'Expiring Soon';
    return 'Normal';
  }

  // Calculate total value of current stock
  double get totalValue => currentStock * unitCost;

  // Calculate reorder quantity
  int get reorderQuantity => (maxStock * 0.6 - currentStock).ceil().clamp(0, maxStock);

  // Convert to map for Firebase/API
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'description': description,
      'category': category,
      'subCategory': subCategory,
      'currentStock': currentStock,
      'minStock': minStock,
      'maxStock': maxStock,
      'location': location,
      'binCode': binCode,
      'unitCost': unitCost,
      'unitPrice': unitPrice,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'unitOfMeasure': unitOfMeasure,
      'expiryDate': expiryDate?.toIso8601String(),
      'batchNumber': batchNumber,
      'barcode': barcode,
      'qrCode': qrCode,
      'weight': weight,
      'dimensions': dimensions,
      'isActive': isActive,
      'isSerialized': isSerialized,
      'serialNumbers': serialNumbers,
      'lastUpdated': lastUpdated.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from map
  factory WarehouseItem.fromMap(Map<String, dynamic> map) {
    return WarehouseItem(
      id: map['id'] ?? '',
      sku: map['sku'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      subCategory: map['subCategory'] ?? '',
      currentStock: map['currentStock'] ?? 0,
      minStock: map['minStock'] ?? 0,
      maxStock: map['maxStock'] ?? 0,
      location: map['location'] ?? '',
      binCode: map['binCode'] ?? '',
      unitCost: (map['unitCost'] ?? 0.0).toDouble(),
      unitPrice: (map['unitPrice'] ?? 0.0).toDouble(),
      supplierId: map['supplierId'] ?? '',
      supplierName: map['supplierName'] ?? '',
      unitOfMeasure: map['unitOfMeasure'] ?? 'pcs',
      expiryDate: map['expiryDate'] != null ? DateTime.parse(map['expiryDate']) : null,
      batchNumber: map['batchNumber'] ?? '',
      barcode: map['barcode'] ?? '',
      qrCode: map['qrCode'] ?? '',
      weight: (map['weight'] ?? 0.0).toDouble(),
      dimensions: (map['dimensions'] ?? 0.0).toDouble(),
      isActive: map['isActive'] ?? true,
      isSerialized: map['isSerialized'] ?? false,
      serialNumbers: List<String>.from(map['serialNumbers'] ?? []),
      lastUpdated: DateTime.parse(map['lastUpdated']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Copy with method for updates
  WarehouseItem copyWith({
    String? id,
    String? sku,
    String? name,
    String? description,
    String? category,
    String? subCategory,
    int? currentStock,
    int? minStock,
    int? maxStock,
    String? location,
    String? binCode,
    double? unitCost,
    double? unitPrice,
    String? supplierId,
    String? supplierName,
    String? unitOfMeasure,
    DateTime? expiryDate,
    String? batchNumber,
    String? barcode,
    String? qrCode,
    double? weight,
    double? dimensions,
    bool? isActive,
    bool? isSerialized,
    List<String>? serialNumbers,
    DateTime? lastUpdated,
    DateTime? createdAt,
  }) {
    return WarehouseItem(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      currentStock: currentStock ?? this.currentStock,
      minStock: minStock ?? this.minStock,
      maxStock: maxStock ?? this.maxStock,
      location: location ?? this.location,
      binCode: binCode ?? this.binCode,
      unitCost: unitCost ?? this.unitCost,
      unitPrice: unitPrice ?? this.unitPrice,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      expiryDate: expiryDate ?? this.expiryDate,
      batchNumber: batchNumber ?? this.batchNumber,
      barcode: barcode ?? this.barcode,
      qrCode: qrCode ?? this.qrCode,
      weight: weight ?? this.weight,
      dimensions: dimensions ?? this.dimensions,
      isActive: isActive ?? this.isActive,
      isSerialized: isSerialized ?? this.isSerialized,
      serialNumbers: serialNumbers ?? this.serialNumbers,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// Stock Movement Model
class StockMovement {
  final String id;
  final String reference;
  final MovementType type;
  final String sku;
  final String itemName;
  final int quantity;
  final String fromLocation;
  final String toLocation;
  final String fromBinCode;
  final String toBinCode;
  final String reason;
  final String userId;
  final String userName;
  final DateTime timestamp;
  final String? documentReference;
  final String? supplierId;
  final String? supplierName;
  final String? customerId;
  final String? customerName;
  final String? notes;
  final bool isConfirmed;
  final DateTime? confirmedAt;
  final String? confirmedBy;

  StockMovement({
    required this.id,
    required this.reference,
    required this.type,
    required this.sku,
    required this.itemName,
    required this.quantity,
    required this.fromLocation,
    required this.toLocation,
    required this.fromBinCode,
    required this.toBinCode,
    required this.reason,
    required this.userId,
    required this.userName,
    required this.timestamp,
    this.documentReference,
    this.supplierId,
    this.supplierName,
    this.customerId,
    this.customerName,
    this.notes,
    this.isConfirmed = false,
    this.confirmedAt,
    this.confirmedBy,
  });

  // Get movement type color
  Color get typeColor {
    switch (type) {
      case MovementType.receipt:
        return Colors.green;
      case MovementType.dispatch:
        return Colors.red;
      case MovementType.adjustment:
        return Colors.blue;
      case MovementType.transfer:
        return Colors.orange;
      case MovementType.cycleCount:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Get movement type icon
  IconData get typeIcon {
    switch (type) {
      case MovementType.receipt:
        return Icons.input;
      case MovementType.dispatch:
        return Icons.output;
      case MovementType.adjustment:
        return Icons.tune;
      case MovementType.transfer:
        return Icons.swap_horiz;
      case MovementType.cycleCount:
        return Icons.inventory;
      default:
        return Icons.question_mark;
    }
  }

  // Convert to map for Firebase/API
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reference': reference,
      'type': type.toString(),
      'sku': sku,
      'itemName': itemName,
      'quantity': quantity,
      'fromLocation': fromLocation,
      'toLocation': toLocation,
      'fromBinCode': fromBinCode,
      'toBinCode': toBinCode,
      'reason': reason,
      'userId': userId,
      'userName': userName,
      'timestamp': timestamp.toIso8601String(),
      'documentReference': documentReference,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'customerId': customerId,
      'customerName': customerName,
      'notes': notes,
      'isConfirmed': isConfirmed,
      'confirmedAt': confirmedAt?.toIso8601String(),
      'confirmedBy': confirmedBy,
    };
  }

  // Create from map
  factory StockMovement.fromMap(Map<String, dynamic> map) {
    return StockMovement(
      id: map['id'] ?? '',
      reference: map['reference'] ?? '',
      type: _parseMovementType(map['type']),
      sku: map['sku'] ?? '',
      itemName: map['itemName'] ?? '',
      quantity: map['quantity'] ?? 0,
      fromLocation: map['fromLocation'] ?? '',
      toLocation: map['toLocation'] ?? '',
      fromBinCode: map['fromBinCode'] ?? '',
      toBinCode: map['toBinCode'] ?? '',
      reason: map['reason'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      documentReference: map['documentReference'],
      supplierId: map['supplierId'],
      supplierName: map['supplierName'],
      customerId: map['customerId'],
      customerName: map['customerName'],
      notes: map['notes'],
      isConfirmed: map['isConfirmed'] ?? false,
      confirmedAt: map['confirmedAt'] != null ? DateTime.parse(map['confirmedAt']) : null,
      confirmedBy: map['confirmedBy'],
    );
  }

  // Helper to parse movement type
  static MovementType _parseMovementType(String typeString) {
    switch (typeString) {
      case 'MovementType.receipt':
        return MovementType.receipt;
      case 'MovementType.dispatch':
        return MovementType.dispatch;
      case 'MovementType.adjustment':
        return MovementType.adjustment;
      case 'MovementType.transfer':
        return MovementType.transfer;
      case 'MovementType.cycleCount':
        return MovementType.cycleCount;
      default:
        return MovementType.adjustment;
    }
  }
}

// Movement Types
enum MovementType {
  receipt,      // Goods received from supplier
  dispatch,     // Goods dispatched to customer
  adjustment,   // Stock adjustment (count differences)
  transfer,     // Internal transfer between locations
  cycleCount,   // Physical inventory count
}

// Warehouse Location Model
class WarehouseLocation {
  final String id;
  final String name;
  final String type; // Aisle, Rack, Shelf, Bin, etc.
  final String? parentId;
  final String code;
  final double capacity; // in cubic meters
  final double currentUtilization;
  final String zone;
  final bool isActive;
  final String temperatureZone; // Ambient, Chilled, Frozen
  final List<String> compatibleProductTypes;
  final DateTime lastUpdated;

  WarehouseLocation({
    required this.id,
    required this.name,
    required this.type,
    this.parentId,
    required this.code,
    required this.capacity,
    required this.currentUtilization,
    required this.zone,
    this.isActive = true,
    this.temperatureZone = 'Ambient',
    this.compatibleProductTypes = const [],
    required this.lastUpdated,
  });

  // Calculate available capacity
  double get availableCapacity => capacity - currentUtilization;

  // Check if location is full
  bool get isFull => availableCapacity <= 0;

  // Check if location is almost full (80%+)
  bool get isAlmostFull => (currentUtilization / capacity) >= 0.8;

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'parentId': parentId,
      'code': code,
      'capacity': capacity,
      'currentUtilization': currentUtilization,
      'zone': zone,
      'isActive': isActive,
      'temperatureZone': temperatureZone,
      'compatibleProductTypes': compatibleProductTypes,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  // Create from map
  factory WarehouseLocation.fromMap(Map<String, dynamic> map) {
    return WarehouseLocation(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      parentId: map['parentId'],
      code: map['code'] ?? '',
      capacity: (map['capacity'] ?? 0.0).toDouble(),
      currentUtilization: (map['currentUtilization'] ?? 0.0).toDouble(),
      zone: map['zone'] ?? '',
      isActive: map['isActive'] ?? true,
      temperatureZone: map['temperatureZone'] ?? 'Ambient',
      compatibleProductTypes: List<String>.from(map['compatibleProductTypes'] ?? []),
      lastUpdated: DateTime.parse(map['lastUpdated']),
    );
  }
}

// Warehouse Dashboard Stats
class WarehouseStats {
  final int totalItems;
  final int totalSKUs;
  final int criticalStockItems;
  final int lowStockItems;
  final int scansToday;
  final int movementsToday;
  final double totalInventoryValue;
  final int itemsToExpire;
  final double inventoryAccuracy;
  final double pickingEfficiency;
  final int pendingReceipts;
  final int pendingDispatches;

  WarehouseStats({
    required this.totalItems,
    required this.totalSKUs,
    required this.criticalStockItems,
    required this.lowStockItems,
    required this.scansToday,
    required this.movementsToday,
    required this.totalInventoryValue,
    required this.itemsToExpire,
    required this.inventoryAccuracy,
    required this.pickingEfficiency,
    required this.pendingReceipts,
    required this.pendingDispatches,
  });

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'totalItems': totalItems,
      'totalSKUs': totalSKUs,
      'criticalStockItems': criticalStockItems,
      'lowStockItems': lowStockItems,
      'scansToday': scansToday,
      'movementsToday': movementsToday,
      'totalInventoryValue': totalInventoryValue,
      'itemsToExpire': itemsToExpire,
      'inventoryAccuracy': inventoryAccuracy,
      'pickingEfficiency': pickingEfficiency,
      'pendingReceipts': pendingReceipts,
      'pendingDispatches': pendingDispatches,
    };
  }

  // Create from map
  factory WarehouseStats.fromMap(Map<String, dynamic> map) {
    return WarehouseStats(
      totalItems: map['totalItems'] ?? 0,
      totalSKUs: map['totalSKUs'] ?? 0,
      criticalStockItems: map['criticalStockItems'] ?? 0,
      lowStockItems: map['lowStockItems'] ?? 0,
      scansToday: map['scansToday'] ?? 0,
      movementsToday: map['movementsToday'] ?? 0,
      totalInventoryValue: (map['totalInventoryValue'] ?? 0.0).toDouble(),
      itemsToExpire: map['itemsToExpire'] ?? 0,
      inventoryAccuracy: (map['inventoryAccuracy'] ?? 0.0).toDouble(),
      pickingEfficiency: (map['pickingEfficiency'] ?? 0.0).toDouble(),
      pendingReceipts: map['pendingReceipts'] ?? 0,
      pendingDispatches: map['pendingDispatches'] ?? 0,
    );
  }
}

// Stock Alert Model
class StockAlert {
  final String id;
  final String sku;
  final String itemName;
  final AlertType type;
  final String message;
  final int currentStock;
  final int threshold;
  final String location;
  final DateTime triggeredAt;
  final bool isResolved;
  final DateTime? resolvedAt;
  final String? resolvedBy;
  final String? resolutionNotes;

  StockAlert({
    required this.id,
    required this.sku,
    required this.itemName,
    required this.type,
    required this.message,
    required this.currentStock,
    required this.threshold,
    required this.location,
    required this.triggeredAt,
    this.isResolved = false,
    this.resolvedAt,
    this.resolvedBy,
    this.resolutionNotes,
  });

  // Get alert color based on type
  Color get alertColor {
    switch (type) {
      case AlertType.critical:
        return Colors.red;
      case AlertType.lowStock:
        return Colors.orange;
      case AlertType.expiry:
        return Colors.purple;
      case AlertType.overstock:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Get alert icon
  IconData get alertIcon {
    switch (type) {
      case AlertType.critical:
        return Icons.warning;
      case AlertType.lowStock:
        return Icons.inventory;
      case AlertType.expiry:
        return Icons.calendar_today;
      case AlertType.overstock:
        return Icons.warehouse;
      default:
        return Icons.notifications;
    }
  }

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sku': sku,
      'itemName': itemName,
      'type': type.toString(),
      'message': message,
      'currentStock': currentStock,
      'threshold': threshold,
      'location': location,
      'triggeredAt': triggeredAt.toIso8601String(),
      'isResolved': isResolved,
      'resolvedAt': resolvedAt?.toIso8601String(),
      'resolvedBy': resolvedBy,
      'resolutionNotes': resolutionNotes,
    };
  }

  // Create from map
  factory StockAlert.fromMap(Map<String, dynamic> map) {
    return StockAlert(
      id: map['id'] ?? '',
      sku: map['sku'] ?? '',
      itemName: map['itemName'] ?? '',
      type: _parseAlertType(map['type']),
      message: map['message'] ?? '',
      currentStock: map['currentStock'] ?? 0,
      threshold: map['threshold'] ?? 0,
      location: map['location'] ?? '',
      triggeredAt: DateTime.parse(map['triggeredAt']),
      isResolved: map['isResolved'] ?? false,
      resolvedAt: map['resolvedAt'] != null ? DateTime.parse(map['resolvedAt']) : null,
      resolvedBy: map['resolvedBy'],
      resolutionNotes: map['resolutionNotes'],
    );
  }

  // Helper to parse alert type
  static AlertType _parseAlertType(String typeString) {
    switch (typeString) {
      case 'AlertType.critical':
        return AlertType.critical;
      case 'AlertType.lowStock':
        return AlertType.lowStock;
      case 'AlertType.expiry':
        return AlertType.expiry;
      case 'AlertType.overstock':
        return AlertType.overstock;
      default:
        return AlertType.lowStock;
    }
  }
}

// Alert Types
enum AlertType {
  critical,   // Stock below minimum threshold
  lowStock,   // Stock getting low
  expiry,     // Items expiring soon
  overstock,  // Too much stock
}// TODO Implement this library.