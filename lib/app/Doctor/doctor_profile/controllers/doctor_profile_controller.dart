import 'package:get/get.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/db/db.dart';
import 'package:flutter/material.dart';
import 'package:sample/app/modules/home/bindings/home_binding.dart';
import 'package:sample/app/modules/home/views/home_view.dart';

class DoctorProfileController extends GetxController {
  final RxBool isOnline = true.obs;

  final String name = 'Dr. Rajesh Sharma';
  final String credentials = 'MBBS, MD (Cardiology) | 12 yrs Exp';
  final String regNo = 'Reg No: PMC-222910';
  final String imagePath = 'assets/profile.png';

  final List<Map<String, dynamic>> section1 = [
    {
      'label': 'My Availability & Slots',
      'iconPath': 'assets/icons/calendar_month.png',
      'route': '/doctor-availability'
    },
    {
      'label': 'Clinic Details & Fees',
      'iconPath': 'assets/icons/home_health.png',
      'route': '/doctor-edit-clinic'
    },
  ];

  final List<Map<String, dynamic>> section2 = [
    {
      'label': 'My Earnings & Payouts',
      'iconPath': 'assets/icons/account_balance_wallet.png',
      'route': '/doctor-earnings',
      'trailing': null
    },
    {
      'label': 'Patient Reviews',
      'iconPath': 'assets/icons/rate_review.png',
      'route': '/doctor-reviews',
      'trailing': '4.9'
    },
  ];

  final List<Map<String, dynamic>> section4 = [
    {
      'label': 'Reminders & Notifications',
      'iconPath': 'assets/icons/circle_notifications.png',
      'route': '/app-language',
      'value': null
    },
    {
      'label': 'App Language',
      'iconPath': 'assets/icons/captive_portal.png',
      'route': '/app-language',
      'value': 'English'
    },
    {
      'label': 'Help & Support',
      'iconPath': 'assets/icons/chat_info.png',
      'route': '/help-support',
      'value': null
    },
    {
      'label': 'Privacy Policy',
      'iconPath': 'assets/icons/shield_locked.png',
      'route': '/privacy-policy',
      'value': null
    },
  ];

  void toggleOnline(bool val) => isOnline.value = val;
  void onEdit() {}
  void onShare() {}
  void onTileRoute(String route) => Get.toNamed(route);

  Future<void> logout() async {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            fontFamily: 'Mulish',
            color: Color(0xFF6B7280),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Mulish',
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();

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
            child: const Text(
              'Logout',
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
