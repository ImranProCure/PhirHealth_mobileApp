import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../service/api/common_api/medicine_api/medicine_api.dart';
import 'package:sample/app/service/notification_service/notification_service.dart';

class DoseData {
  final String label;
  final String period;
  String time;
  String ampm;
  final List<String> options;
  String selectedOption;

  DoseData({
    required this.label,
    required this.period,
    required this.time,
    required this.ampm,
    required this.options,
    required this.selectedOption,
  });

  DoseData copyWith({String? time, String? ampm, String? selectedOption}) {
    return DoseData(
      label: label,
      period: period,
      time: time ?? this.time,
      ampm: ampm ?? this.ampm,
      options: options,
      selectedOption: selectedOption ?? this.selectedOption,
    );
  }
}

class SetScheduleController extends GetxController {
  final RxString selectedFrequency = 'Every Day'.obs;
  final RxString selectedDuration = '7 Days'.obs;
  final List<String> frequencies = ['Every Day', 'Specific Days', 'Interval'];
  final List<String> durations = ['7 Days', '15 Days', 'Custom'];
  final RxBool isLoading = false.obs;

  final Rx<DateTime?> customStartDate = Rx<DateTime?>(null);
  final Rx<DateTime?> customEndDate = Rx<DateTime?>(null);

  late String medicineName;
  late String medicineType;
  late String medicineStrength;
  late String medicineUnit;
  late String medication;
  late String dosageForm;

  // CHANGE: Single list of DoseData — no more sync issues
  final RxList<DoseData> doseList = <DoseData>[].obs;

  // All 4 presets
  static final List<DoseData> _allPresets = [
    DoseData(
      label: 'DOSE 1',
      period: 'Morning',
      time: '08:00',
      ampm: 'AM',
      options: ['Before Food', 'After Breakfast'],
      selectedOption: 'After Breakfast',
    ),
    DoseData(
      label: 'DOSE 2',
      period: 'Afternoon',
      time: '01:00',
      ampm: 'PM',
      options: ['After Lunch', 'With Food'],
      selectedOption: 'After Lunch',
    ),
    DoseData(
      label: 'DOSE 3',
      period: 'Night',
      time: '09:00',
      ampm: 'PM',
      options: ['Before Bed', 'After Dinner'],
      selectedOption: 'After Dinner',
    ),
    DoseData(
      label: 'DOSE 4',
      period: 'Evening',
      time: '06:00',
      ampm: 'PM',
      options: ['Before Food', 'With Food', 'After Food'],
      selectedOption: 'With Food',
    ),
  ];

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
    // Default 3 doses
    setDoseCount(3);
  }

  // CHANGE: Single atomic update — no race condition possible
  void setDoseCount(int count) {
    final limited = count.clamp(1, _allPresets.length);
    doseList.value = List.generate(
      limited,
      (i) => DoseData(
        label: _allPresets[i].label,
        period: _allPresets[i].period,
        time: _allPresets[i].time,
        ampm: _allPresets[i].ampm,
        options: List.from(_allPresets[i].options),
        selectedOption: _allPresets[i].selectedOption,
      ),
    );
  }

  void selectFrequency(String f) => selectedFrequency.value = f;

  void selectDuration(String d) {
    selectedDuration.value = d;
    if (d == 'Custom') pickCustomDates();
  }

  // CHANGE: Direct update on single object — no index mismatch
  void selectOption(int index, String option) {
    if (index < 0 || index >= doseList.length) return;
    final updated = doseList[index].copyWith(selectedOption: option);
    doseList[index] = updated;
    doseList.refresh();
  }

  Future<void> pickCustomDates() async {
    final DateTime? start = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF0D9488)),
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
          colorScheme: const ColorScheme.light(primary: Color(0xFF0D9488)),
        ),
        child: child!,
      ),
    );
    if (end == null) return;

    customStartDate.value = start;
    customEndDate.value = end;
  }

  Future<void> pickTime(int index) async {
    if (index < 0 || index >= doseList.length) return;
    final dose = doseList[index];

    final timeParts = dose.time.split(':');
    int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);
    final bool isAm = dose.ampm == 'AM';

    if (!isAm && hour != 12) hour += 12;
    if (isAm && hour == 12) hour = 0;

    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay(hour: hour, minute: minute),
      builder: (context, child) => Theme(
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
      ),
    );

    if (picked != null) {
      int h = picked.hour;
      final String ampm = h >= 12 ? 'PM' : 'AM';
      if (h > 12) h -= 12;
      if (h == 0) h = 12;

      final String formattedTime =
          '${h.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';

      doseList[index] =
          doseList[index].copyWith(time: formattedTime, ampm: ampm);
      doseList.refresh();
    }
  }

  String _getStartDate() {
    if (selectedDuration.value == 'Custom' && customStartDate.value != null) {
      return DateFormat('yyyy-MM-dd').format(customStartDate.value!);
    }
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

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

  String _buildDosage() {
    final slots = ['Morning', 'Afternoon', 'Night'];
    return List.generate(3, (i) {
      if (i < doseList.length) {
        return doseList[i].period == slots[i] ? '1' : '0';
      }
      return '0';
    }).join('-');
  }

  List<Map<String, String>> _buildSchedule() {
    return doseList.map((dose) {
      final timeParts = dose.time.split(':');
      int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);

      if (dose.ampm == 'PM' && hour != 12) hour += 12;
      if (dose.ampm == 'AM' && hour == 12) hour = 0;

      return {
        'slot': dose.period.toLowerCase(),
        'time':
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00',
        'meal_instruction': dose.selectedOption,
      };
    }).toList();
  }

  Future<void> saveSchedule() async {
    if (selectedDuration.value == 'Custom' &&
        (customStartDate.value == null || customEndDate.value == null)) {
      Get.snackbar('Error', 'Please select start and end date',
          backgroundColor: const Color(0xFFFF4444), colorText: Colors.white);
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
        for (int i = 0; i < doseList.length; i++) {
          final dose = doseList[i];
          final timeParts = dose.time.split(':');
          int hour = int.parse(timeParts[0]);
          final int minute = int.parse(timeParts[1]);

          if (dose.ampm == 'PM' && hour != 12) hour += 12;
          if (dose.ampm == 'AM' && hour == 12) hour = 0;

          await NotificationService.instance.scheduleDailyNotification(
            id: i,
            medicineName: medicineName,
            foodInstruction: dose.selectedOption,
            hour: hour,
            minute: minute,
            type: medicineType,
          );
        }
        Get.toNamed('/medicine-reminder');
      } else {
        Get.snackbar('Error', response.message,
            backgroundColor: const Color(0xFFFF4444), colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed: $e',
          backgroundColor: const Color(0xFFFF4444), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
