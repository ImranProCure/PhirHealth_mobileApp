import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaveReportController extends GetxController {
  late String imagePath;

  final RxString selectedType = 'Prescriptions'.obs;
  final RxString selectedDate = ''.obs;
  final TextEditingController fileNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    imagePath = Get.arguments?['imagePath'] ?? '';
    final now = DateTime.now();
    selectedDate.value = '${now.day} ${_monthName(now.month)} ${now.year}';
    fileNameController.text = 'Prescription_${now.day}${_monthName(now.month)}';
  }

  void selectType(String type) => selectedType.value = type;

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF0D9488),
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      selectedDate.value =
          '${picked.day} ${_monthName(picked.month)} ${picked.year}';
    }
  }

  void retakePhoto() => Get.back();

  void saveRecord() {
    final String title = fileNameController.text.trim().isEmpty
        ? '${selectedType.value} ${selectedDate.value}'
        : fileNameController.text.trim();

    Get.back(result: {
      'type': selectedType.value,
      'title': title,
      'date': selectedDate.value,
      'imagePath': imagePath,
      'isAsset': false,
    });
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  @override
  void onClose() {
    fileNameController.dispose();
    super.onClose();
  }
}
