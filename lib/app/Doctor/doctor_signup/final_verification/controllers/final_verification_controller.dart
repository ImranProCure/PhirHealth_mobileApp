import 'package:get/get.dart';
import 'package:flutter/material.dart';

class FinalVerificationController extends GetxController {
  final RxnBool hasLegalIssue = RxnBool();
  final RxBool isConfirmed = false.obs;

  final TextEditingController legalDetailsController = TextEditingController();
  final TextEditingController motivationController = TextEditingController();

  void submitApplication() {
    Get.offAllNamed('/doctor-dashboard');
  }

  @override
  void onClose() {
    legalDetailsController.dispose();
    motivationController.dispose();
    super.onClose();
  }
}
