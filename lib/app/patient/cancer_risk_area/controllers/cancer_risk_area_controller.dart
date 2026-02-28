import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancerRiskAreaController extends GetxController {
  final RxString selectedGender = 'Male'.obs;
  final RxString selectedArea = ''.obs;

  final List<Map<String, dynamic>> areas = [
    {
      'label': 'Oral & Throat',
      'sub': 'Cough, Pain',
      'imagePath': 'assets/icons/endocrinology.png'
    },
    {
      'label': 'Lungs & Breathing',
      'sub': 'Shortness of breath',
      'imagePath': 'assets/icons/pulmonology.png'
    },
    {
      'label': 'Stomach & Digestion',
      'sub': 'Bloating, Reflux',
      'imagePath': 'assets/icons/gastroenterology.png'
    },
    {
      'label': 'Skin & External',
      'sub': 'Moles, Marks',
      'imagePath': 'assets/icons/dermatology.png'
    },
    {
      'label': 'General Risk',
      'sub': '',
      'imagePath': 'assets/icons/digital_wellbeing.png'
    },
    {
      'label': 'Other Areas',
      'sub': '',
      'imagePath': 'assets/icons/action_key.png'
    },
  ];

  // same for both genders
  List<Map<String, dynamic>> get currentAreas => areas;

  void selectGender(String g) {
    selectedGender.value = g;
    selectedArea.value = '';
  }

  void selectArea(String area) => selectedArea.value = area;

  void goNext() {
    if (selectedArea.value.isEmpty) {
      Get.snackbar(
        'Select Area',
        'Please select a risk area to continue',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    Get.toNamed('/cancer-assessment', arguments: {
      'area': selectedArea.value,
      'gender': selectedGender.value,
    });
  }
}
