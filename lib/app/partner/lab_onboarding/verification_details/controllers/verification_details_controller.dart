import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:image_picker/image_picker.dart';

class VerificationDetailsController extends GetxController {
  final panGstController = TextEditingController();
  final licenseController = TextEditingController();

  final RxBool nablAccredited = true.obs;
  final RxString certificatePath = ''.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickCertificate() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) {
      certificatePath.value = file.path;
    }
  }

  void goToNext() {
    if (panGstController.text.trim().isEmpty) {
      showError('Please enter PAN / GST number');
      return;
    }
    if (licenseController.text.trim().isEmpty) {
      showError('Please enter registration / license number');
      return;
    }
    if (certificatePath.value.isEmpty) {
      showError('Please upload license certificate');
      return;
    }
    Get.toNamed('/operation-tech');
  }

  @override
  void onClose() {
    panGstController.dispose();
    licenseController.dispose();
    super.onClose();
  }
}
