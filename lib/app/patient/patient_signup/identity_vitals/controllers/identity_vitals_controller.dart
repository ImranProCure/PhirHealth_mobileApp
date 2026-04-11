import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sample/app/common_function.dart';
import '../../../../routes/app_routes.dart';

enum Gender { male, female, other }

class IdentityVitalsController extends GetxController {
  // ---------------- TEXT INPUT ----------------

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final dobController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
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

  Future<void> pickProfileImage(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0D9488), // Header & selected date
              onPrimary: Colors.white, // Text on header
              onSurface: Colors.black, // Default text
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0D9488), // Cancel & OK buttons
              ),
            ),
          ),
          child: child!,
        );
      },
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
    if (profileImage.value == null) {
      showError("Please upload profile image");
      return;
    }

    if (nameController.text.trim().isEmpty) {
      showError("Please enter your name");
      return;
    }

    if (emailController.text.trim().isEmpty) {
      showError("Please enter your email");
      return;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      showError("Please enter valid email");
      return;
    }

    if (mobileController.text.trim().isEmpty) {
      showError("Please enter mobile number");
      return;
    }

    if (mobileController.text.trim().length != 10) {
      showError("Please enter valid mobile number");
      return;
    }

    if (dobController.text.trim().isEmpty) {
      showError("Please select date of birth");
      return;
    }

    if (heightController.text.trim().isEmpty) {
      showError("Please enter height");
      return;
    }

    if (weightController.text.trim().isEmpty) {
      showError("Please enter weight");
      return;
    }

    if (bloodGroup.value.isEmpty) {
      showError("Please select blood group");
      return;
    }

    // All validations passed
    Get.toNamed(Routes.PATIENT_MEDICAL_HISTORY);
  }

  // ---------------- CLEANUP ----------------

  @override
  void onClose() {
    nameController.dispose();
    dobController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.onClose();
  }
}
