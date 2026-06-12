import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

class PatientDetailsController extends GetxController {
  Api api = Api.instance;

  // ===== PATIENT SELECTION =====
  final RxInt selectedPatientIndex = 0.obs;

  final RxList<Map<String, dynamic>> patients = <Map<String, dynamic>>[].obs;
  final RxBool isPatientLoading = false.obs;
  final RxBool isAddingMember = false.obs;

  // ===== RELATIONS =====
  final List<String> relations = [
    'Father',
    'Mother',
    'Spouse',
    'Siblings',
    'Family',
    'Other',
  ];

  final List<String> genders = ['Male', 'Female', 'Other'];

  // ===== SYMPTOMS =====
  final RxList<String> symptoms = <String>[].obs;
  final RxBool isSymptomsLoading = false.obs;

  // ===== SELECTED SYMPTOMS (main screen) =====
  final RxList<String> selectedSymptoms = <String>[].obs;

  // ===== BOTTOM SHEET FORM FIELDS =====
  final sheetNameController = TextEditingController();
  final sheetAgeController = TextEditingController();
  final sheetPhoneController = TextEditingController();
  final sheetAllergiesController = TextEditingController();
  final RxString sheetSelectedRelation = 'Father'.obs;
  final RxString sheetSelectedGender = 'Male'.obs;
  final RxList<String> sheetSelectedSymptoms = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPatientRelationsApi();
    fetchSymptomsApi();
  }

  // ================= FETCH SYMPTOMS FROM API =================
  Future<void> fetchSymptomsApi() async {
    isSymptomsLoading.value = true;
    ApiResponse response =
        await api.commonApi.authenticationApi.getMedicalSymptoms();
    isSymptomsLoading.value = false;

    final messageData = response.data['message'];
    if (messageData["status"] == true) {
      final List<dynamic> data = messageData["data"] as List<dynamic>;
      symptoms.assignAll(data.map((e) => e['name'].toString()));
    } else {
      showError(messageData["message"] ?? "Failed to fetch symptoms");
    }
  }

  // ===== SYMPTOM TOGGLE (main screen) =====
  void toggleSymptom(String symptom) {
    if (selectedSymptoms.contains(symptom)) {
      selectedSymptoms.remove(symptom);
    } else {
      selectedSymptoms.add(symptom);
    }
  }

  // ===== ADD CUSTOM SYMPTOM (main screen — "Add Other") =====
  void addCustomSymptom(String symptom) {
    if (!symptoms.contains(symptom)) {
      symptoms.add(symptom);
    }
    if (!selectedSymptoms.contains(symptom)) {
      selectedSymptoms.add(symptom);
    }
  }

  void showAddMemberSheet(BuildContext context) {
    resetSheetForm();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PatientFormBottomSheet(controller: this),
    );
  }

  // ================= FETCH PATIENT RELATIONS FROM API =================
  Future<void> fetchPatientRelationsApi({bool resetSelection = true}) async {
    isPatientLoading.value = true;

    ApiResponse response =
        await api.commonApi.doctorConsultApi.getPatientRelations();
    isPatientLoading.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      final List<dynamic> relations =
          messageData["data"]["relations"] as List<dynamic>;

      final fetchedPatients = relations.map(_mapPatient).toList();
      patients.assignAll(fetchedPatients);

      if (resetSelection) {
        final myselfIndex =
            patients.indexWhere((p) => p['relation'] == 'Myself');
        selectedPatientIndex.value = myselfIndex >= 0 ? myselfIndex : 0;
      }
    } else {
      showError(messageData["message"] ?? "Failed to fetch patient relations");
    }
  }

  Map<String, dynamic> _mapPatient(dynamic e) => {
        "patient_id": e['patient_id']?.toString() ?? '',
        "relation": e['relation']?.toString() ?? '',
        "name": e['patient_name']?.toString() ?? '',
        "mobile": e['mobile']?.toString() ?? '',
        "email": e['email']?.toString() ?? '',
        "gender": e['gender']?.toString() ?? '',
      };

  // ===== PATIENT SELECTION =====
  void selectPatient(int index) {
    selectedPatientIndex.value = index;
  }

  // ===== SYMPTOM TOGGLE (bottom sheet) =====
  void toggleSheetSymptom(String symptom) {
    if (sheetSelectedSymptoms.contains(symptom)) {
      sheetSelectedSymptoms.remove(symptom);
    } else {
      sheetSelectedSymptoms.add(symptom);
    }
  }

  // ===== RESET FORM =====
  void resetSheetForm() {
    sheetNameController.clear();
    sheetAgeController.clear();
    sheetPhoneController.clear();
    sheetAllergiesController.clear();
    sheetSelectedRelation.value = 'Father';
    sheetSelectedGender.value = 'Male';
    sheetSelectedSymptoms.clear();
  }

  // ================= ADD MEMBER — POST API =================
  Future<void> addPatientFromSheet() async {
    final name = sheetNameController.text.trim();
    final phone = sheetPhoneController.text.trim();

    if (name.isEmpty) {
      showError("Please enter the patient's name");
      return;
    }
    if (phone.isEmpty || phone.length < 10) {
      showError("Please enter a valid 10-digit mobile number");
      return;
    }

    isAddingMember.value = true;

    final Map<String, dynamic> body = {
      "patient_name": name,
      "gender": sheetSelectedGender.value,
      "mobile": phone,
      "relation": sheetSelectedRelation.value,
      "age": sheetAgeController.text.trim(),
      "allergies": sheetAllergiesController.text.trim(),
      "common_symptoms": sheetSelectedSymptoms.toList(),
    };

    ApiResponse response =
        await api.commonApi.doctorConsultApi.addPatientRelation(body);
    isAddingMember.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      Get.back();
      await fetchPatientRelationsApi(resetSelection: false);
    } else {
      showError(messageData["message"] ?? "Failed to add member");
    }
  }

  void goToNext() {
    if (patients.isEmpty) {
      showError("No patient selected");
      return;
    }
    final selected = patients[selectedPatientIndex.value];
    Get.toNamed('/booking-confirmation', arguments: {
      'date': Get.arguments?['date'] ?? '',
      'slot': Get.arguments?['slot'] ?? '',
      'tabType': Get.arguments?['tabType'] ?? 0,
      'data': Get.arguments?['data'] ?? {},
      'patientName': selected['name'] ?? '',
      'patientId': selected['patient_id'] ?? '',
      'type': Get.arguments?['type'] ?? '',
      'id': Get.arguments?['id'] ?? '',
      'symptoms': selectedSymptoms.toList(), // ← selected symptoms pass
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
class PatientFormBottomSheet extends StatelessWidget {
  final PatientDetailsController controller;
  const PatientFormBottomSheet({super.key, required this.controller});

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
                                    if (val != null) {
                                      controller.sheetSelectedGender.value =
                                          val;
                                    }
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
                  Obx(() {
                    if (controller.isSymptomsLoading.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: CircularProgressIndicator(
                            color: Color(0xFF0D9488),
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    }
                    return Wrap(
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
                    );
                  }),

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
                            child: Obx(() => controller.isAddingMember.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Add Member",
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  )),
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
