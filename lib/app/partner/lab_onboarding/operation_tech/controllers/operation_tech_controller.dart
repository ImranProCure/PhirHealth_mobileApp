import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class OperationTechController extends GetxController {
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
    Get.toNamed('/verification-details');
  }

  @override
  void onClose() {
    panGstController.dispose();
    licenseController.dispose();
    super.onClose();
  }
}
