import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../login/views/login_view.dart';
import '../../login/bindings/login_binding.dart';

class HomeController extends GetxController {
  // Role items with better matching icons
  final List<Map<String, dynamic>> roleItems = [
    {
      "icon": Icons.person_outline, // Customer/Patient
      "title": "Customer / Patient",
      "subtitle": "Access your health records and appointments.",
      "role": "Patient",
    },
    {
      "icon": Icons.local_hospital_outlined, // Doctor (Stethoscope alternative)
      "title": "Doctor",
      "subtitle": "Manage your patients and consultations.",
      "role": "Doctor",
    },
    {
      "icon": Icons.handshake_outlined, // Collaboration/Partners
      "title": "Collaboration / Partners",
      "subtitle": "Connect and grow with our health network.",
      "role": "Partner",
    },
    {
      "icon": Icons.chat_bubble_outline, // Coaches/Counsellors (alternative)
      "title": "Coaches / Counsellors",
      "subtitle": "Guide your clients towards wellness.",
      "role": "Coach",
    },
    {
      "icon": Icons.business_center_outlined, // Corporates
      "title": "Corporates",
      "subtitle": "Solutions for employee health and insurance.",
      "role": "Corporate",
    },
  ];

  // Observable to store selected role
  final Rx<String> selectedRole = ''.obs;

  // Navigate to Login with selected role
  void onRoleSelected(String role) {
    print("Selected Role: $role");

    // Store selected role
    selectedRole.value = role;

    // Navigate to Login Screen with binding
    Get.to(
      () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
      arguments: {'role': role}, // Pass role to login screen
    );
  }
}
