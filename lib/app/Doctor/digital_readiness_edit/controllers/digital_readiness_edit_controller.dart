import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

import '../../../routes/app_routes.dart';

class DigitalReadinessEditController extends GetxController {
  final Api api = Api.instance;

  /// ================= LOADING =================
  final RxBool isLoading = false.obs;
  final RxBool isFetching = true.obs;

  /// ================= CLINIC PHOTOS =================
  final RxList<File> clinicPhotos = <File>[].obs;
  final RxList<String> existingClinicPhotos = <String>[].obs;
  final ImagePicker _picker = ImagePicker();

  /// ================= CONSULTATION FEE =================
  final TextEditingController feeController = TextEditingController();

  /// ================= WAIT TIME =================
  final TextEditingController waitTimeController = TextEditingController();

  /// ================= EMAIL & MOBILE (identifiers) =================
  final RxString _email = ''.obs;
  final RxString _mobile = ''.obs;

  /// ================= ON INIT =================
  @override
  void onInit() {
    super.onInit();
    _fetchProfile();
  }

  /// ================= GET DOCTOR PROFILE =================
  Future<void> _fetchProfile() async {
    try {
      isFetching.value = true;

      final ApiResponse response =
          await api.commonApi.authenticationApi.getDoctorProfile();

      final data = response.data;
      final message = data['message'];

      if (message != null && message['status'] == true) {
        final msgData = message['data'] as Map<String, dynamic>? ?? {};
        final doctor = msgData['doctor'] as Map<String, dynamic>? ?? {};
        final user = msgData['user'] as Map<String, dynamic>? ?? {};

        // ===== IDENTIFIERS =====
        _email.value = user['email']?.toString() ?? '';
        _mobile.value = user['mobile_no']?.toString() ?? '';

        // ===== FEE =====
        feeController.text = doctor['custom_per_session_fee']?.toString() ?? '';

        // ===== WAIT TIME =====
        waitTimeController.text = doctor['custom_wait_time']?.toString() ?? '';

        // ===== EXISTING CLINIC PHOTOS =====
        // ===== EXISTING CLINIC PHOTOS =====
        final photos = doctor['custom_clinic_photos'];
        print('PHOTOS => $photos');
        if (photos is List) {
          existingClinicPhotos.assignAll(
            photos
                .map((e) {
                  final path = e.toString();
                  if (path.isEmpty) return '';
                  return path.startsWith('http')
                      ? path
                      : 'https://scaphoid-donte-uncompellable.ngrok-free.dev$path';
                })
                .where((e) => e.isNotEmpty)
                .toList(),
          );
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

  /// ================= PICK CLINIC PHOTOS =================
  Future<void> pickClinicPhotos() async {
    final List<XFile> images = await _picker.pickMultiImage(imageQuality: 80);
    if (images.isNotEmpty) {
      clinicPhotos.addAll(images.map((e) => File(e.path)));
    }
  }

  /// ================= REMOVE PHOTO =================
  void removePhoto(File image) {
    clinicPhotos.remove(image);
  }

  /// ================= REMOVE EXISTING PHOTO =================
  void removeExistingPhoto(String url) {
    existingClinicPhotos.remove(url);
  }

  /// ================= VALIDATION =================
  bool validateForm() {
    if (feeController.text.trim().isEmpty) {
      showError('Consultation fee is required');
      return false;
    }
    if (waitTimeController.text.trim().isEmpty) {
      showError('Average wait time is required');
      return false;
    }
    return true;
  }

  /// ================= UPDATE =================
  Future<void> updateDigitalReadiness() async {
    if (!validateForm()) return;
    print('EXISTING PHOTOS => ${existingClinicPhotos.toList()}');

    try {
      isLoading.value = true;

      final Map<String, dynamic> fields = {
        'email': _email.value,
        'mobile_no': _mobile.value,
        'custom_per_session_fee': feeController.text.trim(),
        'custom_wait_time': waitTimeController.text.trim(),
        // existing photos jo delete nahi hui woh bhi bhejo
        'existing_clinic_photos': existingClinicPhotos.toList(),
      };

      final ApiResponse response =
          await api.commonApi.authenticationApi.updateDoctorProfile(
        fields: fields,
        clinicPhotoPaths: clinicPhotos.map((f) => f.path).toList(),
      );

      if (response.status) {
        showMessage('Updated successfully');
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
    feeController.dispose();
    waitTimeController.dispose();
    super.onClose();
  }
}
