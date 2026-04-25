import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoachStep2Controller extends GetxController {
  // Partnership Type / Qualifications
  final qualificationController = TextEditingController();
  final universityController = TextEditingController();
  final RxString selectedField = ''.obs;
  final RxString selectedYear = ''.obs;

  final List<String> fieldOptions = [
    'Psychology',
    'Counseling',
    'Social Work',
    'Medicine',
    'Nursing',
    'Education',
    'Management',
    'Others',
  ];

  final List<String> yearOptions = List.generate(
    50,
    (i) => (DateTime.now().year - i).toString(),
  );

  // Licensing & Certifications
  final certificationController = TextEditingController();
  final registeringAuthorityController = TextEditingController();
  final licenseController = TextEditingController();

  void showFieldSheet(BuildContext context) {
    _showSheet(
      context: context,
      title: 'Field of Study',
      options: fieldOptions,
      onSelect: (v) => selectedField.value = v,
    );
  }

  void showYearSheet(BuildContext context) {
    _showSheet(
      context: context,
      title: 'Year of Graduation',
      options: yearOptions,
      onSelect: (v) => selectedYear.value = v,
    );
  }

  void _showSheet({
    required BuildContext context,
    required String title,
    required List<String> options,
    required ValueChanged<String> onSelect,
  }) {
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
            Text(title,
                style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            SizedBox(
              height: 300,
              child: ListView(
                children: options
                    .map((opt) => ListTile(
                          title: Text(opt,
                              style: const TextStyle(
                                  fontFamily: 'Mulish', fontSize: 14)),
                          onTap: () {
                            onSelect(opt);
                            Get.back();
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goToNext() => Get.toNamed('/coach-step3');

  @override
  void onClose() {
    qualificationController.dispose();
    universityController.dispose();
    certificationController.dispose();
    registeringAuthorityController.dispose();
    licenseController.dispose();
    super.onClose();
  }
}
