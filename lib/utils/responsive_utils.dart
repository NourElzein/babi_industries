import 'package:flutter/widgets.dart';

class ResponsiveUtils {
  static bool isMobile(BuildContext context) => 
      MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) => 
      MediaQuery.of(context).size.width >= 768 && 
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) => 
      MediaQuery.of(context).size.width >= 1024;

  static bool isLargeScreen(BuildContext context) => 
      MediaQuery.of(context).size.width > 600;
}