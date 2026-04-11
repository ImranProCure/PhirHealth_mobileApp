import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/patient/patient_signup/identity_vitals/controllers/identity_vitals_controller.dart';
import 'package:sample/app/routes/app_routes.dart';

class FamilyWellbeingEditController extends GetxController {

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
  ].obs;

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


  // ================= IDENTITY CONTROLLER =================

  final IdentityVitalsController controller =
      Get.put(IdentityVitalsController());


  // ================= NAVIGATION =================

  void goToNextStep() {

    if (selectedFamilyConditions.isEmpty) {
      showError("Please select at least one family condition");
      return;
    }

    if (selectedSymptoms.isEmpty) {
      showError("Please select at least one symptom");
      return;
    }

    if (controller.gender.value == Gender.female) {
      Get.toNamed(Routes.PATIENT_WOMENS_HEALTH);
    } else {
      Get.toNamed(Routes.PATIENT_COMPLETION);
    }
  }
}