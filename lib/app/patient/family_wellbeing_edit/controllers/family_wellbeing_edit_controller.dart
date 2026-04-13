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
  final authStorage = AuthStorageService();

  // ================= CACHE =================
  final cachedEmail = ''.obs;
  final cachedMobile = ''.obs;

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
  final RxInt stressIndex = 1.obs; // 0 = Low, 1 = Moderate, 2 = High

  // ================= COMMON SYMPTOMS =================
  final symptoms = ['Anxiety', 'Depression', 'Insomnia', 'None'].obs;
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
  final IdentityVitalsController identityController =
      Get.put(IdentityVitalsController());

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
      if (rawSymptoms is List) {
        for (final s in rawSymptoms) {
          final symptom = s.toString();
          if (!symptoms.contains(symptom)) symptoms.add(symptom);
          if (!selectedSymptoms.contains(symptom)) {
            selectedSymptoms.add(symptom);
          }
        }
      } else if (rawSymptoms is String &&
          rawSymptoms.isNotEmpty &&
          rawSymptoms.toUpperCase() != 'YES' &&
          rawSymptoms.toUpperCase() != 'NO') {
        final parts = rawSymptoms.split(',').map((e) => e.trim()).toList();
        for (final symptom in parts) {
          if (!symptoms.contains(symptom)) symptoms.add(symptom);
          if (!selectedSymptoms.contains(symptom)) {
            selectedSymptoms.add(symptom);
          }
        }
      }
    }

    // ---- Mental health → stress slider ----
    final mentalHealth = data['mental_health'] as String?;
    if (mentalHealth != null) {
      switch (mentalHealth.toLowerCase()) {
        case 'low':
          stressIndex.value = 0;
          break;
        case 'moderate':
          stressIndex.value = 1;
          break;
        case 'high':
          stressIndex.value = 2;
          break;
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
        if (!familyConditions.contains(condition)) {
          familyConditions.add(condition);
        }
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
      "common_symptoms": selectedSymptoms.toList(),
      "mental_health": stressMap[stressIndex.value],
      "family_medical_history": selectedFamilyConditions.toList(),
    };

    ApiResponse response =
        await api.commonApi.authenticationApi.patientEditProfile(fields: data);
    isLoading.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
    } else {
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
}
