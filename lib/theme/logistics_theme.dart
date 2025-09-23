import 'package:flutter/material.dart';

class LogisticsTheme {
  // Color Scheme for Logistics
  static const kPrimaryColor = Color(0xFF2E7D32); // Green for logistics
  static const kSecondaryColor = Color(0xFF388E3C);
  static const kAccentColor = Color(0xFF4CAF50);
  static const kWarningColor = Color(0xFFFF9800);
  static const kErrorColor = Color(0xFFF44336);
  static const kInfoColor = Color(0xFF2196F3);
  static const kSuccessColor = Color(0xFF4CAF50);
  static const kBackgroundColor = Color(0xFFF8F9FA);
  static const kCardRadius = 12.0;
  static const kPadding = 16.0;

  // Text styles
  static const TextStyle cardTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle metricValueStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle metricLabelStyle = TextStyle(
    color: Colors.grey,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}