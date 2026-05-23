import 'package:get/get.dart';
import '../../../service/api/api_client/api_response.dart';
import '../../../service/api/common_api/doctor_pending_request_api/doctor_pending_request_api.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorPatientDetailController extends GetxController {
  late Map<String, dynamic> appointment;
  final DoctorPendingRequestApi _api = DoctorPendingRequestApi();

  final RxBool isLoading = false.obs;
  final Rx<Map<String, dynamic>> details = Rx<Map<String, dynamic>>({});

  // ── Getters ──
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

  // ✅ FIX: common_symptoms bhi include kiya
  String get complaint {
    final symptoms = details.value['common_symptoms'] as List? ?? [];
    final conditions = details.value['existing_conditions'] as List? ?? [];
    final all = [...symptoms, ...conditions];
    if (all.isEmpty) return 'No data available';
    return all.join(', ');
  }

  String get description {
    final notes = details.value['notes']?.toString() ?? '';
    return notes.isNotEmpty ? notes : 'No description provided.';
  }

  // ✅ FIX: allergies alag getter mein rakha
  String get alertText {
    final allergies = details.value['allergies'] as List? ?? [];
    if (allergies.isEmpty) return 'No known allergies.';
    return allergies.join(', ');
  }

  // ✅ FIX: vital_signs List hai, Map nahi — correctly parse kiya
  List<String> get vitals {
    final vitalList = details.value['vital_signs'] as List? ?? [];
    if (vitalList.isEmpty) return ['No vitals recorded.'];

    final vital = vitalList[0] as Map<String, dynamic>;
    return [
      'Temperature: ${vital['temperature'] ?? '--'}',
      'BP: ${vital['bp'] ?? '--'}',
      'Date: ${vital['date'] ?? '--'}',
      if ((vital['vital_signs_note']?.toString() ?? '').isNotEmpty)
        'Note: ${vital['vital_signs_note']}',
    ];
  }

  // ✅ FIX: patient_encounters bhi expose kiya
  List<Map<String, dynamic>> get encounters {
    final list = details.value['patient_encounters'] as List? ?? [];
    return list.map((e) => e as Map<String, dynamic>).toList();
  }

  // ✅ FIX: medical_records bhi expose kiya
  List<Map<String, dynamic>> get medicalRecords {
    final list = details.value['medical_records'] as List? ?? [];
    return list.map((e) => e as Map<String, dynamic>).toList();
  }

  String get email => details.value['email']?.toString() ?? '--';
  String get phone => details.value['phone']?.toString() ?? '--';

  bool get isReturningPatient => details.value['is_returning_patient'] == true;

  String get videoLink =>
      details.value['video_link']?.toString() ??
      appointment['video_link']?.toString() ??
      '';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      appointment = Get.arguments as Map<String, dynamic>;
      fetchDetails();
    }
  }

  Future<void> fetchDetails() async {
    try {
      isLoading.value = true;
      final appointmentId = appointment['id']?.toString() ?? '';
      final ApiResponse response =
          await _api.getConfirmedAppointmentDetails(appointmentId);
      final message = response.data['message'];

      if (message != null &&
          (message['status'] == true ||
              message['status'].toString() == 'True')) {
        details.value = Map<String, dynamic>.from(message['data']);
      } else {
        Get.snackbar(
          'Error',
          message?['message']?.toString() ?? 'Failed to load details',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void onCall() {}
  void onChat() {}
  void onRecords() {}

  void startConsultation() async {
    if (videoLink.isNotEmpty) {
      final uri = Uri.parse(videoLink);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } else {
      Get.snackbar('Error', 'No video link available',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void reschedule() => Get.toNamed(
        '/doctor-patient-reschedule',
        arguments: {
          'appointment_id': appointment['id']?.toString() ?? '',
        },
      );
  void cancelSession() => Get.toNamed('/doctor-cancel-session');
}
