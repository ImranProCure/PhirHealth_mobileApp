import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

class DoctorVisitsController extends GetxController {
  // ===== API =====
  Api api = Api.instance;

  // ===== LOADING / ERROR STATE =====
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ===== FILTER TABS =====
  final RxString selectedFilter = 'All'.obs;
  final List<String> filters = ['All', 'Upcoming', 'Completed', 'Cancelled'];

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  // ===== VISITS DATA =====
  final RxList<Map<String, dynamic>> allVisits = <Map<String, dynamic>>[].obs;

  List<Map<String, dynamic>> get filteredVisits {
    if (selectedFilter.value == 'All') return allVisits;
    return allVisits.where((v) => v['status'] == selectedFilter.value).toList();
  }

  // Group helpers (used by view)
  List<String> get months {
    final seen = <String>[];
    for (final v in filteredVisits) {
      if (!seen.contains(v['month'])) seen.add(v['month']);
    }
    return seen;
  }

  List<Map<String, dynamic>> visitsForMonth(String month) =>
      filteredVisits.where((v) => v['month'] == month).toList();

  // ===== LIFECYCLE =====
  @override
  void onInit() {
    super.onInit();
    fetchDoctorVisits();
  }

  // ===== FETCH =====
  Future<void> fetchDoctorVisits() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      ApiResponse response =
          await api.commonApi.doctorVisitApi.getAppointments();

      final messageData = response.data['message'];

      if (messageData['status'] == true) {
        final List<dynamic> rawVisits = messageData['data'] as List<dynamic>;

        final mapped = rawVisits
            .map((d) => _mapAppointmentToVisit(d as Map<String, dynamic>))
            .toList();

        allVisits.assignAll(mapped);
      } else {
        errorMessage.value = messageData['message'] ?? 'Failed to fetch visits';
        showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong: $e';
      showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshVisits() async {
    await fetchDoctorVisits();
  }

  // ===== MAPPER =====
  Map<String, dynamic> _mapAppointmentToVisit(Map<String, dynamic> d) {
    // ── Parse appointment_date "yyyy-MM-dd" ──
    String month = '';
    String dateShort = '';
    DateTime? parsedDate;

    final rawDate = d['appointment_date'] as String? ?? '';
    if (rawDate.isNotEmpty) {
      try {
        parsedDate = DateFormat('yyyy-MM-dd').parse(rawDate);
        month = DateFormat('MMMM yyyy').format(parsedDate);
        final monthAbbr = DateFormat('MMM').format(parsedDate).toUpperCase();
        final day = parsedDate.day.toString();
        dateShort = '$monthAbbr\n$day';
      } catch (_) {
        month = rawDate;
        dateShort = rawDate;
      }
    }

    // ── Parse appointment_time "hh:mm AM/PM" into DateTime for join logic ──
    DateTime? appointmentDateTime;
    final rawTime = d['appointment_time'] as String? ?? '';
    if (parsedDate != null && rawTime.isNotEmpty) {
      try {
        final timeParsed = DateFormat('hh:mm a').parse(rawTime);
        appointmentDateTime = DateTime(
          parsedDate.year,
          parsedDate.month,
          parsedDate.day,
          timeParsed.hour,
          timeParsed.minute,
        );
      } catch (_) {
        appointmentDateTime = null;
      }
    }

    final status = d['status'] as String? ?? 'Upcoming';
    final visitType = d['visit_type'] as String? ?? '';
    final meetingLink = d['meeting_link'] as String? ?? '';

    // ── Join button: Upcoming + Video Call + has a meeting link ──
    final bool showJoinButton =
        status == 'Upcoming' &&
        visitType.toLowerCase().contains('video') &&
        meetingLink.isNotEmpty;

    return {
      'appointment_id': d['appointment_id'],
      'doctor_id': d['doctor_id'],
      'month': month,
      'date_short': dateShort,
      'doctor': 'Dr. ${d['doctor_name'] ?? ''}',
      'specialty': d['specialty'] ?? '',
      'time': rawTime,
      'type': visitType,
      'status': status,
      'note': d['notes'] ?? '',
      'meeting_link': meetingLink,
      'appointment_date_time': appointmentDateTime,
      'show_join_button': showJoinButton,
      'show_book_again': status == 'Completed' || status == 'Cancelled',
      'user_roles': d['user_roles'] ?? '',
    };
  }

  // ===== JOIN BUTTON STATE =====
  /// Enabled from 10 min before appointment until 1 hour after it starts.
  bool isJoinEnabled(Map<String, dynamic> visit) {
    final DateTime? apptTime = visit['appointment_date_time'] as DateTime?;
    if (apptTime == null) return false;
    final now = DateTime.now();
    final enableFrom = apptTime.subtract(const Duration(minutes: 10));
    final enableUntil = apptTime.add(const Duration(hours: 1));
    return now.isAfter(enableFrom) && now.isBefore(enableUntil);
  }

  /// Human-readable label for time remaining until the join button opens.
  String joinCountdownLabel(Map<String, dynamic> visit) {
    final DateTime? apptTime = visit['appointment_date_time'] as DateTime?;
    if (apptTime == null) return '';
    final now = DateTime.now();
    final enableFrom = apptTime.subtract(const Duration(minutes: 10));
    if (now.isBefore(enableFrom)) {
      final diff = enableFrom.difference(now);
      if (diff.inDays > 0) {
        return 'Available in ${diff.inDays}d ${diff.inHours.remainder(24)}h';
      } else if (diff.inHours > 0) {
        return 'Available in ${diff.inHours}h ${diff.inMinutes.remainder(60)}m';
      } else if (diff.inMinutes > 0) {
        return 'Available in ${diff.inMinutes}m ${diff.inSeconds.remainder(60)}s';
      } else {
        return 'Available in ${diff.inSeconds}s';
      }
    }
    return '';
  }

  // ===== ACTIONS =====
  void viewMoreDetails(Map<String, dynamic> visit) {
    Get.toNamed('/visit-details', arguments: {'visit': visit});
  }

  void bookAgain(Map<String, dynamic> visit) {
    Get.toNamed('/profile-details');
  }
}