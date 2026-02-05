import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/routes/app_routes.dart';

class VerifyMobileController extends GetxController {
  // Mobile number from previous screen
  final Rx<String> mobileNumber = '+91 98xxxxxx10'.obs;

  // OTP Configuration
  final int otpLength = 4;

  // OTP Controllers & Focus Nodes
  late List<TextEditingController> otpControllers;
  late List<FocusNode> otpFocusNodes;

  // Observable States
  final RxBool isButtonEnabled = false.obs;
  final RxInt remainingSeconds = 45.obs;
  final RxBool canResend = false.obs;

  // Timer
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    // Get mobile number from arguments if available
    if (Get.arguments != null && Get.arguments['phone'] != null) {
      String phone = Get.arguments['phone'];
      // Format: +91 98xxxxx10
      if (phone.length == 10) {
        String masked =
            '+91 ${phone.substring(0, 2)}xxxxxx${phone.substring(8)}';
        mobileNumber.value = masked;
      }
    }

    // Initialize OTP controllers and focus nodes
    otpControllers = List.generate(
      otpLength,
      (index) => TextEditingController(),
    );

    otpFocusNodes = List.generate(otpLength, (index) => FocusNode());

    // Add listeners to update button state
    for (var controller in otpControllers) {
      controller.addListener(_updateButtonState);
    }

    // Start countdown timer
    _startTimer();
  }

  // Get complete OTP value
  String get otpValue {
    return otpControllers.map((c) => c.text).join();
  }

  // Formatted timer string
  String get formattedTime {
    int minutes = remainingSeconds.value ~/ 60;
    int seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Handle OTP field changes
  void onOtpFieldChanged(String value, int index) {
    if (value.isNotEmpty && index < otpLength - 1) {
      // Move to next field
      otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      // Move to previous field
      otpFocusNodes[index - 1].requestFocus();
    }

    _updateButtonState();
  }

  // Update button enabled state
  void _updateButtonState() {
    bool allFilled = otpControllers.every((c) => c.text.isNotEmpty);
    isButtonEnabled.value = allFilled;
  }

  // Start countdown timer
  void _startTimer() {
    remainingSeconds.value = 45;
    canResend.value = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  // Resend OTP
  void resendOtp() {
    if (!canResend.value) return;

    // TODO: Call API to resend OTP
    print('Resending OTP to: $mobileNumber');

    // Clear all OTP fields
    for (var controller in otpControllers) {
      controller.clear();
    }

    // Focus first field
    otpFocusNodes[0].requestFocus();

    // Restart timer
    _startTimer();

    // Show success message
    Get.snackbar(
      'OTP Sent',
      'A new OTP has been sent to ${mobileNumber.value}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  // Verify OTP
  void verifyOtp() {
    if (!isButtonEnabled.value) return;

    String otp = otpValue;

    // TODO: Call API to verify OTP with backend
    print('Verifying OTP: $otp for ${mobileNumber.value}');

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      // Mock validation (for demo - replace with real API)
      if (otp == '5925' || otp.length == 4) {
        // Success
        Get.snackbar(
          'Success',
          'Mobile number verified successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );

        Get.offAllNamed(Routes.DASHBOARD);
        // Get.offAllNamed('/dashboard');
        print('Navigate to next screen');
      } else {
        // Failure
        Get.snackbar(
          'Invalid OTP',
          'Please enter the correct OTP',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );

        // Clear OTP fields
        for (var controller in otpControllers) {
          controller.clear();
        }
        otpFocusNodes[0].requestFocus();
      }
    });
  }

  @override
  void onClose() {
    // Dispose all controllers and focus nodes
    _timer?.cancel();

    for (var controller in otpControllers) {
      controller.dispose();
    }

    for (var focusNode in otpFocusNodes) {
      focusNode.dispose();
    }

    super.onClose();
  }
}
