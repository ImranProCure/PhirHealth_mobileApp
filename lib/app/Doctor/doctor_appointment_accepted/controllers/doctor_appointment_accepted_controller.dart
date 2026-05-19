import 'package:get/get.dart';

class DoctorAppointmentAcceptedController extends GetxController {
  late Map<String, dynamic> data;

  // Getters from API response
  String get patientName => data['patient_name']?.toString() ?? '';
  String get sessionType => data['session_type']?.toString() ?? '';
  String get appointmentTime => data['appointment_time']?.toString() ?? '--';
  String get duration => '${data['duration_minutes']?.toString() ?? '--'} min';
  String get earnings => '₹${data['earnings']?.toString() ?? '--'}';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      data = Get.arguments as Map<String, dynamic>;
    }
  }
}
