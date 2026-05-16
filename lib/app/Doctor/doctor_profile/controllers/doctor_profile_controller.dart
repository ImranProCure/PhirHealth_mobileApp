import 'package:get/get.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/db/db.dart';
import 'package:flutter/material.dart';
import 'package:sample/app/modules/home/bindings/home_binding.dart';
import 'package:sample/app/modules/home/views/home_view.dart';
import '../../../routes/app_routes.dart';

class DoctorProfileController extends GetxController {
  final AuthStorageService _authStorage = AuthStorageService();

  final RxBool isOnline = true.obs;

  /// ================= DYNAMIC DATA =================
  final RxString name = 'Doctor'.obs;

  final RxString credentials = ''.obs;

  final RxString regNo = ''.obs;

  final RxString imagePath = 'assets/profile.png'.obs;

  /// ================= SECTION 1 =================
  final List<Map<String, dynamic>> section1 = [
    {
      'label': 'My Availability & Slots',
      'iconPath': 'assets/icons/calendar_month.png',
      'route': '/doctor-availability',
    },
    {
      'label': 'Clinic Details & Fees',
      'iconPath': 'assets/icons/home_health.png',
      'route': '/doctor-edit-clinic',
    },
  ];

  /// ================= SECTION 2 =================
  final List<Map<String, dynamic>> section2 = [
    {
      'label': 'My Earnings & Payouts',
      'iconPath': 'assets/icons/account_balance_wallet.png',
      'route': '/doctor-earnings',
      'trailing': null,
    },
    {
      'label': 'Patient Reviews',
      'iconPath': 'assets/icons/rate_review.png',
      'route': '/doctor-reviews',
      'trailing': '4.9',
    },
  ];

  /// ================= SECTION 4 =================
  final List<Map<String, dynamic>> section4 = [
    {
      'label': 'Reminders & Notifications',
      'iconPath': 'assets/icons/circle_notifications.png',
      'route': '/app-language',
      'value': null,
    },
    {
      'label': 'App Language',
      'iconPath': 'assets/icons/captive_portal.png',
      'route': '/app-language',
      'value': 'English',
    },
    {
      'label': 'Help & Support',
      'iconPath': 'assets/icons/chat_info.png',
      'route': '/help-support',
      'value': null,
    },
    {
      'label': 'Privacy Policy',
      'iconPath': 'assets/icons/shield_locked.png',
      'route': '/privacy-policy',
      'value': null,
    },
  ];

  @override
  void onInit() {
    super.onInit();

    _loadProfileData();
  }

  /// ================= LOAD PROFILE =================
  Future<void> _loadProfileData() async {
    final user = await _authStorage.getUserDetail();

    print('PROFILE DATA => $user');

    if (user == null) return;

    /// ================= NAME =================
    final fullName = user['full_name']?.toString() ?? '';

    print('FULL NAME => $fullName');

    if (fullName.isNotEmpty) {
      name.value = fullName.startsWith('Dr') ? fullName : 'Dr. $fullName';
    }

    print('FULL NAME => $fullName');

    if (fullName.isNotEmpty) {
      name.value = fullName.startsWith('Dr') ? fullName : 'Dr. $fullName';
    }

    /// ================= IMAGE =================
    final image =
        user['image']?.toString() ?? user['user_image']?.toString() ?? '';

    print('IMAGE => $image');

    if (image.isNotEmpty) {
      imagePath.value =
          image.startsWith('http') ? image : 'http://217.216.58.35$image';
    }

    /// ================= CREDENTIALS =================
    final degree = user['custom_medical_degree']?.toString() ?? '';

    final specialty = user['custom_primary_speciality']?.toString() ?? '';

    final experience = user['custom_total_experience']?.toString() ?? '';

    final List<String> credParts = [];

    if (degree.isNotEmpty) {
      credParts.add(degree);
    }

    if (specialty.isNotEmpty) {
      credParts.add(specialty);
    }

    if (experience.isNotEmpty) {
      credParts.add(experience);
    }

    credentials.value = credParts.join(' | ');

    /// ================= REG NUMBER =================
    final registration = user['custom_registration_number']?.toString() ?? '';

    if (registration.isNotEmpty) {
      regNo.value = 'Reg No: $registration';
    }

    /// ================= FORCE UPDATE =================
    update();

    print('NAME => ${name.value}');
    print(
      'CREDENTIALS => ${credentials.value}',
    );
    print('REG => ${regNo.value}');
  }

  /// ================= TOGGLE =================
  void toggleOnline(bool value) {
    isOnline.value = value;
  }

  /// ================= EDIT =================
  void onEdit() {
    Get.toNamed(Routes.DOCTOR_EDIT_MYPROFILE);
  }

  /// ================= SHARE =================
  void onShare() {}

  /// ================= ROUTING =================
  void onTileRoute(String route) {
    Get.toNamed(route);
  }

  /// ================= LOGOUT =================
  Future<void> logout() async {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20,
          ),
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
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Mulish',
                color: Color(
                  0xFF6B7280,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();

              await _authStorage.clearAll();

              final apiClient = ApiClient();

              apiClient.setBearerToken(
                null,
              );

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
                color: Color(
                  0xFFEF4444,
                ),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
