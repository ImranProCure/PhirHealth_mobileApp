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
  // CHANGED: final list → getter
  // Pehle compile time pe ek baar .tr call hota tha — locale change pe rebuild nahi hota tha
  // Ab har baar getter call hoga toh fresh .tr milega current locale se
  List<List<Map<String, dynamic>>> get menuSections => [
        [
          {
            'icon': Icons.account_balance_wallet_outlined,
            'label': 'patient_menu_wallet'.tr,
            'route': '/wallet',
            'iconColor': const Color(0xFF0D9488),
            'iconBg': const Color(0xFFE0F2F1),
          },
          {
            'icon': Icons.assignment_outlined,
            'label': 'patient_menu_records'.tr,
            'route': '/medical-records',
            'iconColor': const Color(0xFF0D9488),
            'iconBg': const Color(0xFFE0F2F1),
          },
          {
            'icon': Icons.emergency_outlined,
            'label': 'patient_menu_emergency'.tr,
            'route': '/emergency-contacts',
            'iconColor': const Color(0xFFFF6B35),
            'iconBg': const Color(0xFFFFF0EB),
          },
        ],
        [
          {
            'icon': Icons.notifications_outlined,
            'label': 'patient_menu_reminders'.tr,
            'route': '/medicine-reminder',
            'iconColor': const Color(0xFF0D9488),
            'iconBg': const Color(0xFFE0F2F1),
          },
          {
            'icon': Icons.language_outlined,
            'label': 'patient_menu_language'.tr,
            'route': '/app-language',
            'isLangItem': true,
            'iconColor': const Color(0xFF0D9488),
            'iconBg': const Color(0xFFE0F2F1),
          },
        ],
        [
          {
            'icon': Icons.help_outline,
            'label': 'patient_menu_help'.tr,
            'route': '/help',
            'iconColor': const Color(0xFF0D9488),
            'iconBg': const Color(0xFFE0F2F1),
          },
          {
            'icon': Icons.shield_outlined,
            'label': 'login_privacy'.tr,
            'route': '/privacy',
            'iconColor': const Color(0xFF0D9488),
            'iconBg': const Color(0xFFE0F2F1),
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
        title: Text('patient_logout_title'.tr,
            style:
                TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.w700)),
        content: Text('patient_logout_msg'.tr,
            style: TextStyle(fontFamily: 'Mulish', color: Color(0xFF6B7280))),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('patient_logout_cancel'.tr,
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
            child: Text('patient_logout_title'.tr,
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
