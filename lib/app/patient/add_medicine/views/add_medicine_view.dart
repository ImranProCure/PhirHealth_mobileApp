import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_medicine_controller.dart';

// ─────────────────────────────────────────────
// Breakpoint helper
// ─────────────────────────────────────────────
bool _isTablet(BuildContext context) =>
    MediaQuery.of(context).size.shortestSide >= 600;

// ═══════════════════════════════════════════════════════════
//  ROOT VIEW
// ═══════════════════════════════════════════════════════════
class AddMedicineView extends GetView<AddMedicineController> {
  const AddMedicineView({super.key});

  @override
  Widget build(BuildContext context) {
    return _isTablet(context)
        ? _TabletAddMedicineView(controller: controller)
        : _PhoneAddMedicineView(controller: controller);
  }
}

// ═══════════════════════════════════════════════════════════
//  PHONE LAYOUT  (original — untouched)
// ═══════════════════════════════════════════════════════════
class _PhoneAddMedicineView extends StatelessWidget {
  final AddMedicineController controller;
  const _PhoneAddMedicineView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: _buildAppBar(fontSize: 16),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('add_medicine_title'.tr),
                  const SizedBox(height: 8),
                  _NameField(controller: controller),
                  const SizedBox(height: 20),
                  _TypeGrid(controller: controller, crossAxisCount: 2),
                  const SizedBox(height: 20),
                  _StrengthUnitRow(controller: controller),
                  const SizedBox(height: 16),
                  // _EmrToggle(controller: controller),
                  // const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: _NextButton(controller: controller),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  TABLET LAYOUT
// ═══════════════════════════════════════════════════════════
class _TabletAddMedicineView extends StatelessWidget {
  final AddMedicineController controller;
  const _TabletAddMedicineView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: _buildAppBar(fontSize: 18),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── LEFT PANEL: Name + Medicine Type ─────────────
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.46,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'add_medicine_badge'.tr,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D9488),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'add_medicine_heading'.tr,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'add_medicine_sub'.tr,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _FieldLabel('add_medicine_name_label'.tr),
                  const SizedBox(height: 8),
                  _NameField(controller: controller),
                  const SizedBox(height: 24),

                  _FieldLabel('add_medicine_type_label'.tr),
                  const SizedBox(height: 12),

                  // Type grid fills remaining space
                  Expanded(
                    child: _TypeGrid(
                      controller: controller,
                      crossAxisCount: 2,
                      childAspectRatio: 1.25,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── RIGHT PANEL: Strength, Unit, EMR, Button ─────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StrengthUnitRow(controller: controller),
                  const SizedBox(height: 20),
                  // _EmrToggle(controller: controller),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: _NextButton(controller: controller),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  SHARED WIDGETS
// ═══════════════════════════════════════════════════════════

AppBar _buildAppBar({required double fontSize}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
      onPressed: () => Get.back(),
    ),
    centerTitle: true,
    title: Text(
      'add_medicine_title'.tr,
      style: TextStyle(
        fontFamily: 'Mulish',
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Mulish',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }
}

// ── Medicine Name Field ───────────────────────────────────
class _NameField extends StatelessWidget {
  final AddMedicineController controller;
  const _NameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller.nameController,
        style: const TextStyle(
            fontFamily: 'Mulish', fontSize: 15, color: Colors.black),
        decoration: InputDecoration(
          prefixIcon:
              const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
          hintText: 'add_medicine_name_hint'.tr,
          hintStyle:
              const TextStyle(fontFamily: 'Mulish', color: Color(0xFF9CA3AF)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

// ── Type Grid ─────────────────────────────────────────────
class _TypeGrid extends StatelessWidget {
  final AddMedicineController controller;
  final int crossAxisCount;
  final double childAspectRatio;

  const _TypeGrid({
    required this.controller,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.3,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: childAspectRatio,
          children: controller.types.map((t) {
            final bool isSelected = controller.selectedType.value == t['label'];
            return GestureDetector(
              onTap: () => controller.selectType(t['label'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0D9488)
                        : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            t['imagePath'] as String,
                            width: 60,
                            height: 60,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.medication,
                                size: 50,
                                color: Color(0xFF0D9488)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            t['label'] as String,
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? const Color(0xFF0D9488)
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF0D9488)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF0D9488)
                                : const Color(0xFFD1D5DB),
                            width: 1.5,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 14)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ));
  }
}

// ── Strength + Unit Row ───────────────────────────────────
class _StrengthUnitRow extends StatelessWidget {
  final AddMedicineController controller;
  const _StrengthUnitRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FieldLabel('add_medicine_strength_label'.tr),
              const SizedBox(height: 8),
              Obx(() => _Dropdown(
                    value: controller.strength.value,
                    items: controller.strengths,
                    onChanged: controller.selectStrength,
                  )),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FieldLabel('add_medicine_unit_label'.tr),
              const SizedBox(height: 8),
              Obx(() => _Dropdown(
                    value: controller.unit.value,
                    items: controller.units,
                    onChanged: controller.selectUnit,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Dropdown ──────────────────────────────────────────────
class _Dropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final Function(String) onChanged;

  const _Dropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
          style: const TextStyle(
            fontFamily: 'Mulish',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

// ── EMR Toggle ────────────────────────────────────────────
// class _EmrToggle extends StatelessWidget {
//   final AddMedicineController controller;
//   const _EmrToggle({required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text(
//                   'Familiar with EMR Systems?',
//                   style: TextStyle(
//                     fontFamily: 'Mulish',
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 SizedBox(height: 2),
//                 Text(
//                   'Alert when 2 pills left',
//                   style: TextStyle(
//                     fontFamily: 'Mulish',
//                     fontSize: 12,
//                     color: Color(0xFF9CA3AF),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Obx(() => Switch(
//                 value: controller.emrAlert.value,
//                 onChanged: controller.toggleEmr,
//                 activeColor: const Color(0xFF0D9488),
//               )),
//         ],
//       ),
//     );
//   }
// }

// ── Next Button ───────────────────────────────────────────
class _NextButton extends StatelessWidget {
  final AddMedicineController controller;
  const _NextButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF00897B), Color(0xFF1565C0)],
          ),
        ),
        child: ElevatedButton(
          onPressed: controller.nextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'next_button'.tr,
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
