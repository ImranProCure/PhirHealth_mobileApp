import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/patient/patient_signup/Lifestyle/controllers/lifestyle_controller.dart';
import 'package:sample/app/patient/patient_signup/Womens_health/controllers/womens_health_controller.dart';
import 'package:sample/app/patient/patient_signup/completion/controllers/completion_controller.dart';
import 'package:sample/app/patient/patient_signup/family_wellbeing/controllers/family_wellbeing_controller.dart';
import 'package:sample/app/patient/patient_signup/identity_vitals/controllers/identity_vitals_controller.dart';
import 'package:sample/app/patient/patient_signup/medical_history/controllers/medical_history_controller.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/db/db.dart';
import '../../../controllers/role_controller.dart';
import '../../../routes/app_routes.dart';
import 'package:intl/intl.dart';

class VerifyMobileSignupController extends GetxController {
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

  final IdentityVitalsController controller1 =
      Get.put(IdentityVitalsController());

  final MedicalHistoryController controller2 =
      Get.put(MedicalHistoryController());

  final LifestyleController controller3 = Get.put(LifestyleController());

  final FamilyWellbeingController controller4 =
      Get.put(FamilyWellbeingController());

  final WomensHealthController controller5 = Get.put(WomensHealthController());
  final CompletionController controller6 = Get.put(CompletionController());

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

  Future<void> verifyOtpApi() async {
    isLoading.value = true;
    ApiResponse response = await api.commonApi.authenticationApi
        .verifyOtp(mobile: number.value, country_code: "+91", otp: otpValue);
    final messageData = response.data['message'];

    await authStorage.init();

    if (messageData["status"] == "success") {
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
    isLoading.value = false;
  }

  void verifyOtp() {
    if (!isButtonEnabled.value) return;
    isLoading.value = true; // ← ADD THIS

    Future.delayed(const Duration(seconds: 1), () {
      if (otpValue.length == 6) {
        completeProfile();
      } else {
        showError("Please enter the correct OTP");

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

  String getBloodGroupFullName(String group) {
    switch (group) {
      case 'A+':
        return 'A Positive';
      case 'A-':
        return 'A Negative';
      case 'B+':
        return 'B Positive';
      case 'B-':
        return 'B Negative';
      case 'O+':
        return 'O Positive';
      case 'O-':
        return 'O Negative';
      default:
        return group;
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

  Future<void> _resendApi() async {
    isLoading.value = true;
    ApiResponse response = await api.commonApi.authenticationApi
        .resendOtp(flag: "register", mobile: number.value, country_code: "+91");
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

  String getStressLevel(int value) {
    switch (value) {
      case 0:
        return "Low";
      case 1:
        return "Moderate";
      case 2:
        return "High";
      default:
        return "Unknown";
    }
  }

  String formatDob(String dob) {
    DateTime date = DateFormat("dd / MM / yyyy").parse(dob);
    return DateFormat("yyyy-MM-dd").format(date);
  }

  void hideProfileDialog() {
    if (Get.isDialogOpen ?? false) Get.back();
  }

  // ================= FINAL ACTION =================
  void completeProfile() async {
    final Map<String, dynamic> fields = {
      'full_name': controller1.nameController.text,
      'email': controller1.emailController.text,
      'mobile_number': controller1.mobileController.text,
      'date_of_birth': formatDob(controller1.dobController.text),
      'gender': controller1.gender.value.name,
      'height': controller1.heightController.text,
      'weight': controller1.weightController.text,
      'blood_group': getBloodGroupFullName(controller1.bloodGroup.value),
      'existing_medical_condition': controller2.selectedConditions.value,
      'allergies': controller2.selectedAllergies.value,
      'allergy': controller2.pastProceduresController.text,
      'current_medications': controller2.medicationsController.text,
      'smoking': controller3.selectedSmoking.value,
      'alcohol': controller3.selectedAlcohol.value,
      'diet_preference': controller3.selectedDiet.value,
      'average_sleep': controller3.sleepIndex.value,
      'family_medical_history': controller4.selectedFamilyConditions.value,
      'mental_well_being': getStressLevel(controller4.stressIndex.value),
      'common_symptoms': controller4.selectedSymptoms.value,
      'emergency_contact_name': controller6.contactNameController.text,
      'emergency_relation': controller6.selectedRelationship.value,
      'emergency_mobile': controller6.mobileController.text,
      'authorize_phir_health': 1,
      'country_code': "91",
      'otp': otpValue,
    };

    if (controller1.gender.value == Gender.female) {
      fields['menstrual_cycle'] = controller5.lastPeriodController.text;
      fields['pregnancy_status'] = controller5.isPregnant.value;
      fields['gynaecological_history'] =
          controller5.historyController.text.isEmpty
              ? ""
              : controller5.historyController.text.isEmpty;
    }

    ApiResponse response = await api.commonApi.authenticationApi.patientSignup(
      fields: fields,
      filePath: controller1
          .profileImage.value!.path, // safe now due to null check above
    );
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

          Get.offAllNamed(Routes.DASHBOARD);
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
}
