import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../login/views/login_view.dart';
import '../../login/bindings/login_binding.dart';
import '../../../controllers/role_controller.dart';

class HomeController extends GetxController {
  /// =========================
  /// GLOBAL ROLE CONTROLLER
  /// =========================
  final RoleController _roleController = Get.find<RoleController>();

  /// =========================
  /// LANGUAGE TOGGLE — ONLY ADDITION
  /// =========================
  final RxBool isHindi = false.obs;

  void toggleLanguage() {
    isHindi.value = !isHindi.value;
    if (isHindi.value) {
      Get.updateLocale(const Locale('hi', 'IN'));
    } else {
      Get.updateLocale(const Locale('en', 'US'));
    }
  }

  /// =========================
  /// ROLE LIST FOR UI
  /// title/subtitle → titleKey/subtitleKey (translation keys)
  /// =========================
  final List<Map<String, dynamic>> roleItems = const [
    {
      "icon": Icons.person_outline,
      "titleKey": "role_patient_title",
      "subtitleKey": "role_patient_subtitle",
      "role": UserRole.patient,
    },
    {
      "icon": Icons.local_hospital_outlined,
      "titleKey": "role_doctor_title",
      "subtitleKey": "role_doctor_subtitle",
      "role": UserRole.doctor,
    },
    {
      "icon": Icons.handshake_outlined,
      "titleKey": "role_partner_title",
      "subtitleKey": "role_partner_subtitle",
      "role": UserRole.partner,
    },
    {
      "icon": Icons.chat_bubble_outline,
      "titleKey": "role_coach_title",
      "subtitleKey": "role_coach_subtitle",
      "role": UserRole.coach,
    },
    {
      "icon": Icons.business_center_outlined,
      "titleKey": "role_corporate_title",
      "subtitleKey": "role_corporate_subtitle",
      "role": UserRole.corporate,
    },
  ];

  /// =========================
  /// ROLE SELECTION HANDLER
  /// =========================
  void onRoleSelected(UserRole role) {
    /// 1️⃣ Store role
    _roleController.selectRole(role);

    /// 2️⃣ Handle flow
    if (role == UserRole.partner) {
      /// 👉 Collaborator flow
      Get.toNamed('/select-facility-type');
    } else {
      /// 👉 Normal flow (patient, doctor, etc.)
      Get.to(
        () => const LoginView(),
        binding: LoginBinding(),
        transition: Transition.rightToLeft,
      );
    }
  }
}
