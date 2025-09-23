import 'package:flutter/material.dart';

class BuyerUtils {
  /// Map badge text to color
  static Color getBadgeColor(String? badge) {
    switch (badge?.toLowerCase()) {
      case 'verified':
        return Colors.green;
      case 'top rated':
        return Colors.blue;
      case 'fast delivery':
        return Colors.purple;
      case 'best price':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  /// Map alert type to color
  static Color getAlertColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'delay':
      case 'error':
        return Colors.red;
      case 'warning':
      case 'stock':
        return Colors.orange;
      case 'info':
      case 'payment':
        return Colors.blue;
      case 'success':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Map alert type to icon
  static IconData getAlertIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'delay':
        return Icons.access_time;
      case 'stock':
        return Icons.inventory;
      case 'payment':
        return Icons.payment;
      case 'delivery':
        return Icons.local_shipping;
      case 'supplier':
        return Icons.business;
      default:
        return Icons.info;
    }
  }

  /// Map insight icon string to IconData
  static IconData mapInsightIcon(String? iconName) {
    switch (iconName) {
      case 'trending_up':
        return Icons.trending_up;
      case 'savings':
        return Icons.savings;
      case 'schedule':
        return Icons.schedule;
      default:
        return Icons.insights;
    }
  }

  /// Map insight color string to Color
  static Color mapInsightColor(String? colorName) {
    switch (colorName?.toLowerCase()) {
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
