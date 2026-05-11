import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../service/api/common_api/medicine_api/medicine_api.dart';
import 'package:sample/app/service/notification_service/notification_service.dart';

class SetScheduleController extends GetxController {
  final RxString selectedFrequency = 'Every Day'.obs;
  final RxString selectedDuration = '7 Days'.obs;
  final List<String> frequencies = ['Every Day', 'Specific Days', 'Interval'];
  final List<String> durations = [
    '7 Days',
    '15 Days',
    'Custom'
  ]; // ✅ Continuous → Custom
  final RxBool isLoading = false.obs;

  // ✅ Custom dates
  final Rx<DateTime?> customStartDate = Rx<DateTime?>(null);
  final Rx<DateTime?> customEndDate = Rx<DateTime?>(null);

  // ✅ Add Medicine se aaya data
  late String medicineName;
  late String medicineType;
  late String medicineStrength;
  late String medicineUnit;
  late String medication;
  late String dosageForm;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      medicineName = args['name'] ?? 'Medicine';
      medicineType = args['type'] ?? 'Tablet';
      medicineStrength = args['strength'] ?? '500';
      medicineUnit = args['unit'] ?? 'mg';
      medication = args['medication'] ?? 'Medicine';
      dosageForm = args['dosage_form'] ?? 'Tablet';
    }
  }

  final RxList<Map<String, dynamic>> doses = <Map<String, dynamic>>[
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
  ].obs;

  final RxList<String> selectedOptions =
      <String>['After Breakfast', 'After Lunch', 'After Dinner'].obs;

  void selectFrequency(String f) => selectedFrequency.value = f;

  // ✅ Custom pe date picker open karo
  void selectDuration(String d) {
    selectedDuration.value = d;
    if (d == 'Custom') {
      pickCustomDates();
    }
  }

  void selectOption(int doseIndex, String option) =>
      selectedOptions[doseIndex] = option;

  // ✅ Custom date picker
  Future<void> pickCustomDates() async {
    final DateTime? start = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF0D9488),
          ),
        ),
        child: child!,
      ),
    );
    if (start == null) return;

    final DateTime? end = await showDatePicker(
      context: Get.context!,
      initialDate: start.add(const Duration(days: 1)),
      firstDate: start.add(const Duration(days: 1)),
      lastDate: start.add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF0D9488),
          ),
        ),
        child: child!,
      ),
    );
    if (end == null) return;

    customStartDate.value = start;
    customEndDate.value = end;
  }

  void setDoseCount(int count) {
    final presets = [
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
      {
        'label': 'DOSE 4',
        'period': 'Custom',
        'time': '06:00',
        'ampm': 'PM',
        'options': ['Before Food', 'With Food', 'After Food'],
        'selected': 'With Food',
      },
    ];

    doses.value = presets.sublist(0, count);
    selectedOptions.value = List.generate(
      count,
      (i) => presets[i]['selected'] as String,
    );
  }

  Future<void> pickTime(int index) async {
    final dose = doses[index];

    final timeParts = (dose['time'] as String).split(':');
    int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);
    final bool isAm = dose['ampm'] == 'AM';

    if (!isAm && hour != 12) hour += 12;
    if (isAm && hour == 12) hour = 0;

    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay(hour: hour, minute: minute),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0D9488),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            timePickerTheme: const TimePickerThemeData(
              dialBackgroundColor: Color(0xFFF3F4F6),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      int h = picked.hour;
      final String ampm = h >= 12 ? 'PM' : 'AM';
      if (h > 12) h -= 12;
      if (h == 0) h = 12;

      final String formattedTime =
          '${h.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';

      final updated = Map<String, dynamic>.from(doses[index]);
      updated['time'] = formattedTime;
      updated['ampm'] = ampm;
      doses[index] = updated;
    }
  }

  // ✅ Start date
  String _getStartDate() {
    if (selectedDuration.value == 'Custom' && customStartDate.value != null) {
      return DateFormat('yyyy-MM-dd').format(customStartDate.value!);
    }
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  // ✅ End date
  String _getEndDate() {
    final now = DateTime.now();
    if (selectedDuration.value == '7 Days') {
      return DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 7)));
    } else if (selectedDuration.value == '15 Days') {
      return DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 15)));
    } else if (selectedDuration.value == 'Custom' &&
        customEndDate.value != null) {
      return DateFormat('yyyy-MM-dd').format(customEndDate.value!);
    }
    return DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 365)));
  }

  // ✅ Dosage string — "1-0-1"
  String _buildDosage() {
    final List<String> slots = ['Morning', 'Afternoon', 'Night'];
    return List.generate(3, (i) {
      if (i < doses.length) {
        return doses[i]['period'] == slots[i] ? '1' : '0';
      }
      return '0';
    }).join('-');
  }

  // ✅ Schedule list
  List<Map<String, String>> _buildSchedule() {
    return List.generate(doses.length, (i) {
      final dose = doses[i];
      final timeParts = (dose['time'] as String).split(':');
      int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);
      final String ampm = dose['ampm'] as String;

      if (ampm == 'PM' && hour != 12) hour += 12;
      if (ampm == 'AM' && hour == 12) hour = 0;

      return {
        'slot': dose['period'] as String,
        'time':
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00',
        'meal_instruction': selectedOptions[i],
      };
    });
  }

  Future<void> saveSchedule() async {
    // ✅ Custom date validation
    if (selectedDuration.value == 'Custom' &&
        (customStartDate.value == null || customEndDate.value == null)) {
      Get.snackbar(
        'Error',
        'Please select start and end date',
        backgroundColor: const Color(0xFFFF4444),
        colorText: const Color(0xFFFFFFFF),
      );
      return;
    }

    try {
      isLoading.value = true;

      final api = MedicineApi();
      final response = await api.setSchedule(
        medication: medication,
        dosageForm: dosageForm,
        startDate: _getStartDate(),
        customEndDate: _getEndDate(),
        schedule: _buildSchedule(),
        dosage: _buildDosage(),
      );

      if (response.status) {
        for (int i = 0; i < doses.length; i++) {
          final dose = doses[i];
          final timeParts = (dose['time'] as String).split(':');
          int hour = int.parse(timeParts[0]);
          final int minute = int.parse(timeParts[1]);
          final String ampm = dose['ampm'] as String;

          if (ampm == 'PM' && hour != 12) hour += 12;
          if (ampm == 'AM' && hour == 12) hour = 0;

          await NotificationService.instance.scheduleDailyNotification(
            id: i,
            medicineName: medicineName,
            foodInstruction: selectedOptions[i],
            hour: hour,
            minute: minute,
            type: medicineType,
          );
        }

        Get.toNamed('/medicine-reminder');
      } else {
        Get.snackbar(
          'Error',
          response.message,
          backgroundColor: const Color(0xFFFF4444),
          colorText: const Color(0xFFFFFFFF),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed: $e',
        backgroundColor: const Color(0xFFFF4444),
        colorText: const Color(0xFFFFFFFF),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
