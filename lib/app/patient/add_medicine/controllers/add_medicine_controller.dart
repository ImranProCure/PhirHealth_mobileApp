import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMedicineController extends GetxController {
  final RxString selectedType = 'Tablet'.obs;
  final RxString strength = '650'.obs;
  final RxString unit = 'mg'.obs;
  final RxBool emrAlert = true.obs;
  final TextEditingController nameController =
      TextEditingController(text: 'Dolo 650');

  final List<Map<String, dynamic>> types = [
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
  void toggleEmr(bool v) => emrAlert.value = v;

  void nextStep() => Get.toNamed('/set-schedule', arguments: {
        'name': nameController.text,
        'type': selectedType.value,
        'strength': strength.value,
        'unit': unit.value,
      });

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
