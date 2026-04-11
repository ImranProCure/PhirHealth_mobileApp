import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../controllers/add_family_members_controller.dart';

class AddFamilyMemberView extends GetView<AddFamilyMemberController> {
  const AddFamilyMemberView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text("Add Family Members",
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.share_outlined, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== WHO IS PATIENT =====
                    const Text("Who is the patient?",
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 16),

                    Obx(() => SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...List.generate(
                                  controller.patients.length,
                                  (i) => _patientCard(
                                        relation: controller.patients[i]
                                            ["relation"],
                                        name: controller.patients[i]["name"],
                                        isSelected: controller
                                                .selectedPatientIndex.value ==
                                            i,
                                        onTap: () =>
                                            controller.selectPatient(i),
                                      )),
                              _addMemberCard(),
                            ],
                          ),
                        )),
                    const SizedBox(height: 24),

                    // ===== ADD NEW MEMBER FORM =====
                    const Text("Add new member",
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 16),

                    _fieldLabel("Full Name"),
                    const SizedBox(height: 8),
                    _inputField(
                        ctrl: controller.nameController, hint: "Shalini Verma"),
                    const SizedBox(height: 14),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fieldLabel("Age"),
                              const SizedBox(height: 8),
                              TextField(
                                controller: controller.ageController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                style: const TextStyle(
                                    fontFamily: 'Mulish', fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: "60",
                                  hintStyle: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 14,
                                      color: Color(0xFF9CA3AF)),
                                  suffixText: "Yrs",
                                  suffixStyle: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 14,
                                      color: Color(0xFF6B7280)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 14),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Color(0xFFE5E7EB))),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Color(0xFFE5E7EB))),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF0D9488),
                                          width: 1.5)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fieldLabel("Gender"),
                              const SizedBox(height: 8),
                              Obx(() => DropdownButtonFormField<String>(
                                    value: controller.selectedGender.value,
                                    style: const TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 14,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 14),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: Color(0xFFE5E7EB))),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: Color(0xFFE5E7EB))),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: Color(0xFF0D9488),
                                              width: 1.5)),
                                    ),
                                    items: controller.genders
                                        .map((g) => DropdownMenuItem(
                                              value: g,
                                              child: Text(g,
                                                  style: const TextStyle(
                                                      fontFamily: 'Mulish')),
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null)
                                        controller.selectedGender.value = val;
                                    },
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    _fieldLabel("Mobile Number"),
                    const SizedBox(height: 8),
                    _mobileField(),
                    const SizedBox(height: 24),

                    // ===== COMMON SYMPTOMS =====
                    const Text("Common Symptoms",
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 14),

                    Obx(() => Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: controller.symptoms
                              .map((s) => _symptomChip(s))
                              .toList(),
                        )),
                    const SizedBox(height: 24),

                    // ===== ALLERGIES =====
                    const Text("Allergies",
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller.allergiesController,
                      maxLines: 4,
                      style:
                          const TextStyle(fontFamily: 'Mulish', fontSize: 13),
                      decoration: InputDecoration(
                        hintText:
                            "List any past procedures or hospital stays...",
                        hintStyle: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            color: Color(0xFF9CA3AF)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(14),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFE5E7EB))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFE5E7EB))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFF0D9488), width: 1.5)),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),

          // ===== SAVE DETAILS BUTTON =====
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                ),
              ),
              child: ElevatedButton(
                onPressed: controller.saveDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Save Details",
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _patientCard(
      {required String relation,
      required String name,
      required bool isSelected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 122,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected
                  ? const Color(0xFF0D9488)
                  : const Color(0xFFE5E7EB),
              width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle_outlined,
                size: 38,
                color: isSelected ? const Color(0xFF0D9488) : Colors.black45),
            const SizedBox(height: 8),
            Text(relation,
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color:
                        isSelected ? const Color(0xFF0D9488) : Colors.black)),
            Text(name,
                style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 12,
                    color: Color(0xFF6B7280))),
          ],
        ),
      ),
    );
  }

  Widget _addMemberCard() {
    return GestureDetector(
      onTap: controller.showAddMemberDialog,
      child: Container(
        width: 100,
        height: 122,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: const Color(0xFF0D9488), width: 1.5)),
              child: const Icon(Icons.add, size: 20, color: Color(0xFF0D9488)),
            ),
            const SizedBox(height: 8),
            const Text("Add",
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D9488))),
            const Text("Member",
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 12,
                    color: Color(0xFF0D9488))),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Text(label,
        style: const TextStyle(
            fontFamily: 'Mulish', fontSize: 13, color: Color(0xFF374151)));
  }

  Widget _inputField(
      {required TextEditingController ctrl, required String hint}) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            fontFamily: 'Mulish', fontSize: 14, color: Color(0xFF9CA3AF)),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5)),
      ),
    );
  }

  Widget _mobileField() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB))),
          child: const Row(
            children: [
              Text("🇮🇳", style: TextStyle(fontSize: 16)),
              SizedBox(width: 6),
              Text("+91",
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10)
            ],
            style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: "9876543210",
              hintStyle: const TextStyle(
                  fontFamily: 'Mulish', fontSize: 14, color: Color(0xFF9CA3AF)),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF0D9488), width: 1.5)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _symptomChip(String symptom) {
    final isSelected = controller.selectedSymptoms.contains(symptom);
    return GestureDetector(
      onTap: () => controller.toggleSymptom(symptom),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isSelected
              ? const Color(0xFF0D9488).withOpacity(0.08)
              : Colors.white,
          border: Border.all(
              color: isSelected
                  ? const Color(0xFF0D9488)
                  : const Color(0xFFD1D5DB)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isSelected ? const Color(0xFF0D9488) : Colors.transparent,
                border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0D9488)
                        : const Color(0xFFD1D5DB),
                    width: 1.5),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 7),
            Text(symptom,
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color:
                        isSelected ? const Color(0xFF0D9488) : Colors.black87)),
          ],
        ),
      ),
    );
  }
}
