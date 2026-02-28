import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../routes/app_routes.dart';

class RegistrationController extends GetxController {
  /// ================= TEXT CONTROLLERS =================
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController degreeController = TextEditingController();
  final TextEditingController registrationNumberController =
      TextEditingController();

  /// ================= STATE =================
  final Rxn<DateTime> graduationYear = Rxn<DateTime>();
  final RxBool isLicensed = true.obs;
  final Rx<File?> profileImage = Rx<File?>(null);

  /// ================= IMAGE PICKER =================
  final ImagePicker _picker = ImagePicker();

  Future<void> pickProfileImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      profileImage.value = File(image.path);
    }
  }

  /// ================= PICK YEAR =================
  Future<void> pickGraduationYear() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      helpText: "Select Graduation Year",
      fieldLabelText: "Year",
    );

    if (picked != null) {
      graduationYear.value = picked;
    }
  }

  /// ================= VALIDATION =================
  bool validateForm() {
    return fullNameController.text.trim().isNotEmpty &&
        degreeController.text.trim().isNotEmpty &&
        registrationNumberController.text.trim().isNotEmpty &&
        graduationYear.value != null;
  }

  /// ================= NAVIGATION =================
  void goToNextStep() {
    Get.toNamed(Routes.DOCTOR_EXPERIENCE);
  }

  @override
  void onClose() {
    fullNameController.dispose();
    degreeController.dispose();
    registrationNumberController.dispose();
    super.onClose();
  }
}
