import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/api/common_api/doctor_availability_api/doctor_availability_api.dart';

class DoctorEditScheduleController extends GetxController {
  final DoctorAvailabilityApi _api = DoctorAvailabilityApi();

  // ===== LOADING =====
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  // ===== DAY INFO =====
  final RxString dayName = ''.obs;
  final RxString scheduleName = ''.obs;
  final RxBool applyToOtherDays = false.obs;
  final RxInt totalSlots = 0.obs;
  final RxInt slotDuration = 30.obs;

  // ===== SESSIONS FROM API =====
  final RxMap<String, List<String>> sessionAllSlots =
      <String, List<String>>{}.obs;
  final RxMap<String, RxSet<String>> sessionSelected =
      <String, RxSet<String>>{}.obs;
  final RxMap<String, Map<String, String>> sessionTimes =
      <String, Map<String, String>>{}.obs;

  // ===== OTHER DAYS =====
  final RxList<String> otherDays = <String>[].obs;

  // ===== SESSION DEFAULTS =====
  final Map<String, Map<String, String>> _sessionDefaults = {
    'Morning': {'from': '09:00 AM', 'to': '12:00 PM'},
    'Afternoon': {'from': '12:00 PM', 'to': '05:00 PM'},
    'Evening': {'from': '05:00 PM', 'to': '08:00 PM'},
  };

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      dayName.value = Get.arguments['day']?.toString() ?? '';
      scheduleName.value = Get.arguments['schedule']?.toString() ?? '';
    }
    fetchDaySlots();
  }

  // ===== FETCH DAY SLOTS =====
  Future<void> fetchDaySlots() async {
    try {
      isLoading.value = true;

      final ApiResponse response = await _api.getDaySlots(
        schedule: scheduleName.value,
        day: dayName.value,
      );

      final message = response.data['message'];

      if (message != null && message['status'] == true) {
        final data = message['data'] as Map<String, dynamic>;

        slotDuration.value = data['slot_duration'] ?? 30;
        totalSlots.value = data['total_slots'] ?? 0;

        // Other days
        final rawOtherDays = data['other_days'] as List? ?? [];
        otherDays.assignAll(rawOtherDays.map((d) => d.toString()).toList());

        // Sessions
        final sessions = data['sessions'] as List? ?? [];
        sessionAllSlots.clear();
        sessionSelected.clear();
        sessionTimes.clear();

        for (final s in sessions) {
          final name = s['name']?.toString() ?? '';
          final slots = s['slots'] as List? ?? [];

          final allSlotStrings = slots
              .map((sl) =>
                  '${sl['from_time']?.toString() ?? ''} - ${sl['to_time']?.toString() ?? ''}')
              .toList();

          sessionAllSlots[name] = allSlotStrings;
          sessionSelected[name] = <String>{...allSlotStrings}.obs;
          sessionTimes[name] = {
            'from': s['from_time']?.toString() ?? '',
            'to': s['to_time']?.toString() ?? '',
          };
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

  // ===== AVAILABLE SESSIONS TO ADD =====
  List<String> get availableSessionsToAdd {
    final existing = sessionAllSlots.keys.toSet();
    return _sessionDefaults.keys.where((s) => !existing.contains(s)).toList();
  }

  // ===== ADD SESSION VIA API =====
  Future<void> addSessionByName(String sessionName) async {
    try {
      isLoading.value = true;

      final times = _sessionDefaults[sessionName];
      if (times == null) {
        showError('Unknown session type');
        return;
      }

      final ApiResponse response = await _api.updateDaySlots(
        schedule: scheduleName.value,
        day: dayName.value,
        action: 'add',
        fromTime: times['from']!,
        toTime: times['to']!,
        slotDuration: slotDuration.value.toString(),
        session: sessionName,
      );

      final message = response.data['message'];

      if (message != null && message['status'] == true) {
        await Future.delayed(const Duration(milliseconds: 500));
        await fetchDaySlots();
        showMessage('$sessionName session added!');
      } else {
        showError(message?['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ===== TOGGLE SLOT =====
  void toggleSlot(String session, String slot) {
    if (sessionSelected[session] == null) return;
    if (sessionSelected[session]!.contains(slot)) {
      sessionSelected[session]!.remove(slot);
    } else {
      sessionSelected[session]!.add(slot);
    }
    sessionSelected.refresh();
  }

  // ===== DELETE SESSION =====
  Future<void> deleteSession(String session) async {
    try {
      isLoading.value = true;

      final times = sessionTimes[session];
      if (times == null) {
        showError('Session times not found');
        return;
      }

      final ApiResponse response = await _api.updateDaySlots(
        schedule: scheduleName.value,
        day: dayName.value,
        action: 'delete',
        fromTime: times['from']!,
        toTime: times['to']!,
        slotDuration: slotDuration.value.toString(),
        session: session,
      );

      final message = response.data['message'];

      if (message != null && message['status'] == true) {
        await Future.delayed(const Duration(milliseconds: 500));
        await fetchDaySlots();
        showMessage('$session session deleted!');
      } else {
        showError(message?['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ===== UPDATE SLOTS =====
  Future<void> updateSlots() async {
    try {
      isSaving.value = true;

      for (final session in sessionAllSlots.keys) {
        final allSlots = sessionAllSlots[session] ?? [];
        final selected = sessionSelected[session] ?? {};

        for (final slot in allSlots) {
          final parts = slot.split(' - ');
          if (parts.length != 2) continue;

          final fromTime = parts[0].trim();
          final toTime = parts[1].trim();
          final isSelected = selected.contains(slot);

          await _api.updateDaySlots(
            schedule: scheduleName.value,
            day: dayName.value,
            action: isSelected ? 'add' : 'delete',
            fromTime: fromTime,
            toTime: toTime,
            slotDuration: slotDuration.value.toString(),
            session: session,
          );
        }
      }

      showMessage('Slots updated successfully!');
      Get.back(result: true);
    } catch (e) {
      showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }
}
