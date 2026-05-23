import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/api/common_api/doctor_reschedule_api/doctor_reschedule_api.dart';

class DoctorPatientRescheduleController extends GetxController {
  final DoctorRescheduleApi _api = DoctorRescheduleApi();
  final TextEditingController reasonController = TextEditingController();

  // ===== LOADING =====
  final RxBool isLoading = false.obs;
  final RxBool isSlotsLoading = false.obs;
  final RxBool isSaving = false.obs;

  // ===== ARGS =====
  String appointmentId = '';

  // ===== CURRENT SESSION =====
  final RxString currentDateTime = ''.obs;
  final RxString patientName = ''.obs;
  final RxString sessionType = ''.obs;

  // ===== CALENDAR =====
  final RxString currentMonth = ''.obs;
  final RxInt selectedDay = 0.obs;
  final RxInt currentYear = 0.obs;
  final RxInt currentMonthIndex = 0.obs;

  final List<String> weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  // Calendar grid
  final RxList<int?> calendarDays = <int?>[].obs;

  // ===== SLOTS =====
  final RxString selectedSlot = ''.obs;
  final RxList<String> morningSlots = <String>[].obs;
  final RxList<String> afternoonSlots = <String>[].obs;
  final RxList<String> eveningSlots = <String>[].obs;

  // ===== SELECTED DAY LABEL =====
  String get selectedDayLabel {
    if (selectedDay.value == 0) return '';
    final date =
        DateTime(currentYear.value, currentMonthIndex.value, selectedDay.value);
    return DateFormat('EEEE, MMMM d').format(date);
  }

  // ===== SELECTED DATE STRING =====
  String get selectedDateString {
    if (selectedDay.value == 0) return '';
    final date =
        DateTime(currentYear.value, currentMonthIndex.value, selectedDay.value);
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      appointmentId = Get.arguments['appointment_id']?.toString() ?? '';
    }
    fetchSessionDetails();
    _initCalendar();
  }

  // ===== INIT CALENDAR =====
  void _initCalendar() {
    final now = DateTime.now();
    currentYear.value = now.year;
    currentMonthIndex.value = now.month;
    _buildCalendar();

    // Default select today
    selectedDay.value = now.day;
    fetchAvailableSlots();
  }

  // ===== BUILD CALENDAR GRID =====
  void _buildCalendar() {
    final year = currentYear.value;
    final month = currentMonthIndex.value;

    currentMonth.value = DateFormat('MMMM yyyy').format(DateTime(year, month));

    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;

    // Monday = 0, so adjust weekday (dart: Mon=1, Sun=7)
    int startWeekday = firstDay.weekday - 1; // 0=Mon, 6=Sun

    final List<int?> days = [];

    // Empty cells before month starts
    for (int i = 0; i < startWeekday; i++) {
      days.add(null);
    }

    // Actual days
    for (int d = 1; d <= daysInMonth; d++) {
      days.add(d);
    }

    // Fill remaining cells
    while (days.length % 7 != 0) {
      days.add(null);
    }

    calendarDays.assignAll(days);
  }

  // ===== PREV / NEXT MONTH =====
  void prevMonth() {
    final date = DateTime(currentYear.value, currentMonthIndex.value - 1);
    currentYear.value = date.year;
    currentMonthIndex.value = date.month;
    selectedDay.value = 0;
    selectedSlot.value = '';
    morningSlots.clear();
    afternoonSlots.clear();
    eveningSlots.clear();
    _buildCalendar();
  }

  void nextMonth() {
    final date = DateTime(currentYear.value, currentMonthIndex.value + 1);
    currentYear.value = date.year;
    currentMonthIndex.value = date.month;
    selectedDay.value = 0;
    selectedSlot.value = '';
    morningSlots.clear();
    afternoonSlots.clear();
    eveningSlots.clear();
    _buildCalendar();
  }

  // ===== FETCH SESSION DETAILS =====
  Future<void> fetchSessionDetails() async {
    try {
      isLoading.value = true;

      final ApiResponse response = await _api.getCurrentSessionDetails(
        appointmentId: appointmentId,
      );

      final message = response.data['message'];

      if (message != null && message['status'] == true) {
        final data = message['data'] as Map<String, dynamic>;

        final date = data['appointment_date']?.toString() ?? '';
        final time = data['appointment_time']?.toString() ?? '';
        final duration = data['duration']?.toString() ?? '';

        // Format: "May 23, 2026 | 10:00 AM • 30 min"
        try {
          final parsed = DateFormat('yyyy-MM-dd').parse(date);
          final formatted = DateFormat('MMMM d, yyyy').format(parsed);
          currentDateTime.value = '$formatted | $time • $duration';
        } catch (_) {
          currentDateTime.value = '$date | $time • $duration';
        }

        patientName.value = data['patient']?['patient_name']?.toString() ?? '';
        sessionType.value = data['consultation_type']?.toString() ?? '';
      } else {
        showError(message?['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ===== FETCH AVAILABLE SLOTS =====
  Future<void> fetchAvailableSlots() async {
    if (selectedDay.value == 0) return;

    try {
      isSlotsLoading.value = true;
      selectedSlot.value = '';
      morningSlots.clear();
      afternoonSlots.clear();
      eveningSlots.clear();

      final ApiResponse response = await _api.getAvailableSlots(
        date: selectedDateString,
      );

      final message = response.data['message'];

      if (message != null && message['status'] == true) {
        final slots = message['data']['slots'] as Map<String, dynamic>;

        morningSlots.assignAll(
          (slots['morning'] as List? ?? [])
              .map((s) => s['time'].toString())
              .toList(),
        );
        afternoonSlots.assignAll(
          (slots['afternoon'] as List? ?? [])
              .map((s) => s['time'].toString())
              .toList(),
        );
        eveningSlots.assignAll(
          (slots['evening'] as List? ?? [])
              .map((s) => s['time'].toString())
              .toList(),
        );
      } else {
        showError(message?['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isSlotsLoading.value = false;
    }
  }

  // ===== SELECT DAY =====
  void selectDay(int day) {
    selectedDay.value = day;
    fetchAvailableSlots();
  }

  // ===== SELECT SLOT =====
  void selectSlot(String slot) {
    selectedSlot.value = slot;
  }

  // ===== RESCHEDULE =====
  Future<void> sendRescheduleRequest() async {
    if (selectedDay.value == 0 || selectedSlot.value.isEmpty) {
      showError('Please select a date and time slot');
      return;
    }

    if (reasonController.text.trim().isEmpty) {
      showError('Please provide a reason for rescheduling');
      return;
    }

    try {
      isSaving.value = true;

      final ApiResponse response = await _api.rescheduleAppointment(
        appointmentId: appointmentId,
        newDate: selectedDateString,
        newTime: selectedSlot.value,
        reason: reasonController.text.trim(),
      );

      final message = response.data['message'];

      if (message != null && message['status'] == true) {
        showMessage('Reschedule Request Sent Successfully!');
        Get.back(result: true);
      } else {
        showError(message?['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  // ===== CANCEL =====
  void cancelSession() => Get.back();

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}
