import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PharmacyRegistrationController extends GetxController {
  final pharmacyNameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final websiteController = TextEditingController();

  final List<String> interestAreas = [
    'Retail',
    'Wholesale',
    'Online',
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
    Get.toNamed('/inventory-offerings');
  }

  @override
  void onClose() {
    pharmacyNameController.dispose();
    contactController.dispose();
    emailController.dispose();
    addressController.dispose();
    websiteController.dispose();
    super.onClose();
  }
}
