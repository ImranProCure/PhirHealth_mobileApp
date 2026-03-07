import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/role_controller.dart';
import '../../../routes/app_routes.dart';

class VerifyMobileController extends GetxController {
  final RoleController _roleController = Get.find<RoleController>();

  final Rx<String> mobileNumber = '+91 98xxxxxx10'.obs;

  final int otpLength = 4;
  late List<TextEditingController> otpControllers;
  late List<FocusNode> otpFocusNodes;

  final RxBool isButtonEnabled = false.obs;
  final RxInt remainingSeconds = 45.obs;
  final RxBool canResend = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments['phone'] != null) {
      String phone = Get.arguments['phone'];
      if (phone.length == 10) {
        mobileNumber.value =
            '+91 ${phone.substring(0, 2)}xxxxxx${phone.substring(8)}';
      }
    }

    otpControllers = List.generate(otpLength, (i) => TextEditingController());
    otpFocusNodes = List.generate(otpLength, (i) => FocusNode());

    for (var c in otpControllers) {
      c.addListener(_updateButtonState);
    }

    _startTimer();
  }

  String get otpValue => otpControllers.map((c) => c.text).join();

  String get formattedTime {
    int m = remainingSeconds.value ~/ 60;
    int s = remainingSeconds.value % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void onOtpFieldChanged(String value, int index) {
    if (value.isNotEmpty && index < otpLength - 1) {
      otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }
    _updateButtonState();
  }

  void _updateButtonState() {
    isButtonEnabled.value = otpControllers.every((c) => c.text.isNotEmpty);
  }

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

  void resendOtp() {
    if (!canResend.value) return;
    for (var c in otpControllers) c.clear();
    otpFocusNodes[0].requestFocus();
    _startTimer();
    Get.snackbar('OTP Sent', 'A new OTP has been sent to ${mobileNumber.value}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2));
  }

  void verifyOtp() {
    if (!isButtonEnabled.value) return;

    Future.delayed(const Duration(seconds: 1), () {
      if (otpValue.length == 4) {
        Get.snackbar('Success', 'Mobile number verified successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade100,
            colorText: Colors.green.shade900,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
            duration: const Duration(seconds: 2));

        // ===== ROLE-BASED NAVIGATION =====
        final role = _roleController.role;
        switch (role) {
          case UserRole.doctor:
            Get.offAllNamed(Routes.DOCTOR_DASHBOARD);
            break;
          case UserRole.patient:
          default:
            Get.offAllNamed(Routes.DASHBOARD);
            break;
        }
      } else {
        Get.snackbar('Invalid OTP', 'Please enter the correct OTP',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
            duration: const Duration(seconds: 2));

        for (var c in otpControllers) c.clear();
        otpFocusNodes[0].requestFocus();
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var c in otpControllers) c.dispose();
    for (var f in otpFocusNodes) f.dispose();
    super.onClose();
  }
}
