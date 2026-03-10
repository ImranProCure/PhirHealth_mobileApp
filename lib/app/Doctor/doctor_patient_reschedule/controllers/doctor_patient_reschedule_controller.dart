import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorPatientRescheduleController extends GetxController {
  final TextEditingController reasonController = TextEditingController();

  // Current session info
  final String currentDateTime = 'February 12, 2026 | 10:00 AM • 30 min';
  final String patientName = 'Akansha Tripathi';
  final String sessionType = 'Video Consultation';

  // Calendar
  final RxInt selectedDay = 13.obs;
  final RxString currentMonth = 'February 2026'.obs;

  final List<String> weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  // Calendar grid (Feb 2026 starts on Sunday)
  final List<int?> calendarDays = [
    31,
    30,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    null,
    null,
  ];

  // Dots per day (teal dots shown in figma)
  final Map<int, int> dayDots = {
    2: 3,
    3: 2,
    6: 1,
    8: 1,
    9: 1,
    10: 3,
    13: 2,
    15: 1,
    17: 2,
    20: 1,
    22: 3,
    23: 1,
    29: 3,
    31: 3,
  };

  // Selected day label
  String get selectedDayLabel => 'Wednesday, February 14';

  // Time slots
  final RxString selectedSlot = ''.obs;

  final List<String> morningSlots = [
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 AM'
  ];
  final List<String> afternoonSlots = [
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
    '6:00 PM'
  ];
  final List<String> eveningSlots = ['7:00 PM', '8:00 PM'];

  // Booked slots (greyed out)
  final List<String> bookedSlots = ['6:00 PM'];

  void selectDay(int day) => selectedDay.value = day;
  void selectSlot(String slot) {
    if (!bookedSlots.contains(slot)) selectedSlot.value = slot;
  }

  void sendRescheduleRequest() {
    Get.offNamed('/doctor-patient-reschedule-sent');
  }

  void cancelSession() => Get.back();

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}
