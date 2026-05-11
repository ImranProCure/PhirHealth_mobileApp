import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/routes/app_routes.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/db/db.dart';

class CounsellorProfileDetailsController extends GetxController {
  Api api = Api.instance;

  // ===== LOADING =====
  final RxBool isLoading = false.obs;

  // ===== DOCTOR PROFILE DATA =====
  final RxString doctorName = ''.obs;
  final RxString doctorDegree = ''.obs;
  final RxString doctorSpecialty = ''.obs;
  final RxString doctorExperience = ''.obs;
  final RxDouble doctorRating = 0.0.obs;
  final RxInt reviewCount = 0.obs;
  final RxInt fees = 0.obs;
  final RxInt reviewStatus = 0.obs;
  final RxInt total = 0.obs;
  final RxString doctorImage = ''.obs;
  final RxString clinicName = ''.obs;
  final RxString address = ''.obs;
  final RxInt waitTime = 0.obs;
  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs; 

  final RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> allReviews = <Map<String, dynamic>>[].obs;
  final RxMap doctorData = {}.obs;
  final RxList<String> services = <String>[].obs;
  final RxList<String> specializations = <String>[].obs;
  final RxList<String> clinicPhotos = <String>[].obs;

  // ===== PAGINATION =====
  final RxBool isLoadingMoreReviews = false.obs;
  final RxBool hasMoreReviews = true.obs;
  int _reviewPage = 1;
  static const int _reviewPageSize = 10;

  Future<void> fetchAllReview({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMoreReviews.value || !hasMoreReviews.value) return;
      isLoadingMoreReviews.value = true;
    } else {
      // Fresh load — reset pagination
      _reviewPage = 1;
      hasMoreReviews.value = true;
      allReviews.clear();
      isLoading.value = true;
    }

    final Map<String, dynamic> body = {
      'practitioner': 'HLC-PRAC-2026-00002',
      'page': _reviewPage,
    };

