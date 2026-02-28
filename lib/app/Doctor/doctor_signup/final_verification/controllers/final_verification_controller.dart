import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../../../routes/app_routes.dart';

class FinalVerificationController extends GetxController {
  /// ================= LEGAL CHECK =================
  final RxnBool hasLegalIssue = RxnBool();
  // null = not selected
  // true = Yes
  // false = No

  final TextEditingController legalDetailsController = TextEditingController();

  /// ================= MOTIVATION =================
  final TextEditingController motivationController = TextEditingController();

  /// ================= CONFIRMATION =================
  final RxBool isConfirmed = false.obs;

  /// ================= VALIDATION =================
  bool validateForm() {
    if (hasLegalIssue.value == null) {
      Get.snackbar(
        "Incomplete",
        "Please select Yes or No for legal check",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (hasLegalIssue.value == true &&
        legalDetailsController.text.trim().isEmpty) {
      Get.snackbar(
        "Incomplete",
        "Please provide legal details",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (motivationController.text.trim().isEmpty) {
      Get.snackbar(
        "Incomplete",
        "Please write your motivation",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (!isConfirmed.value) {
      Get.snackbar(
        "Confirmation Required",
        "Please confirm the declaration",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  /// ================= SUBMIT =================
  void submitApplication() {
    if (!validateForm()) return;

    // TODO: API call or navigation
    // Get.offAllNamed(Routes.DOCTOR_SUCCESS);

    Get.snackbar(
      "Submitted",
      "Application submitted for review",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    legalDetailsController.dispose();
    motivationController.dispose();
    super.onClose();
  }
}
