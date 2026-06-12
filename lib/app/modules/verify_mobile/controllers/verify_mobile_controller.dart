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

  // ===== HELPER FUNCTIONS =====
  String _getRoleString() {
    switch (_roleController.role) {
      case UserRole.doctor:
        return 'doctor';
      case UserRole.corporate:
        return 'corporate';
      case UserRole.coach:
        return 'coach';
      case UserRole.partner:
        return _getPartnerRoleString();
      case UserRole.patient:
      default:
        return 'patient';
    }
  }

  String _getPartnerRoleString() {
    switch (_roleController.partnerType) {
      case PartnerType.clinic:
        return 'clinic';
      case PartnerType.hospital:
        return 'hospital';
      case PartnerType.pharmacy:
        return 'pharmacy';
      case PartnerType.lab:
        return 'lab manager';
      default:
        return 'partner';
    }
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
      role: _getRoleString(), // 👈 fixed
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

    if (_roleController.role == UserRole.doctor) {
      response = await api.commonApi.authenticationApi.verifyDoctorOtp(
        mobile: number.value,
        country_code: "+91",
        otp: otpValue,
        role: "doctor",
        flag: 'login',
      );
    } else if (_roleController.role == UserRole.partner) {
      switch (_roleController.partnerType) {
        case PartnerType.hospital:
          response = await api.commonApi.authenticationApi.verifyHospitalOtp(
            mobile: number.value,
            country_code: "+91",
            otp: otpValue,
            role: _getPartnerRoleString(),
            flag: 'login',
          );
          break;
        case PartnerType.pharmacy:
          response = await api.commonApi.authenticationApi.verifyPharmacyOtp(
            mobile: number.value,
            country_code: "+91",
            otp: otpValue,
            role: _getPartnerRoleString(),
            flag: 'login',
          );
          break;
        case PartnerType.clinic: // 👈 yeh add karo
          response = await api.commonApi.authenticationApi.verifyClinicOtp(
            mobile: number.value,
            country_code: "+91",
            otp: otpValue,
            role: _getPartnerRoleString(),
            flag: 'login',
          );
          break;
        case PartnerType.lab:
        default:
          response = await api.commonApi.authenticationApi.verifyLabOtp(
            mobile: number.value,
            country_code: "+91",
            otp: otpValue,
            role: _getPartnerRoleString(),
            flag: 'login',
          );
      }
    } else {
      response = await api.commonApi.authenticationApi.verifyOtp(
        mobile: number.value,
        country_code: "+91",
        otp: otpValue,
        role: _getRoleString(),
      );
    }
    // ... baaki code same

    isLoading.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] != true) {
      showError(messageData["message"] ?? 'Verification failed');
      for (var c in otpControllers) c.clear();
      otpFocusNodes[0].requestFocus();
      return;
    }

    if (messageData is Map<String, dynamic>) {
      final token = messageData['access_token'] as String?;
      print("TOKEN => $token");
      final sid = messageData['sid']?.toString() ?? '';

      if (sid.isNotEmpty) {
        await authStorage.saveCookie('sid=$sid');
      }

      final user = messageData['user'] as Map<String, dynamic>?;
      final doctor = messageData['doctor'] as Map<String, dynamic>? ?? {};

      if (token != null && token.isNotEmpty) {
        await authStorage.saveToken(token);
        ApiClient().setBearerToken(token);
        print("SAVED TOKEN => $token");

        await authStorage.saveRole(_getRoleString()); // 👈 fixed

        apiClient.setBearerToken(token);
      }

      if (user != null) {
        final mergedData = {
          ...?user,
          ...doctor,
        };

        await authStorage.saveUserDetail(mergedData);
        await authStorage.saveLoginStatus(true);
        showMessage('Mobile number verified successfully!');

        // ===== NAVIGATION =====
        switch (_roleController.role) {
          case UserRole.doctor:
            Get.offAllNamed(Routes.DOCTOR_DASHBOARD);
            break;
          case UserRole.partner:
            switch (_roleController.partnerType) {
              case PartnerType.lab:
                Get.offAllNamed('/lab-dashboard');
                break;
              case PartnerType.clinic:
                Get.offAllNamed('/clinic-dashboard');
                break;
              case PartnerType.hospital:
                Get.offAllNamed('/hospital-dashboard');
                break;
              case PartnerType.pharmacy:
                Get.offAllNamed('/pharmacy-dashboard');
                break;
              default:
                Get.offAllNamed('/lab-dashboard');
            }
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
