import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sample/app/modules/doctor_verify_otp/views/doctor_verify_otp_view.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/common_function.dart';

import '../../registration/controllers/registration_controller.dart';

class FinalVerificationController extends GetxController {
  final Api api = Api.instance;

  /// ================= CONFIRMATION =================

  final RxBool isConfirmed = false.obs;

  final RxBool isLoading = false.obs;

  /// ================= MOTIVATION =================

  final TextEditingController motivationController = TextEditingController();

  /// ================= LOCATION =================

  final RxString latitude = ''.obs;

  final RxString longitude = ''.obs;

  final RxBool isFetchingLocation = false.obs;

  final RxString locationStatus = 'Location not fetched'.obs;

  /// ================= GET CURRENT LOCATION =================

  Future<void> getCurrentLocation() async {
    try {
      isFetchingLocation.value = true;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        showError(
          'Please enable location services',
        );

        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        showError(
          'Location permission denied',
        );

        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude.toString();

      longitude.value = position.longitude.toString();

      locationStatus.value = 'Location fetched successfully';

      showMessage(
        'Location fetched successfully',
      );
    } catch (e) {
      showError(
        e.toString(),
      );
    } finally {
      isFetchingLocation.value = false;
    }
  }

  /// ================= SUBMIT =================

  Future<void> submitApplication() async {
    if (isLoading.value) return;

    if (latitude.value.isEmpty ||
        longitude.value.isEmpty ||
        !isConfirmed.value) {
      showError(
        'Please complete all required fields',
      );

      return;
    }

    final reg = Get.find<RegistrationController>();

    final String mobile = reg.mobileController.text.trim();

    if (mobile.length != 10) {
      showError(
        'Invalid mobile number',
      );

      return;
    }

    try {
      isLoading.value = true;

      final ApiResponse response = await api.commonApi.authenticationApi.login(
        flag: 'register',
        country_code: '+91',
        mobile: mobile,
        role: 'doctor',
      );

      print(
        "GENERATE OTP RESPONSE => ${response.data}",
      );

      final dynamic messageData = response.data['message'];

      if (messageData is Map<String, dynamic> &&
          messageData['status'] == true) {
        final otp = messageData['otp']?.toString() ?? '';

        await Future.delayed(
          const Duration(
            milliseconds: 200,
          ),
        );

        Get.to(
          () => const DoctorVerifyOtpView(),
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
      showError(
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    motivationController.dispose();

    super.onClose();
  }
}
