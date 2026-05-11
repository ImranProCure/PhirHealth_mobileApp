import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/controllers/role_controller.dart';

import 'package:sample/app/modules/verify_mobile_signup_patient/bindings/verify_mobile_signup_binding.dart';
import 'package:sample/app/modules/verify_mobile_signup_patient/views/verify_mobile_signup_view.dart';
import 'package:sample/app/patient/patient_signup/Lifestyle/controllers/lifestyle_controller.dart';
import 'package:sample/app/patient/patient_signup/Womens_health/controllers/womens_health_controller.dart';
import 'package:sample/app/patient/patient_signup/family_wellbeing/controllers/family_wellbeing_controller.dart';
import 'package:sample/app/patient/patient_signup/identity_vitals/controllers/identity_vitals_controller.dart';
import 'package:sample/app/patient/patient_signup/medical_history/controllers/medical_history_controller.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import '../../../../routes/app_routes.dart';

class CompletionController extends GetxController {
  // ================= TEXT CONTROLLERS =================
  Api api = Api.instance;
  ApiClient apiClient = ApiClient();
  final RoleController _roleController = Get.find<RoleController>();

  final contactNameController = TextEditingController();
  final mobileController = TextEditingController();

  // ================= RELATIONSHIP =================

  final relationships = [
    'Father',
    'Mother',
    'Brother',
    'Sister',
    'Spouse',
    'Child',
    'Other'
  ];

  final selectedRelationship = ''.obs;

  void selectRelationship(String value) {
    selectedRelationship.value = value;
  }

  // ================= CHECKBOXES =================

  final authorizeEmergency = false.obs;
  final agreePolicy = false.obs;
  final RxBool isLoading = false.obs;
  void toggleAuthorize() {
    authorizeEmergency.toggle();
  }

  void toggleAgreePolicy() {
    agreePolicy.toggle();
  }

  // ================= APP PERMISSIONS =================

  final medicalDataProcessing = true.obs;
  final shareWithDoctors = true.obs;
  final healthReminders = false.obs;

  final allowMedicalProcessing = true.obs;
  final enableReminders = false.obs;

  void toggleMedicalProcessing(bool value) {
    medicalDataProcessing.value = value;
  }

  void toggleShareWithDoctors(bool value) {
    shareWithDoctors.value = value;
  }

  void toggleHealthReminders(bool value) {
    healthReminders.value = value;
  }

  final acceptTerms = false.obs;

  void toggleTerms() {
    acceptTerms.value = !acceptTerms.value;
  }

  final IdentityVitalsController controller1 =
      Get.put(IdentityVitalsController());

  get toastService => null;

  void otpSend() async {
    if (contactNameController.text.isEmpty) {
      showError('Please enter name');
      return;
    }
    if (selectedRelationship.isEmpty) {
      showError('Please select relationship');
      return;
    }
    if (mobileController.text.isEmpty) {
      showError('Please enter mobile number');
      return;
    }
    if (!authorizeEmergency.value) {
      showError(
          'Please authorize PHIR Health to share critical medical profile in case of emergency');
      return;
    }
    if (!acceptTerms.value) {
      showError('Please agree to Terms & Privacy Policy');
      return;
    }
    isLoading.value = true;
    ApiResponse response = await api.commonApi.authenticationApi.login(
      mobile: controller1.mobileController.text,
      country_code: "+91",
      flag: "register",
      role: 'patient',
    );
    isLoading.value = false;
    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      if (messageData is Map<String, dynamic>) {
        final otp = messageData['otp'];

        if (otp != null && otp.isNotEmpty) {
          showMessage(
            'OTP sent to +91${controller1.mobileController.text}',
          );

          // All roles go through OTP — role passed in arguments
          Get.to(
            () => const VerifyMobileSignupView(),
            binding: VerifyMobileSignupBinding(),
            arguments: {
              'phone': controller1.mobileController.text,
              'role': _roleController.role,
              'otp': otp,
            },
          );
        }
      } else {
        showError(response.message);
        // Get.offAllNamed(Routes.MAIN_SCREEN);
      }
    } else {
      showError(
        messageData["message"],
      );
    }
  }

  @override
  void onClose() {
    contactNameController.dispose();
    mobileController.dispose();
    super.onClose();
  }
}
