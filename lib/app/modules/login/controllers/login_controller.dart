import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/modules/verify_mobile/bindings/verify_mobile_binding.dart';
import 'package:sample/app/modules/verify_mobile/views/verify_mobile_view.dart';

class LoginController extends GetxController {
  // Text Controller for phone number
  final TextEditingController phoneController = TextEditingController();

  // Observable for loading state
  final RxBool isLoading = false.obs;

  // Get OTP Function
  void getOTP() {
    String phoneNumber = phoneController.text.trim();

    // Validation
    if (phoneNumber.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your mobile number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (phoneNumber.length != 10) {
      Get.snackbar(
        'Error',
        'Please enter a valid 10-digit mobile number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    // Success - Navigate to OTP screen
    print('Phone Number: +91$phoneNumber');
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
      arguments: {'phone': phoneNumber},
    );
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
