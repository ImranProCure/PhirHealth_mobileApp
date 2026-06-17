import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../routes/app_routes.dart';

class DigitalReadinessController extends GetxController {
  /// ================= CLINIC PHOTOS =================

  final RxList<File> clinicPhotos = <File>[].obs;

  final ImagePicker _picker = ImagePicker();

  /// ================= CONSULTATION FEE =================

  final TextEditingController feeController = TextEditingController();
  final TextEditingController clinicVisitFeeController =
      TextEditingController();

  /// ================= WAIT TIME =================

  final TextEditingController waitTimeController = TextEditingController();

  /// ================= PICK CLINIC PHOTOS =================

  Future<void> pickClinicPhotos() async {
    final List<XFile> images = await _picker.pickMultiImage(
      imageQuality: 80,
    );

    if (images.isNotEmpty) {
      clinicPhotos.addAll(
        images.map(
          (e) => File(e.path),
        ),
      );
    }
  }

  /// ================= REMOVE PHOTO =================

  void removePhoto(File image) {
    clinicPhotos.remove(image);
  }

  /// ================= VALIDATION =================

  bool validateForm() {
    return feeController.text.trim().isNotEmpty &&
        clinicVisitFeeController.text.trim().isNotEmpty &&
        waitTimeController.text.trim().isNotEmpty;
  }

  /// ================= NEXT STEP =================

  void goToNextStep() {
    if (!validateForm()) {
      Get.snackbar(
        'Incomplete',
        'Please fill all required fields',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    Get.toNamed(
      Routes.DOCTOR_FINAL_VERIFICATION,
    );
  }

  /// ================= DISPOSE =================

  @override
  void onClose() {
    feeController.dispose();
    clinicVisitFeeController.dispose();

    waitTimeController.dispose();

    super.onClose();
  }
}
