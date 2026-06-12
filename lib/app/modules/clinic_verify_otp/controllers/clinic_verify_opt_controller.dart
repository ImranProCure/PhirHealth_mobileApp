import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/db/db.dart';

import '../../../partner/clinic_onboarding/clinic_registration/controllers/clinic_registration_controller.dart';
import '../../../partner/clinic_onboarding/clinic_expertise/controllers/clinic_expertise_controller.dart';
import '../../../partner/clinic_onboarding/operations_appointments/controllers/operations_appointments_controller.dart';
import '../../../partner/clinic_onboarding/clinic_legal_compliance/controllers/clinic_legal_compliance_controller.dart';

class ClinicVerifyOtpController extends GetxController {
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

  // Day index to name mapping
  final List<String> _dayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

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
      await _submitClinicOnboarding();
    });
  }

  Future<void> _submitClinicOnboarding() async {
    try {
      final registration = Get.find<ClinicRegistrationController>();
      final expertise = Get.find<ClinicExpertiseController>();
      final operations = Get.find<OperationsAppointmentsController>();
      final legal = Get.find<ClinicLegalComplianceController>();

      // Working days — index to name convert karo
      final List<String> workingDays = operations.selectedDays
          .map((index) => _dayNames[index])
          .toList()
        ..sort((a, b) => _dayNames.indexOf(a).compareTo(_dayNames.indexOf(b)));

      // Consultation type → in_person / online flags
      final String consultationType = expertise.selectedConsultationType.value;
      final String inPerson =
          (consultationType == 'inperson' || consultationType == 'both')
              ? '1'
              : '0';
      final String online =
          (consultationType == 'online' || consultationType == 'both')
              ? '1'
              : '0';

      final formData = FormData.fromMap({
        // Basic Info
        'clinic_name': registration.clinicNameController.text.trim(),
        'doctor_names': registration.doctorNameController.text.trim(),
        'mobile': number.value.isNotEmpty
            ? number.value
            : registration.contactController.text.trim(),
        'country_code': '+91',
        'address': registration.addressController.text.trim(),
        'type_of_clinic': registration.selectedClinicTypes.join(', '),
        'email': registration.emailController.text.trim(),

        // Expertise
        'in_person': inPerson,
        'online': online,

        // Operations
        'from_time': operations.fromTime.value,
        'to_time': operations.toTime.value,
        'working_days': jsonEncode(workingDays), // ["Monday","Tuesday",...]
        'appointment_booking': operations.appointmentBooking.value ? '1' : '0',
        'tele_consultation': operations.teleConsultation.value ? '1' : '0',

        // Legal
        'registrationlicense_number': legal.licenseNumberController.text.trim(),

        // OTP
        'otp': otpValue,
      });

      // Clinic logo
      if (registration.logoPath.value.isNotEmpty) {
        formData.files.add(MapEntry(
          'clinic_logo',
          await MultipartFile.fromFile(
            registration.logoPath.value,
            filename: 'clinic_logo.jpg',
          ),
        ));
      }

      // Certificate
      if (legal.certificatePath.value.isNotEmpty) {
        formData.files.add(MapEntry(
          'upload_certificates',
          await MultipartFile.fromFile(
            legal.certificatePath.value,
            filename: 'certificate.jpg',
          ),
        ));
      }

      debugPrint('🟢 CLINIC ONBOARDING FIELDS => ${formData.fields}');

      final ApiResponse response =
          await api.commonApi.authenticationApi.clinicSignup(
        formData: formData,
      );

      debugPrint('🟢 CLINIC ONBOARDING RESPONSE => ${response.data}');

      final dynamic messageData = response.data['message'];

      if (messageData is Map && messageData['status'] == true) {
        final token = messageData['access_token'];
        final user = messageData['user'];

        if (token != null && token.toString().isNotEmpty) {
          await authStorage.saveToken(token);
          apiClient.setBearerToken(token);
        }

        if (user != null) {
          final clinic = messageData['clinic'] as Map<String, dynamic>? ?? {};
          final mergedData = {
            ...Map<String, dynamic>.from(user),
            ...clinic,
          };
          await authStorage.saveUserDetail(mergedData);
          await authStorage.saveLoginStatus(true);
        }

        showMessage('Clinic registered successfully! 🎉');
        Get.offAllNamed('/clinic-dashboard');
      } else {
        showError(
          messageData is Map
              ? messageData['message']?.toString() ?? 'Something went wrong'
              : 'Something went wrong',
        );
      }
    } catch (e) {
      debugPrint('❌ Clinic onboarding error: $e');
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
