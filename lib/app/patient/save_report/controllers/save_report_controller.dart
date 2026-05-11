import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaveReportController extends GetxController {
  // ===== MULTIPLE IMAGES — list hai ab =====
  final RxList<String> imagePaths = <String>[].obs;
  final RxInt currentImageIndex = 0.obs;

  final RxString selectedType = 'Prescriptions'.obs;
  final RxString selectedDate = ''.obs;
  final TextEditingController fileNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Single ya multiple — dono handle karo
    final args = Get.arguments;
    if (args is Map) {
      final single = args['imagePath'] as String? ?? '';
      final multiple = args['imagePaths'] as List<String>? ?? [];
      if (multiple.isNotEmpty) {
        imagePaths.value = multiple;
      } else if (single.isNotEmpty) {
        imagePaths.value = [single];
      }
    }

    final now = DateTime.now();
    selectedDate.value = '${now.day} ${_monthName(now.month)} ${now.year}';
    fileNameController.text = 'Prescription_${now.day}${_monthName(now.month)}';
  }

  // Current image jo preview mein dikh rahi hai
  String get currentImagePath =>
      imagePaths.isNotEmpty ? imagePaths[currentImageIndex.value] : '';

  void selectType(String type) => selectedType.value = type;

  void goToImage(int index) {
    if (index >= 0 && index < imagePaths.length) {
      currentImageIndex.value = index;
    }
  }

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

    final Map<String, String> typeMapping = {
      'Prescriptions': 'Prescriptions',
      'Lab Reports': 'Lab Reports',
      'Doctor Notes': 'Doctor Notes',
      'Vitals Tracking': 'Vitals Tracking',
      'Imaging Reports': 'Imaging Reports',
      'Discharge Summary': 'Discharge Summary',
      'Medical History': 'Medical History',
    };

    final String apiType =
        typeMapping[selectedType.value] ?? selectedType.value;

    Get.back(result: {
      'type': apiType,
      'title': title,
      'date': selectedDate.value,
      'imagePaths': imagePaths.toList(), // ← list return karo
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
