import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/routes/app_routes.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/db/db.dart';
import 'package:intl/intl.dart';
import '../../../Doctor/doctor_availability/views/doctor_availability_view.dart';
import '../../../Doctor/doctor_availability/controllers/doctor_availability_controller.dart';

// STEP CONTROLLERS
import '../../../Doctor/doctor_signup/registration/controllers/registration_controller.dart';
import '../../../Doctor/doctor_signup/experience/controllers/experience_controller.dart';
import '../../../Doctor/doctor_signup/final_verification/controllers/final_verification_controller.dart';
import '../../../Doctor/doctor_signup/digital_readiness/controllers/digital_readiness_controller.dart';

class DoctorVerifyOtpController extends GetxController {
  final Api api = Api.instance;

  final ApiClient apiClient = ApiClient();

  final AuthStorageService authStorage = AuthStorageService();

  final int otpLength = 6;

  late List<TextEditingController> otpControllers;

  late List<FocusNode> otpFocusNodes;

  final Rx<String> mobileNumber = ''.obs;

  final Rx<String> number = ''.obs;

  final RxBool isButtonEnabled = false.obs;

  final RxBool isLoading = false.obs;

  final RxBool canResend = false.obs;

  final RxInt remainingSeconds = 60.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    otpControllers = List.generate(
      otpLength,
      (_) => TextEditingController(),
    );

    otpFocusNodes = List.generate(
      otpLength,
      (_) => FocusNode(),
    );

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

  void onOtpFieldChanged(
    String value,
    int index,
  ) {
    if (value.isNotEmpty && index < otpLength - 1) {
      otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }

    _updateButtonState();
  }

  void _updateButtonState() {
    isButtonEnabled.value = otpControllers.every(
      (c) => c.text.isNotEmpty,
    );
  }

  void _startTimer() {
    remainingSeconds.value = 60;

    canResend.value = false;

    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          canResend.value = true;

          timer.cancel();
        }
      },
    );
  }

  Future<void> _resendApi() async {
    try {
      isLoading.value = true;

      final ApiResponse response =
          await api.commonApi.authenticationApi.resendOtp(
        flag: "register",
        mobile: number.value,
        country_code: "+91",
        role: "doctor",
      );

      final dynamic messageData = response.data['message'];

      if (messageData is Map && messageData['status'] == true) {
        final otp = messageData['otp']?.toString() ?? '';

        if (otp.isNotEmpty) {
          for (int i = 0; i < otp.length && i < otpControllers.length; i++) {
            otpControllers[i].text = otp[i];
          }
        }
      } else {
        showError(
          messageData is Map
              ? messageData['message']?.toString() ?? 'Failed to resend OTP'
              : 'Failed to resend OTP',
        );
      }
    } catch (e) {
      showError(
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resendOtp() {
    if (!canResend.value) return;

    for (var c in otpControllers) {
      c.clear();
    }

    _resendApi();

    _startTimer();

    showMessage(
      'A new OTP has been sent to ${mobileNumber.value}',
    );
  }

  void verifyOtp() {
    if (!isButtonEnabled.value) return;

    if (otpValue.length != 6) {
      showError(
        'Please enter correct OTP',
      );

      return;
    }

    isLoading.value = true;

    Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        await _submitDoctorSignup();
      },
    );
  }

  Future<void> _submitDoctorSignup() async {
    try {
      final reg = Get.find<RegistrationController>();

      final exp = Get.find<ExperienceController>();

      final digital = Get.find<DigitalReadinessController>();

      final finalController = Get.find<FinalVerificationController>();
      final fullName = reg.fullNameController.text.trim();

      final nameParts = fullName.split(' ');

      final firstName = nameParts.isNotEmpty ? nameParts.first : '';

      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final Map<String, dynamic> fields = {
        // OTP
        'otp': otpValue,
        'mobile': number.value,
        'country_code': '+91',

        // STEP 1
        'first_name': firstName,

        'last_name': lastName,

        'email': reg.emailController.text.trim(),

        'custom_medical_degree': reg.degreeController.text.trim(),

        'custom_registration_number':
            reg.registrationNumberController.text.trim(),

        'custom_year_of_graduation': reg.graduationYear.value != null
            ? DateFormat('yyyy-MM-dd').format(reg.graduationYear.value!)
            : '',

        // STEP 2
        'custom_total_experience': exp.totalExperience.value.toString(),

        'custom_primary_speciality': exp.specialtyController.text.trim(),

        'custom_current_practice_place': exp.selectedPracticePlaces.join(', '),

        'custom_care_experience': exp.selectedCareExperience.value!,

        'custom_gynaecological_history': exp.historyController.text.trim(),

        // STEP 3
        'custom_per_session_fee': digital.feeController.text.trim(),

        'custom_wait_time': digital.waitTimeController.text.trim(),

        // STEP 4
        'custom_latitude': finalController.latitude.value,

        'custom_longitude': finalController.longitude.value,

        'custom_why_do_you_want_to_join_phir_health':
            finalController.motivationController.text.trim(),
      };

      print(
        "DOCTOR SIGNUP FIELDS => $fields",
      );

      final ApiResponse response =
          await api.commonApi.authenticationApi.doctorSignup(
        fields: fields,
        profileImagePath: reg.profileImage.value?.path,
        clinicPhotoPaths: digital.clinicPhotos.map((e) => e.path).toList(),
      );

      print(
        "DOCTOR SIGNUP RESPONSE => ${response.data}",
      );

      final dynamic messageData = response.data['message'];

      if (messageData is Map && messageData['status'] == true) {
        final token = messageData['access_token'];
        final user = messageData['user'];

        if (token != null && token.toString().isNotEmpty) {
          await authStorage.saveToken(
            token,
          );

          apiClient.setBearerToken(
            token,
          );
        }

        if (user != null) {
          final doctor = messageData['doctor'] as Map<String, dynamic>? ?? {};

          final mergedData = {
            ...Map<String, dynamic>.from(user),
            ...doctor,
          };

          print('🟢 Merged data: $mergedData'); // ✅ Yeh add karo

          await authStorage.saveUserDetail(mergedData);
          final saved = await authStorage.getUserDetail();

          print('FINAL SAVED => $saved');
          await authStorage.saveLoginStatus(true);
        }

        showMessage(
          "Doctor registration successful",
        );

        Get.offAll(
          () => const DoctorAvailabilityView(isFromRegistration: true),
          binding: BindingsBuilder.put(() => DoctorAvailabilityController()),
        );
      } else {
        showError(
          messageData is Map
              ? messageData['message']?.toString() ?? 'Something went wrong'
              : 'Something went wrong',
        );
      }
    } catch (e) {
      showError(
        e.toString(),
      );
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
