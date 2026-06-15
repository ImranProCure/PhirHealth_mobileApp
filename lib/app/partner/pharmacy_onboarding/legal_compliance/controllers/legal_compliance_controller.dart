import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/modules/pharmacy_verify_otp/views/pharmacy_verify_otp_view.dart';
import '../../pharmacy_registration/controllers/pharmacy_registration_controller.dart';

class LegalComplianceController extends GetxController {
  final Api api = Api.instance;
  final RxBool isLoading = false.obs;

  final panController = TextEditingController();
  final gstController = TextEditingController();
  final RxString drugLicensePath = ''.obs;
  final RxBool agreedToPolicy = false.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickDrugLicense() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) {
      drugLicensePath.value = file.path;
    }
  }

  Future<void> submitRegistration() async {
    if (!agreedToPolicy.value) {
      Get.snackbar(
        'Agreement Required',
        'Please agree to PHIR Policies before submitting.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D9488),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final registration = Get.find<PharmacyRegistrationController>();
      final String mobile = registration.contactController.text.trim();

      if (mobile.length != 10) {
        showError('Invalid mobile number');
        return;
      }

      final ApiResponse response = await api.commonApi.authenticationApi.login(
        flag: 'register',
        country_code: '+91',
        mobile: mobile,
        role: 'pharmacy',
      );

      debugPrint('PHARMACY OTP RESPONSE => ${response.data}');

      final dynamic messageData = response.data['message'];

      if (messageData is Map<String, dynamic> &&
          messageData['status'] == true) {
        final otp = messageData['otp']?.toString() ?? '';

        await Future.delayed(const Duration(milliseconds: 200));

        Get.to(
          () => const PharmacyVerifyOtpView(),
          arguments: {
            'phone': mobile,
            'otp': otp,
          },
        );
      } else {
        showError(
          messageData is Map
              ? messageData['message']?.toString() ?? 'Failed to send OTP'
              : response.data.toString(),
        );
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    panController.dispose();
    gstController.dispose();
    super.onClose();
  }
}
