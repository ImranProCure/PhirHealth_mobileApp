import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../service/api/common_api/medicine_api/medicine_api.dart';

class AddMedicineController extends GetxController {
  final RxString selectedType = 'Tablet'.obs;
  final RxString strength = '650'.obs;
  final RxString unit = 'mg'.obs;
  final RxBool emrAlert = true.obs;
  final RxBool isLoading = false.obs;

  final TextEditingController nameController = TextEditingController();

  List<Map<String, dynamic>> get types => [
        {'label': 'Tablet', 'imagePath': 'assets/icons/medicine 1.png'},
        {'label': 'Capsule', 'imagePath': 'assets/icons/capsule 1.png'},
        {'label': 'Syrup', 'imagePath': 'assets/icons/syrup 1.png'},
        {'label': 'Injection', 'imagePath': 'assets/icons/medical 1.png'},
      ];

  final List<String> strengths = ['250', '500', '650', '1000'];
  final List<String> units = ['mg', 'ml', 'mcg', 'g'];

  void selectType(String t) => selectedType.value = t;
  void selectStrength(String s) => strength.value = s;
  void selectUnit(String u) => unit.value = u;

  Future<void> nextStep() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter medicine name',
        backgroundColor: const Color(0xFFFF4444),
        colorText: const Color(0xFFFFFFFF),
      );
      return;
    }

    try {
      isLoading.value = true;

      final api = MedicineApi();
      final response = await api.addMedicine(
        name: nameController.text.trim(),
        type: selectedType.value,
        strength: int.parse(strength.value),
        unit: unit.value,
      );

      if (response.status) {
        final data = response.data['message'];
        final String medication = data['medication'];
        final String dosageForm = data['dosage_form'];

        Get.toNamed('/set-schedule', arguments: {
          'name': nameController.text.trim(),
          'type': selectedType.value,
          'strength': strength.value,
          'unit': unit.value,
          'medication': medication,
          'dosage_form': dosageForm,
        });
      } else {
        Get.snackbar(
          'Error',
          response.message,
          backgroundColor: const Color(0xFFFF4444),
          colorText: const Color(0xFFFFFFFF),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed: $e',
        backgroundColor: const Color(0xFFFF4444),
        colorText: const Color(0xFFFFFFFF),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
