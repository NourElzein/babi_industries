import 'package:flutter/material.dart';
import 'package:babi_industries/theme/logistics_theme.dart';

class Sidebar extends StatelessWidget {
  final Function(String) onItemSelected;

  const Sidebar({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              _buildSidebarItem(
                Icons.dashboard,
                "Dashboard",
                isSelected: true,
                onTap: () => onItemSelected('dashboard'),
              ),
              _buildSidebarItem(
                Icons.local_shipping,
                "Shipments",
                onTap: () => onItemSelected('shipments'),
              ),
              _buildSidebarItem(
                Icons.map,
                "Tracking",
                onTap: () => onItemSelected('tracking'),
              ),
              _buildSidebarItem(
                Icons.route,
                "Routes",
                onTap: () => onItemSelected('routes'),
              ),
              _buildSidebarItem(
                Icons.directions_car,
                "Vehicles",
                onTap: () => onItemSelected('vehicles'),
              ),
              _buildSidebarItem(
                Icons.analytics,
                "Analytics",
                onTap: () => onItemSelected('analytics'),
              ),
              _buildSidebarItem(
                Icons.report,
                "Reports",
                onTap: () => onItemSelected('reports'),
              ),
              _buildSidebarItem(
                Icons.settings,
                "Settings",
                onTap: () => onItemSelected('settings'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, {bool isSelected = false, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon,
          color: isSelected ? LogisticsTheme.kPrimaryColor : Colors.grey.shade700),
      title: Text(title,
          style: TextStyle(
              color: isSelected ? LogisticsTheme.kPrimaryColor : Colors.grey.shade700,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      selected: isSelected,
      onTap: onTap,
    );
  }
}