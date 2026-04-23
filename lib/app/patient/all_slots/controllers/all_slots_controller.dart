import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class AllSlotsController extends GetxController {
  late int tabType;
  late int type;
  final RxString screenTitle = "".obs;

  // ===== MONTH NAVIGATION =====
  final RxString currentMonthLabel = "".obs;
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
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    currentMonthLabel.value =
        "${months[_currentMonth.month - 1]}, ${_currentMonth.year}";
  }

  // ===== DATES =====
  final selectedDateIndex = 0.obs;
  final RxList<Map<String, dynamic>> dates = <Map<String, dynamic>>[].obs;
  final RxString selectedDateLabel = "".obs;

  final List<String> _dayNames = [
    "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"
  ];
  final List<String> _monthNames = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  // Raw available_slots passed from ProfileDetailsController via arguments
  List<Map<String, dynamic>> _availableSlots = [];

  void _generateDates() {
    // Filter cached slots to the current month being viewed
    final filtered = _availableSlots.where((slot) {
      final dateStr = slot["date"]?.toString() ?? '';
      if (dateStr.isEmpty) return false;
      final parts = dateStr.split('-');
      if (parts.length < 2) return false;
      return int.tryParse(parts[0]) == _currentMonth.year &&
          int.tryParse(parts[1]) == _currentMonth.month;
    }).toList();

    if (filtered.isEmpty) {
      selectedDateIndex.value = 0;
      selectedSlot.value = '';
      dates.clear();
      _clearSessions();
      selectedDateLabel.value = "No available dates";
      return;
    }

    final List<Map<String, dynamic>> generated = filtered.map((slot) {
      final DateTime? fullDate =
          DateTime.tryParse(slot["date"]?.toString() ?? '');
      return {
        "date": slot["day_number"].toString(),
        "day": slot["day"].toString(),
        "slots": (slot["slot_count"] as int?) ?? 0,
        "rawSlots": List<String>.from(slot["slots"] ?? []),
        "fullDate": fullDate,
        "isToday": fullDate != null &&
            fullDate.day == DateTime.now().day &&
            fullDate.month == DateTime.now().month &&
            fullDate.year == DateTime.now().year,
      };
    }).toList();

    selectedDateIndex.value = 0;
    selectedSlot.value = '';
    dates.assignAll(generated);
    _updateDateLabel(0);
    _distributeSlots(List<String>.from(generated[0]["rawSlots"]));
  }

  void _updateDateLabel(int index) {
    final item = dates[index];
    final DateTime? d = item["fullDate"] as DateTime?;
    if (d == null) {
      selectedDateLabel.value = item["date"].toString();
      return;
    }
    final bool isToday = item["isToday"] as bool;
    final prefix = isToday ? "Today" : _dayNames[d.weekday - 1];
    selectedDateLabel.value =
        "$prefix, ${d.day} ${_monthNames[d.month - 1]}";
  }

  // ===== SLOTS BY SESSION =====
  final RxList<String> morningSlots = <String>[].obs;
  final RxList<String> afternoonSlots = <String>[].obs;
  final RxList<String> eveningSlots = <String>[].obs;
  final RxList<String> nightSlots = <String>[].obs;
  final selectedSlot = ''.obs;

  void selectSlot(String time) {
    selectedSlot.value = time;
  }

  void selectDate(int index) {
    selectedDateIndex.value = index;
    selectedSlot.value = '';
    _updateDateLabel(index);
    final rawSlots =
        List<String>.from(dates[index]["rawSlots"] as List? ?? []);
    _distributeSlots(rawSlots);
  }

  void _clearSessions() {
    morningSlots.clear();
    afternoonSlots.clear();
    eveningSlots.clear();
    nightSlots.clear();
  }

  /// Distributes the raw slot strings from the API into morning/afternoon/evening/night
  /// buckets based on the parsed hour of each time string.
  void _distributeSlots(List<String> rawSlots) {
    _clearSessions();

    for (final timeStr in rawSlots) {
      final hour = _parseHour(timeStr);
      if (hour == null) continue;

      if (hour >= 0 && hour < 12) {
        morningSlots.add(timeStr); // 12 AM – 11:59 AM
      } else if (hour >= 12 && hour < 17) {
        afternoonSlots.add(timeStr); // 12 PM – 4:59 PM
      } else if (hour >= 17 && hour < 20) {
        eveningSlots.add(timeStr); // 5 PM – 7:59 PM
      } else {
        nightSlots.add(timeStr); // 8 PM – 11:59 PM
      }
    }
  }

  /// Parses "10:30 AM" / "2:00 PM" → 24-hour integer (0-23), or null on failure.
  int? _parseHour(String timeStr) {
    try {
      final parts = timeStr.trim().split(' ');
      if (parts.length < 2) return null;
      final timeParts = parts[0].split(':');
      if (timeParts.isEmpty) return null;
      int hour = int.parse(timeParts[0]);
      final isPM = parts[1].toUpperCase() == 'PM';
      final isAM = parts[1].toUpperCase() == 'AM';
      if (isPM && hour != 12) hour += 12;
      if (isAM && hour == 12) hour = 0;
      return hour;
    } catch (_) {
      return null;
    }
  }

  // ===== NEXT STEP =====
  void goToPatientDetails() {
    if (selectedSlot.value.isEmpty) {
      Get.snackbar(
        "Select a Slot",
        "Please select a time slot to continue",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF3F4F6),
        colorText: Colors.black,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    if (type == 1) {
      Get.toNamed('/booking-confirmation', arguments: {
        'date': selectedDateLabel.value,
        'slot': selectedSlot.value,
        'tabType': tabType,
        'patientName': 'Rahul Sharma',
      });
    } else {
      Get.toNamed(Routes.PATIENT_DETAILS, arguments: {
        'tabType': tabType,
        'slot': selectedSlot.value,
        'date': selectedDateLabel.value,
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    tabType = Get.arguments?['tabType'] ?? 0;
    type = Get.arguments?['type'] ?? 0;
    screenTitle.value =
        tabType == 0 ? "Clinic Visit Slots" : "Video Consult Slots";

    // Receive pre-fetched available_slots from ProfileDetailsController
    final rawSlots =
        Get.arguments?['availableSlots'] as List<Map<String, dynamic>>?;
    if (rawSlots != null && rawSlots.isNotEmpty) {
      _availableSlots = rawSlots;
      // Set current month from first slot date
      final firstDate =
          DateTime.tryParse(rawSlots[0]['date']?.toString() ?? '');
      if (firstDate != null) {
        _currentMonth = DateTime(firstDate.year, firstDate.month);
      }
    }

    _updateMonthLabel();
    _generateDates();
  }
}