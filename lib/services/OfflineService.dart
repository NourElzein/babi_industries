import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineService {
  // Check internet availability
  static Future<bool> isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Save data to a Hive box
  static Future<void> saveData(String boxName, String id, Map data) async {
    var box = Hive.box(boxName);
    box.put(id, jsonEncode(data));
  }

  // Load all data from a Hive box
  static List loadData(String boxName) {
    var box = Hive.box(boxName);
    return box.keys.map((key) => jsonDecode(box.get(key))).toList();
  }

  // Update a single item in Hive
  static Future<void> updateData(String boxName, String id, Map data) async {
    var box = Hive.box(boxName);
    box.put(id, jsonEncode(data));
  }

  // Sync all offline data to server
  static Future<void> syncOfflineData({
    required Future<void> Function(Map) updateOrdersAPI,
    required Future<void> Function(Map) updateInventoryAPI,
    required Future<void> Function(Map)? updateSuppliersAPI,
  }) async {
    bool online = await isInternetAvailable();
    if (!online) return;

    // Sync Orders
    var ordersBox = Hive.box('ordersBox');
    for (var key in ordersBox.keys) {
      var order = jsonDecode(ordersBox.get(key));
      await updateOrdersAPI(order);
    }

    // Sync Inventory
    var inventoryBox = Hive.box('inventoryBox');
    for (var key in inventoryBox.keys) {
      var item = jsonDecode(inventoryBox.get(key));
      await updateInventoryAPI(item);
    }

    // Optional: Sync Suppliers
    if (updateSuppliersAPI != null) {
      var suppliersBox = Hive.box('suppliersBox');
      for (var key in suppliersBox.keys) {
        var supplier = jsonDecode(suppliersBox.get(key));
        await updateSuppliersAPI(supplier);
      }
    }
  }
}
