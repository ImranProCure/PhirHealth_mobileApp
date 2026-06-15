import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CoachStep1Controller extends GetxController {
  final fullNameController = TextEditingController();
  final bioController = TextEditingController();
  final addressController = TextEditingController();
  // final stateController = TextEditingController();
  // final countryController = TextEditingController();

  final RxString avatarPath = ''.obs;
  final RxString selectedTitle = ''.obs;

  final List<String> titleOptions = [
    'Psychologist',
    'Life Coach',
    'Career Coach',
    'Mental Health Counselor',
    'Therapist',
    'Wellness Coach',
    'Others',
  ];

  final RxList<String> allLanguages =
      <String>['English', 'Spanish', 'French'].obs;
  final RxSet<String> selectedLanguages = <String>{'English'}.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickAvatar() async {
    final XFile? file =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file != null) avatarPath.value = file.path;
  }

  void toggleLanguage(String lang) {
    if (selectedLanguages.contains(lang)) {
      selectedLanguages.remove(lang);
    } else {
      selectedLanguages.add(lang);
    }
  }

  void addLanguage(String lang) {
    final t = lang.trim();
    if (t.isNotEmpty && !allLanguages.contains(t)) {
      allLanguages.add(t);
      selectedLanguages.add(t);
    }
  }

  void goToNext() => Get.toNamed('/coach-step2');

  @override
  void onClose() {
    fullNameController.dispose();
    bioController.dispose();
    addressController.dispose();
    // stateController.dispose();
    // countryController.dispose();
    super.onClose();
  }
}
