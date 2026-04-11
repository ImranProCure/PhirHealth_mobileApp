import 'package:get/get.dart';
import 'package:sample/app/routes/app_routes.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/db/db.dart';

class LifestyleEditController extends GetxController {
  // ================= SMOKING =================
  final smokingOptions = ['Never', 'Former', 'Current'].obs;
  final selectedSmoking = 'Never'.obs;

  void selectSmoking(String value) {
    selectedSmoking.value = value;
  }
  Api api = Api.instance;
  final RxBool isLoading = false.obs;
  final authStorage = AuthStorageService();

  // ================= ALCOHOL =================
  final alcoholOptions = ['Never', 'Occasional', 'Frequent'].obs;
  final selectedAlcohol = 'Never'.obs;

  void selectAlcohol(String value) {
    selectedAlcohol.value = value;
  }

  // ================= DIET =================
  final dietOptions = ['Vegetarian', 'Non-Veg', 'Vegan', 'Eggitarian'].obs;
  final selectedDiet = 'Vegetarian'.obs;

  void selectDiet(String value) {
    selectedDiet.value = value;
  }

  // ================= SLEEP =================
  final sleepIndex = 1.obs; // default 6–8 hr

  // ================= ERROR FUNCTION =================
  void showError(String message) {
    Get.snackbar(
      "Validation",
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Future<void> _lifeStyleEditApi() async {
  //   isLoading.value = true;
  //   Map<String, dynamic>? user = await authStorage.getUserDetail();

  //   String email = user?['email'] ?? '';
  //   String mobile_no = user?['mobile_no'] ?? '';

  //   var data = {
  //     "existing_medical_condition": selectedConditions.value,
  //     "email": email,
  //     "mobile_no": mobile_no,
  //     "allergies": selectedAllergies.value,
  //     "allergy": pastProceduresController.text,
  //     "current_medications": medicationsController.text,
  //   };

  //   ApiResponse response =
  //       await api.commonApi.authenticationApi.patientEditProfile(fields: data);
  //   isLoading.value = false;

  //   final messageData = response.data['message'];

  //   if (messageData["status"] == true) {
  //     if (messageData is Map<String, dynamic>) {
  //     } else {
  //       showError(
  //         messageData["message"],
  //       );
  //       // Get.offAllNamed(Routes.MAIN_SCREEN);
  //     }
  //   } else {
  //     showError(
  //       messageData["message"],
  //     );
  //   }
  // }

  // ================= NEXT STEP =================
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

    Get.toNamed(Routes.PATIENT_FAMILY_WELLBEING);
  }
}