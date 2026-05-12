import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/modules/verify_mobile/bindings/verify_mobile_binding.dart';
import 'package:sample/app/modules/verify_mobile/views/verify_mobile_view.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/db/db.dart';
import 'package:sample/app/service/toast_service/toast_service.dart';
import '../../../controllers/role_controller.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final RoleController _roleController = Get.find<RoleController>();
  final TextEditingController phoneController = TextEditingController();
  final RxBool isLoading = false.obs;
  Api api = Api.instance;
  ToastService toastService = ToastService.instance;
  AuthStorageService authStorage = AuthStorageService();
  ApiClient apiClient = ApiClient();
  // ===== GET OTP — same for all roles =====
  void getOTP() {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      _showError('Please enter your mobile number');
      return;
    }
    if (phone.length != 10) {
      _showError('Please enter a valid 10-digit mobile number');
      return;
    }

    _login();
  }

  // ===== SIGNUP — role based =====
  void goToSignup() {
    final role = _roleController.role;
    if (role == null) {
      _showError('Please select a role first');
      return;
    }
    switch (role) {
      case UserRole.patient:
        Get.toNamed(Routes.PATIENT_IDENTITY_VITALS);
        break;
      case UserRole.doctor:
        Get.toNamed(Routes.DOCTOR_REGISTRATION);
        break;
      case UserRole.corporate:
        Get.toNamed(Routes.CORPORATE_STEP1);
        break;
      case UserRole.coach:
        Get.toNamed(Routes.COACH_STEP1);
        break;
      case UserRole.partner:
      case UserRole.coach:
        _showError('Signup flow not implemented yet for this role');
        break;
    }
  }

  void _showError(String message) {
    Get.snackbar('Error', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(16),
        borderRadius: 12);
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  Future<void> _login() async {
    isLoading.value = true;
    String role = 'patient'; // default
    if (_roleController.role == UserRole.doctor) {
      role = 'doctor';
    }
    ApiResponse response = await api.commonApi.authenticationApi.login(
        mobile: phoneController.text,
        country_code: "+91",
        flag: "kalash",
        role: role);
    isLoading.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      if (messageData is Map<String, dynamic>) {
        final otp = messageData['otp'];

        if (otp != null && otp.isNotEmpty) {
          showMessage(
            'OTP sent to +91${phoneController.text}',
          );

          // All roles go through OTP — role passed in arguments
          Get.to(
            () => const VerifyMobileView(),
            binding: VerifyMobileBinding(),
            arguments: {
              'phone': phoneController.text,
              'role': _roleController.role,
              'otp': otp,
            },
          );
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
