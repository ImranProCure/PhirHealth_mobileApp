import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/db/db.dart';

class MedicalHistoryEditController extends GetxController {
  // ================= CONDITIONS =================
  final conditions = <String>[].obs; // Populated from API

  final selectedConditions = <String>[].obs;

  // ================= ALLERGIES =================
  final allergies = <String>[].obs; // Now populated from API

  Api api = Api.instance;
  final selectedAllergies = <String>[].obs;

  // ================= TEXT INPUTS =================
  final pastProceduresController = TextEditingController();
  final medicationsController = TextEditingController();
  final otherConditionController = TextEditingController();
  final otherAllergyController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isConditionsLoading = false.obs;
  final RxBool isAllergiesLoading = false.obs;
  final RxBool isAddingCondition = false.obs;
  final RxBool isAddingAllergy = false.obs;
  final authStorage = AuthStorageService();

  final cachedEmail = ''.obs;
  final cachedMobile = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserCache();
    fetchConditionsApi();  // fetch conditions from API
    fetchAllergiesApi();   // fetch allergies from API
    fetchProfileApi();
  }

  Future<void> _loadUserCache() async {
    final user = await authStorage.getUserDetail();
    cachedEmail.value = user?['email']?.toString().trim() ?? '';
    cachedMobile.value = user?['mobile_no']?.toString().trim() ?? '';
  }

  // ================= FETCH CONDITIONS FROM API =================
  Future<void> fetchConditionsApi() async {
    isConditionsLoading.value = true;

    ApiResponse response =
        await api.commonApi.authenticationApi.getMedicalConditions();
    isConditionsLoading.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      final List<dynamic> data = messageData["data"] as List<dynamic>;

      final fetchedConditions =
          data.map((e) => e['name'].toString()).toList();

      conditions.assignAll(fetchedConditions);
    } else {
      showError(messageData["message"] ?? "Failed to fetch conditions");
    }
  }

  // ================= FETCH ALLERGIES FROM API =================
  Future<void> fetchAllergiesApi() async {
    isAllergiesLoading.value = true;

    ApiResponse response =
        await api.commonApi.authenticationApi.getAllergies();
    isAllergiesLoading.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      final List<dynamic> data = messageData["data"] as List<dynamic>;

      final fetchedAllergies =
          data.map((e) => e['name'].toString()).toList();

      allergies.assignAll(fetchedAllergies);
    } else {
      showError(messageData["message"] ?? "Failed to fetch allergies");
    }
  }

  // ================= CREATE NEW CONDITION =================
  Future<void> _createConditionApi(String conditionName) async {
    isAddingCondition.value = true;

    ApiResponse response =
        await api.commonApi.authenticationApi.createMedicalCondition(
      name: conditionName,
    );
    isAddingCondition.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      if (!conditions.contains(conditionName)) {
        conditions.add(conditionName);
      }
      if (!selectedConditions.contains(conditionName)) {
        selectedConditions.add(conditionName);
      }
      otherConditionController.clear();
    } else {
      showError(messageData["message"] ?? "Failed to add condition");
    }
  }

  // ================= CREATE NEW ALLERGY =================
  Future<void> _createAllergyApi(String allergyName) async {
    isAddingAllergy.value = true;

    ApiResponse response =
        await api.commonApi.authenticationApi.createAllergy(
      name: allergyName,
    );
    isAddingAllergy.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      if (!allergies.contains(allergyName)) {
        allergies.add(allergyName);
      }
      if (!selectedAllergies.contains(allergyName)) {
        selectedAllergies.add(allergyName);
      }
      otherAllergyController.clear();
    } else {
      showError(messageData["message"] ?? "Failed to add allergy");
    }
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
      loadMedicalHistory(data);
    } else {
      showError(messageData["message"]);
    }
  }

  void loadMedicalHistory(Map<String, dynamic> data) {
    // ---- Existing medical conditions ----
    final rawConditions = data['existing_medical_conditions'];
    if (rawConditions != null) {
      List<String> parsed = [];

      if (rawConditions is List) {
        parsed = rawConditions.map((e) => e.toString()).toList();
      } else if (rawConditions is String && rawConditions.isNotEmpty) {
        parsed = rawConditions.split(',').map((e) => e.trim()).toList();
      }

      for (final condition in parsed) {
        // If condition from profile is not in fetched list, add it locally
        if (!conditions.contains(condition)) conditions.add(condition);
        if (!selectedConditions.contains(condition)) {
          selectedConditions.add(condition);
        }
      }
    }

    // ---- Allergy chips ----
    final rawAllergies = data['allergy'];
    if (rawAllergies != null) {
      List<String> parsed = [];

      if (rawAllergies is List) {
        parsed = rawAllergies.map((e) => e.toString()).toList();
      } else if (rawAllergies is String && rawAllergies.isNotEmpty) {
        parsed = rawAllergies.split(',').map((e) => e.trim()).toList();
      }

      for (final allergy in parsed) {
        // If allergy from profile is not in fetched list, add it locally
        if (!allergies.contains(allergy)) allergies.add(allergy);
        if (!selectedAllergies.contains(allergy)) {
          selectedAllergies.add(allergy);
        }
      }
    }

    // ---- Past procedures ----
    final pastProcedures = data['allergies'] as String?;
    if (pastProcedures != null && pastProcedures.isNotEmpty) {
      pastProceduresController.text = pastProcedures;
    }

    // ---- Current medications ----
    final medications = data['current_medications'] as String?;
    if (medications != null && medications.isNotEmpty) {
      medicationsController.text = medications;
    }
  }

  Future<void> _medicalEditApi() async {
    isLoading.value = true;

    final user = await authStorage.getUserDetail();
    final email = user?['email']?.toString().trim() ?? '';
    final mobileNo = user?['mobile_no']?.toString().trim() ?? '';

    if (email.isEmpty) {
      isLoading.value = false;
      showError("User email not found. Please login again.");
      return;
    }

    if (mobileNo.isEmpty) {
      isLoading.value = false;
      showError("User mobile number not found. Please login again.");
      return;
    }

    final data = {
      "email": email,
      "mobile_no": mobileNo,
      "existing_medical_condition": jsonEncode(selectedConditions.toList()),
      "allergy": jsonEncode(selectedAllergies.toList()),
      "allergies": pastProceduresController.text.trim(),
      "current_medications": medicationsController.text.trim(),
    };

    ApiResponse response =
        await api.commonApi.authenticationApi.patientEditProfile(fields: data);
    isLoading.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      //Get.toNamed(Routes.PATIENT_LIFESTYLE);
    } else {
      showError(messageData["message"]);
    }
  }

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

  /// Calls the create API for a new condition, then adds it to the list
  void addOtherCondition() {
    final text = otherConditionController.text.trim();
    if (text.isEmpty) return;
    _createConditionApi(text);
  }

  /// Calls the create API for a new allergy, then adds it to the list
  void addOtherAllergy() {
    final text = otherAllergyController.text.trim();
    if (text.isEmpty) return;
    _createAllergyApi(text); // <-- API call instead of local-only add
  }

  // ================= VALIDATION =================
  void goToNextStep() {
    if (selectedConditions.isEmpty) {
      showError("Please select at least one medical condition");
      return;
    }
    if (selectedAllergies.isEmpty) {
      showError("Please select at least one allergy");
      return;
    }
    if (pastProceduresController.text.trim().isEmpty) {
      showError("Please enter past procedures");
      return;
    }
    if (medicationsController.text.trim().isEmpty) {
      showError("Please enter current medications");
      return;
    }

    _medicalEditApi();
  }

  // ================= CLEANUP =================
  @override
  void onClose() {
    pastProceduresController.dispose();
    medicationsController.dispose();
    otherConditionController.dispose();
    otherAllergyController.dispose();
    super.onClose();
  }
}