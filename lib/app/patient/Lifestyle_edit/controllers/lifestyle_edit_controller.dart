import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/routes/app_routes.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/db/db.dart';

class LifestyleEditController extends GetxController {
  // ================= OPTIONS =================
  final smokingOptions = ['Never', 'Former', 'Current'].obs;
  final alcoholOptions = ['Never', 'Occasional', 'Frequent'].obs;
  final dietOptions = ['Vegetarian', 'Non-Veg', 'Vegan', 'Eggitarian'].obs;

  // ================= SELECTIONS =================
  final selectedSmoking = 'Never'.obs;
  final selectedAlcohol = 'Never'.obs;
  final selectedDiet = 'Vegetarian'.obs;
  final sleepIndex = 1.obs;

  // ================= CACHE =================
  final cachedEmail = ''.obs;
  final cachedMobile = ''.obs;

  Api api = Api.instance;
  final RxBool isLoading = false.obs;
  final authStorage = AuthStorageService();

  // ================= INIT =================
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
      loadLifestyle(data);
    } else {
      showError(messageData["message"]);
    }
  }

  // ================= LOAD DATA FROM API =================
  void loadLifestyle(Map<String, dynamic> data) {
    final smoking = data['smoking'] as String?;
    if (smoking != null && smokingOptions.contains(smoking)) {
      selectedSmoking.value = smoking;
    }

    final alcohol = data['alcohol'] as String?;
    if (alcohol != null && alcoholOptions.contains(alcohol)) {
      selectedAlcohol.value = alcohol;
    }

    final diet = data['diet'] as String?;
    if (diet != null && dietOptions.contains(diet)) {
      selectedDiet.value = diet;
    }

    final sleep = data['sleep'];
    if (sleep != null) {
      final hours =
          (sleep is int) ? sleep : int.tryParse(sleep.toString()) ?? 7;
      if (hours < 4) {
        sleepIndex.value = 0;
      } else if (hours <= 8) {
        sleepIndex.value = 1;
      } else {
        sleepIndex.value = 2;
      }
    }
  }

  // ================= EDIT API =================
  Future<void> _lifestyleEditApi() async {
    if (cachedEmail.value.isEmpty) {
      showError("User email not found. Please login again.");
      return;
    }

    if (cachedMobile.value.isEmpty) {
      showError("User mobile number not found. Please login again.");
      return;
    }

    isLoading.value = true;

    const sleepMap = {0: '2', 1: '7', 2: '9'};

    final data = {
      "email": cachedEmail.value,
      "mobile_no": cachedMobile.value,
      "smoking": selectedSmoking.value,
      "alcohol": selectedAlcohol.value,
      "diet_preference": selectedDiet.value,
      "average_sleep": sleepMap[sleepIndex.value],
    };

    ApiResponse response = await api.commonApi.authenticationApi
        .patientEditProfile(fields: data);
    isLoading.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      //Get.toNamed(Routes.PATIENT_FAMILY_WELLBEING);
    } else {
      showError(messageData["message"]);
    }
  }

  // ================= SELECTORS =================
  void selectSmoking(String value) => selectedSmoking.value = value;
  void selectAlcohol(String value) => selectedAlcohol.value = value;
  void selectDiet(String value) => selectedDiet.value = value;

  // ================= VALIDATION + SUBMIT =================
  void goToNextStep() {
    if (selectedSmoking.value.isEmpty) {
      showError("Please select smoking habit");
      return;
    }
    if (selectedAlcohol.value.isEmpty) {
      showError("Please select alcohol habit");
      return;
    }
    if (selectedDiet.value.isEmpty) {
      showError("Please select diet type");
      return;
    }

    _lifestyleEditApi();
  }
}