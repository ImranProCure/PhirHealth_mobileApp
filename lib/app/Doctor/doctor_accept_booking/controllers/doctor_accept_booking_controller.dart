import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorAcceptBookingController extends GetxController {
  late Map<String, dynamic> request;
  final TextEditingController notesController = TextEditingController();

  // Patient info
  final String patientName = 'Akansha Tripathi';
  final String patientInitials = 'AR';
  final String patientInfo = 'Female, 28 Yrs | Blood Group: O+';
  final String patientType = 'Returning Patient';

  // Session info
  final String complaint = 'High Fever & Body Ache';
  final String dateTime = 'February 12, 2026 | 10:00 AM • 30 min';
  final String sessionType = 'Video Consultation';
  final String earnings = '₹500 (Paid)';

  // Symptoms
  final List<String> symptoms = [
    'Fever & Cough',
    'Joint Pain',
    'High Blood Pressure'
  ];

  // Before you accept
  final List<String> beforeAccept = [
    'Make sure you are available at the scheduled time.',
    'Patient will receive an instant confirmation notification.',
    'Appointment will be automatically synced to your calendar.',
    'Payment will be processed after the consultation is completed.',
  ];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      request = Get.arguments as Map<String, dynamic>;
    }
  }

  void confirmAccept() {
    Get.offNamed('/doctor-appointment-accepted');
  }

  void backToRequests() => Get.back();

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
