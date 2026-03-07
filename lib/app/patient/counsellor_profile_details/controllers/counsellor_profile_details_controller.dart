import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounsellorProfileDetailsController extends GetxController {
  // ===== TAB =====
  final selectedTab = 0.obs;

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void viewAllSlots() {
    Get.toNamed('/all-slots',
        arguments: {'tabType': selectedTab.value, 'type': 1});
  }

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

  final List<String> _dayNames = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];

  void _generateDates() {
    final List<Map<String, dynamic>> generated = [];
    final int daysInMonth =
        DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);

    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, i);
      final dayName = _dayNames[date.weekday - 1];
      final slots = date.weekday == DateTime.sunday ? 0 : (i % 6) + 2;
      generated.add({
        "date": i.toString(),
        "day": dayName,
        "slots": slots,
      });
    }

    selectedDateIndex.value = 0;
    selectedSlot.value = '';
    timeSlots.assignAll(_defaultSlots);
    dates.assignAll(generated);
  }

  // ===== TIME SLOTS =====
  final List<String> _defaultSlots = [
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
  ];

  final RxList<String> timeSlots = <String>[
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
  ].obs;

  final selectedSlot = ''.obs;

  void selectSlot(String time) {
    selectedSlot.value = time;
  }

  void selectDate(int index) {
    selectedDateIndex.value = index;
    selectedSlot.value = '';

    final item = dates[index];
    final int slots = item["slots"] as int;

    if (slots == 0) {
      timeSlots.clear();
    } else {
      final List<String> generated = [];
      const startMinutes = 9 * 60;
      const interval = 30;

      for (int i = 0; i < slots && i < 8; i++) {
        final totalMinutes = startMinutes + (i * interval);
        final hour = totalMinutes ~/ 60;
        final minute = totalMinutes % 60;
        final isPM = hour >= 12;
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        generated.add(
          "${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${isPM ? 'PM' : 'AM'}",
        );
      }
      timeSlots.assignAll(generated);
    }
  }

  // ===== BOOK APPOINTMENT =====
  void bookAppointment() {
    if (selectedSlot.value.isEmpty) {
      Get.snackbar(
        "Select a Slot",
        "Please select a time slot to book appointment",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF3F4F6),
        colorText: Colors.black,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    Get.snackbar(
      "Appointment Booked!",
      "Confirmed for ${dates[selectedDateIndex.value]["date"]} at ${selectedSlot.value}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0D9488),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onInit() {
    super.onInit();
    _generateDates();
  }
}
