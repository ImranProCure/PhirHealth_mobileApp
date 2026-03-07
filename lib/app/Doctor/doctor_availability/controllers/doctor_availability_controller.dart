import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorAvailabilityController extends GetxController {
  final RxString slotDuration = '30 Mins'.obs;
  final List<String> slotOptions = ['15 Mins', '30 Mins', '45 Mins', '60 Mins'];

  // Each day has its own RxBool for enabled state
  final RxBool mon = true.obs;
  final RxBool tue = true.obs;
  final RxBool wed = true.obs;
  final RxBool thu = true.obs;
  final RxBool fri = true.obs;
  final RxBool sat = false.obs;
  final RxBool sun = false.obs;

  List<RxBool> get enabledList => [mon, tue, wed, thu, fri, sat, sun];

  final List<String> dayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final List<String> dayTimes = List.filled(7, '10:00 AM - 08:00 PM');

  final List<List<String>> daySessions = [
    ['Morning', 'Afternoon', 'Evening'],
    ['Morning', 'Afternoon', 'Evening'],
    ['Morning', 'Evening'],
    ['Morning', 'Afternoon', 'Evening'],
    ['Afternoon', 'Evening'],
    [],
    [],
  ];

  void toggleDay(int i, bool val) => enabledList[i].value = val;

  void editDay(int i) {
    Get.toNamed('/doctor-edit-schedule', arguments: {'day': dayNames[i]});
  }

  void saveSchedule() => Get.back();

  void showSlotPicker() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Slot Duration',
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...slotOptions.map((o) => ListTile(
                  title: Text(o,
                      style:
                          const TextStyle(fontFamily: 'Mulish', fontSize: 14)),
                  onTap: () {
                    slotDuration.value = o;
                    Get.back();
                  },
                )),
          ],
        ),
      ),
    );
  }
}
