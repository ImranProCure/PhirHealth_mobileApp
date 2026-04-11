import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import '../../../../routes/app_routes.dart';

class WomensHealthController extends GetxController {
  // ================= DATE CONTROLLERS =================

  final TextEditingController lastPeriodController = TextEditingController();
  final TextEditingController deliveryDateController = TextEditingController();
  final TextEditingController historyController =
      TextEditingController(); // optional

  // ================= PREGNANCY STATUS =================

  RxBool isPregnant = false.obs;

  void setPregnancy(bool value) {
    isPregnant.value = value;

    if (!value) {
      deliveryDateController.clear();
    }
  }

  // ================= DATE PICKER =================

  Future<void> pickDate(
    BuildContext context,
    TextEditingController fieldController,
  ) async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0D9488), // selected date circle
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            datePickerTheme: const DatePickerThemeData(
              backgroundColor: Colors.white,
              dividerColor: Color(0xFFE5E7EB), // header divider
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0D9488),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      fieldController.text = "${pickedDate.month.toString().padLeft(2, '0')} / "
          "${pickedDate.day.toString().padLeft(2, '0')} / "
          "${pickedDate.year}";
    }
  }
  // ================= VALIDATION =================

  bool validateForm() {
    if (lastPeriodController.text.isEmpty) {
      showError(
        "Please select Last Menstrual Period Date",
      );
      return false;
    }

    if (isPregnant.value == null) {
      showError(
        "Please select pregnancy status",
      );
      return false;
    }

    if (isPregnant.value == true && deliveryDateController.text.isEmpty) {
      showError(
        "Please select Expected Delivery Date",
      );
      return false;
    }

    return true;
  }

  // ================= NAVIGATION =================

  void goToNextStep() {
    if (!validateForm()) return;

    Get.toNamed(Routes.PATIENT_COMPLETION);
  }

  // ================= CLEANUP =================

  @override
  void onClose() {
    lastPeriodController.dispose();
    deliveryDateController.dispose();
    historyController.dispose();
    super.onClose();
  }
}
