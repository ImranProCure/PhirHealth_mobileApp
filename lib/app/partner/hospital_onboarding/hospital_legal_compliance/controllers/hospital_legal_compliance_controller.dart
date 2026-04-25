import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HospitalLegalComplianceController extends GetxController {
  final licenseNumberController = TextEditingController();

  final RxBool nabhAccreditation = true.obs;
  final RxString hospitalLicensePath = ''.obs;
  final RxBool agreedToPolicy = false.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickHospitalLicense() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) {
      hospitalLicensePath.value = file.path;
    }
  }

  void submitRegistration() {
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
    // TODO: API submit call
    Get.offAllNamed('/hospital-legal-compliance');
  }

  @override
  void onClose() {
    licenseNumberController.dispose();
    super.onClose();
  }
}
