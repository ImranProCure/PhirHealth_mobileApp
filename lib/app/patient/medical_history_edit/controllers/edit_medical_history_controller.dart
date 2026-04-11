import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/routes/app_routes.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/db/db.dart';

class MedicalHistoryEditController extends GetxController {
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
  Api api = Api.instance;

  final selectedAllergies = <String>[].obs;

  // ================= TEXT INPUTS =================
  final pastProceduresController = TextEditingController();
  final medicationsController = TextEditingController();

  final otherConditionController = TextEditingController();
  final otherAllergyController = TextEditingController();
  final RxBool isLoading = false.obs;
  final authStorage = AuthStorageService();

  // ================= TOGGLES =================
  void toggleCondition(String value) {
    if (selectedConditions.contains(value)) {
      selectedConditions.remove(value);
    } else {
      selectedConditions.add(value);
    }
  }

  Future<void> _medicalEditApi() async {
    isLoading.value = true;
    Map<String, dynamic>? user = await authStorage.getUserDetail();

    String email = user?['email'] ?? '';
    String mobile_no = user?['mobile_no'] ?? '';

    var data = {
      "existing_medical_condition": selectedConditions.value,
      "email": email,
      "mobile_no": mobile_no,
      "allergies": selectedAllergies.value,
      "allergy": pastProceduresController.text,
      "current_medications": medicationsController.text,
    };

    ApiResponse response =
        await api.commonApi.authenticationApi.patientEditProfile(fields: data);
    isLoading.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      if (messageData is Map<String, dynamic>) {
      } else {
        showError(
          messageData["message"],
        );
        // Get.offAllNamed(Routes.MAIN_SCREEN);
      }
    } else {
      showError(
        messageData["message"],
      );
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
    // Condition validation
    if (selectedConditions.isEmpty) {
      showError(
        "Please select at least one medical condition",
      );
      return;
    }

    // Allergy validation
    if (selectedAllergies.isEmpty) {
      showError(
        "Please select at least one allergy",
      );
      return;
    }

    // Optional text validation
    if (pastProceduresController.text.trim().isEmpty) {
      showError("Please enter past procedures");
      return;
    }

    if (medicationsController.text.trim().isEmpty) {
      showError(
        "Please enter current medications",
      );
      return;
    }

    // If all valid
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
