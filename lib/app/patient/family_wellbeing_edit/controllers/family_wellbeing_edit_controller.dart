import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/patient/patient_signup/identity_vitals/controllers/identity_vitals_controller.dart';
import 'package:sample/app/routes/app_routes.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/db/db.dart';

class FamilyWellbeingEditController extends GetxController {
  Api api = Api.instance;
  final RxBool isLoading = false.obs;
  final RxBool isFamilyConditionsLoading = false.obs;
  final RxBool isAddingFamilyCondition = false.obs;

  // ← NEW
  final RxBool isSymptomsLoading = false.obs;
  final RxBool isAddingSymptom = false.obs;

  final authStorage = AuthStorageService();

  // ================= CACHE =================
  final cachedEmail = ''.obs;
  final cachedMobile = ''.obs;

  // ================= FAMILY HISTORY =================
  final familyConditions = <String>[].obs;
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
  final RxInt stressIndex = 1.obs;

  // ================= COMMON SYMPTOMS =================
  // ← CHANGED: was a static hardcoded list, now populated from API
  final symptoms = <String>[].obs;
  final selectedSymptoms = <String>[].obs;

  // ← NEW
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
    _loadUserCache();
    fetchFamilyConditionsApi();
    fetchSymptomsApi(); // ← NEW
    fetchProfileApi();
  }

  Future<void> _loadUserCache() async {
    final user = await authStorage.getUserDetail();
    cachedEmail.value = user?['email']?.toString().trim() ?? '';
    cachedMobile.value = user?['mobile_no']?.toString().trim() ?? '';
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

  // ================= FETCH SYMPTOMS FROM API ← NEW =================
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

  // ================= CREATE NEW SYMPTOM ← NEW =================
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

  // ← NEW
  void addOtherSymptom() {
    final text = otherSymptomController.text.trim();
    if (text.isEmpty) return;
    _createSymptomApi(text);
  }

  // ================= FETCH PROFILE =================
  Future<void> fetchProfileApi() async {
    isLoading.value = true;
    ApiResponse response =
        await api.commonApi.authenticationApi.getProfileDetail();
    isLoading.value = false;

    final messageData = response.data['message'];
    if (messageData["status"] == true) {
      final data = messageData["data"] as Map<String, dynamic>;
      loadFamilyWellbeing(data);
    } else {
      showError(messageData["message"]);
    }
  }

  // ================= LOAD DATA FROM API =================
  void loadFamilyWellbeing(Map<String, dynamic> data) {
    // ---- Common symptoms ----
    final rawSymptoms = data['common_symptoms'];
    if (rawSymptoms != null) {
      List<String> parsed = [];
      if (rawSymptoms is List) {
        parsed = rawSymptoms.map((e) => e.toString()).toList();
      } else if (rawSymptoms is String &&
          rawSymptoms.isNotEmpty &&
          rawSymptoms.toUpperCase() != 'YES' &&
          rawSymptoms.toUpperCase() != 'NO') {
        parsed = rawSymptoms.split(',').map((e) => e.trim()).toList();
      }
      for (final symptom in parsed) {
        // If symptom from profile isn't in fetched list, add locally
        if (!symptoms.contains(symptom)) symptoms.add(symptom);
        if (!selectedSymptoms.contains(symptom)) selectedSymptoms.add(symptom);
      }
    }

    // ---- Mental health → stress slider ----
    final mentalHealth = data['mental_health'] as String?;
    if (mentalHealth != null) {
      switch (mentalHealth.toLowerCase()) {
        case 'low':      stressIndex.value = 0; break;
        case 'moderate': stressIndex.value = 1; break;
        case 'high':     stressIndex.value = 2; break;
      }
    }

    // ---- Family medical history ----
    final rawFamily = data['family_medical_history'];
    if (rawFamily != null) {
      List<String> parsed = [];
      if (rawFamily is List) {
        parsed = rawFamily.map((e) => e.toString()).toList();
      } else if (rawFamily is String && rawFamily.isNotEmpty) {
        parsed = rawFamily.split(',').map((e) => e.trim()).toList();
      }
      for (final condition in parsed) {
        if (!familyConditions.contains(condition)) familyConditions.add(condition);
        if (!selectedFamilyConditions.contains(condition)) {
          selectedFamilyConditions.add(condition);
        }
      }
    }
  }

  // ================= EDIT API =================
  Future<void> _familyWellbeingEditApi() async {
    if (cachedEmail.value.isEmpty) {
      showError("User email not found. Please login again.");
      return;
    }
    if (cachedMobile.value.isEmpty) {
      showError("User mobile number not found. Please login again.");
      return;
    }

    isLoading.value = true;
    const stressMap = {0: 'Low', 1: 'Moderate', 2: 'High'};

    final data = {
      "email": cachedEmail.value,
      "mobile_no": cachedMobile.value,
      "common_symptoms": jsonEncode(selectedSymptoms.toList()),
      "mental_well_being": stressMap[stressIndex.value],
      "family_medical_history": jsonEncode(selectedFamilyConditions.toList()),
    };

    ApiResponse response =
        await api.commonApi.authenticationApi.patientEditProfile(fields: data);
    isLoading.value = false;

    final messageData = response.data['message'];
    if (messageData["status"] != true) {
      showError(messageData["message"]);
    }
  }

  // ================= VALIDATION + SUBMIT =================
  void goToNextStep() {
    if (selectedFamilyConditions.isEmpty) {
      showError("Please select at least one family condition");
      return;
    }
    if (selectedSymptoms.isEmpty) {
      showError("Please select at least one symptom");
      return;
    }
    _familyWellbeingEditApi();
  }

  // ================= CLEANUP =================
  @override
  void onClose() {
    otherFamilyConditionController.dispose();
    otherSymptomController.dispose(); // ← NEW
    super.onClose();
  }
}