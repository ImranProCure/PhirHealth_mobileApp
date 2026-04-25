import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoachStep4Controller extends GetxController {
  // Work Preferences
  final RxBool teleconsultation = true.obs;
  final RxBool multidisciplinary = true.obs;

  // Languages (reuse from step1 pattern)
  final List<String> defaultLanguages = [
    'English',
    'Hindi',
    'Spanish',
    'French'
  ];
  final RxList<String> allLanguages =
      <String>['English', 'Hindi', 'Spanish', 'French'].obs;
  final RxSet<String> selectedLanguages = <String>{'English', 'Hindi'}.obs;

  // Primary Communication Mode
  final RxString selectedCommMode = 'Video Call'.obs;
  final List<String> commModeOptions = [
    'Video Call',
    'Audio Call',
    'Chat',
    'In Person',
  ];

  // Availability — days (index based)
  final List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  // Default: Mon-Fri selected (teal), Sat-Sun not selected
  final RxSet<int> selectedDays = <int>{0, 1, 2, 3, 4}.obs;

  final RxString fromTime = '09:00 AM'.obs;
  final RxString toTime = '05:00 PM'.obs;

  // Per Session Fee
  final feeController = TextEditingController();

  void toggleDay(int index) {
    if (selectedDays.contains(index)) {
      selectedDays.remove(index);
    } else {
      selectedDays.add(index);
    }
  }

  void toggleLanguage(String lang) {
    if (selectedLanguages.contains(lang)) {
      selectedLanguages.remove(lang);
    } else {
      selectedLanguages.add(lang);
    }
  }

  void addLanguage(String lang) {
    final trimmed = lang.trim();
    if (trimmed.isNotEmpty && !allLanguages.contains(trimmed)) {
      allLanguages.add(trimmed);
      selectedLanguages.add(trimmed);
    }
  }

  void showAddLanguageDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Language',
            style:
                TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.w700)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. German'),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              addLanguage(ctrl.text);
              Get.back();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void showCommModeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            const Text('Primary Communication Mode',
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...commModeOptions.map((opt) => ListTile(
                  title: Text(opt,
                      style:
                          const TextStyle(fontFamily: 'Mulish', fontSize: 14)),
                  onTap: () {
                    selectedCommMode.value = opt;
                    Get.back();
                  },
                )),
          ],
        ),
      ),
    );
  }

  void goToNext() => Get.toNamed('/coach-step5');

  @override
  void onClose() {
    feeController.dispose();
    super.onClose();
  }
}
