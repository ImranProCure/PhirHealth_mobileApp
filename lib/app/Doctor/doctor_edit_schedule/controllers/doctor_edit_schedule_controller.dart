import 'package:get/get.dart';

class DoctorEditScheduleController extends GetxController {
  final RxString dayName = 'Monday'.obs;
  final RxBool isDayEnabled = true.obs;
  final RxBool applyToOtherDays = false.obs;

  // Morning selected slots
  final RxSet<String> morningSelected =
      <String>{'10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM', '12:00 PM'}.obs;

  // Afternoon selected slots
  final RxSet<String> afternoonSelected = <String>{
    '01:00 PM',
    '01:30 PM',
    '02:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
    '05:00 PM'
  }.obs;

  final List<String> morningSlots = [
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
  ];

  final List<String> afternoonSlots = [
    '01:00 PM',
    '01:30 PM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
    '06:00 PM',
  ];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['day'] != null) {
      dayName.value = Get.arguments['day'] as String;
    }
  }

  void toggleMorningSlot(String slot) {
    if (morningSelected.contains(slot)) {
      morningSelected.remove(slot);
    } else {
      morningSelected.add(slot);
    }
  }

  void toggleAfternoonSlot(String slot) {
    if (afternoonSelected.contains(slot)) {
      afternoonSelected.remove(slot);
    } else {
      afternoonSelected.add(slot);
    }
  }

  void deleteMorning() => morningSelected.clear();
  void deleteAfternoon() => afternoonSelected.clear();

  void addAfternoonSlot() {}

  void updateSlots() => Get.back();
}
