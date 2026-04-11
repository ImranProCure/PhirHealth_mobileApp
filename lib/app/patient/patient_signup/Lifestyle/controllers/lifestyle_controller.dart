import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class LifestyleController extends GetxController {
  // ================= SMOKING =================
  final smokingOptions = ['Never', 'Former', 'Current'].obs;
  final selectedSmoking = 'Never'.obs;

  void selectSmoking(String value) {
    selectedSmoking.value = value;
  }

  // ================= ALCOHOL =================
  final alcoholOptions = ['Never', 'Occasional', 'Frequent'].obs;
  final selectedAlcohol = 'Never'.obs;

  void selectAlcohol(String value) {
    selectedAlcohol.value = value;
  }

  // ================= DIET =================
  final dietOptions = ['Vegetarian', 'Non-Veg', 'Vegan', 'Eggitarian'].obs;
  final selectedDiet = 'Vegetarian'.obs;

  void selectDiet(String value) {
    selectedDiet.value = value;
  }

  // ================= SLEEP =================
  final sleepIndex = 1.obs; // default 6–8 hr

  // ================= ERROR FUNCTION =================
  void showError(String message) {
    Get.snackbar(
      "Validation",
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ================= NEXT STEP =================
  void goToNextStep() {
    if (selectedSmoking.value.isEmpty) {
      showError("Please select smoking habit");
      return;
    }

    if (selectedAlcohol.value.isEmpty) {
      showError("Please select alcohol habit");
      return;
    }

    if (selectedDiet.value.isEmpty) {
      showError("Please select diet type");
      return;
    }

    Get.toNamed(Routes.PATIENT_FAMILY_WELLBEING);
  }
}