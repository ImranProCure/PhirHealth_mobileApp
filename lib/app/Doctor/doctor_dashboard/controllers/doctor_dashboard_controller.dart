import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/db/db.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import '../../../service/api/common_api/doctor_dashboard_api/doctor_dashboard_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sample/app/service/api/api_client/api_constants.dart';

class DoctorDashboardController extends GetxController {
  final AuthStorageService _authStorage = AuthStorageService();
  final DoctorDashboardApi _dashboardApi = DoctorDashboardApi();

  final RxInt currentIndex = 0.obs;
  final RxBool isEndingMeeting = false.obs; // ← class level pe

  // ===== DOCTOR INFO =====
  final RxString doctorName = 'Doctor'.obs;
  final RxString doctorImage = ''.obs;

  // ===== OVERVIEW =====
  final RxString date = ''.obs;
  final RxString totalEarnings = '₹ 0.00'.obs;

  // ===== STATS =====
  final RxList<Map<String, dynamic>> stats = <Map<String, dynamic>>[
    {
      'label': 'Total Bookings',
      'value': '0',
      'iconPath': 'assets/icons/group.png',
      'iconColor': 0xFF3B82F6,
    },
    {
      'label': 'Completed Appointments',
      'value': '0',
      'iconPath': 'assets/icons/check_circle.png',
      'iconColor': 0xFF22C55E,
    },
    {
      'label': 'Pending Appointments',
      'value': '0',
      'iconPath': 'assets/icons/pending.png',
      'iconColor': 0xFFF59E0B,
    },
    {
      'label': 'Cancelled Appointments',
      'value': '0',
      'iconPath': 'assets/icons/cancel.png',
      'iconColor': 0xFFEF4444,
    },
  ].obs;

  // ===== APPOINTMENTS =====
  final RxList<Map<String, dynamic>> appointments =
      <Map<String, dynamic>>[].obs;

  final List<Map<String, String>> navItems = [
    {'label': 'Home', 'iconPath': 'assets/home.png'},
    {'label': 'Request', 'iconPath': 'assets/stethoscope.png'},
    {'label': 'Schedule', 'iconPath': 'assets/article.png'},
    {'label': 'Profile', 'iconPath': 'assets/account_circle.png'},
  ];

  @override
  void onInit() {
    super.onInit();
    _loadDoctorData();
    _fetchDashboard();
  }

  // ===== LOAD FROM STORAGE =====
  Future<void> _loadDoctorData() async {
    final user = await _authStorage.getUserDetail();
    if (user != null) {
      final firstName = user['first_name']?.toString() ?? '';
      final lastName = user['last_name']?.toString() ?? '';
      final fullName = user['full_name']?.toString() ?? '';

      if (fullName.isNotEmpty) {
        doctorName.value =
            fullName.startsWith('Dr') ? fullName : 'Dr. $fullName';
      } else if (firstName.isNotEmpty) {
        doctorName.value = 'Dr. $firstName $lastName'.trim();
      }

      final image = user['practitioner_image']?.toString() ??
          user['user_image']?.toString() ??
          '';
      if (image.isNotEmpty) {
        doctorImage.value = ApiConstants.imageUrl(image);
      }
    }
  }

  // ===== FETCH DASHBOARD API =====
  Future<void> _fetchDashboard() async {
    try {
      final ApiResponse response = await _dashboardApi.getDoctorDashboard();
      final message = response.data['message'];

      if (message != null && message['status'] == true) {
        final data = message['data'] as Map<String, dynamic>? ?? {};

        final overview = data['overview'] as Map<String, dynamic>? ?? {};

        final rawDate = overview['date']?.toString() ?? '';
        if (rawDate.isNotEmpty) {
          try {
            final d = DateTime.parse(rawDate);
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
            date.value = '${months[d.month - 1]} ${d.day}, ${d.year}';
          } catch (_) {
            date.value = rawDate;
          }
        }

        final earnings = overview['total_earnings'] ?? 0.0;
        totalEarnings.value =
            '₹ ${double.tryParse(earnings.toString())?.toStringAsFixed(2) ?? '0.00'}';

        stats[0] = {
          ...stats[0],
          'value': overview['total_bookings']?.toString() ?? '0'
        };
        stats[1] = {
          ...stats[1],
          'value': overview['completed_appointments']?.toString() ?? '0'
        };
        stats[2] = {
          ...stats[2],
          'value': overview['pending_appointments']?.toString() ?? '0'
        };
        stats[3] = {
          ...stats[3],
          'value': overview['cancelled_appointments']?.toString() ?? '0'
        };
        stats.refresh();

        final apts = data['upcoming_appointments'] as List? ?? [];

        if (apts.isNotEmpty) {
          print('🔵 DASHBOARD APT KEYS: ${apts[0].keys.toList()}');
          print('🔵 DASHBOARD APT SAMPLE: ${apts[0]}');
        } else {
          print('🔴 DASHBOARD: upcoming_appointments empty hai');
          print('🔴 DASHBOARD DATA KEYS: ${data.keys.toList()}');
        }

        appointments.assignAll(
          apts.map((apt) {
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
          }).toList(),
        );
      }
    } catch (e) {
      showError(e.toString());
    }
  }

