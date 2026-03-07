import 'package:get/get.dart';

class SetScheduleController extends GetxController {
  final RxString selectedFrequency = 'Every Day'.obs;
  final RxString selectedDuration = '7 Days'.obs;

  final List<String> frequencies = ['Every Day', 'Specific Days', 'Interval'];
  final List<String> durations = ['7 Days', '15 Days', 'Continuous'];

  final List<Map<String, dynamic>> doses = [
    {
      'label': 'DOSE 1',
      'period': 'Morning',
      'time': '08:00',
      'ampm': 'AM',
      'options': ['Before Food', 'After Breakfast'],
      'selected': 'After Breakfast',
    },
    {
      'label': 'DOSE 2',
      'period': 'Afternoon',
      'time': '01:00',
      'ampm': 'PM',
      'options': ['After Lunch', 'With Food'],
      'selected': 'After Lunch',
    },
    {
      'label': 'DOSE 3',
      'period': 'Night',
      'time': '09:00',
      'ampm': 'PM',
      'options': ['Before Bed', 'After Dinner'],
      'selected': 'After Dinner',
    },
  ];

  // Track selected food option per dose
  final RxList<String> selectedOptions =
      <String>['After Breakfast', 'After Lunch', 'After Dinner'].obs;

  void selectFrequency(String f) => selectedFrequency.value = f;
  void selectDuration(String d) => selectedDuration.value = d;
  void selectOption(int doseIndex, String option) =>
      selectedOptions[doseIndex] = option;

  void saveSchedule() {
    Get.toNamed('/medicine-reminder');
  }
}
