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

  void goToNextStep() {
    Get.toNamed(Routes.PATIENT_FAMILY_WELLBEING);
  }
}
