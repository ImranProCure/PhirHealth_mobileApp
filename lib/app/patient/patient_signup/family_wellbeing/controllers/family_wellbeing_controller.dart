import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/patient/patient_signup/identity_vitals/controllers/identity_vitals_controller.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import '../../../../routes/app_routes.dart';

class FamilyWellbeingController extends GetxController {
  Api api = Api.instance;

  // ================= LOADING STATES =================
  final RxBool isFamilyConditionsLoading = false.obs;
  final RxBool isAddingFamilyCondition = false.obs;
  final RxBool isSymptomsLoading = false.obs;
  final RxBool isAddingSymptom = false.obs;

  // ================= FAMILY HISTORY =================
  final familyConditions = <String>[].obs; // Populated from API
  final selectedFamilyConditions = <String>[].obs;
  final otherFamilyConditionController = TextEditingController();

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
  final symptoms = <String>[].obs; // Populated from API
  final selectedSymptoms = <String>[].obs;
  final otherSymptomController = TextEditingController();

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
  final IdentityVitalsController identityController =
      Get.put(IdentityVitalsController());

  // ================= INIT =================
  @override
  void onInit() {
    super.onInit();
    fetchFamilyConditionsApi();
    fetchSymptomsApi();
  }

  // ================= FETCH FAMILY CONDITIONS FROM API =================
  Future<void> fetchFamilyConditionsApi() async {
    isFamilyConditionsLoading.value = true;
    ApiResponse response =
        await api.commonApi.authenticationApi.getMedicalConditions();
    isFamilyConditionsLoading.value = false;

    final messageData = response.data['message'];
    if (messageData["status"] == true) {
      final List<dynamic> data = messageData["data"] as List<dynamic>;
      familyConditions.assignAll(data.map((e) => e['name'].toString()));
    } else {
      showError(messageData["message"] ?? "Failed to fetch family conditions");
    }
  }

  // ================= FETCH SYMPTOMS FROM API =================
  Future<void> fetchSymptomsApi() async {
    isSymptomsLoading.value = true;
    ApiResponse response =
        await api.commonApi.authenticationApi.getMedicalSymptoms();
    isSymptomsLoading.value = false;

    final messageData = response.data['message'];
    if (messageData["status"] == true) {
      final List<dynamic> data = messageData["data"] as List<dynamic>;
      symptoms.assignAll(data.map((e) => e['name'].toString()));
    } else {
      showError(messageData["message"] ?? "Failed to fetch symptoms");
    }
  }

  // ================= CREATE NEW FAMILY CONDITION =================
  Future<void> _createFamilyConditionApi(String conditionName) async {
    isAddingFamilyCondition.value = true;
    ApiResponse response =
        await api.commonApi.authenticationApi.createMedicalCondition(
      name: conditionName,
    );
    isAddingFamilyCondition.value = false;

    final messageData = response.data['message'];
    if (messageData["status"] == true) {
      if (!familyConditions.contains(conditionName)) {
        familyConditions.add(conditionName);
      }
      if (!selectedFamilyConditions.contains(conditionName)) {
        selectedFamilyConditions.add(conditionName);
      }
      otherFamilyConditionController.clear();
    } else {
      showError(messageData["message"] ?? "Failed to add family condition");
    }
  }

  // ================= CREATE NEW SYMPTOM =================
  Future<void> _createSymptomApi(String symptomName) async {
    isAddingSymptom.value = true;
    ApiResponse response =
        await api.commonApi.authenticationApi.createMedicalSymptom(
      name: symptomName,
    );
    isAddingSymptom.value = false;

    final messageData = response.data['message'];
    if (messageData["status"] == true) {
      if (!symptoms.contains(symptomName)) {
        symptoms.add(symptomName);
      }
      if (!selectedSymptoms.contains(symptomName)) {
        selectedSymptoms.add(symptomName);
      }
      otherSymptomController.clear();
    } else {
      showError(messageData["message"] ?? "Failed to add symptom");
    }
  }

  // ================= ADD OTHER HANDLERS =================
  void addOtherFamilyCondition() {
    final text = otherFamilyConditionController.text.trim();
    if (text.isEmpty) return;
    _createFamilyConditionApi(text);
  }

  void addOtherSymptom() {
    final text = otherSymptomController.text.trim();
    if (text.isEmpty) return;
    _createSymptomApi(text);
  }

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

    if (identityController.gender.value == Gender.female) {
      Get.toNamed(Routes.PATIENT_WOMENS_HEALTH);
    } else {
      Get.toNamed(Routes.PATIENT_COMPLETION);
    }
  }

  // ================= CLEANUP =================
  @override
  void onClose() {
    otherFamilyConditionController.dispose();
    otherSymptomController.dispose();
    super.onClose();
  }
}