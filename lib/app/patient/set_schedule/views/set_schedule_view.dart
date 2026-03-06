import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/set_schedule_controller.dart';

class SetScheduleView extends GetView<SetScheduleController> {
  const SetScheduleView({super.key});

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
        title: const Text(
          'Set Schedule',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),

                    // ===== FREQUENCY TABS =====
                    _frequencyTabs(),
                    const SizedBox(height: 24),

                    // ===== HOW MANY TIMES =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'How many times a day?',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0D9488),
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF0D9488),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // ===== DURATION PILLS =====
                    _durationRow(),
                    const SizedBox(height: 20),

                    // ===== DOSE CARDS =====
                    ...List.generate(
                      controller.doses.length,
                      (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _doseCard(i),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===== SAVE BUTTON =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: controller.saveSchedule,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Save Schedule',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward,
                            color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== FREQUENCY TABS =====
  Widget _frequencyTabs() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(5),
          child: Row(
            children: controller.frequencies.map((f) {
              final bool isSelected = controller.selectedFrequency.value == f;
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.selectFrequency(f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: isSelected
                        ? BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          )
                        : BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                    child: Text(
                      f,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color:
                            isSelected ? Colors.white : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }

  // ===== DURATION ROW =====
  Widget _durationRow() {
    return Obx(() => Row(
          children: controller.durations.map((d) {
            final bool isSelected = controller.selectedDuration.value == d;
            final double pillWidth = d == 'Continuous' ? 115 : 95;
            return GestureDetector(
              onTap: () => controller.selectDuration(d),
              child: Container(
                width: pillWidth,
                height: 34,
                margin: const EdgeInsets.only(right: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(70),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 18,
                      height: 18,
                      decoration: isSelected
                          ? const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                              ),
                            )
                          : BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFFD1D5DB), width: 1.5),
                            ),
                      child: isSelected
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 11)
                          : null,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        d,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ));
  }

  // ===== DOSE CARD =====
  Widget _doseCard(int i) {
    final dose = controller.doses[i];
    return Container(
      width: double.infinity,
      height: 154,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== TOP ROW: label+period LEFT, time RIGHT =====
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left — DOSE label + period name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dose['label'] as String,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9CA3AF),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dose['period'] as String,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Right — time
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    dose['time'] as String,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0D9488),
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    dose['ampm'] as String,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ===== BOTTOM ROW: food option pills =====
          const SizedBox(height: 20),
          Obx(() => Row(
                children: (dose['options'] as List<String>).map((opt) {
                  final bool isSelected = controller.selectedOptions[i] == opt;
                  return GestureDetector(
                    onTap: () => controller.selectOption(i, opt),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: isSelected
                          ? BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF00897B),
                                  Color(0xFF1565C0),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                            )
                          : BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: const Color(0xFFD1D5DB),
                                width: 1.2,
                              ),
                            ),
                      child: Text(
                        opt,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
        ],
      ),
    );
  }
}
