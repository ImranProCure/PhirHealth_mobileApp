import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/service/db/db.dart';

class BmiController extends GetxController {
  final RxString selectedGender = 'Male'.obs;
  final RxInt age = 28.obs;
  final RxString height = "5'9".obs;
  final RxInt weight = 110.obs;

  // ===== SEEDHA INITIALIZE — late nahi =====
  final TextEditingController ageTec = TextEditingController(text: '28');
  final TextEditingController heightTec = TextEditingController(text: "5'9");
  final TextEditingController weightTec = TextEditingController(text: '110');

  final List<Map<String, dynamic>> genders = [
    {'label': 'bmi_gender_male'.tr, 'icon': Icons.male},
    {'label': 'bmi_gender_female'.tr, 'icon': Icons.female},
    {'label': 'patient_step1_gender_other'.tr, 'icon': Icons.male},
  ];
  AuthStorageService authStorage = AuthStorageService();

  void selectGender(String g) => selectedGender.value = g;

  void onAgeChanged(String val) {
    final int? v = int.tryParse(val);
    if (v != null) age.value = v;
  }

  void onHeightChanged(String val) => height.value = val;

  void onWeightChanged(String val) {
    final int? v = int.tryParse(val);
    if (v != null) weight.value = v;
  }

  Future<void> calculateBmi() async {
    if (age.value <= 0 || age.value > 120) {
      Get.snackbar("Invalid Age", "Please enter a valid age",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12);
      return;
    }
    if (weight.value <= 0 || weight.value > 300) {
      Get.snackbar("Invalid Weight", "Please enter a valid weight",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12);
      return;
    }
    if (height.value.trim().isEmpty) {
      Get.snackbar("Invalid Height", "Please enter your height",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12);
      return;
    }
// name

    final userDetail = await authStorage.getUserDetail();
    String userName = (userDetail?['full_name'] as String? ?? '').trim();
    Get.toNamed('/bmi-result', arguments: {
      'gender': selectedGender.value,
      'age': age.value,
      'height': height.value,
      'weight': weight.value,
      'name': userName
    });
  }

  @override
  void onClose() {
    ageTec.dispose();
    heightTec.dispose();
    weightTec.dispose();
    super.onClose();
  }
}
