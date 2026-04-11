import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DoctorEditClinicController extends GetxController {
  final TextEditingController clinicNameController =
      TextEditingController(text: 'Evergreen Wellness Clinic');
  final TextEditingController addressController =
      TextEditingController(text: '11, Vijay Nagar, Indore');
  final TextEditingController firstConsultController =
      TextEditingController(text: '600');
  final TextEditingController followUpController =
      TextEditingController(text: '200');
  final TextEditingController videoConsultController =
      TextEditingController(text: '500');

  final RxBool acceptingNewPatients = true.obs;
  final RxBool onlineBookingEnabled = true.obs;

  // Photos — File paths (picked from gallery)
  final RxList<String> clinicPhotos = <String>[
    'assets/icons/clinic1.png',
    'assets/icons/clinic2.png',
    'assets/icons/clinic3.png',
  ].obs;

  final int maxPhotos = 10;
  String get photoCount => '${clinicPhotos.length}/$maxPhotos';

  final ImagePicker _picker = ImagePicker();

  Future<void> addPhoto() async {
    if (clinicPhotos.length >= maxPhotos) {
      Get.snackbar('Limit Reached', 'Maximum $maxPhotos photos allowed',
          backgroundColor: Colors.white,
          colorText: Colors.black,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      clinicPhotos.add(picked.path);
    }
  }

  void removePhoto(int index) {
    clinicPhotos.removeAt(index);
  }

  void save() {
    Get.focusScope?.unfocus();
  }

  void cancel() {
    Get.focusScope?.unfocus();
  }

  @override
  void onClose() {
    clinicNameController.dispose();
    addressController.dispose();
    firstConsultController.dispose();
    followUpController.dispose();
    videoConsultController.dispose();
    super.onClose();
  }
}
