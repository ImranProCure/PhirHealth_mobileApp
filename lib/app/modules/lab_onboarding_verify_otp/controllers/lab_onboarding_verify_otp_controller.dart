import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/db/db.dart';

// 4 screen controllers
import '../../../partner/lab_onboarding/basic_info/controllers/basic_info_controller.dart';
import '../../../partner/lab_onboarding/capabilities/controllers/capabilities_controller.dart';
import '../../../partner/lab_onboarding/operation_tech/controllers/operation_tech_controller.dart';
import '../../../partner/lab_onboarding/verification_details/controllers/verification_details_controller.dart';

class LabOnboardingVerifyOtpController extends GetxController {
  final Api api = Api.instance; // ✅ Add
  final ApiClient apiClient = ApiClient();
  final AuthStorageService authStorage = AuthStorageService(); // ✅ Add

  final int otpLength = 6;

  late List<TextEditingController> otpControllers;
  late List<FocusNode> otpFocusNodes;

  final RxString mobileNumber = ''.obs;
  final RxString number = ''.obs;

  final RxBool isButtonEnabled = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool canResend = false.obs;
  final RxInt remainingSeconds = 60.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    otpControllers = List.generate(otpLength, (_) => TextEditingController());
    otpFocusNodes = List.generate(otpLength, (_) => FocusNode());

    for (var c in otpControllers) {
      c.addListener(_updateButtonState);
    }

    if (Get.arguments != null) {
      final String phone = Get.arguments['phone'] ?? '';
      final String otp = Get.arguments['otp'] ?? '';

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

  void resendOtp() {
    if (!canResend.value) return;
    for (var c in otpControllers) {
      c.clear();
    }
    _startTimer();
    showMessage('A new OTP has been sent to ${mobileNumber.value}');
  }

  void verifyOtp() {
    if (!isButtonEnabled.value) return;
    if (otpValue.length != 6) {
      showError('Please enter correct OTP');
      return;
    }
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 300), () async {
      await _submitLabOnboarding();
    });
  }

  Future<void> _submitLabOnboarding() async {
    try {
      final basic = Get.find<BasicInfoController>();
      final capabilities = Get.find<CapabilitiesController>();
      final opTech = Get.find<OperationTechController>();
      final verification = Get.find<VerificationDetailsController>();

      const dayNames = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      final workingDaysSorted = opTech.selectedDays.toList()..sort();
      final workingDaysString =
          '[${workingDaysSorted.map((i) => '"${dayNames[i]}"').join(',')}]';

      final interestAreasString =
          '[${basic.selectedInterests.map((e) => '"$e"').join(',')}]';

      final formData = FormData.fromMap({
        'lab_name': basic.labNameController.text.trim(),
        'mobile': number.value.isNotEmpty
            ? number.value
            : basic.contactController.text.trim(),
        'country_code': '+91',
        'email': basic.emailController.text.trim(),
        'lab_address': basic.addressController.text.trim(),
        'city_state': basic.cityStateController.text.trim(),
        'interest_areas': interestAreasString,
        'latitude': basic.latitude.value,
        'longitude': basic.longitude.value,
        'goal_and_objective': capabilities.goalsController.text.trim(),
        'equipment_details': capabilities.equipmentController.text.trim(),
        'home_collection_available':
            capabilities.homeSampleCollection.value ? '1' : '0',
        'digital_reports': capabilities.digitalReports.value ? '1' : '0',
        'avg_delivery_time': capabilities.selectedTimeframe.value,
        'pan_gst_number': verification.panGstController.text.trim(),
        'registration_number': verification.licenseController.text.trim(),
        'is_nabl_certified': verification.nablAccredited.value ? '1' : '0',
        'working_days': workingDaysString,
        'working_hours_from': opTech.fromTime.value,
        'working_hours_to': opTech.toTime.value,
        'emergency_24x7': opTech.emergencyService.value ? '1' : '0',
        'online_booking': opTech.onlineBookings.value ? '1' : '0',
        'lis_integration': opTech.apiIntegration.value ? '1' : '0',
        'otp': otpValue,
      });

      if (basic.logoPath.value.isNotEmpty) {
        formData.files.add(MapEntry(
          'lab_image',
          await MultipartFile.fromFile(
            basic.logoPath.value,
            filename: 'lab_image.jpg',
          ),
        ));
      }

      if (verification.certificatePath.value.isNotEmpty) {
        formData.files.add(MapEntry(
          'license_certificate',
          await MultipartFile.fromFile(
            verification.certificatePath.value,
            filename: 'license_certificate.jpg',
          ),
        ));
      }

      debugPrint('🔵 LAB ONBOARDING FIELDS => ${formData.fields}');

      final ApiResponse response =
          await api.commonApi.authenticationApi.labSignup(
        formData: formData,
      );

      debugPrint('🔵 LAB ONBOARDING RESPONSE => ${response.data}');

      // ✅ Doctor jaisa response handling
      final dynamic messageData = response.data['message'];

      if (messageData is Map && messageData['status'] == true) {
        final token = messageData['access_token'];
        final user = messageData['user'];

        if (token != null && token.toString().isNotEmpty) {
          await authStorage.saveToken(token);
          apiClient.setBearerToken(token);
        }

        if (user != null) {
          final lab = messageData['lab'] as Map<String, dynamic>? ?? {};
          final mergedData = {
            ...Map<String, dynamic>.from(user),
            ...lab,
          };
          await authStorage.saveUserDetail(mergedData);
          await authStorage.saveLoginStatus(true);
        }

        showMessage('Lab profile created successfully! 🎉');
        Get.offAllNamed('/lab-dashboard');
      } else {
        showError(
          messageData is Map
              ? messageData['message']?.toString() ?? 'Something went wrong'
              : 'Something went wrong',
        );
      }
    } catch (e) {
      debugPrint('❌ Lab onboarding error: $e');
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in otpFocusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}
