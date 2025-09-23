import 'package:babi_industries/utils/buyer_utils.dart';
import 'package:flutter/material.dart';

/// -------------------- Supplier Recommendation --------------------
class SupplierRecommendation {
  final String id;
  final String name;
  final String category;
  final String badge;
  final Color badgeColor;
  final String performance;
  final String totalOrders;
  final double rating;

  SupplierRecommendation({
    required this.id,
    required this.name,
    required this.category,
    required this.badge,
    required this.badgeColor,
    required this.performance,
    required this.totalOrders,
    required this.rating,
  });

  /// From Hive/Json
  factory SupplierRecommendation.fromJson(Map<String, dynamic> json) {
    return SupplierRecommendation(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      badge: json['badge'] ?? '',
      badgeColor: Color(json['badgeColor'] ?? 0xFF888888),
      performance: json['performance'] ?? '',
      totalOrders: json['totalOrders'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  /// From API map
  factory SupplierRecommendation.fromApi(Map<String, dynamic> api) {
    return SupplierRecommendation(
      id: api['id'] ?? '',
      name: api['name'] ?? '',
      category: api['category'] ?? 'N/A',
      badge: api['badge'] ?? 'N/A',
      badgeColor: _mapBadgeColor(api['badge']),
      performance: '${api['performance_score'] ?? 0}%',
      totalOrders: '${api['total_orders'] ?? 0} orders',
      rating: (api['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'badge': badge,
        'badgeColor': badgeColor.value,
        'performance': performance,
        'totalOrders': totalOrders,
        'rating': rating,
      };

  static Color _mapBadgeColor(String? badge) {
    switch (badge) {
      case 'Gold':
        return Colors.amber;
      case 'Silver':
        return Colors.grey;
      case 'Bronze':
        return Colors.brown;
      default:
        return Colors.blueGrey;
    }
  }
}

/// -------------------- Buyer Alert --------------------
class BuyerAlert {
  final String id;
  final String type;
  final String title;
  final String message;
  final Color color;
  final IconData icon;
  final DateTime timestamp;
  final bool isUrgent;

  BuyerAlert({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.color,
    required this.icon,
    required this.timestamp,
    required this.isUrgent,
  });

  factory BuyerAlert.fromJson(Map<String, dynamic> json) {
    return BuyerAlert(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      color: Color(json['color'] ?? 0xFF888888),
      icon: IconData(json['icon'] ?? 0xe88e, fontFamily: 'MaterialIcons'),
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      isUrgent: json['isUrgent'] ?? false,
    );
  }

  factory BuyerAlert.fromApi(Map<String, dynamic> api) {
    return BuyerAlert(
      id: api['id'] ?? '',
      type: api['type'] ?? '',
      title: api['title'] ?? '',
      message: api['message'] ?? '',
      color: _mapAlertColor(api['type']),
      icon: _mapAlertIcon(api['type']),
      timestamp: DateTime.tryParse(api['timestamp'] ?? '') ?? DateTime.now(),
      isUrgent: api['is_urgent'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'message': message,
        'color': color.value,
        'icon': icon.codePoint,
        'timestamp': timestamp.toIso8601String(),
        'isUrgent': isUrgent,
      };

  static Color _mapAlertColor(String? type) {
    switch (type) {
      case 'error':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'info':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  static IconData _mapAlertIcon(String? type) {
    switch (type) {
      case 'error':
        return Icons.error;
      case 'warning':
        return Icons.warning;
      case 'info':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }
}

/// -------------------- Buyer Insight --------------------
class BuyerInsight {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String trend;

  BuyerInsight({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.trend,
  });

  factory BuyerInsight.fromJson(Map<String, dynamic> json) {
    return BuyerInsight(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: IconData(json['icon'] ?? 0xe88e, fontFamily: 'MaterialIcons'),
      color: Color(json['color'] ?? 0xFF888888),
      trend: json['trend'] ?? '',
    );
  }

  factory BuyerInsight.fromApi(Map<String, dynamic> api) {
    return BuyerInsight(
      title: api['title'] ?? '',
      description: api['description'] ?? '',
      icon: BuyerUtils.mapInsightIcon(api['icon']),
      color: BuyerUtils.mapInsightColor(api['color']),
      trend: api['trend'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'icon': icon.codePoint,
        'color': color.value,
        'trend': trend,
      };
}

/// -------------------- Buyer Notification --------------------
class BuyerNotification {
  final String id;
  final String title;
  final String message;
  final String type;
  final Color color;
  final String time;

  BuyerNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.color,
    required this.time,
  });

  factory BuyerNotification.fromJson(Map<String, dynamic> json) {
    Color mapColor(String? color) {
      switch (color) {
        case 'error':
          return Colors.red;
        case 'warning':
          return Colors.orange;
        case 'accent':
          return Colors.blue;
        default:
          return Colors.grey;
      }
    }

    return BuyerNotification(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      color: mapColor(json['color']),
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'type': type,
        'color': color.value,
        'time': time,
      };
}
