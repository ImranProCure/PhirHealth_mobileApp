import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/db/db.dart';

import '../../../partner/hospital_onboarding/basic_information/controllers/basic_information_controller.dart';
import '../../../partner/hospital_onboarding/clinical_capacity/controllers/clinical_capacity_controller.dart';
import '../../../partner/hospital_onboarding/resource_allocation/controllers/resource_allocation_controller.dart';
import '../../../partner/hospital_onboarding/hospital_legal_compliance/controllers/hospital_legal_compliance_controller.dart';

class HospitalVerifyOtpController extends GetxController {
  final Api api = Api.instance;
  final ApiClient apiClient = ApiClient();
  final AuthStorageService authStorage = AuthStorageService();

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
      await _submitHospitalOnboarding();
    });
  }

  Future<void> _submitHospitalOnboarding() async {
    try {
      final basic = Get.find<BasicInformationController>();
      final capacity = Get.find<ClinicalCapacityController>();
      final resource = Get.find<ResourceAllocationController>();
      final legal = Get.find<HospitalLegalComplianceController>();

      final formData = FormData.fromMap({
        // Basic Info
        'hospital_name': basic.hospitalNameController.text.trim(),
        'contact_number': number.value.isNotEmpty
            ? number.value
            : basic.contactController.text.trim(),
        'country_code': '+91',
        'email': basic.emailController.text.trim(),
        'address': basic.addressController.text.trim(),
        'hospital_type': basic.selectedInterests.join(', '),

        // Clinical Capacity
        'total_licensed_beds': capacity.totalBedsController.text.trim(),
        'icu_availability': capacity.icuAvailability.value ? '1' : '0',
        'emergency_service': capacity.emergencyServices.value ? '1' : '0',
        'operation_theatres': capacity.operationTheatres.value ? '1' : '0',
        'diagnostic_facility': capacity.diagnosticFacilities.value ? '1' : '0',
        'pharmacy_availability':
            capacity.pharmacyAvailability.value ? '1' : '0',

        // Resource Allocation
        'number_of_doctors': resource.doctorCountController.text.trim(),
        'visiting_consultants': resource.visitingConsultants.value ? '1' : '0',
        'hms_installed': resource.hmsInstalled.value ? '1' : '0',
        'tele_consultation': resource.teleConsultation.value ? '1' : '0',

        // Legal
        'registration_number': legal.licenseNumberController.text.trim(),
        'nabh_accreditation': legal.nabhAccreditation.value ? '1' : '0',

        // OTP
        'otp': otpValue,
      });

      // Hospital logo
      if (basic.logoPath.value.isNotEmpty) {
        formData.files.add(MapEntry(
          'hospital_logo',
          await MultipartFile.fromFile(
            basic.logoPath.value,
            filename: 'hospital_logo.jpg',
          ),
        ));
      }

      // Hospital license
      if (legal.hospitalLicensePath.value.isNotEmpty) {
        formData.files.add(MapEntry(
          'hospital_license',
          await MultipartFile.fromFile(
            legal.hospitalLicensePath.value,
            filename: 'hospital_license.jpg',
          ),
        ));
      }

      debugPrint('🔵 HOSPITAL ONBOARDING FIELDS => ${formData.fields}');

      final ApiResponse response =
          await api.commonApi.authenticationApi.hospitalSignup(
        formData: formData,
      );

      debugPrint('🔵 HOSPITAL ONBOARDING RESPONSE => ${response.data}');

      final dynamic messageData = response.data['message'];

      if (messageData is Map && messageData['status'] == true) {
        final token = messageData['access_token'];
        final user = messageData['user'];

        if (token != null && token.toString().isNotEmpty) {
          await authStorage.saveToken(token);
          apiClient.setBearerToken(token);
        }

        if (user != null) {
          final hospital = messageData['data'] as Map<String, dynamic>? ??
              {}; // 👈 'data' key hai response mein
          final mergedData = {
            ...Map<String, dynamic>.from(user),
            ...hospital,
          };
          await authStorage.saveUserDetail(mergedData);
          await authStorage.saveLoginStatus(true);
        }

        showMessage('Hospital registered successfully! 🎉');
        Get.offAllNamed('/hospital-dashboard');
      } else {
        showError(
          messageData is Map
              ? messageData['message']?.toString() ?? 'Something went wrong'
              : 'Something went wrong',
        );
      }
    } catch (e) {
      debugPrint('❌ Hospital onboarding error: $e');
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
