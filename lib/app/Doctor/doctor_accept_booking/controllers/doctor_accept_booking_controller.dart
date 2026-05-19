import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../service/api/api_client/api_response.dart';
import '../../../service/api/common_api/doctor_pending_request_api/doctor_pending_request_api.dart';

class DoctorAcceptBookingController extends GetxController {
  late Map<String, dynamic> request;
  final TextEditingController notesController = TextEditingController();
  final DoctorPendingRequestApi _requestsApi = DoctorPendingRequestApi();

  final RxBool isLoading = false.obs;
  final Rx<Map<String, dynamic>> details = Rx<Map<String, dynamic>>({});

  // ── Getters from GET API response ──
  String get patientName => details.value['patient_name']?.toString() ?? '';
  String get patientInitials {
    final parts = patientName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty)
      return parts[0][0].toUpperCase();
    return 'P';
  }

  String get patientInfo {
    final gender = details.value['gender']?.toString() ?? '';
    final age = details.value['age']?.toString() ?? '';
    final blood = details.value['blood_group']?.toString() ?? '';
    return '$gender, $age Yrs | Blood Group: $blood';
  }

  bool get isReturningPatient => details.value['is_returning_patient'] == true;

  String get dateTime {
    final date = details.value['date']?.toString() ?? '';
    final time = details.value['time']?.toString() ?? '';
    final duration = details.value['duration']?.toString() ?? '';
    return '$date | $time • $duration min';
  }

  String get sessionType => details.value['appointment_mode']?.toString() ?? '';

  String get earnings {
    final amount = details.value['earnings'];
    final isPaid = details.value['is_paid'] == true;
    return '₹${amount?.toString() ?? '--'} ${isPaid ? '(Paid)' : ''}';
  }

  // Chief complaint = allergies + existing conditions
  String get complaint {
    final allergies = (details.value['allergies'] as List? ?? []);
    final conditions = (details.value['existing_conditions'] as List? ?? []);
    final all = [...allergies, ...conditions];
    if (all.isEmpty) return 'No data available';
    return all.join(', ');
  }

  // Symptoms
  List<String> get symptoms {
    final list = details.value['common_symptoms'] as List? ?? [];
    if (list.isEmpty) return ['No symptoms listed'];
    return list.map((e) => e.toString()).toList();
  }

  // Medical records / patient encounters
  List<Map<String, dynamic>> get medicalRecords {
    final records = details.value['medical_records'];
    if (records == null) return [];
    if (records is List)
      return records.map((e) => e as Map<String, dynamic>).toList();
    return [];
  }

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
      fetchAppointmentDetails();
    }
  }

  Future<void> fetchAppointmentDetails() async {
    try {
      isLoading.value = true;
      final appointmentId = request['appointment_id'] as String;
      final ApiResponse response =
          await _requestsApi.getAppointmentDetails(appointmentId);
      final message = response.data['message'];

      if (message != null &&
          (message['status'] == true ||
              message['status'].toString() == 'True')) {
        details.value = message['data'] as Map<String, dynamic>;
      } else {
        Get.snackbar('Error',
            message?['message']?.toString() ?? 'Failed to load details',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void confirmAccept() async {
    final appointmentId = request['appointment_id'] as String;

    try {
      isLoading.value = true;
      final ApiResponse response =
          await _requestsApi.acceptAppointment(appointmentId);
      final message = response.data['message'];

      if (message != null &&
          (message['status'] == true ||
              message['status'].toString() == 'True')) {
        Get.offNamed('/doctor-appointment-accepted',
            arguments: message['data']);
      } else {
        Get.snackbar(
            'Error', message?['message']?.toString() ?? 'Failed to accept',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void backToRequests() => Get.back();

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
