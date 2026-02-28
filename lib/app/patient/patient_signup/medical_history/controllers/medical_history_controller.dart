import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class MedicalHistoryController extends GetxController {
  // ================= CONDITIONS =================
  final conditions = <String>[
    'Diabetes',
    'Hypertension',
    'Asthma',
    'Thyroid',
    'None',
  ].obs;

  final selectedConditions = <String>[].obs;

  // ================= ALLERGIES =================
  final allergies = <String>[
    'Peanuts',
    'Antibiotics',
    'Dust',
  ].obs;

  final selectedAllergies = <String>[].obs;

  // ================= TEXT INPUTS =================
  final pastProceduresController = TextEditingController();
  final medicationsController = TextEditingController();

  final otherConditionController = TextEditingController();
  final otherAllergyController = TextEditingController();

  // ================= TOGGLES =================
  void toggleCondition(String value) {
    if (selectedConditions.contains(value)) {
      selectedConditions.remove(value);
    } else {
      selectedConditions.add(value);
    }
  }

  void toggleAllergy(String value) {
    if (selectedAllergies.contains(value)) {
      selectedAllergies.remove(value);
    } else {
      selectedAllergies.add(value);
    }
  }

  // ================= ADD OTHER =================
  void addOtherCondition() {
    final text = otherConditionController.text.trim();
    if (text.isEmpty) return;

    if (!conditions.contains(text)) {
      conditions.add(text);
    }
    selectedConditions.add(text);
    otherConditionController.clear();
  }

  void addOtherAllergy() {
    final text = otherAllergyController.text.trim();
    if (text.isEmpty) return;

    if (!allergies.contains(text)) {
      allergies.add(text);
    }
    selectedAllergies.add(text);
    otherAllergyController.clear();
  }

  void goToNextStep() {
    Get.toNamed(Routes.PATIENT_LIFESTYLE);
  }

  @override
  void onClose() {
    pastProceduresController.dispose();
    medicationsController.dispose();
    otherConditionController.dispose();
    otherAllergyController.dispose();
    super.onClose();
  }
}
