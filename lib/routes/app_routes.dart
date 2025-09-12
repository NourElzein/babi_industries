abstract class AppRoutes {
  AppRoutes._(); // Private constructor to prevent instantiation

  // Auth routes
  static const LOGIN = '/login';
  static const REGISTER = '/register';

  // General routes
  static const HOME = '/home';
  static const SUPPLIERS = '/suppliers';
  static const ORDERS = '/orders';
  static const WAREHOUSE = '/warehouse';
  static const REPORTS = '/reports';

  // Role-specific dashboards
  static const DASHBOARD_MANAGER = '/dashboard/manager';
  static const DASHBOARD_BUYER = '/dashboard/buyer';
  static const DASHBOARD_WAREHOUSE = '/dashboard/warehouse';
  static const DASHBOARD_LOGISTICS = '/dashboard/logistics';
}