  // ===== 5 MIN JOIN CHECK =====
  bool canJoin(Map<String, dynamic> apt) {
    final timeStr = apt['time']?.toString() ?? '';
    if (timeStr.isEmpty) return false;
    try {
      final now = DateTime.now();
      final parts = timeStr.trim().split(' ');
      final timeParts = parts[0].split(':');
      final isPm = parts.length > 1 && parts[1].toUpperCase() == 'PM';
      int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);
      if (isPm && hour != 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;
      final appointmentTime =
          DateTime(now.year, now.month, now.day, hour, minute);
      final enableFrom = appointmentTime.subtract(const Duration(minutes: 5));
      return now.isAfter(enableFrom);
    } catch (_) {
      return false;
    }
  }

  // ===== JOIN CALL =====
  // ===== JOIN CALL =====
  void joinCall(Map<String, dynamic> apt) async {
    print('🟡 APT TIME: ${apt['time']}');

    // if (!canJoin(apt)) {
    //   final timeStr = apt['time']?.toString() ?? '';
    //   showError('Call will be available 5 minutes before $timeStr');
    //   return;
    // }

    String link = apt['video_link']?.toString() ?? '';
    if (link.isEmpty) {
      showError('No link available');
      return;
    }

    // Dynamic link se seedha meet link nikalo
    if (link.contains('meet.app.goo.gl') || link.contains('goo.gl')) {
      final uri = Uri.parse(link);
      link = uri.queryParameters['link'] ?? link;
    }

    print('🟢 FINAL MEET LINK: $link');

    // Chrome mein kholo
    final uri = Uri.parse(link);
    await launchUrl(uri, mode: LaunchMode.externalApplication);

    // Meeting WebView screen pe bhi jao — sirf End Meeting button ke liye
    Get.toNamed('/meeting-webview', arguments: {
      ...apt,
      'meet_link': link,
    });
  }

  // ===== END MEETING =====
  Future<void> endMeeting(Map<String, dynamic> apt) async {
    if (isEndingMeeting.value) return;
    isEndingMeeting.value = true;
    try {
      final appointmentId = apt['id']?.toString() ?? '';
      final token = await _authStorage.getToken();
      final cookie = await _authStorage.getCookie();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${ApiConstants.baseUrl}/api/method/vhealthcare.api.patient.doctor_consult.patient_encounter.create_patient_encounterr'),
      );
      request.headers.addAll({
        'Authorization': 'token $token',
        'Cookie': cookie ?? '',
      });
      request.fields['appointment_id'] = appointmentId;
      final response = await request.send();
      final resBody = await response.stream.bytesToString();
      print('🟢 END MEETING RESPONSE: $resBody');
      final data = jsonDecode(resBody);
      if (data['message']['status'] == true) {
        await _fetchDashboard();
        Get.offAllNamed('/doctor-dashboard');
      } else {
        showError('Could not end meeting');
      }
    } catch (e) {
      print('🔴 END MEETING ERROR: $e');
      showError(e.toString());
    } finally {
      isEndingMeeting.value = false;
    }
  }

  // ===== NAV =====
  void onNavTap(int index) {
    currentIndex.value = index;
    if (index == 1) Get.toNamed('/doctor-requests');
    if (index == 2) Get.toNamed('/doctor-schedule');
    if (index == 3) Get.toNamed('/doctor-profile');
  }

  void seeAll() => Get.toNamed('/see-all-appointments');
  void onAppointmentTap(Map<String, dynamic> apt) =>
      Get.toNamed('/doctor-patient-detail', arguments: apt);
  void onNotification() => Get.toNamed('/doctor-notifications');
}
