import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BasicInformationController extends GetxController {
  final hospitalNameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  final List<String> interestAreas = [
    'Multi-Specialty',
    'Super-Specialty',
    'Single-Specialty',
  ];

  final RxSet<String> selectedInterests = <String>{}.obs;
  final RxString logoPath = ''.obs;

  final ImagePicker _picker = ImagePicker();

  void toggleInterest(String area) {
    if (selectedInterests.contains(area)) {
      selectedInterests.remove(area);
    } else {
      selectedInterests.add(area);
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
    Get.toNamed('/clinical-capacity');
  }

  @override
  void onClose() {
    hospitalNameController.dispose();
    contactController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
