import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class FamilyWellbeingController extends GetxController {
  // ================= FAMILY HISTORY =================
  final familyConditions = [
    'Diabetes',
    'Heart Disease',
    'Cancer',
    'Hypertension',
  ].obs;

  final selectedFamilyConditions = <String>[].obs;

  void toggleFamilyCondition(String value) {
    if (selectedFamilyConditions.contains(value)) {
      selectedFamilyConditions.remove(value);
    } else {
      selectedFamilyConditions.add(value);
    }
  }

  // ================= STRESS LEVEL =================
  final RxInt stressIndex = 1.obs; // 0 Low, 1 Moderate, 2 High

  // ================= COMMON SYMPTOMS =================
  final symptoms = [
    'Anxiety',
    'Depression',
    'Insomnia',
    'None',
  ];

  final selectedSymptoms = <String>[].obs;

  void toggleSymptom(String value) {
    if (value == 'None') {
      selectedSymptoms.clear();
      selectedSymptoms.add('None');
      return;
    }

    selectedSymptoms.remove('None');

    if (selectedSymptoms.contains(value)) {
      selectedSymptoms.remove(value);
    } else {
      selectedSymptoms.add(value);
    }
  }

  // ================= NAVIGATION =================
  void goToNextStep() {
    Get.toNamed(Routes.PATIENT_WOMENS_HEALTH); // Change to your actual route
  }
}
