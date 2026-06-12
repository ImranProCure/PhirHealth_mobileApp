import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/modules/lab_onboarding_verify_otp/views/lab_onboarding_verify_otp_view.dart';
import '../../../lab_onboarding/basic_info/controllers/basic_info_controller.dart';

import 'package:flutter/material.dart';

class OperationTechController extends GetxController {
  final Api api = Api.instance;
  final RxBool isLoading = false.obs;

  final List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  final RxSet<int> selectedDays = <int>{5, 6}.obs;

  final RxString fromTime = '08:00 AM'.obs;
  final RxString toTime = '08:00 PM'.obs;

  final RxBool emergencyService = true.obs;
  final RxBool onlineBookings = true.obs;
  final RxBool apiIntegration = false.obs;

  void toggleDayByIndex(int index) {
    if (selectedDays.contains(index)) {
      selectedDays.remove(index);
    } else {
      selectedDays.add(index);
    }
  }

  Future<void> submitRegistration() async {
    if (isLoading.value) return;
    final workingDays = List.from(selectedDays);
    if (workingDays.length == 7) {
      showError('Please select at least one working day');
      return;
    }

    try {
      isLoading.value = true;

      final basic = Get.find<BasicInfoController>();
      final String mobile = basic.contactController.text.trim();

      if (mobile.length != 10) {
        showError('Invalid mobile number');
        return;
      }

      final ApiResponse response = await api.commonApi.authenticationApi.login(
        flag: 'register',
        country_code: '+91',
        mobile: mobile,
        role: 'lab manager',
      );

      debugPrint('GENERATE OTP RESPONSE => ${response.data}');

      final dynamic messageData = response.data['message'];

      if (messageData is Map<String, dynamic> &&
          messageData['status'] == true) {
        final otp = messageData['otp']?.toString() ?? '';

        await Future.delayed(const Duration(milliseconds: 200));

        Get.to(
          () => const LabOnboardingVerifyOtpView(),
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
}
