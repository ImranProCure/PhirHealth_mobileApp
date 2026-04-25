import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PatientDetailsController extends GetxController {
  // ===== PATIENT SELECTION =====
  final RxInt selectedPatientIndex = 0.obs; // default: Myself (index 0)

  final RxList<Map<String, dynamic>> patients = <Map<String, dynamic>>[
    {"relation": "Myself", "name": "Rahul"},
    {"relation": "Father", "name": "Rakesh"},
  ].obs;

  void selectPatient(int index) {
    selectedPatientIndex.value = index;
  }

  // ===== RELATIONS =====
  final List<String> relations = [
    'Father', 'Mother', 'Son', 'Daughter',
    'Wife', 'Husband', 'Brother', 'Sister',
    'Grandfather', 'Grandmother', 'Other',
  ];

  final List<String> genders = ['Male', 'Female', 'Other'];

  final List<String> symptoms = [
    'Fever', 'Stomach Pain', 'Loose Motion', 'Cold/Cough', 'Headache',
  ];

  // ===== BOTTOM SHEET FORM FIELDS =====
  final sheetNameController = TextEditingController();
  final sheetAgeController = TextEditingController();
  final sheetPhoneController = TextEditingController();
  final sheetAllergiesController = TextEditingController();
  final RxString sheetSelectedRelation = 'Father'.obs;
  final RxString sheetSelectedGender = 'Male'.obs;
  final RxList<String> sheetSelectedSymptoms = <String>[].obs;

  void toggleSheetSymptom(String symptom) {
    if (sheetSelectedSymptoms.contains(symptom)) {
      sheetSelectedSymptoms.remove(symptom);
    } else {
      sheetSelectedSymptoms.add(symptom);
    }
  }

  void resetSheetForm() {
    sheetNameController.clear();
    sheetAgeController.clear();
    sheetPhoneController.clear();
    sheetAllergiesController.clear();
    sheetSelectedRelation.value = 'Father';
    sheetSelectedGender.value = 'Male';
    sheetSelectedSymptoms.clear();
  }

  void addPatientFromSheet() {
    final name = sheetNameController.text.trim();
    if (name.isNotEmpty) {
      patients.add({
        "relation": sheetSelectedRelation.value,
        "name": name,
        "age": sheetAgeController.text.trim(),
        "gender": sheetSelectedGender.value,
        "phone": sheetPhoneController.text.trim(),
        "symptoms": List<String>.from(sheetSelectedSymptoms),
        "allergies": sheetAllergiesController.text.trim(),
      });
      selectedPatientIndex.value = patients.length - 1;
      Get.back();
    }
  }

  void showAddMemberSheet(BuildContext context) {
    resetSheetForm();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PatientFormBottomSheet(controller: this),
    );
  }

  // ===== NEXT STEP =====
  void goToNext() {
    Get.toNamed('/booking-confirmation', arguments: {
      'date': Get.arguments?['date'] ?? '',
      'slot': Get.arguments?['slot'] ?? '',
      'tabType': Get.arguments?['tabType'] ?? 0,
      'data': Get.arguments?['data'] ?? 0,
      'patientName': patients[selectedPatientIndex.value]['name'] ?? '',
    });
  }

  @override
  void onClose() {
    sheetNameController.dispose();
    sheetAgeController.dispose();
    sheetPhoneController.dispose();
    sheetAllergiesController.dispose();
    super.onClose();
  }
}

