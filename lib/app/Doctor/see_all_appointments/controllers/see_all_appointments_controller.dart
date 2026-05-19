import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import '../../../service/api/common_api/doctor_dashboard_api/doctor_dashboard_api.dart';
import 'package:url_launcher/url_launcher.dart';

class SeeAllAppointmentsController extends GetxController {
  final DoctorDashboardApi _dashboardApi = DoctorDashboardApi();

  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> appointments =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllBookings();
  }

  /// ================= FETCH ALL BOOKINGS =================
  Future<void> fetchAllBookings() async {
    try {
      isLoading.value = true;

      final ApiResponse response = await _dashboardApi.getAllBookings();

      final message = response.data['message'];

      if (message != null && message['status'] == true) {
        final dataMap = message['data'] as Map<String, dynamic>? ?? {};
        final data = dataMap['bookings'] as List? ?? [];

        appointments.assignAll(
          data.map((apt) {
            final image = apt['patient_image']?.toString() ?? '';
            return {
              'name': apt['patient_name']?.toString() ?? '',
              'time': apt['appointment_time']?.toString() ?? '',
              'details':
                  '${apt['patient_gender'] ?? ''} | ${apt['patient_age'] ?? ''} years',
              'type': apt['consultation_type']?.toString() ?? '',
              'imagePath': image.isNotEmpty
                  ? (image.startsWith('http')
                      ? image
                      : 'http://217.216.58.35$image')
                  : 'assets/icons/account_circle.png',
              'video_link': apt['video_link']?.toString() ?? '',
              'id': apt['id']?.toString() ?? '',
            };
          }).toList(),
        );
      } else {
        showError(message?['message']?.toString() ?? 'Failed to load bookings');
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= CHECK IF JOIN ALLOWED =================
  /// 5 min pehle se button enable hoga
  bool canJoin(Map<String, dynamic> apt) {
    final timeStr = apt['time']?.toString() ?? '';
    if (timeStr.isEmpty) return false;

    try {
      final now = DateTime.now();

      // Parse "09:30 AM" / "02:00 PM" format
      final parts = timeStr.trim().split(' ');
      final timeParts = parts[0].split(':');
      final isPm = parts.length > 1 && parts[1].toUpperCase() == 'PM';

      int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);

      if (isPm && hour != 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;

      final appointmentTime = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // 5 min pehle se enable
      final enableFrom = appointmentTime.subtract(const Duration(minutes: 5));

      return now.isAfter(enableFrom);
    } catch (_) {
      return false;
    }
  }

  /// ================= JOIN CALL =================
  void joinCall(Map<String, dynamic> apt) async {
    if (!canJoin(apt)) {
      final timeStr = apt['time']?.toString() ?? '';
      showError('Call will be available 5 minutes before $timeStr');
      return;
    }

    final link = apt['video_link']?.toString() ?? '';
    if (link.isEmpty) {
      showError('No link available for this appointment');
      return;
    }

    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      showError('Could not open the link');
    }
  }
}
