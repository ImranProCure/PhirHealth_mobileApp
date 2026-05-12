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
    ApiResponse response = await api.commonApi.authenticationApi.resendOtp(
      flag: "login",
      mobile: number.value,
      country_code: "+91",
      role: _roleController.role == UserRole.doctor ? 'doctor' : 'patient',
    );
    isLoading.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      if (messageData is Map<String, dynamic>) {
        final otp = messageData['otp'];
        if (otp != null && otp.isNotEmpty) {
          for (int i = 0; i < otp.length && i < otpControllers.length; i++) {
            otpControllers[i].text = otp[i];
          }
        }
      } else {
        showError(messageData["message"]);
      }
    } else {
      showError(messageData["message"]);
    }
  }

  void resendOtp() {
    if (!canResend.value) return;
    for (var c in otpControllers) c.clear();
    _resendApi();
    _startTimer();
    showMessage('A new OTP has been sent to ${mobileNumber.value}');
  }

  Future<void> verifyOtpApi() async {
    ApiResponse response;

    // CHANGE: Role ke hisaab se alag endpoint
    if (_roleController.role == UserRole.doctor) {
      response = await api.commonApi.authenticationApi.verifyDoctorOtp(
        mobile: number.value,
        country_code: "+91",
        otp: otpValue,
        role: "doctor",
      );
    } else {
      response = await api.commonApi.authenticationApi.verifyOtp(
        mobile: number.value,
        country_code: "+91",
        otp: otpValue,
        role: "patient",
      );
    }

    isLoading.value = false;

    final messageData = response.data['message'];

    // CHANGE: Status false hone pe seedha error dikhao — aage mat jao
    if (messageData["status"] != true) {
      showError(messageData["message"] ?? 'Verification failed');
      for (var c in otpControllers) c.clear();
      otpFocusNodes[0].requestFocus();
      return;
    }

    if (messageData is Map<String, dynamic>) {
      final token = messageData['access_token'] as String?;
      final user = messageData['user'] as Map<String, dynamic>?;

      if (token != null && token.isNotEmpty) {
        await authStorage.saveToken(token);

        await authStorage.saveRole(
          _roleController.role == UserRole.doctor ? "doctor" : "patient",
        );

        apiClient.setBearerToken(token);
      }

      if (user != null) {
        // CHANGE: Backend se role check karo
        // Agar patient ne doctor number se login karne ki koshish ki
        // final userRoles = user['roles'] as List? ?? [];
        // final isDoctor = userRoles.any((r) =>
        //     r.toString().toLowerCase().contains('doctor') ||
        //     r.toString().toLowerCase().contains('physician'));

        // if (_roleController.role == UserRole.patient && isDoctor) {
        //   // Doctor ka number — patient login block karo
        //   showError(
        //       'This number is registered as a Doctor. Please use Doctor login.');
        //   await authStorage.saveToken('');
        //   apiClient.setBearerToken('');
        //   return;
        // }

        // if (_roleController.role == UserRole.doctor && !isDoctor) {
        //   // Patient ka number — doctor login block karo
        //   showError(
        //       'This number is registered as a Patient. Please use Patient login.');
        //   await authStorage.saveToken('');
        //   apiClient.setBearerToken('');
        //   return;
        // }

        await authStorage.saveUserDetail(user);
        await authStorage.saveLoginStatus(true);
        showMessage('Mobile number verified successfully!');

        // CHANGE: Role based navigation
        switch (_roleController.role) {
          case UserRole.doctor:
            Get.offAllNamed(Routes.DOCTOR_DASHBOARD);
            break;
          case UserRole.patient:
          default:
            Get.offAllNamed(Routes.DASHBOARD);
            break;
        }
      } else {
        showError(messageData["message"] ?? 'Something went wrong');
      }
    } else {
      showError(messageData["message"] ?? 'Something went wrong');
    }
  }

  void verifyOtp() {
    if (!isButtonEnabled.value) return;
    isLoading.value = true;

    Future.delayed(const Duration(seconds: 1), () {
      if (otpValue.length == 6) {
        verifyOtpApi();
      } else {
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
