import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/modules/verify_mobile/bindings/verify_mobile_binding.dart';
import 'package:sample/app/modules/verify_mobile/views/verify_mobile_view.dart';

import '../../../controllers/role_controller.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  /// =========================
  /// DEPENDENCIES
  /// =========================
  final RoleController _roleController = Get.find<RoleController>();

  /// =========================
  /// TEXT CONTROLLERS
  /// =========================
  final TextEditingController phoneController = TextEditingController();

  /// =========================
  /// STATE
  /// =========================
  final RxBool isLoading = false.obs;

  /// =========================
  /// LOGIN → GET OTP
  /// =========================
  void getOTP() {
    final phoneNumber = phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      _showError('Please enter your mobile number');
      return;
    }

    if (phoneNumber.length != 10) {
      _showError('Please enter a valid 10-digit mobile number');
      return;
    }

    Get.snackbar(
      'Success',
      'OTP sent to +91$phoneNumber',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );

    Get.to(
      () => const VerifyMobileView(),
      binding: VerifyMobileBinding(),
      arguments: {
        'phone': phoneNumber,
        'role': _roleController.role,
      },
    );
  }

  /// =========================
  /// ROLE-BASED SIGNUP FLOW
  /// =========================
  void goToSignup() {
    final role = _roleController.role;

    if (role == null) {
      _showError('Please select a role first');
      return;
    }

    switch (role) {
      case UserRole.patient:
        Get.toNamed(Routes.PATIENT_IDENTITY_VITALS);
        break;

      case UserRole.doctor:
        Get.toNamed(Routes.DOCTOR_REGISTRATION);
        break;

      case UserRole.partner:
      case UserRole.counsellor:
      case UserRole.corporate:
        _showError('Signup flow not implemented yet for this role');
        break;
    }
  }

  /// =========================
  /// COMMON ERROR HANDLER
  /// =========================
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
