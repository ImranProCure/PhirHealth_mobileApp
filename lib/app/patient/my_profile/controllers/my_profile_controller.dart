import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProfileController extends GetxController {
  // ===== USER INFO =====
  final String name = 'Rahul Verma';
  final String phirId = 'PHIR ID: PH28-1029-44';
  final String phone = '+91 9876543210';
  final String age = '68 yrs, Male';
  final String bloodGroup = 'Blood Group: O+';
  final String profileImage = 'assets/profile.png';

  // ===== MENU SECTIONS =====
  final List<List<Map<String, dynamic>>> menuSections = [
    [
      {
        'icon': Icons.account_balance_wallet_outlined,
        'label': 'My Wallet',
        'route': '/wallet',
        'iconColor': Color(0xFF0D9488),
        'iconBg': Color(0xFFE0F2F1)
      },
      {
        'icon': Icons.assignment_outlined,
        'label': 'Medical Records',
        'route': '/medical-records',
        'iconColor': Color(0xFF0D9488),
        'iconBg': Color(0xFFE0F2F1)
      },
      {
        'icon': Icons.emergency_outlined,
        'label': 'Emergency Contacts',
        'route': '/emergency-contacts',
        'iconColor': Color(0xFFFF6B35),
        'iconBg': Color(0xFFFFF0EB)
      },
    ],
    [
      {
        'icon': Icons.notifications_outlined,
        'label': 'Reminders',
        'route': '/reminders',
        'iconColor': Color(0xFF0D9488),
        'iconBg': Color(0xFFE0F2F1)
      },
      {
        'icon': Icons.language_outlined,
        'label': 'App Language',
        'route': '/language',
        'trailing': 'English',
        'iconColor': Color(0xFF0D9488),
        'iconBg': Color(0xFFE0F2F1)
      },
    ],
    [
      {
        'icon': Icons.help_outline,
        'label': 'Help & Support',
        'route': '/help',
        'iconColor': Color(0xFF0D9488),
        'iconBg': Color(0xFFE0F2F1)
      },
      {
        'icon': Icons.shield_outlined,
        'label': 'Privacy Policy',
        'route': '/privacy',
        'iconColor': Color(0xFF0D9488),
        'iconBg': Color(0xFFE0F2F1)
      },
    ],
  ];

  void onMenuTap(String route) {
    Get.toNamed(route);
  }

  void editProfile() {
    Get.toNamed('/edit-profile');
  }

  void openSettings() {
    Get.toNamed('/settings');
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Log Out',
          style: TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(fontFamily: 'Mulish', color: Color(0xFF6B7280)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Mulish', color: Color(0xFF6B7280)),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed('/login');
            },
            child: const Text(
              'Log Out',
              style: TextStyle(
                fontFamily: 'Mulish',
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
