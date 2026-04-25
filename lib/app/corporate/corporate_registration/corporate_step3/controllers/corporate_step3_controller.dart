import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CorporateStep3Controller extends GetxController {
  // Preferred Mode
  final RxString preferredMode = 'Onsite'.obs;
  final List<String> modes = ['Onsite', 'Online', 'Hybrid'];

  // Expected Timeline date
  final RxString expectedTimeline = '06/01/2024'.obs;

  // Budget
  final budgetController = TextEditingController();

  // EMR Toggle
  final RxBool familiarWithEMR = true.obs;

  // Experience Details
  final experienceController = TextEditingController();

  // KPI
  final kpiController = TextEditingController();

  void selectMode(String mode) {
    preferredMode.value = mode;
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2024, 6, 1),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0D9488),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      expectedTimeline.value =
          '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  void goToNext() {
    Get.toNamed('/corporate-step4');
  }

  @override
  void onClose() {
    budgetController.dispose();
    experienceController.dispose();
    kpiController.dispose();
    super.onClose();
  }
}
