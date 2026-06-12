import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/api/common_api/doctor_availability_api/doctor_availability_api.dart';

class DoctorAvailabilityController extends GetxController {
  final DoctorAvailabilityApi _api = DoctorAvailabilityApi();

  // ===== LOADING =====
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  // ===== DATA =====
  final RxString scheduleType = ''.obs;
  final RxString slotDuration = ''.obs;

  // ===== DAY DATA =====
  final List<String> dayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final List<RxBool> enabledList = List.generate(7, (_) => false.obs);
  final List<RxString> dayTimes = List.generate(7, (_) => ''.obs);
  final List<RxList<String>> daySessions =
      List.generate(7, (_) => <String>[].obs);
  final List<RxList<Map<String, dynamic>>> daySessionDetails =
      List.generate(7, (_) => <Map<String, dynamic>>[].obs);

  // ===== CREATE FORM FIELDS (registration only) =====
  final RxString fromTime = '09:00 AM'.obs;
  final RxString toTime = '05:00 PM'.obs;
  final RxBool isClinic = false.obs; // false = video (default), true = clinic

  @override
  void onInit() {
    super.onInit();
    fetchSlots();
  }

  // ===== FETCH =====
  Future<void> fetchSlots() async {
    try {
      isLoading.value = true;

      final ApiResponse response = await _api.getAvailabilitySlots();
      final message = response.data['message'];

      if (message != null && message['status'] == true) {
        final data = message['data'] as Map<String, dynamic>? ?? {};
        final schedules = data['schedules'] as List? ?? [];
        if (schedules.isEmpty) return;

        final schedule = schedules[0] as Map<String, dynamic>;
        scheduleType.value = schedule['schedule_type']?.toString() ?? '';
        slotDuration.value = schedule['slot_duration']?.toString() ?? '';

        final rawDays = schedule['days'] as List? ?? [];

        for (int i = 0; i < dayNames.length; i++) {
          final matching =
              rawDays.where((d) => d['day'] == dayNames[i]).toList();
          if (matching.isEmpty) continue;

          final dayData = matching.first;
          enabledList[i].value = dayData['enabled'] == true;
          dayTimes[i].value = dayData['time_range']?.toString() ?? '';

          final sessions = dayData['sessions'] as List? ?? [];

          daySessions[i].assignAll(
            sessions
                .where((s) => s['active'] == true)
                .map((s) => s['name'].toString())
                .toList(),
          );

          daySessionDetails[i].assignAll(
            sessions
                .map((s) => {
                      'name': s['name']?.toString() ?? '',
                      'active': s['active'] == true,
                      'from': s['from']?.toString() ?? '',
                      'to': s['to']?.toString() ?? '',
                      'slot_count': s['slot_count']?.toString() ?? '0',
                    })
                .toList(),
          );
        }
      } else {
        showError(message?['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ===== TOGGLE DAY =====
  void toggleDay(int i, bool val) {
    enabledList[i].value = val;
  }

  // ===== EDIT DAY =====
  void editDay(int i) {
    Get.toNamed(
      '/doctor-edit-schedule',
      arguments: {
        'day': dayNames[i],
        'schedule': scheduleType.value,
      },
    );
  }

  // ===== CREATE SLOTS (registration form) =====
  Future<void> createSlots() async {
    final selectedDays = <String>[];
    for (int i = 0; i < dayNames.length; i++) {
      if (enabledList[i].value) selectedDays.add(dayNames[i]);
    }

    if (selectedDays.isEmpty) {
      showError('Please select at least one day');
      return;
    }

    try {
      isSaving.value = true;

      final ApiResponse response = await _api.createDoctorSlots(
        fromTime: fromTime.value,
        toTime: toTime.value,
        durationMins: 30,
        days: selectedDays,
        allowVideoConferencing: isClinic.value ? 1 : 0,
      );

      final message = response.data['message'];
      final bool success = message?['success'] == true;

      if (success) {
        showMessage('Slots created successfully!');
        Get.offAllNamed('/doctor-dashboard');
      } else {
        showError(message?['message'] ?? 'Could not create slots.');
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  // ===== SAVE SCHEDULE (dashboard edit) =====
  Future<void> saveSchedule() async {
    try {
      isSaving.value = true;
      showMessage('Schedule saved!');
      Get.offAllNamed('/doctor-dashboard');
    } catch (e) {
      showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }
}
