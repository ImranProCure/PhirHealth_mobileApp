import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'mdrd_gfr_controller.dart';

class MdrdGfrFormView extends GetView<MdrdGfrController> {
  const MdrdGfrFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),

      // ─────────────────────────────────────────────
      // APP BAR
      // ─────────────────────────────────────────────

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
          'MDRD GFR Equation calculator',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),

      // ─────────────────────────────────────────────
      // BODY
      // ─────────────────────────────────────────────

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── About You ─────────────────────────────────
                  const _SectionHeader(title: 'About you'),
                  const SizedBox(height: 14),

                  // Gender Toggle
                  _GenderToggle(controller: controller),
                  const SizedBox(height: 24),

                  // ── Age ───────────────────────────────────────
                  const _FieldLabel(label: 'Age'),
                  const SizedBox(height: 8),
                  Obx(
                    () => _UnitInputField(
                      textController: controller.ageController,
                      hint: 'Norm: 20-79',
                      unit: 'yrs',
                      rangeHint: '18 – 110',
                      errorText: controller.ageError.value,
                      onChanged: (_) => controller.clearAgeError(),
                      inputType: TextInputType.number,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Creatinine ────────────────────────────────
                  const _FieldLabel(label: 'Creatinine'),
                  const SizedBox(height: 8),
                  Obx(
                    () => _UnitInputField(
                      textController: controller.creatinineController,
                      hint: 'Norm: 62 - 115',
                      unit: 'µmol/L',
                      rangeHint: '10 – 2000',
                      errorText: controller.creatinineError.value,
                      onChanged: (_) => controller.clearCreatinineError(),
                      inputType: const TextInputType.numberWithOptions(
                          decimal: true),
                      formatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*')),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Race ──────────────────────────────────────
                  const _SectionHeader(title: 'Race'),
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

          // ── Calculate Button ─────────────────────────────────
          _CalculateButton(onTap: controller.onCalculate),
        ],
      ),
    );
  }
}

// ─── Gender Toggle ────────────────────────────────────────────────────────────

class _GenderToggle extends StatelessWidget {
  final MdrdGfrController controller;
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
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF6B7280),
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

// ─── Unit Input Field ─────────────────────────────────────────────────────────

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