    try {
      ApiResponse response =
          await api.commonApi.counsallerConsultApi.getAllReviews(queryParams: body);

      final messageData = response.data['message'];

      if (messageData['status'] == true) {
        final authStorage = AuthStorageService();
        final userData = await authStorage.getUserDetail();
        final String fullName = userData?['full_name']?.toString() ?? '';

        final rawReviews =
            messageData['data']["reviews"] as List<dynamic>? ?? [];
        total.value = messageData['data']["pagination"]["total"];

        final mapped = rawReviews
            .map((r) => {
                  'reviewer_name': fullName == r['reviewer_name']?.toString()
                      ? 'You'
                      : r['reviewer_name']?.toString() ?? '',
                  'initials': r['initials']?.toString() ?? '',
                  'rating': (r['rating'] as num?)?.toDouble() ?? 0.0,
                  'review_text': r['review_text']?.toString() ?? '',
                  'relative_date': r['relative_date']?.toString() ?? '',
                })
            .toList();

        allReviews.addAll(mapped);

        // If fewer results than page size returned, no more pages
        if (rawReviews.length < _reviewPageSize) {
          hasMoreReviews.value = false;
        } else {
          _reviewPage++;
        }
      } else {
        showError(messageData['message'] ?? 'Failed to fetch reviews');
      }
    } catch (e) {
      showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
      isLoadingMoreReviews.value = false;
    }
  }

  // ===== TAB =====
  final selectedTab = 0.obs;

  void changeTab(int index) {
    selectedTab.value = index;
    // Re-populate dates/slots from cached available_slots when tab changes
    _populateDatesFromSlots();
  }

  void viewAllSlots() {
    Get.toNamed('/all-slots',
        arguments: {'tabType': selectedTab.value, 'type': 0});
  }

  Future<void> goToPatientDetails() async {
    if (selectedSlot.value.isEmpty) {
      Get.snackbar(
        "Select a Slot",
        "Please select a time slot to continue",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFF3F4F6),
        colorText: Colors.black,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    final authStorage = AuthStorageService();
    final userData = await authStorage.getUserDetail();
    final String fullName = userData?['full_name']?.toString() ?? '';

    // Get.toNamed('/booking-confirmation', arguments: {
    //   'date': dates[selectedDateIndex.value]["fullDate"],
    //   'slot': selectedSlot.value,
    //   'tabType': selectedTab.value,
    //   'patientName': fullName,
    //   'data': doctorData,
    // });

    Get.toNamed(Routes.PATIENT_DETAILS, arguments: {
      'tabType': selectedTab.value,
      'slot': selectedSlot.value,
      'date': dates[selectedDateIndex.value]["fullDate"],
      'patientName': fullName,
      'data': doctorData,
      'type': "counsellor",
      'id': Get.arguments?['id'] ?? {},
    });
  }

  // ===== MONTH NAVIGATION =====
  final RxString currentMonthLabel = ''.obs;
  DateTime _currentMonth = DateTime.now();

  void nextMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    _updateMonthLabel();
    _generateDates();
  }

  void prevMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    _updateMonthLabel();
    _generateDates();
  }

  void _updateMonthLabel() {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    currentMonthLabel.value =
        "${months[_currentMonth.month - 1]}, ${_currentMonth.year}";
  }

  // ===== DATES =====
  final selectedDateIndex = 0.obs;
  final RxList<Map<String, dynamic>> dates = <Map<String, dynamic>>[].obs;

  // Raw available_slots from API — cached so we can re-use on tab switch
  List<Map<String, dynamic>> _availableSlots = [];

  /// Builds the date list from the API's available_slots array.
  void _populateDatesFromSlots() {
    if (_availableSlots.isEmpty) return;

    final List<Map<String, dynamic>> generated = _availableSlots.map((slot) {
      return {
        "date": slot["day_number"].toString(),
        "day": slot["day"].toString(),
        "slots": (slot["slot_count"] as int?) ?? 0,
        "rawSlots": List<String>.from(slot["slots"] ?? []),
        "fullDate": slot["date"].toString(), // "2026-04-22"
      };
    }).toList();

    selectedDateIndex.value = 0;
    selectedSlot.value = '';
    dates.assignAll(generated);

    if (generated.isNotEmpty) {
      _loadTimeSlotsForIndex(0);
    }
  }

  // Add this method to ProfileDetailsController
  Future<void> submitReview({
    required int rating,
    required String reviewText,
  }) async {
    // Get doctor id from arguments (same as fetchDoctorProfile)
    final args = Get.arguments;
    final String doctorId = args?['id']?.toString() ?? '';

    final Map<String, dynamic> body = {
      "practitioner": doctorId,
      "rating": rating,
      "review_text": reviewText
    };

    try {
      ApiResponse response = await api.commonApi.counsallerConsultApi
          .submitReview(body); // 👈 add this endpoint in your API layer

      final messageData = response.data['message'];

      if (messageData["status"] == true) {
        // ✅ Instantly prepend the new review to the list
        reviews.insert(0, {
          'reviewer_name': 'You',
          'initials': doctorName.value.isNotEmpty
              ? doctorName.value.trim()[0].toUpperCase()
              : 'U',
          'rating': rating.toDouble(),
          'review_text': reviewText,
          'relative_date': 'Just now',
        });

        // ✅ Update review count
        reviewCount.value = reviewCount.value + 1;
      } else {
        showError(messageData["message"] ?? "Failed to submit review");
      }
    } catch (e) {
      showError("Something went wrong. Please try again.");
    }
  }

  /// Fallback: generates dummy dates for the current month when no API data.
  void _generateDates() {
    if (_availableSlots.isNotEmpty) {
      // Filter slots to current month
      final filtered = _availableSlots.where((slot) {
        final dateStr = slot["date"]?.toString() ?? '';
        if (dateStr.isEmpty) return false;
        final parts = dateStr.split('-');
        if (parts.length < 2) return false;
        return int.tryParse(parts[0]) == _currentMonth.year &&
            int.tryParse(parts[1]) == _currentMonth.month;
      }).toList();

      if (filtered.isNotEmpty) {
        final List<Map<String, dynamic>> generated = filtered.map((slot) {
          return {
            "date": slot["day_number"].toString(),
            "day": slot["day"].toString(),
            "slots": (slot["slot_count"] as int?) ?? 0,
            "rawSlots": List<String>.from(slot["slots"] ?? []),
            "fullDate": slot["date"].toString(),
          };
        }).toList();

        selectedDateIndex.value = 0;
        selectedSlot.value = '';
        dates.assignAll(generated);
        if (generated.isNotEmpty) _loadTimeSlotsForIndex(0);
        return;
      }
    }

    // No data for this month — show empty
    selectedDateIndex.value = 0;
    selectedSlot.value = '';
    dates.clear();
    timeSlots.clear();
  }

  // ===== TIME SLOTS =====
  final RxList<String> timeSlots = <String>[].obs;
  final selectedSlot = ''.obs;

  void selectSlot(String time) {
    selectedSlot.value = time;
  }

  void selectDate(int index) {
    selectedDateIndex.value = index;
    selectedSlot.value = '';
    _loadTimeSlotsForIndex(index);
  }

  void _loadTimeSlotsForIndex(int index) {
    if (index >= dates.length) return;
    final item = dates[index];
    final rawSlots = item["rawSlots"];

    if (rawSlots is List && rawSlots.isNotEmpty) {
      // Show only first 6 slots in the preview card; all slots in AllSlotsView
      final preview = rawSlots.map((e) => e.toString()).toList();
      timeSlots.assignAll(preview);
    } else {
      timeSlots.clear();
    }
  }

  // ===== FETCH DOCTOR PROFILE FROM API =====
  Future<void> fetchDoctorProfile() async {
    isLoading.value = true;

    // Get doctor id passed from SelectDoctorController via Get.arguments
    final args = Get.arguments;
    final String doctorId = args?['id']?.toString() ?? '';
    final Map<String, String> params = {
      'practitioner': doctorId,
    };
    ApiResponse response = await api.commonApi.counsallerConsultApi
        .getDoctorProfile(queryParams: params);
    isLoading.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      final data = messageData["data"] as Map<String, dynamic>;
      _mapDoctorProfile(data);
    } else {
      showError(messageData["message"] ?? "Failed to fetch doctor profile");
    }
  }

  Future<void> _mapDoctorProfile(Map<String, dynamic> data) async {
    doctorData.value = data;
    doctorName.value = data['name']?.toString() ?? '';
    doctorDegree.value = data['degree']?.toString() ?? '';
    doctorSpecialty.value = data['specialty']?.toString() ?? '';
    doctorExperience.value = data['experience']?.toString() ?? '';
    doctorRating.value = (data['rating'] as num?)?.toDouble() ?? 0.0;
    reviewCount.value = (data['review_count'] as int?) ?? 0;
    doctorImage.value = data['image']?.toString() ?? '';
    fees.value = (data['fees'] as int?) ?? 0;
    reviewStatus.value = (data['review_status'] as int?) ?? 0;
    clinicName.value = data['clinic_name']?.toString() ?? '';
    waitTime.value = (data['wait_time'] as int?) ?? 0;
    latitude.value = (data['latitude'] as num?)?.toDouble() ?? 0.0;
    longitude.value = (data['longitude'] as num?)?.toDouble() ?? 0.0;

    // Address
    final addr = data['address'] as Map<String, dynamic>?;
    if (addr != null) {
      final parts = [
        addr['address_line1']?.toString() ?? '',
        addr['address_line2']?.toString() ?? '',
        addr['city']?.toString() ?? '',
      ].where((s) => s.isNotEmpty).toList();
      address.value = parts.join(', ');
    }
    final authStorage = AuthStorageService();
    final datas = await authStorage.getUserDetail();
    final String fullName = datas?['full_name']?.toString() ?? '';

    // Reviews
    final rawReviews = data['reviews'] as List<dynamic>? ?? [];
    reviews.assignAll(rawReviews
        .map((r) => {
              'reviewer_name': fullName == r['reviewer_name']?.toString()
                  ? "You"
                  : r['reviewer_name']?.toString() ?? '',
              'initials': r['initials']?.toString() ?? '',
              'rating': (r['rating'] as num?)?.toDouble() ?? 0.0,
              'review_text': r['review_text']?.toString() ?? '',
              'relative_date': r['relative_date']?.toString() ?? '',
            })
        .toList());

    // Services & specializations
    services.assignAll(
        (data['services'] as List<dynamic>? ?? []).map((e) => e.toString()));
    specializations.assignAll((data['specializations'] as List<dynamic>? ?? [])
        .map((e) => e.toString()));
    clinicPhotos.assignAll((data['clinic_photos'] as List<dynamic>? ?? [])
        .map((e) => e.toString()));

    // Available slots
    _availableSlots = (data['available_slots'] as List<dynamic>? ?? [])
        .map((e) => e as Map<String, dynamic>)
        .toList();

    // Set current month from first available slot date
    if (_availableSlots.isNotEmpty) {
      final firstDate =
          DateTime.tryParse(_availableSlots[0]['date']?.toString() ?? '');
      if (firstDate != null) {
        _currentMonth = DateTime(firstDate.year, firstDate.month);
      }
    }

    _updateMonthLabel();
    _populateDatesFromSlots();
  }

  @override
  void onInit() {
    super.onInit();
    fetchDoctorProfile();
  }
}
