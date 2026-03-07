import 'package:get/get.dart';

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
      'route': '/doctor-clinic'
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

  void logout() {
    Get.offAllNamed('/login');
  }
}
