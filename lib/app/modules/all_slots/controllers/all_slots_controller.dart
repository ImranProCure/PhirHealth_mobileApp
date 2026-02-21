import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class AllSlotsController extends GetxController {
  late int tabType;
  final RxString screenTitle = "".obs;

  // ===== MONTH NAVIGATION =====
  final RxString currentMonthLabel = "Feb, 2026".obs;
  DateTime _currentMonth = DateTime(2026, 2);

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
  final RxString selectedDateLabel = "".obs;

  final List<String> _dayNames = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];
  final List<String> _monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  void _generateDates() {
    final List<Map<String, dynamic>> generated = [];
    final int daysInMonth =
        DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final now = DateTime.now();

    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, i);
      final dayName = _dayNames[date.weekday - 1];
      final slots = date.weekday == DateTime.sunday ? 0 : (i % 6) + 2;
      generated.add({
        "date": i.toString(),
        "day": dayName,
        "slots": slots,
        "fullDate": date,
        "isToday": date.day == now.day &&
            date.month == now.month &&
            date.year == now.year,
      });
    }

    selectedDateIndex.value = 0;
    selectedSlot.value = '';
    dates.assignAll(generated);
    _updateDateLabel(0);
    _generateSlots(generated[0]["slots"] as int);
  }

  void _updateDateLabel(int index) {
    final item = dates[index];
    final DateTime d = item["fullDate"] as DateTime;
    final bool isToday = item["isToday"] as bool;
    final prefix = isToday ? "Today" : _dayNames[d.weekday - 1];
    selectedDateLabel.value = "$prefix, ${d.day} ${_monthNames[d.month - 1]}";
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
    _generateSlots(dates[index]["slots"] as int);
  }

  void _generateSlots(int totalSlots) {
    morningSlots.clear();
    afternoonSlots.clear();
    eveningSlots.clear();
    nightSlots.clear();

    if (totalSlots == 0) return;

    if (tabType == 0) {
      // Clinic Visit
      final morningTimes = ["10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM"];
      final afternoonTimes = ["02:00 PM", "03:00 PM", "03:30 PM", "04:00 PM"];
      final eveningTimes = ["05:00 PM", "05:30 PM", "06:00 PM"];
      final nightTimes = ["07:00 PM", "07:30 PM"];

      int remaining = totalSlots;
      final mCount = remaining >= 3 ? 3 : remaining;
      morningSlots.assignAll(morningTimes.take(mCount).toList());
      remaining -= mCount;

      if (remaining > 0) {
        final aCount = remaining >= 2 ? 2 : remaining;
        afternoonSlots.assignAll(afternoonTimes.take(aCount).toList());
        remaining -= aCount;
      }
      if (remaining > 0) {
        final eCount = remaining >= 2 ? 2 : remaining;
        eveningSlots.assignAll(eveningTimes.take(eCount).toList());
        remaining -= eCount;
      }
      if (remaining > 0) {
        nightSlots.assignAll(nightTimes.take(remaining).toList());
      }
    } else {
      // Video Consult
      final morningTimes = ["08:00 AM", "09:00 AM", "09:30 AM", "10:00 AM"];
      final afternoonTimes = ["12:00 PM", "01:00 PM", "02:00 PM"];
      final eveningTimes = ["05:00 PM", "06:00 PM"];
      final nightTimes = ["07:00 PM", "08:00 PM"];

      int remaining = totalSlots;
      final mCount = remaining >= 2 ? 2 : remaining;
      morningSlots.assignAll(morningTimes.take(mCount).toList());
      remaining -= mCount;

      if (remaining > 0) {
        final aCount = remaining >= 2 ? 2 : remaining;
        afternoonSlots.assignAll(afternoonTimes.take(aCount).toList());
        remaining -= aCount;
      }
      if (remaining > 0) {
        final eCount = remaining >= 1 ? 1 : remaining;
        eveningSlots.assignAll(eveningTimes.take(eCount).toList());
        remaining -= eCount;
      }
      if (remaining > 0) {
        nightSlots.assignAll(nightTimes.take(remaining).toList());
      }
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
    Get.toNamed(Routes.PATIENT_DETAILS, arguments: {
      'tabType': tabType,
      'slot': selectedSlot.value,
      'date': selectedDateLabel.value,
    });
  }

  @override
  void onInit() {
    super.onInit();
    tabType = Get.arguments?['tabType'] ?? 0;
    screenTitle.value =
        tabType == 0 ? "Clinic Visit Slots" : "Video Consult Slots";
    _generateDates();
  }
}
