import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import '../../../service/api/common_api/doctor_dashboard_api/doctor_dashboard_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';

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

  // ===== FETCH ALL BOOKINGS =====
  Future<void> fetchAllBookings() async {
    try {
      isLoading.value = true;
      final ApiResponse response = await _dashboardApi.getAllBookings();
      final message = response.data['message'];

      if (message != null && message['status'] == true) {
        final dataMap = message['data'] as Map<String, dynamic>? ?? {};
        final data = dataMap['bookings'] as List? ?? [];

        final mapped = data.map((apt) {
          final image = apt['patient_image']?.toString() ?? '';
          return {
            'name': apt['patient_name']?.toString() ?? '',
            'time': apt['appointment_time']?.toString() ?? '',
            'date': apt['appointment_date']?.toString() ??
                apt['date']?.toString() ??
                '',
            'details':
                '${apt['patient_gender'] ?? ''} | ${apt['patient_age'] ?? ''} years',
            'type': apt['consultation_type']?.toString() ?? '',
            'imagePath': image.isNotEmpty
                ? ApiConstants.imageUrl(image)
                : 'assets/icons/account_circle.png',
            'video_link': apt['video_link']?.toString() ?? '',
            'id': apt['id']?.toString() ?? '',
          };
        }).toList();

        // ===== DATE-WISE SORT — latest first =====
        mapped.sort((a, b) {
          try {
            final da = DateTime.parse(a['date'] ?? '');
            final db = DateTime.parse(b['date'] ?? '');
            return da.compareTo(db); // ascending
          } catch (_) {
            return 0;
          }
        });

        appointments.assignAll(mapped);
      } else {
        showError(message?['message']?.toString() ?? 'Failed to load bookings');
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ===== GROUPED APPOINTMENTS =====
  Map<String, List<Map<String, dynamic>>> get groupedAppointments {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    for (final apt in appointments) {
      final dateStr = apt['date']?.toString() ?? '';
      String label;
      try {
        final parsed = DateTime.parse(dateStr);
        final dateOnly = DateTime(parsed.year, parsed.month, parsed.day);
        if (dateOnly == today) {
          label = 'Today';
        } else if (dateOnly == tomorrow) {
          label = 'Tomorrow';
        } else {
          label = '${_monthName(parsed.month)} ${parsed.day}, ${parsed.year}';
        }
      } catch (_) {
        label = dateStr;
      }

      grouped.putIfAbsent(label, () => []);
      grouped[label]!.add(apt);
    }

    return grouped;
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  // ===== 5 MIN JOIN CHECK =====
  bool canJoin(Map<String, dynamic> apt) {
    final timeStr = apt['time']?.toString() ?? '';
    final dateStr = apt['date']?.toString() ?? '';
    if (timeStr.isEmpty || dateStr.isEmpty) return false;
    try {
      final now = DateTime.now();

      final dateParts = dateStr.split('-');
      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);

      final parts = timeStr.trim().split(' ');
      final timeParts = parts[0].split(':');
      final isPm = parts.length > 1 && parts[1].toUpperCase() == 'PM';
      int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);
      if (isPm && hour != 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;

      final appointmentTime = DateTime(year, month, day, hour, minute);
      final enableFrom = appointmentTime.subtract(const Duration(minutes: 5));

      return now.isAfter(enableFrom);
    } catch (_) {
      return false;
    }
  }

  // ===== ON APPOINTMENT TAP =====
  void onAppointmentTap(Map<String, dynamic> apt) {
    Get.toNamed('/doctor-patient-detail', arguments: apt);
  }

  // ===== JOIN CALL =====
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
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
