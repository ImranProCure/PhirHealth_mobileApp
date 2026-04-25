import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ClinicRegistrationController extends GetxController {
  final clinicNameController = TextEditingController();
  final doctorNameController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();

  final List<String> clinicTypes = [
    'General',
    'Speciality',
    'Dental',
    'Physiotherapy',
  ];

  final RxSet<String> selectedClinicTypes = <String>{}.obs;
  final RxString logoPath = ''.obs;

  final ImagePicker _picker = ImagePicker();

  void toggleClinicType(String type) {
    if (selectedClinicTypes.contains(type)) {
      selectedClinicTypes.remove(type);
    } else {
      selectedClinicTypes.add(type);
    }
  }

  Future<void> pickLogo() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) {
      logoPath.value = file.path;
    }
  }

  void goToNext() {
    Get.toNamed('/clinic-expertise');
  }

  @override
  void onClose() {
    clinicNameController.dispose();
    doctorNameController.dispose();
    contactController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
