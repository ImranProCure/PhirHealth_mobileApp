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

  final cachedEmail = ''.obs;
  final cachedMobile = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserCache();
    fetchProfileApi();
  }

  Future<void> _loadUserCache() async {
    final user = await authStorage.getUserDetail();
    cachedEmail.value = user?['email']?.toString().trim() ?? '';
    cachedMobile.value = user?['mobile_no']?.toString().trim() ?? '';
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
    // ---- Existing medical conditions → "existing_medical_conditions" (List) ----
    final rawConditions =
        data['existing_medical_conditions']; // note: plural with 's'
    if (rawConditions != null) {
      List<String> parsed = [];

      if (rawConditions is List) {
        parsed = rawConditions.map((e) => e.toString()).toList();
      } else if (rawConditions is String && rawConditions.isNotEmpty) {
        parsed = rawConditions.split(',').map((e) => e.trim()).toList();
      }

      for (final condition in parsed) {
        if (!conditions.contains(condition)) conditions.add(condition);
        if (!selectedConditions.contains(condition))
          selectedConditions.add(condition);
      }
    }

    // ---- Allergy chips → "allergy" (List) ----
    final rawAllergies = data['allergy'];
    if (rawAllergies != null) {
      List<String> parsed = [];

      if (rawAllergies is List) {
        parsed = rawAllergies.map((e) => e.toString()).toList();
      } else if (rawAllergies is String && rawAllergies.isNotEmpty) {
        parsed = rawAllergies.split(',').map((e) => e.trim()).toList();
      }

      for (final allergy in parsed) {
        if (!allergies.contains(allergy)) allergies.add(allergy);
        if (!selectedAllergies.contains(allergy))
          selectedAllergies.add(allergy);
      }
    }

    // ---- Past procedures text field → "allergies" (String) ----
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
      "existing_medical_conditions": selectedConditions.toList(),
      "allergy": selectedAllergies.toList(),
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
  void addOtherCondition() {
    final text = otherConditionController.text.trim();
    if (text.isEmpty) return;
    if (!conditions.contains(text)) conditions.add(text);
    if (!selectedConditions.contains(text)) selectedConditions.add(text);
    otherConditionController.clear();
  }

  void addOtherAllergy() {
    final text = otherAllergyController.text.trim();
    if (text.isEmpty) return;
    if (!allergies.contains(text)) allergies.add(text);
    if (!selectedAllergies.contains(text)) selectedAllergies.add(text);
    otherAllergyController.clear();
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
