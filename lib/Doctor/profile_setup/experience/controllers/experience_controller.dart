import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';

class ExperienceController extends GetxController {
  /// ================= EXPERIENCE =================
  final RxDouble totalExperience = 8.0.obs;

  /// ================= PRIMARY SPECIALTY =================
  final TextEditingController specialtyController =
      TextEditingController(text: "General Physician");

  /// ================= PRACTICE PLACE =================
  final RxList<String> selectedPracticePlaces = <String>[].obs;

  /// ================= CARE EXPERIENCE =================
  final RxList<String> selectedCareExperience = <String>[].obs;

  /// ================= HISTORY =================
  final TextEditingController historyController = TextEditingController();

  /// ================= TOGGLE HELPERS =================
  void togglePracticePlace(String value) {
    if (selectedPracticePlaces.contains(value)) {
      selectedPracticePlaces.remove(value);
    } else {
      selectedPracticePlaces.add(value);
    }
  }

  void toggleCareExperience(String value) {
    if (selectedCareExperience.contains(value)) {
      selectedCareExperience.remove(value);
    } else {
      selectedCareExperience.add(value);
    }
  }

  /// ================= VALIDATION =================
  bool validateForm() {
    return specialtyController.text.trim().isNotEmpty;
  }

  /// ================= NAVIGATION =================
  void goToNextStep() {
    if (!validateForm()) {
      Get.snackbar(
        "Incomplete Details",
        "Please fill required fields",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // TODO: Next step route
    // Get.toNamed(Routes.DOCTOR_STEP3);
  }

  @override
  void onClose() {
    specialtyController.dispose();
    historyController.dispose();
    super.onClose();
  }
}
