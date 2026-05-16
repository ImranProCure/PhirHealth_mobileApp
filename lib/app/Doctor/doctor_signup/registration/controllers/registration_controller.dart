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

  final TextEditingController mobileController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  /// ================= STATE =================

  final Rxn<DateTime> graduationYear = Rxn<DateTime>();

  final Rxn<DateTime> birthDate = Rxn<DateTime>();

  final RxBool isLicensed = true.obs;

  final Rx<File?> profileImage = Rx<File?>(null);

  /// ================= IMAGE PICKER =================

  final ImagePicker _picker = ImagePicker();

  /// ================= PICK IMAGE =================

  Future<void> pickProfileImage() async {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Profile Photo',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _imageOption(
                    icon: Icons.camera_alt_rounded,
                    title: 'Camera',
                    onTap: () async {
                      Get.back();

                      final XFile? image = await _picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 80,
                      );

                      if (image != null) {
                        profileImage.value = File(image.path);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _imageOption(
                    icon: Icons.photo_library_rounded,
                    title: 'Gallery',
                    onTap: () async {
                      Get.back();

                      final XFile? image = await _picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 80,
                      );

                      if (image != null) {
                        profileImage.value = File(image.path);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// ================= IMAGE OPTION =================

  Widget _imageOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 34,
              color: const Color(0xFF0D9488),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= PICK GRADUATION YEAR =================

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

  /// ================= PICK DOB =================

  Future<void> pickBirthDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      helpText: "Select Date of Birth",
    );

    if (picked != null) {
      birthDate.value = picked;
    }
  }

  /// ================= VALIDATION =================

  bool validateForm() {
    return fullNameController.text.trim().isNotEmpty &&
        degreeController.text.trim().isNotEmpty &&
        registrationNumberController.text.trim().isNotEmpty &&
        mobileController.text.trim().isNotEmpty &&
        mobileController.text.trim().length == 10 &&
        emailController.text.trim().isNotEmpty &&
        graduationYear.value != null &&
        birthDate.value != null;
  }

  /// ================= NEXT STEP =================

  void goToNextStep() {
    if (!validateForm()) {
      Get.snackbar(
        "Incomplete",
        "Please fill all required fields",
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    Get.toNamed(
      Routes.DOCTOR_EXPERIENCE,
    );
  }

  /// ================= DISPOSE =================

  @override
  void onClose() {
    fullNameController.dispose();

    degreeController.dispose();

    registrationNumberController.dispose();

    mobileController.dispose();

    emailController.dispose();

    super.onClose();
  }
}
