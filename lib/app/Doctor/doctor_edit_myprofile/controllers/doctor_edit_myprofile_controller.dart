import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/routes/app_routes.dart';

class DoctorEditMyProfileController extends GetxController {
  // ===== EDIT PROFILE SECTIONS =====

  final List<Map<String, dynamic>> editSections = [
    {
      'icon': Icons.badge_outlined,
      'label': 'Registration',
      'route': Routes.DOCTOR_REGISTRATION_EDIT,
      'iconColor': Color(0xFF0D9488),
      'iconBg': Color(0xFFE0F2F1),
    },
    {
      'icon': Icons.work_outline,
      'label': 'Experience',
      'route': Routes.DOCTOR_EXPERIENCE_EDIT,
      'iconColor': Color(0xFF0D9488),
      'iconBg': Color(0xFFE0F2F1),
    },
    {
      'icon': Icons.devices_outlined,
      'label': 'Digital Readiness',
      'route': Routes.DOCTOR_DIGITAL_READINESS_EDIT,
      'iconColor': Color(0xFF0D9488),
      'iconBg': Color(0xFFE0F2F1),
    },
  ];

  // ===== ACTIONS =====

  void onEditSectionTap(String route) {
    Get.toNamed(route);
  }
}
