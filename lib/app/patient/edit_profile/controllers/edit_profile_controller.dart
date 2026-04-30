import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/modules/home/bindings/home_binding.dart';
import 'package:sample/app/modules/home/views/home_view.dart';
import 'package:sample/app/patient/patient_signup/identity_vitals/controllers/identity_vitals_controller.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/db/db.dart';

class EditProfileController extends GetxController {
  // ===== USER INFO =====

  final IdentityVitalsController controller1 =
      Get.put(IdentityVitalsController());
  // ===== EDIT PROFILE SECTIONS (for the Edit Profile screen from screenshot) =====

  final List<Map<String, dynamic>> editSections = [
    {
      'icon': Icons.badge_outlined,
      'label': 'patient_step1_edit'.tr,
      'route': '/identity-vitals-edit',
      'iconColor': Color(0xFF0D9488),
      'iconBg': Color(0xFFE0F2F1),
    },
    {
      'icon': Icons.medical_information_outlined,
      'label': 'patient_step2_heading'.tr,
      'route': '/medical-history-edit',
      'iconColor': Color(0xFF0D9488),
      'iconBg': Color(0xFFE0F2F1),
    },
    {
      'icon': Icons.self_improvement_outlined,
      'label': 'patient_step3_heading'.tr,
      'route': '/lifestyle-edit',
      'iconColor': Color(0xFF0D9488),
      'iconBg': Color(0xFFE0F2F1),
    },
    {
      'icon': Icons.family_restroom_outlined,
      'label': 'patient_step4_heading'.tr,
      'route': '/family-wellbeing-edit',
      'iconColor': Color(0xFF0D9488),
      'iconBg': Color(0xFFE0F2F1),
    },
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (controller1.gender.value == Gender.female) {
      editSections.add({
        'icon': Icons.female_outlined,
        'label': "patient_step5_heading".tr,
        'route': '/womens-health',
        'iconColor': Color(0xFFE91E8C),
        'iconBg': Color(0xFFFCE4F3),
      });
    }
  }

  // ===== ACTIONS =====

  void onMenuTap(String route) {
    Get.toNamed(route);
  }

  void onEditSectionTap(String route) {
    Get.toNamed(route);
  }

  void editProfile() {
    Get.toNamed('/edit-profile-sections');
  }

  void openSettings() {
    Get.toNamed('/settings');
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'patient_logout_title'.tr,
          style: TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.w700),
        ),
        content: Text(
          'patient_logout_msg'.tr,
          style: TextStyle(fontFamily: 'Mulish', color: Color(0xFF6B7280)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'patient_logout_cancel'.tr,
              style: TextStyle(fontFamily: 'Mulish', color: Color(0xFF6B7280)),
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
            child: Text(
              'patient_logout_title'.tr,
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
