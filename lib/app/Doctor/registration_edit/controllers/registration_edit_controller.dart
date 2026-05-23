import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/db/db.dart';
import '../../../service/api/api_client/api_constants.dart';

import '../../../../app/routes/app_routes.dart';

class RegistrationEditController extends GetxController {
  final Api api = Api.instance;

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

  final RxBool isLoading = false.obs;

  final RxBool isFetching = true.obs;

  final Rx<File?> profileImage = Rx<File?>(null);

  final RxString existingImageUrl = ''.obs;

  /// ================= RAW MOBILE (as stored in DB) =================
  final RxString _rawMobile = ''.obs;

  /// ================= IMAGE PICKER =================

  final ImagePicker _picker = ImagePicker();

  /// ================= ON INIT =================

  @override
  void onInit() {
    super.onInit();
    _fetchProfile();
  }

  /// ================= GET API =================

  Future<void> _fetchProfile() async {
    try {
      isFetching.value = true;
      await ApiClient().initializeToken();

      final ApiResponse response =
          await api.commonApi.authenticationApi.getDoctorProfile();
      final data = response.data;
      final message = data['message'];

      if (message != null && message['status'] == true) {
        final msgData = message['data'] as Map<String, dynamic>? ?? {};
        final user = msgData['user'] as Map<String, dynamic>? ?? {};
        final doctor = msgData['doctor'] as Map<String, dynamic>? ?? {};
        final mergedData = {...user, ...doctor};

        // ===== FULL NAME =====
        final fullName =
            '${mergedData['first_name'] ?? ''} ${mergedData['last_name'] ?? ''}'
                .trim();
        fullNameController.text = fullName;

        // ===== DEGREE =====
        degreeController.text =
            mergedData['custom_medical_degree']?.toString() ?? '';

        // ===== REG NUMBER =====
        registrationNumberController.text =
            mergedData['custom_registration_number']?.toString() ?? '';

        // ===== MOBILE =====
        final mobile = mergedData['mobile_no']?.toString() ?? '';
        _rawMobile.value = mobile; // raw value save karo
        mobileController.text = mobile.replaceAll('+91', '').trim();

        // ===== EMAIL =====
        emailController.text = mergedData['email']?.toString() ?? '';

        // ===== GRADUATION YEAR =====
        final gradYear = doctor['custom_year_of_graduation']?.toString() ?? '';
        if (gradYear.isNotEmpty) {
          try {
            graduationYear.value = DateTime.parse('$gradYear-01-01');
          } catch (_) {}
        }

        // ===== DOB =====
        final dob = user['date_of_birth']?.toString() ?? '';
        if (dob.isNotEmpty) {
          try {
            birthDate.value = DateTime.parse(dob);
          } catch (_) {}
        }

        // ===== PROFILE IMAGE =====
        final image =
            doctor['image']?.toString() ?? user['user_image']?.toString() ?? '';
        if (image.isNotEmpty) {
          existingImageUrl.value = ApiConstants.imageUrl(image);
        }
      } else {
        showError(
          message?['message']?.toString() ?? 'Failed to load profile',
        );
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isFetching.value = false;
    }
  }

  /// ================= PICK IMAGE =================

  Future<void> pickProfileImage() async {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 34, color: const Color(0xFF0D9488)),
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
      initialDate: graduationYear.value ?? DateTime.now(),
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
      initialDate: birthDate.value ?? DateTime(2000),
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

  /// ================= UPDATE PROFILE =================

  Future<void> updateProfile() async {
    if (!validateForm()) {
      Get.snackbar(
        "Incomplete",
        "Please fill all required fields",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      // ===== FULL NAME SPLIT =====
      final nameParts = fullNameController.text.trim().split(' ');
      final firstName = nameParts.first;
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final Map<String, dynamic> fields = {
        'email': emailController.text.trim(),
        'mobile_no': _rawMobile.value,
        'first_name': firstName,
        'last_name': lastName,
        'custom_medical_degree': degreeController.text.trim(),
        'custom_registration_number': registrationNumberController.text.trim(),
        'custom_year_of_graduation':
            graduationYear.value?.year.toString() ?? '',
        'date_of_birth': birthDate.value != null
            ? '${birthDate.value!.year}-${birthDate.value!.month.toString().padLeft(2, '0')}-${birthDate.value!.day.toString().padLeft(2, '0')}'
            : '',
      };

      final ApiResponse response =
          await api.commonApi.authenticationApi.updateDoctorProfile(
        fields: fields,
        profileImagePath: profileImage.value?.path,
      );

      if (response.status) {
        showMessage('Profile updated successfully');
        Get.back();
      } else {
        showError(response.message);
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
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
