import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/db/db.dart';
import '../../../../routes/app_routes.dart';

class MedicalHistoryController extends GetxController {
  // ================= CONDITIONS =================
  final conditions = <String>[].obs; // Populated from API

  final selectedConditions = <String>[].obs;

  // ================= ALLERGIES =================
  final allergies = <String>[].obs; // Populated from API

  final selectedAllergies = <String>[].obs;

  // ================= TEXT INPUTS =================
  final pastProceduresController = TextEditingController();
  final medicationsController = TextEditingController();
  final otherConditionController = TextEditingController();
  final otherAllergyController = TextEditingController();

  // ================= LOADING STATES =================
  final RxBool isConditionsLoading = false.obs;
  final RxBool isAllergiesLoading = false.obs;
  final RxBool isAddingCondition = false.obs;
  final RxBool isAddingAllergy = false.obs;

  Api api = Api.instance;
  final authStorage = AuthStorageService();

  // ================= INIT =================
  @override
  void onInit() {
    super.onInit();
    fetchConditionsApi();
    fetchAllergiesApi();
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
    _createAllergyApi(text);
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

    // If all valid
    Get.toNamed(Routes.PATIENT_LIFESTYLE);
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