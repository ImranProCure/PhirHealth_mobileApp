import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

class VisitDetailsController extends GetxController {
  // ===== API =====
  Api api = Api.instance;

  // ===== ARGUMENTS =====
  late Map<String, dynamic> visit;

  // ===== LOADING / ERROR STATE =====
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ===== VISIT DETAIL DATA =====
  final Rx<Map<String, dynamic>> visitDetail = Rx<Map<String, dynamic>>({});

  // ===== COMPUTED GETTERS =====
  String get doctorName => visitDetail.value['doctor']?['name'] != null
      ? 'Dr. ${visitDetail.value['doctor']['name']}'
      : visit['doctor'] ?? 'Dr. Jyoti Wadhwani';

  String get specialty =>
      visitDetail.value['doctor']?['specialty'] ??
      visit['specialty'] ??
      'General Physician';

  String get clinicAddress =>
      visitDetail.value['doctor']?['address'] ?? 'Bombay Hospital, Indore';

  String get clinicPhone => visitDetail.value['doctor']?['clinic_phone'] ?? '';

  String get doctorNotes =>
      visitDetail.value['doctor_notes'] ?? 'No notes available.';

  String get bp => visitDetail.value['vitals']?['bp'] != null
      ? '${visitDetail.value['vitals']['bp']}'
      : 'N/A';

  String get temperature => visitDetail.value['vitals']?['temperature'] != null
      ? '${visitDetail.value['vitals']['temperature']} F'
      : 'N/A';

  String get consultationFee {
    final fee = visitDetail.value['bill_summary']?['consultation_fee'];
    if (fee == null) return '₹0';
    return '₹${fee.toStringAsFixed(0)}';
  }

  String get paymentStatus =>
      visitDetail.value['bill_summary']?['payment_status'] ?? 'Paid via UPI';

  List<String> get prescriptionImages {
    final images = visitDetail.value['prescription']?['prescription_images'];
    if (images == null) return [];
    return List<String>.from(images);
  }

  String get prescriptionUpdatedLabel {
    final rawDate = visit['appointment_date'] as String? ?? '';
    final rawTime = visit['time'] as String? ?? '';
    if (rawDate.isNotEmpty) {
      try {
        final date = DateFormat('yyyy-MM-dd').parse(rawDate);
        final formatted = DateFormat('dd MMM').format(date);
        return 'Updated on $formatted${rawTime.isNotEmpty ? ', $rawTime' : ''}';
      } catch (_) {}
    }
    return 'Updated on 12 Feb, 11:00 AM';
  }

  String get appBarTitle {
    final rawDate = visit['appointment_date'] as String? ??
        visit['date_short'] as String? ??
        '';
    if (rawDate.contains('-')) {
      try {
        final date = DateFormat('yyyy-MM-dd').parse(rawDate);
        return 'Visit on ${DateFormat('d MMM yyyy').format(date)}';
      } catch (_) {}
    }
    return 'Visit Details';
  }

  // ===== LIFECYCLE =====
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
    fetchVisitDetails();
  }

  // ===== FETCH =====
  Future<void> fetchVisitDetails() async {
    final appointmentId = visit['appointment_id'];
    if (appointmentId == null) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      ApiResponse response = await api.commonApi.doctorVisitApi
          .getVisitDetails(queryParams: appointmentId);

      final messageData = response.data['message'];

      if (messageData['status'] == true) {
        visitDetail.value =
            Map<String, dynamic>.from(messageData['data'] as Map);
        // also store appointment_date on visit map for appBarTitle
        visit['appointment_date'] = visitDetail.value['appointment_date'] ?? '';
      } else {
        errorMessage.value =
            messageData['message'] ?? 'Failed to fetch visit details';
        showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong: $e';
      showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // ===== ACTIONS =====
  void viewPrescription() {
    if (prescriptionImages.isEmpty) {
      Get.snackbar(
        "No Prescription",
        "No prescription images available.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF6B7280),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    // Navigate with prescription images list
    Get.toNamed('/prescription-view', arguments: {
      'images': prescriptionImages,
    });
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
    if (clinicPhone.isEmpty) {
      Get.snackbar(
        "Unavailable",
        "Clinic phone number not available.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF6B7280),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    // Use url_launcher to dial: launch('tel:$clinicPhone')
    Get.snackbar(
      "Calling",
      "Connecting to clinic at $clinicPhone...",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0D9488),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
