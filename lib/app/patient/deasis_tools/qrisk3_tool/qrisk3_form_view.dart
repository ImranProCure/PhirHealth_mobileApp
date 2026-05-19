import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sample/app/patient/deasis_tools/qrisk3_tool/qrisk3_controller.dart';

class Qrisk3FormView extends GetView<Qrisk3Controller> {
  const Qrisk3FormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),

      // ───────────────────────────────────────────────────────────
      // APP BAR
      // ───────────────────────────────────────────────────────────

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: const Text(
          'ASCVD Risk Estimator',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),

      // ───────────────────────────────────────────────────────────
      // BODY
      // ───────────────────────────────────────────────────────────

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─────────────────────────────
                  // About You
                  // ─────────────────────────────

                  const _SectionHeader(title: 'About you'),
                  const SizedBox(height: 14),

                  // GENDER TOGGLE
                  _GenderToggle(controller: controller),
                  const SizedBox(height: 16),

                  // AGE
                  const _FieldLabel(label: 'Age (25-84):'),
                  const SizedBox(height: 8),
                  Obx(
                    () => _PlainInputField(
                      textController: controller.ageController,
                      hint: 'Enter your age',
                      errorText: controller.ageError.value,
                      onChanged: (_) => controller.clearAgeError(),
                      inputType: TextInputType.number,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ETHNICITY
                  const _FieldLabel(label: 'Ethnicity:'),
                  const SizedBox(height: 8),
                  Obx(
                    () => _DropdownField(
                      value: controller.selectedEthnicity.value,
                      items: controller.ethnicityOptions,
                      onChanged: controller.selectEthnicity,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // UK POSTCODE
                  const _FieldLabel(
                    label: 'UK postcode: leave blank if unknown',
                    subtitle: 'Postcode',
                  ),
                  const SizedBox(height: 8),
                  _PlainInputField(
                    textController: controller.postcodeController,
                    hint: 'Postcode',
                    errorText: '',
                    inputType: TextInputType.text,
                  ),
                  const SizedBox(height: 28),

                  // ─────────────────────────────
                  // Clinical Information
                  // ─────────────────────────────

                  const _SectionHeader(title: 'Clinical information'),
                  const SizedBox(height: 14),

                  // SMOKING STATUS
                  const _FieldLabel(label: 'Smoking status'),
                  const SizedBox(height: 8),
                  Obx(
                    () => _DropdownField(
                      value: controller.selectedSmokingStatus.value,
                      items: controller.smokingOptions,
                      onChanged: controller.selectSmokingStatus,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // DIABETES STATUS
                  const _FieldLabel(label: 'Diabetes status'),
                  const SizedBox(height: 8),
                  Obx(
                    () => _DropdownField(
                      value: controller.selectedDiabetesStatus.value,
                      items: controller.diabetesOptions,
                      onChanged: controller.selectDiabetesStatus,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // CHECKBOXES
                  _CheckboxCard(
                    items: [
                      _CheckboxItem(
                        label: 'Angina or heart attack in a 1st degree\nrelative < 60?',
                        rxValue: controller.hasFamilyHeartHistory,
                      ),
                      _CheckboxItem(
                        label: 'Chronic kidney disease\n(stage 3, 4 or 5)?',
                        rxValue: controller.hasCKD,
                      ),
                      _CheckboxItem(
                        label: 'Atrial fibrillation?',
                        rxValue: controller.hasAtrialFibrillation,
                      ),
                      _CheckboxItem(
                        label: 'On blood pressure treatment?',
                        rxValue: controller.hasTreatmentForHypertension,
                      ),
                      _CheckboxItem(
                        label: 'Do you have migraines?',
                        rxValue: controller.hasMigraines,
                      ),
                      _CheckboxItem(
                        label: 'Rheumatoid arthritis?',
                        rxValue: controller.hasRheumatoidArthritis,
                      ),
                      _CheckboxItem(
                        label: 'Systemic lupus erythematosus (SLE)?',
                        rxValue: controller.hasSLE,
                      ),
                      _CheckboxItem(
                        label:
                            'Severe mental illness?\n(this includes schizophrenia, bipolar disorder\nand moderate/severe depression)',
                        rxValue: controller.hasSevereMentalIllness,
                      ),
                      _CheckboxItem(
                        label: 'On atypical antipsychotic medication?',
                        rxValue: controller.hasAntipsychoticMedication,
                      ),
                      _CheckboxItem(
                        label: 'Are you on regular steroid tablets?',
                        rxValue: controller.hasRegularSteroids,
                      ),
                      _CheckboxItem(
                        label:
                            'A diagnosis of or treatment for erectile\ndysfunction?',
                        rxValue: controller.hasErectileDysfunction,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ─────────────────────────────
                  // Leave Blank If Unknown
                  // ─────────────────────────────

                  const _SectionHeader(title: 'Leave blank if unknown'),
                  const SizedBox(height: 14),

                  // CHOLESTEROL/HDL RATIO
                  const _FieldLabel(label: 'Cholesterol/HDL ratio'),
                  const SizedBox(height: 8),
                  Obx(
                    () => _PlainInputField(
                      textController: controller.cholHdlRatioController,
                      hint: 'Enter your name',
                      errorText: controller.cholHdlRatioError.value,
                      onChanged: (_) => controller.clearCholHdlRatioError(),
                      inputType: const TextInputType.numberWithOptions(decimal: true),
                      formatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // SYSTOLIC BP
                  const _FieldLabel(label: 'Systolic blood pressure (mmHg)'),
                  const SizedBox(height: 8),
                  Obx(
                    () => _PlainInputField(
                      textController: controller.systolicBpController,
                      hint: 'Enter your name',
                      errorText: controller.systolicBpError.value,
                      onChanged: (_) => controller.clearSystolicBpError(),
                      inputType: const TextInputType.numberWithOptions(decimal: true),
                      formatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // SYSTOLIC BP STD DEV
                  const _FieldLabel(
                    label:
                        'Standard deviation of at least two most recent systolic\nblood pressure readings (mmHg):',
                  ),
                  const SizedBox(height: 8),
                  _PlainInputField(
                    textController: controller.systolicBpSdController,
                    hint: 'Enter your name',
                    errorText: '',
                    inputType: const TextInputType.numberWithOptions(decimal: true),
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ─────────────────────────────
                  // Body Mass Index
                  // ─────────────────────────────

                  const _SectionHeader(title: 'Body mass index'),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _FieldLabel(label: 'Height (cm):'),
                            const SizedBox(height: 8),
                            _PlainInputField(
                              textController: controller.heightController,
                              hint: 'Enter..',
                              errorText: '',
                              inputType: const TextInputType.numberWithOptions(decimal: true),
                              formatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _FieldLabel(label: 'Weight (kg):'),
                            const SizedBox(height: 8),
                            _PlainInputField(
                              textController: controller.weightController,
                              hint: 'Enter..',
                              errorText: '',
                              inputType: const TextInputType.numberWithOptions(decimal: true),
                              formatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ───────────────────────────────────
          // BUTTON
          // ───────────────────────────────────

          _CalculateButton(onTap: controller.onContinueFromForm),
        ],
      ),
    );
  }
}

// ─── Gender Toggle ────────────────────────────────────────────────────────────

class _GenderToggle extends StatelessWidget {
  final Qrisk3Controller controller;
  const _GenderToggle({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: controller.genderOptions.map((gender) {
            final isSelected = controller.selectedGender.value == gender;
            final isMale = gender == 'Male';
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.selectGender(gender),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.all(isSelected ? 4 : 0),
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFF0D9488), Color(0xFF0E7490)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isMale ? Icons.male : Icons.female,
                        size: 18,
                        color: isSelected ? Colors.white : const Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        gender,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Mulish',
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Colors.black,
      ),
    );
  }
}

// ─── Field Label ──────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  final String? subtitle;
  const _FieldLabel({required this.label, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Mulish',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 12,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Plain Input Field ────────────────────────────────────────────────────────

class _PlainInputField extends StatelessWidget {
  final TextEditingController textController;
  final String hint;
  final String errorText;
  final ValueChanged<String>? onChanged;
  final TextInputType inputType;
  final List<TextInputFormatter> formatters;

  const _PlainInputField({
    required this.textController,
    required this.hint,
    required this.errorText,
    this.onChanged,
    this.inputType = TextInputType.text,
    this.formatters = const [],
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError ? const Color(0xFFEF4444) : const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          child: TextField(
            controller: textController,
            keyboardType: inputType,
            inputFormatters: formatters,
            onChanged: onChanged,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                color: Color(0xFFD1D5DB),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: InputBorder.none,
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.info_outline, size: 13, color: Color(0xFFEF4444)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  errorText,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 11,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// ─── Dropdown Field ───────────────────────────────────────────────────────────

class _DropdownField extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
          style: const TextStyle(
            fontFamily: 'Mulish',
            fontSize: 14,
            color: Colors.black,
          ),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// ─── Checkbox Item Data ───────────────────────────────────────────────────────

class _CheckboxItem {
  final String label;
  final RxBool rxValue;
  _CheckboxItem({required this.label, required this.rxValue});
}

// ─── Checkbox Card ────────────────────────────────────────────────────────────

class _CheckboxCard extends StatelessWidget {
  final List<_CheckboxItem> items;
  const _CheckboxCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;
          return Column(
            children: [
              Obx(
                () => InkWell(
                  onTap: () => item.rxValue.value = !item.rxValue.value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.label,
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              color: Color(0xFF374151),
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 22,
                          height: 22,
                          margin: const EdgeInsets.only(top: 1),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: item.rxValue.value
                                  ? const Color(0xFF0D9488)
                                  : const Color(0xFFD1D5DB),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(4),
                            color: item.rxValue.value
                                ? const Color(0xFF0D9488)
                                : Colors.white,
                          ),
                          child: item.rxValue.value
                              ? const Icon(Icons.check, size: 14, color: Colors.white)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!isLast)
                const Divider(height: 1, color: Color(0xFFE5E7EB), indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─── Calculate Button ─────────────────────────────────────────────────────────

class _CalculateButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CalculateButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
              colors: [Color(0xFF0D9488), Color(0xFF2563EB)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: const Center(
            child: Text(
              'Calculate Risk',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}