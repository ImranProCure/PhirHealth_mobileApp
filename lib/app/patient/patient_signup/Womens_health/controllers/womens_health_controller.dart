import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class WomensHealthController extends GetxController {
  // ================= DATE CONTROLLERS =================

  final TextEditingController lastPeriodController = TextEditingController();

  final TextEditingController deliveryDateController = TextEditingController();

  final TextEditingController historyController = TextEditingController();

  // ================= SYMPTOMS =================

  final symptomOptions = ['Yes', 'No'].obs;

  final selectedSymptoms = ''.obs;

  void selectSymptoms(String value) {
    selectedSymptoms.value = value;
  }

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
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0D9488), // Selected date circle
              onPrimary: Colors.white, // Text inside selected date
              onSurface: Colors.black,
            ),
            datePickerTheme: DatePickerThemeData(
              todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xFF0D9488); // Circle color
                }
                return null;
              }),
              todayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white; // Text color inside circle
                }
                return const Color(0xFF0D9488); // Normal today text color
              }),
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

  bool get isFormValid {
    // Optional screen hai, toh strict validation nahi kar rahe
    return true;
  }

  // ================= NAVIGATION =================

  void goToNextStep() {
    if (!isFormValid) {
      Get.snackbar(
        'Incomplete Details',
        'Please fill required fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // 👉 Step 6 screen ka route yaha daalna
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
