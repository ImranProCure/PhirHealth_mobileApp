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

  final RxString doctorName = ''.obs;
  final RxString doctorDegree = ''.obs;
  final RxString doctorSpecialty = ''.obs;
  final RxString doctorExperience = ''.obs;
  final RxDouble doctorRating = 0.0.obs;
  final RxInt reviewCount = 0.obs;
  final RxInt fees = 0.obs;
  final RxString doctorImage = ''.obs;
  final RxString clinicName = ''.obs;
  final RxString address = ''.obs;

  // ===== BILL DETAILS =====
  final int consultationFee = 500;
  final int servicesFee = 69;
  final int totalAmount = 500;
  final int savedAmount = 49;
  final RxMap doctorData = {}.obs;

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
    patientName = Get.arguments?['patientName'];
    doctorData.value = Get.arguments?['data'];

    doctorName.value = doctorData.value['name']?.toString() ?? '';
    doctorDegree.value = doctorData.value['degree']?.toString() ?? '';
    doctorSpecialty.value = doctorData.value['specialty']?.toString() ?? '';
    doctorExperience.value = doctorData.value['experience']?.toString() ?? '';
    doctorRating.value =
        (doctorData.value['rating'] as num?)?.toDouble() ?? 0.0;
    reviewCount.value = (doctorData.value['review_count'] as int?) ?? 0;
    doctorImage.value = doctorData.value['image']?.toString() ?? '';
    fees.value = (doctorData.value['fees'] as int?) ?? 0;

    clinicName.value = doctorData.value['clinic_name']?.toString() ?? '';

    final addr = doctorData.value['address'] as Map<String, dynamic>?;
    if (addr != null) {
      final parts = [
        addr['address_line1']?.toString() ?? '',
        addr['address_line2']?.toString() ?? '',
        addr['city']?.toString() ?? '',
      ].where((s) => s.isNotEmpty).toList();
      address.value = parts.join(', ');
    }
  }
}
