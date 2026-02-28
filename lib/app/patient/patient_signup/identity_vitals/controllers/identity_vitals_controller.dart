import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../routes/app_routes.dart';

enum Gender { male, female, other }

class IdentityVitalsController extends GetxController {
  // ---------------- TEXT INPUT ----------------

  final nameController = TextEditingController();
  final dobController = TextEditingController();

  // ---------------- SELECTION STATES ----------------

  final gender = Gender.male.obs;

  /// Height stored in inches (easy to convert to ft/in)
  /// Example: 5'9" = 69 inches
  final heightInInches = 69.obs;

  /// Weight in KG (decimal allowed)
  final weightKg = 72.5.obs;

  final bloodGroup = 'A+'.obs;

  final bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-'];

  // ---------------- PROFILE IMAGE ----------------

  final Rx<File?> profileImage = Rx<File?>(null);

  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery
  Future<void> pickProfileImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      profileImage.value = File(image.path);
    }
  }

  /// Remove selected profile image (optional feature)
  void removeProfileImage() {
    profileImage.value = null;
  }

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (pickedDate != null) {
      dobController.text = "${pickedDate.month.toString().padLeft(2, '0')} / "
          "${pickedDate.day.toString().padLeft(2, '0')} / "
          "${pickedDate.year}";
    }
  }

  // ---------------- DERIVED VALUES (HELPERS) ----------------

  /// Convert inches → feet
  int get heightFeet => heightInInches.value ~/ 12;

  /// Remaining inches
  int get heightRemainingInches => heightInInches.value % 12;

  /// Simple form validation (can be expanded later)
  bool get isFormValid {
    return nameController.text.isNotEmpty &&
        dobController.text.isNotEmpty &&
        bloodGroup.value.isNotEmpty;
  }

  // ---------------- NAVIGATION ----------------

  void goToNextStep() {
    Get.toNamed(Routes.PATIENT_MEDICAL_HISTORY);
  }

  // ---------------- CLEANUP ----------------

  @override
  void onClose() {
    nameController.dispose();
    dobController.dispose();
    super.onClose();
  }
}
