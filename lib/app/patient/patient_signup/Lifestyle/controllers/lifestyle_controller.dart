import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class LifestyleController extends GetxController {
  // ================= SMOKING =================
  final smokingOptions = [
    'patient_step3_smoking_never'.tr,
    'patient_step3_smoking_former'.tr,
    'patient_step3_smoking_current'.tr
  ].obs;
  final selectedSmoking = 'patient_step3_smoking_never'.tr.obs;

  void selectSmoking(String value) {
    selectedSmoking.value = value;
  }

  // ================= ALCOHOL =================
  final alcoholOptions = [
    'patient_step3_alcohol_never'.tr,
    'patient_step3_alcohol_occasional'.tr,
    'patient_step3_alcohol_frequent'.tr
  ].obs;
  final selectedAlcohol = 'patient_step3_alcohol_never'.tr.obs;

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
