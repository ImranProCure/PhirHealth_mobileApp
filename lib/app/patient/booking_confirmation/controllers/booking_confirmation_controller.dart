import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingConfirmationController extends GetxController {
  // ===== ARGUMENTS =====
  late String selectedDate;
  late String selectedSlot;
  late int tabType;
  late String patientName;

  // ===== PAYMENT METHOD =====
  final RxString selectedPayment = 'Wallet'.obs;

  void selectPayment(String method) {
    selectedPayment.value = method;
  }

  // ===== BILL DETAILS =====
  final int consultationFee = 500;
  final int servicesFee = 69;
  final int totalAmount = 500;
  final int savedAmount = 49;

  String get appointmentType =>
      tabType == 0 ? 'In-Clinic Appointment' : 'Video Consultation';

  String get appBarTitle =>
      tabType == 0 ? 'Book In-Clinic Appointment' : 'Book Video Consultation';

  String get slotTypeLabel =>
      tabType == 0 ? 'Clinic Visit Slots' : 'Video Consult Slots';

  // ===== CONFIRM =====
  void confirmBooking() {
    Get.toNamed('/appointment-confirmed');
  }

  @override
  void onInit() {
    super.onInit();
    selectedDate = Get.arguments?['date'] ?? 'Thu, 12 Feb';
    selectedSlot = Get.arguments?['slot'] ?? '03:00 PM';
    tabType = Get.arguments?['tabType'] ?? 0;
    patientName = Get.arguments?['patientName'] ?? 'Rahul Sharma';
  }
}
