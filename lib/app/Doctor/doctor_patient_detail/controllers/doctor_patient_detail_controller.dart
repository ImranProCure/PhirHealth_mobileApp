import 'package:get/get.dart';

class DoctorPatientDetailController extends GetxController {
  // Patient info
  final String patientName = 'Akansha Tripathi';
  final String patientInitials = 'AR';
  final String patientInfo = 'Female, 28 Yrs | Blood Group: O+';

  // Session info
  final String complaint = 'High Fever & Body Ache';
  final String dateTime = 'February 12, 2026 | 10:00 AM • 30 min';
  final String sessionType = 'Video Consultation';
  final String earnings = '₹500 (Paid)';

  // Description
  final String description =
      'Patient has been experiencing high fever (102°F) for the last 3 days along with severe body ache, dry cough, and mild weakness. No history of recent travel.';
  final String alertText = 'Allergic to Penicillin and dust.';

  // Vitals
  final List<String> vitals = [
    'Temperature recorded by patient: 102.4°F',
    'Blood Pressure: 120/80 mmHg (Last checked: 1 month ago)',
    'Last prescribed medicine: Paracetamol 500mg (SOS)',
    'CBC Blood Test report is pending for review.',
  ];

  // Contact
  final String email = 'akansha.tripathi@gmail.com';
  final String phone = '+91 98765 43210';

  void onCall() {}
  void onChat() {}
  void onRecords() {}
  void startConsultation() => Get.toNamed('/doctor-patient-reschedule');
  void reschedule() => Get.toNamed('/doctor-patient-reschedule');
  void cancelSession() => Get.toNamed('/doctor-cancel-session');
}
