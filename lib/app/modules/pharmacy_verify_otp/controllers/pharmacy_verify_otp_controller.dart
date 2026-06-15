import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/db/db.dart';

import '../../../partner/pharmacy_onboarding/pharmacy_registration/controllers/pharmacy_registration_controller.dart';
import '../../../partner/pharmacy_onboarding/logistics_integration/controllers/logistics_integration_controller.dart';
import '../../../partner/pharmacy_onboarding/inventory_offerings /controllers/inventory_offerings_controller.dart';
import '../../../partner/pharmacy_onboarding/legal_compliance/controllers/legal_compliance_controller.dart';

class PharmacyVerifyOtpController extends GetxController {
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
      await _submitPharmacyOnboarding();
    });
  }

  Future<void> _submitPharmacyOnboarding() async {
    try {
      final registration = Get.find<PharmacyRegistrationController>();
      final inventory = Get.find<InventoryOfferingsController>();
      final logistics = Get.find<LogisticsIntegrationController>();
      final legal = Get.find<LegalComplianceController>();

      // Medicine types list
      final medicineTypesString =
          '[${inventory.selectedMedicineTypes.map((e) => '"$e"').join(',')}]';

      // Delivery time
      String deliveryTime = '';
      if (logistics.selectedDeliveryTime.value == '2hours') {
        deliveryTime = '2 Hours';
      } else if (logistics.selectedDeliveryTime.value == 'sameday') {
        deliveryTime = 'Same Day';
      } else {
        deliveryTime = logistics.customTimeController.text.trim();
      }

      final formData = FormData.fromMap({
        // Basic Info
        'pharmacy_name': registration.pharmacyNameController.text.trim(),
        'contact_number': number.value.isNotEmpty
            ? number.value
            : registration.contactController.text.trim(),
        'country_code': '+91',
        'email': registration.emailController.text.trim(),
        'address': registration.addressController.text.trim(),
        'website': registration.websiteController.text.trim(),
        'type_of_pharmacy': registration.selectedInterests.join(', '),

        // Inventory
        'medicine_types': medicineTypesString,
        'schedule_drugs': inventory.scheduleDrugs.value ? '1' : '0',
        'generic_medicines': inventory.genericMedicines.value ? '1' : '0',
        'e_prescriptions': inventory.ePrescriptions.value ? '1' : '0',

        // Logistics
        'home_delivery_available': logistics.homeDelivery.value ? '1' : '0',
        'delivery_time': deliveryTime,
        'custom_time': logistics.customTimeController.text.trim(),
        'online_order_management': logistics.omsAvailable.value ? '1' : '0',

        // Legal
        'pan_number': legal.panController.text.trim(),
        'gst_number': legal.gstController.text.trim(),

        // OTP
        'otp': otpValue,
      });

      // Pharmacy logo
      if (registration.logoPath.value.isNotEmpty) {
        formData.files.add(MapEntry(
          'pharmacy_logo',
          await MultipartFile.fromFile(
            registration.logoPath.value,
            filename: 'pharmacy_logo.jpg',
          ),
        ));
      }

      // Drug license
      if (legal.drugLicensePath.value.isNotEmpty) {
        formData.files.add(MapEntry(
          'upload_drug_license',
          await MultipartFile.fromFile(
            legal.drugLicensePath.value,
            filename: 'drug_license.jpg',
          ),
        ));
      }

      debugPrint('🟣 PHARMACY ONBOARDING FIELDS => ${formData.fields}');

      final ApiResponse response =
          await api.commonApi.authenticationApi.pharmacySignup(
        formData: formData,
      );

      debugPrint('🟣 PHARMACY ONBOARDING RESPONSE => ${response.data}');

      final dynamic messageData = response.data['message'];

      if (messageData is Map && messageData['status'] == true) {
        final token = messageData['access_token'];
        final user = messageData['user'];

        if (token != null && token.toString().isNotEmpty) {
          await authStorage.saveToken(token);
          apiClient.setBearerToken(token);
        }

        if (user != null) {
          final pharmacy =
              messageData['pharmacy'] as Map<String, dynamic>? ?? {};
          final mergedData = {
            ...Map<String, dynamic>.from(user),
            ...pharmacy,
          };
          await authStorage.saveUserDetail(mergedData);
          await authStorage.saveLoginStatus(true);
        }

        showMessage('Pharmacy registered successfully! 🎉');
        Get.offAllNamed('/pharmacy-dashboard');
      } else {
        showError(
          messageData is Map
              ? messageData['message']?.toString() ?? 'Something went wrong'
              : 'Something went wrong',
        );
      }
    } catch (e) {
      debugPrint('❌ Pharmacy onboarding error: $e');
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
