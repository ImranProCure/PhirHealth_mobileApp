import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VisitDetailsController extends GetxController {
  // ===== ARGUMENTS =====
  late Map<String, dynamic> visit;

  @override
  void onInit() {
    super.onInit();
    visit = Get.arguments?['visit'] ??
        {
          "month": "February 2026",
          "date_short": "FEB\n12",
          "doctor": "Dr. Jyoti Wadhwani",
          "specialty": "General Physician",
          "time": "10:30 AM",
          "type": "Video Call",
          "status": "Completed",
          "note": "",
        };
  }

  String get appBarTitle => "Visit on 12 Feb 2026";

  // ===== ACTIONS =====
  void viewPrescription() {
    Get.snackbar(
      "Prescription",
      "Opening digital prescription...",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0D9488),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void downloadPdf() {
    Get.snackbar(
      "Download",
      "Downloading prescription PDF...",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFF3F4F6),
      colorText: Colors.black,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void downloadInvoice() {
    Get.snackbar(
      "Download",
      "Downloading invoice...",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFF3F4F6),
      colorText: Colors.black,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void callClinic() {
    Get.snackbar(
      "Calling",
      "Connecting to clinic...",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0D9488),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
