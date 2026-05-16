import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sample/app/patient/deasis_tools/ascvd_controller.dart';

class AscvdFormView extends GetView<AscvdController> {
  const AscvdFormView({super.key});

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
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          '10-Year ASCVD Risk Calculator',
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
                  // Gender
                  // ─────────────────────────────

                  _GenderToggle(
                    controller: controller,
                  ),

                  const SizedBox(height: 24),

                  // ─────────────────────────────
                  // Biometrics
                  // ─────────────────────────────

                  const _SectionHeader(
                    title: 'Biometrics',
                  ),

                  const SizedBox(height: 14),

                  // FULL NAME

                  const _FieldLabel(
                    label: 'Full Name',
                    subtitle:
                        'ASCVD risk screening for adults aged 20–79 years.',
                  ),

                  const SizedBox(height: 8),

                  Obx(
                    () => _PlainTextField(
                      textController: controller.nameController,
                      hint: 'Enter your full name',
                      errorText: controller.nameError.value,
                      onChanged: (_) => controller.clearNameError(),
                      inputType: TextInputType.name,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // AGE

                  const _FieldLabel(
                    label: 'Age',
                    subtitle: 'Must be between 20 and 79 years.',
                  ),

                  const SizedBox(height: 8),

                  Obx(
                    () => _UnitInputField(
                      textController: controller.ageController,
                      hint: 'e.g. 45',
                      unit: 'yrs',
                      rangeHint: '20 – 79',
                      errorText: controller.ageError.value,
                      onChanged: (_) => controller.clearAgeError(),
                      inputType: TextInputType.number,
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // TOTAL CHOLESTEROL

                  const _FieldLabel(
                    label: 'Total Cholesterol',
                  ),

                  const SizedBox(height: 8),

                  Obx(
                    () => _UnitInputField(
                      textController: controller.totalCholesterolController,
                      hint: 'e.g. 4.5',
                      unit: 'mmol/L',
                      rangeHint: 'Ideal: < 5.2',
                      errorText: controller.totalCholesterolError.value,
                      onChanged: (_) => controller.clearTotalCholesterolError(),
                      inputType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      formatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(
                            r'^\d*\.?\d*',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // HDL

                  const _FieldLabel(
                    label: 'HDL Cholesterol',
                  ),

                  const SizedBox(height: 8),

                  Obx(
                    () => _UnitInputField(
                      textController: controller.hdlCholesterolController,
                      hint: 'e.g. 1.3',
                      unit: 'mmol/L',
                      rangeHint: 'Normal: > 1.0',
                      errorText: controller.hdlCholesterolError.value,
                      onChanged: (_) => controller.clearHdlError(),
                      inputType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      formatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(
                            r'^\d*\.?\d*',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // SYSTOLIC BP

                  const _FieldLabel(
                    label: 'Systolic Blood Pressure',
                  ),

                  const SizedBox(height: 8),

                  Obx(
                    () => _UnitInputField(
                      textController: controller.systolicBpController,
                      hint: 'e.g. 120',
                      unit: 'mm Hg',
                      rangeHint: 'Ideal: < 120',
                      errorText: controller.systolicBpError.value,
                      onChanged: (_) => controller.clearSystolicBpError(),
                      inputType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      formatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(
                            r'^\d*\.?\d*',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ─────────────────────────────
                  // History
                  // ─────────────────────────────

                  const _SectionHeader(
                    title: 'History & Lifestyle',
                  ),

                  const SizedBox(height: 14),

                  Obx(
                    () => _ToggleTile(
                      label: 'Diabetes',
                      value: controller.hasDiabetes.value,
                      onChanged: (v) => controller.hasDiabetes.value = v,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Obx(
                    () => _ToggleTile(
                      label: 'Smoker',
                      value: controller.isSmoker.value,
                      onChanged: (v) => controller.isSmoker.value = v,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Obx(
                    () => _ToggleTile(
                      label: 'Treatment for Hypertension',
                      value: controller.hasTreatmentForHypertension.value,
                      onChanged: (v) =>
                          controller.hasTreatmentForHypertension.value = v,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ─────────────────────────────
                  // Race
                  // ─────────────────────────────

                  const _SectionHeader(
                    title: 'Race',
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Risk estimates for races other than White or African American may be less accurate.',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Obx(
                    () => _RaceSelector(
                      options: controller.raceOptions,
                      selected: controller.selectedRace.value,
                      onSelect: controller.selectRace,
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ───────────────────────────────────
          // BUTTON
          // ───────────────────────────────────

          _ContinueButton(
            onTap: controller.onContinueFromForm,
          ),
        ],
      ),
    );
  }
}

// ─── Gender Toggle ────────────────────────────────────────────────────────────

class _GenderToggle extends StatelessWidget {
  final AscvdController controller;
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
                        color:
                            isSelected ? Colors.white : const Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        gender,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF6B7280),
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
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
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

// ─── Plain Text Field (name) ──────────────────────────────────────────────────

class _PlainTextField extends StatelessWidget {
  final TextEditingController textController;
  final String hint;
  final String errorText;
  final ValueChanged<String>? onChanged;
  final TextInputType inputType;

  const _PlainTextField({
    required this.textController,
    required this.hint,
    required this.errorText,
    this.onChanged,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasError ? const Color(0xFFEF4444) : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: textController,
            keyboardType: inputType,
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: InputBorder.none,
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.info_outline,
                  size: 13, color: Color(0xFFEF4444)),
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

// ─── Unit Input Field (cholesterol / BP / age) ────────────────────────────────

class _UnitInputField extends StatelessWidget {
  final TextEditingController textController;
  final String hint;
  final String unit;
  final String rangeHint;
  final String errorText;
  final ValueChanged<String>? onChanged;
  final TextInputType inputType;
  final List<TextInputFormatter> formatters;

  const _UnitInputField({
    required this.textController,
    required this.hint,
    required this.unit,
    required this.rangeHint,
    required this.errorText,
    this.onChanged,
    this.inputType = TextInputType.number,
    this.formatters = const [],
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasError ? const Color(0xFFEF4444) : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              // Range hint + unit chip
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      rangeHint,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 10,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          unit,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.swap_horiz,
                            size: 16, color: Color(0xFF9CA3AF)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.info_outline,
                  size: 13, color: Color(0xFFEF4444)),
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

// ─── Toggle Tile ──────────────────────────────────────────────────────────────

class _ToggleTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleTile(
      {required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.medical_services_outlined,
                size: 20, color: Color(0xFF0284C7)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF0D9488),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFD1D5DB),
          ),
        ],
      ),
    );
  }
}

// ─── Race Selector ────────────────────────────────────────────────────────────

class _RaceSelector extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;
  const _RaceSelector(
      {required this.options, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: options.map((opt) {
        final isSelected = opt == selected;
        return GestureDetector(
          onTap: () => onSelect(opt),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0D9488)
                        : const Color(0xFFD1D5DB),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Center(
                        child: Icon(Icons.check,
                            size: 13, color: Color(0xFF0D9488)),
                      )
                    : null,
              ),
              const SizedBox(width: 6),
              Text(
                opt,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF0D9488)
                      : const Color(0xFF374151),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─── Continue Button ──────────────────────────────────────────────────────────

class _ContinueButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ContinueButton({required this.onTap});

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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
