import 'package:flutter/material.dart';
import 'package:babi_industries/theme/app_colors.dart';
import 'package:babi_industries/views/buyer_dashboard/utils/dialog_utils.dart';
import 'package:babi_industries/controllers/buyer_dashboard_controller.dart';

class ProfileView extends StatelessWidget {
  final BuyerDashboardController controller;

  const ProfileView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: AppColors.kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => DialogUtils.showFeatureDialog("Edit Profile"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.kPrimaryColor,
              child: Text('B', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            const Text('Buyer Portal', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Senior Buyer • Yopougon, Côte d\'Ivoire', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Profile Settings'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => DialogUtils.showFeatureDialog('Profile Settings'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notification Preferences'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => DialogUtils.showFeatureDialog('Notification Settings'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Security Settings'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => DialogUtils.showFeatureDialog('Security Settings'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => DialogUtils.showFeatureDialog('Help & Support'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.kErrorColor),
                    title: const Text('Logout', style: TextStyle(color: AppColors.kErrorColor)),
                    onTap: () => DialogUtils.showLogoutDialog(controller),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}