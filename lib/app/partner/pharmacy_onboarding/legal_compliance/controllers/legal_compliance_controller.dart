import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class LegalComplianceController extends GetxController {
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
    Get.offAllNamed('/select-facility-type');
  }

  @override
  void onClose() {
    panController.dispose();
    gstController.dispose();
    super.onClose();
  }
}
