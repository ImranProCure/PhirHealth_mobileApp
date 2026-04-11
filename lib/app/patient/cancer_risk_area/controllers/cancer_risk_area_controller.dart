import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancerRiskAreaController extends GetxController {
  /// 🔹 State
  final RxString selectedGender = 'Male'.obs;
  final RxString selectedArea = ''.obs;

  /// 🔹 Areas List (UI data)
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

  /// 🔥 Map-based routing (CORE LOGIC)
  final Map<String, String> _areaRoutes = {
    'Oral & Throat': '/cancer-throat-assessment',
    'Lungs & Breathing': '/cancer-lung-assessment',
    'Stomach & Digestion': '/cancer-stomach-assessment',
    'Skin & External': '/cancer-skin-assessment',
    'General Risk': '/cancer-general-assessment',
    'Other Areas': '/cancer-other-assessment',
  };

  /// Getter for UI
  List<Map<String, dynamic>> get currentAreas => areas;

  /// 🔹 Actions
  void selectGender(String gender) {
    selectedGender.value = gender;
    selectedArea.value = '';
  }

  void selectArea(String area) {
    selectedArea.value = area;
  }

  /// 🔥 Navigation logic
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

    final route = _areaRoutes[selectedArea.value];

    /// 🧪 Debug (remove in production)
    debugPrint("Selected Area: ${selectedArea.value}");
    debugPrint("Route: $route");

    if (route == null) {
      Get.snackbar(
        'Error',
        'No route found for selected area',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.toNamed(
      route,
      arguments: {
        'area': selectedArea.value,
        'gender': selectedGender.value,
      },
    );
  }
}
