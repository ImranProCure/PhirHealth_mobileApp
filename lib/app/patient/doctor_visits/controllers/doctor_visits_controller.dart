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
  // Response has: "Upcoming", "Completed", "Cancelled"
  final RxString selectedFilter = 'All'.obs;
  final List<String> filters = ['All', 'Upcoming', 'Completed', 'Cancelled'];

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  // ===== VISITS DATA =====
  final RxList<Map<String, dynamic>> allVisits =
      <Map<String, dynamic>>[].obs;

  List<Map<String, dynamic>> get filteredVisits {
    if (selectedFilter.value == 'All') return allVisits;
    return allVisits
        .where((v) => v['status'] == selectedFilter.value)
        .toList();
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

      // Same pattern as IdentityVitalsEditController
      ApiResponse response =
          await api.commonApi.doctorVisitApi.getAppointments();
      // ^ Add getDoctorVisits() to your authenticationApi class

      final messageData = response.data['message'];

      if (messageData['status'] == true) {
        final List<dynamic> rawVisits =
            messageData['data'] as List<dynamic>;

        final mapped = rawVisits
            .map((d) => _mapAppointmentToVisit(d as Map<String, dynamic>))
            .toList();

        allVisits.assignAll(mapped);
      } else {
        errorMessage.value =
            messageData['message'] ?? 'Failed to fetch visits';
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
  /// Maps a real appointment object from the API response:
  /// appointment_id, doctor_name, specialty, status,
  /// appointment_date ("yyyy-MM-dd"), appointment_time, visit_type, notes
  Map<String, dynamic> _mapAppointmentToVisit(Map<String, dynamic> d) {
    // ── Parse appointment_date "yyyy-MM-dd" ──
    String month = '';
    String dateShort = '';
    final rawDate = d['appointment_date'] as String? ?? '';
    if (rawDate.isNotEmpty) {
      try {
        final parsed = DateFormat('yyyy-MM-dd').parse(rawDate);
        // Month header: "April 2026"
        month = DateFormat('MMMM yyyy').format(parsed);
        // Date circle: "APR\n28"
        final monthAbbr = DateFormat('MMM').format(parsed).toUpperCase();
        final day = parsed.day.toString();
        dateShort = '$monthAbbr\n$day';
      } catch (_) {
        month = rawDate;
        dateShort = rawDate;
      }
    }

    final status = d['status'] as String? ?? 'Upcoming';

    return {
      'appointment_id': d['appointment_id'],
      'doctor_id': d['doctor_id'],
      'month': month,
      'date_short': dateShort,
      'doctor': 'Dr. ${d['doctor_name'] ?? ''}',
      'specialty': d['specialty'] ?? '',
      'time': d['appointment_time'] ?? '',
      'type': d['visit_type'] ?? '',
      'status': status,
      'note': d['notes'] ?? '',
      'show_book_again': status == 'Completed' || status == 'Cancelled',
    };
  }

  // ===== ACTIONS =====
  void viewMoreDetails(Map<String, dynamic> visit) {
    Get.toNamed('/visit-details', arguments: {'visit': visit});
  }

  void bookAgain(Map<String, dynamic> visit) {
    Get.toNamed('/profile-details');
  }
}