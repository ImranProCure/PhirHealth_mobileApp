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
  /// ROLE LIST FOR UI
  /// =========================
  final List<Map<String, dynamic>> roleItems = const [
    {
      "icon": Icons.person_outline,
      "title": "Customer / Patient",
      "subtitle": "Access your health records and appointments.",
      "role": UserRole.patient,
    },
    {
      "icon": Icons.local_hospital_outlined,
      "title": "Doctor",
      "subtitle": "Manage your patients and consultations.",
      "role": UserRole.doctor,
    },
    {
      "icon": Icons.handshake_outlined,
      "title": "Collaboration / Partners",
      "subtitle": "Connect and grow with our health network.",
      "role": UserRole.partner,
    },
    {
      "icon": Icons.chat_bubble_outline,
      "title": "Coaches / Counsellors",
      "subtitle": "Guide your clients towards wellness.",
      "role": UserRole.counsellor,
    },
    {
      "icon": Icons.business_center_outlined,
      "title": "Corporates",
      "subtitle": "Solutions for employee health and insurance.",
      "role": UserRole.corporate,
    },
  ];

  /// =========================
  /// ROLE SELECTION HANDLER
  /// =========================
  void onRoleSelected(UserRole role) {
    /// 1️⃣ Store selected role globally
    _roleController.selectRole(role);

    /// 2️⃣ Navigate to common Login Screen
    Get.to(
      () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.rightToLeft,
    );
  }
}
