import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/db/db.dart';
import '../../../controllers/role_controller.dart';
import '../../../routes/app_routes.dart';

class VerifyMobileController extends GetxController {
  final RoleController _roleController = Get.find<RoleController>();
  RxBool isLoading = false.obs;

  final Rx<String> mobileNumber = '+91 98xxxxxx10'.obs;
  final Rx<String> number = ''.obs;
  Api api = Api.instance;
  AuthStorageService authStorage = AuthStorageService();
  ApiClient apiClient = ApiClient();
  final int otpLength = 6;
  late List<TextEditingController> otpControllers;
  late List<FocusNode> otpFocusNodes;

  final RxBool isButtonEnabled = false.obs;
  final RxInt remainingSeconds = 60.obs;
  final RxBool canResend = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    otpControllers = List.generate(otpLength, (i) => TextEditingController());
    otpFocusNodes = List.generate(otpLength, (i) => FocusNode());

    for (var c in otpControllers) {
      c.addListener(_updateButtonState);
    }

    if (Get.arguments != null && Get.arguments['phone'] != null) {
      String phone = Get.arguments['phone'];
      String otp = Get.arguments['otp'];

      if (phone.length == 10) {
        mobileNumber.value =
            '+91 ${phone.substring(0, 2)}xxxxxx${phone.substring(8)}';

        number.value = phone;
      }

      /// Set OTP digits into controllers
      for (int i = 0; i < otp.length && i < otpControllers.length; i++) {
        otpControllers[i].text = otp[i];
      }
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
    remainingSeconds.value = 60;
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

  Future<void> _resendApi() async {
    isLoading.value = true;
    ApiResponse response = await api.commonApi.authenticationApi
        .resendOtp(flag: "login", mobile: number.value, country_code: "+91");
    isLoading.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      if (messageData is Map<String, dynamic>) {
        final otp = messageData['opt'];

        if (otp != null && otp.isNotEmpty) {
          // showMessage(
          //   'OTP sent to +91${number.value}',
          // );

          for (int i = 0; i < otp.length && i < otpControllers.length; i++) {
            otpControllers[i].text = otp[i];
          }

          // All roles go through OTP — role passed in arguments
        }
      } else {
        showError(
          messageData["message"],
        );
        // Get.offAllNamed(Routes.MAIN_SCREEN);
      }
    } else {
      showError(
        messageData["message"],
      );
    }
  }

  void resendOtp() {
    if (!canResend.value) return;
    for (var c in otpControllers) c.clear();
    //otpFocusNodes[0].requestFocus();
    _resendApi();
    _startTimer();
    showMessage(
      'A new OTP has been sent to ${mobileNumber.value}',
    );
  }

  Future<void> verifyOtpApi() async {
    ApiResponse response = await api.commonApi.authenticationApi
        .verifyOtp(mobile: number.value, country_code: "+91", otp: otpValue);
    isLoading.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      if (messageData is Map<String, dynamic>) {
        final token = messageData['access_token'] as String?;
        final user = messageData['user'] as Map<String, dynamic>?;

        if (token != null && token.isNotEmpty) {
          await authStorage.saveToken(token);
          apiClient.setBearerToken(token);
        }

        if (user != null) {
          await authStorage.saveUserDetail(user);
          await authStorage.saveLoginStatus(true);
          //final dashboardRoute = NavigationHelper.getDashboardRoute(roles);
          showMessage(
            'Mobile number verified successfully!',
          );

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
          //Get.offAllNamed(dashboardRoute);
        } else {
          showError(
            messageData["message"],
          );
          //Get.offAllNamed(Routes.MAIN_SCREEN);
        }
      } else {
        showError(
          messageData["message"],
        );
        // Get.offAllNamed(Routes.MAIN_SCREEN);
      }
    } else {
      showError(
        messageData["message"],
      );
    }
  }

  void verifyOtp() {
    if (!isButtonEnabled.value) return;
    isLoading.value = true;

    Future.delayed(const Duration(seconds: 1), () {
      if (otpValue.length == 6) {
        verifyOtpApi();
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
