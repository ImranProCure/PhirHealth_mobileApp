import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/modules/home/bindings/home_binding.dart';
import 'package:sample/app/modules/home/views/home_view.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/db/db.dart';

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
      {
        'icon': Icons.group_outlined,
        'label': 'My Family Members',
        'route': '/family-members',
        'iconColor': Color(0xFF0D9488),
        'iconBg': Color(0xFFE0F2F1)
      },
    ],
    [
      {
        'icon': Icons.notifications_outlined,
        'label': 'Reminders',
        'route': '/medicine-reminder',
        'iconColor': Color(0xFF0D9488),
        'iconBg': Color(0xFFE0F2F1)
      },
      {
        'icon': Icons.language_outlined,
        'label': 'App Language',
        'route': '/app-language',
        'trailing': 'English',
        'iconColor': Color(0xFF0D9488),
        'iconBg': Color(0xFFE0F2F1)
      },
    ],
    [
      {
        'icon': Icons.help_outline,
        'label': 'Help & Support',
        'iconColor': Color(0xFF0D9488),
        'iconBg': Color(0xFFE0F2F1)
      },
      {
        'icon': Icons.shield_outlined,
        'label': 'Privacy Policy',
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

  void openSettings() {}

  String maskMobile(String mobile) {
    if (mobile.length < 4) return mobile;
    String last4 = mobile.substring(mobile.length - 4);
    return "XXXXXX$last4";
  }

  String maskEmail(String email) {
    if (!email.contains('@')) return email;

    List<String> parts = email.split('@');
    String name = parts[0];
    String domain = parts[1];

    if (name.length <= 2) {
      return "${name[0]}***@$domain";
    }

    String first = name.substring(0, 2);
    return "$first****@$domain";
  }

  String getBloodGroupFullName(String group) {
    switch (group) {
      case 'A Positive':
        return 'A+';
      case 'A Negative':
        return 'A-';
      case 'B Positive':
        return 'B+';
      case 'B Negative':
        return 'B-';
      case 'O Positive':
        return 'O+';
      case 'O Negative':
        return 'O-';
      default:
        return group;
    }
  }

  String calculateAge(String dob) {
    if (dob == "") return "";

    List<String> parts = dob.split('-');

    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);

    DateTime birthDate = DateTime(year, month, day);
    DateTime today = DateTime.now();

    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return "${age.toString()}, ";
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out',
            style:
                TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to log out?',
            style: TextStyle(fontFamily: 'Mulish', color: Color(0xFF6B7280))),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel',
                style:
                    TextStyle(fontFamily: 'Mulish', color: Color(0xFF6B7280))),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              Get.offAllNamed('/login');
              final authStorage = AuthStorageService();
              await authStorage.clearAll();

              final apiClient = ApiClient();
              apiClient.setBearerToken(null);
              apiClient.clearCookies();

              Get.off(
                () => const HomeView(),
                binding: HomeBinding(),
              );
            },
            child: const Text('Log Out',
                style: TextStyle(
                    fontFamily: 'Mulish',
                    color: Color(0xFFEF4444),
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
