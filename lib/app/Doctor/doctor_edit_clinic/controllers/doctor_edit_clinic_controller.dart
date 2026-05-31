import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/api/common_api/doctor_clinic_api/doctor_clinic_api.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';

class DoctorEditClinicController extends GetxController {
  final DoctorClinicApi _api = DoctorClinicApi();

  // ===== LOADING =====
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  // ===== TEXT CONTROLLERS =====
  final TextEditingController clinicNameController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController clinicFeeController = TextEditingController();
  final TextEditingController videoFeeController = TextEditingController();

  // ===== PHOTOS =====
  final RxList<String> existingPhotos = <String>[].obs;
  final RxList<String> newPhotos = <String>[].obs;

  final int maxPhotos = 10;

  List<String> get clinicPhotos => [...existingPhotos, ...newPhotos];
  String get photoCount => '${clinicPhotos.length}/$maxPhotos';

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchClinicProfile();
  }

  // ===== FETCH =====
  Future<void> fetchClinicProfile() async {
    try {
      isLoading.value = true;

      final ApiResponse response = await _api.getClinicProfile();
      final message = response.data['message'];

      if (message != null && message['status'] == true) {
        final data = message['data'] as Map<String, dynamic>;

        clinicNameController.text = data['clinic_name']?.toString() ?? '';

        final address = data['physical_address'] as Map<String, dynamic>? ?? {};
        addressLine1Controller.text =
            address['address_line1']?.toString() ?? '';
        addressLine2Controller.text =
            address['address_line2']?.toString() ?? '';
        cityController.text = address['city']?.toString() ?? '';

        clinicFeeController.text = data['clinic_visit_fee']?.toString() ?? '0';
        videoFeeController.text = data['video_consult_fee']?.toString() ?? '0';

        final photos = data['clinic_photos'] as List? ?? [];
        existingPhotos.assignAll(
          photos.map((p) => p.toString()).toList(),
        );
      } else {
        showError(message?['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ===== ADD PHOTO =====
  Future<void> addPhoto() async {
    if (clinicPhotos.length >= maxPhotos) {
      showError('Maximum $maxPhotos photos allowed');
      return;
    }
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      newPhotos.add(picked.path);
    }
  }

  // ===== REMOVE PHOTO =====
  void removePhoto(int index) {
    if (index < existingPhotos.length) {
      existingPhotos.removeAt(index);
    } else {
      newPhotos.removeAt(index - existingPhotos.length);
    }
  }

  // ===== SAVE =====
  Future<void> save() async {
    Get.focusScope?.unfocus();

    if (clinicNameController.text.trim().isEmpty) {
      showError('Please enter clinic name');
      return;
    }

    try {
      isSaving.value = true;

      final ApiResponse response = await _api.updateClinicProfile(
        clinicName: clinicNameController.text.trim(),
        addressLine1: addressLine1Controller.text.trim(),
        addressLine2: addressLine2Controller.text.trim(),
        city: cityController.text.trim(),
        clinicFee: clinicFeeController.text.trim(),
        videoFee: videoFeeController.text.trim(),
        clinicPhotos: existingPhotos.toList(),
      );

      final message = response.data['message'];

      if (message != null && message['status'] == true) {
        showMessage('Clinic profile updated successfully!');
        Get.back(result: true);
      } else {
        showError(message?['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  // ===== CANCEL =====
  void cancel() {
    Get.focusScope?.unfocus();
    Get.back();
  }

  @override
  void onClose() {
    clinicNameController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    clinicFeeController.dispose();
    videoFeeController.dispose();
    super.onClose();
  }
}