// ===================================================
// BOTTOM SHEET — Full Patient Info Form
// ===================================================
class _PatientFormBottomSheet extends StatelessWidget {
  final PatientDetailsController controller;
  const _PatientFormBottomSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.08,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ---- Fixed Header ----
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.person_add_outlined,
                          size: 18, color: Color(0xFF0D9488)),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add New Member",
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Fill in the patient details",
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.close,
                            size: 16, color: Color(0xFF6B7280)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(color: Colors.grey.shade100, height: 1),
              ],
            ),
          ),

          // ---- Scrollable Body ----
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 20 + bottomPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Relation
                  _label("Relation"),
                  const SizedBox(height: 10),
                  Obx(() => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.relations.map((rel) {
                          final isSel =
                              controller.sheetSelectedRelation.value == rel;
                          return GestureDetector(
                            onTap: () =>
                                controller.sheetSelectedRelation.value = rel,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: isSel
                                    ? const Color(0xFF0D9488)
                                    : const Color(0xFFF9FAFB),
                                border: Border.all(
                                  color: isSel
                                      ? const Color(0xFF0D9488)
                                      : const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: Text(
                                rel,
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSel
                                      ? Colors.white
                                      : const Color(0xFF374151),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )),

                  const SizedBox(height: 18),

                  // Full Name
                  _label("Full Name"),
                  const SizedBox(height: 8),
                  _field(
                    ctrl: controller.sheetNameController,
                    hint: "Enter full name",
                  ),

                  const SizedBox(height: 14),

                  // Age + Gender
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label("Age"),
                            const SizedBox(height: 8),
                            _field(
                              ctrl: controller.sheetAgeController,
                              hint: "28",
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              suffixText: "Yrs",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label("Gender"),
                            const SizedBox(height: 8),
                            Obx(() => DropdownButtonFormField<String>(
                                  value: controller.sheetSelectedGender.value,
                                  style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF9FAFB),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 14),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Color(0xFFE5E7EB)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Color(0xFFE5E7EB)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF0D9488), width: 1.5),
                                    ),
                                  ),
                                  items: controller.genders
                                      .map((g) => DropdownMenuItem(
                                            value: g,
                                            child: Text(g,
                                                style: const TextStyle(
                                                    fontFamily: 'Mulish',
                                                    fontSize: 13)),
                                          ))
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null)
                                      controller.sheetSelectedGender.value =
                                          val;
                                  },
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Mobile
                  _label("Mobile Number"),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: const Row(
                          children: [
                            Text("🇮🇳", style: TextStyle(fontSize: 16)),
                            SizedBox(width: 6),
                            Text(
                              "+91",
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _field(
                          ctrl: controller.sheetPhoneController,
                          hint: "9876543210",
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Symptoms
                  _label("Common Symptoms"),
                  const SizedBox(height: 10),
                  Obx(() => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.symptoms.map((s) {
                          final isSel =
                              controller.sheetSelectedSymptoms.contains(s);
                          return GestureDetector(
                            onTap: () => controller.toggleSheetSymptom(s),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: isSel
                                    ? const Color(0xFF0D9488).withOpacity(0.08)
                                    : const Color(0xFFF9FAFB),
                                border: Border.all(
                                  color: isSel
                                      ? const Color(0xFF0D9488)
                                      : const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSel
                                          ? const Color(0xFF0D9488)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isSel
                                            ? const Color(0xFF0D9488)
                                            : const Color(0xFFD1D5DB),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: isSel
                                        ? const Icon(Icons.check,
                                            size: 10, color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    s,
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isSel
                                          ? const Color(0xFF0D9488)
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      )),

                  const SizedBox(height: 20),

                  // Allergies
                  _label("Allergies / Medical History"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.sheetAllergiesController,
                    maxLines: 3,
                    style: const TextStyle(fontFamily: 'Mulish', fontSize: 13),
                    decoration: InputDecoration(
                      hintText: "List any past procedures or allergies...",
                      hintStyle: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 13,
                        color: Color(0xFF9CA3AF),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      contentPadding: const EdgeInsets.all(14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF0D9488), width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF0D9488)),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0D9488),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: controller.addPatientFromSheet,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Add Member",
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          fontFamily: 'Mulish',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF374151),
        ),
      );

  Widget _field({
    required TextEditingController ctrl,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? suffixText,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            fontFamily: 'Mulish', fontSize: 14, color: Color(0xFF9CA3AF)),
        suffixText: suffixText,
        suffixStyle: const TextStyle(
            fontFamily: 'Mulish', fontSize: 14, color: Color(0xFF6B7280)),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
        ),
      ),
    );
  }
}