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
        title: const Text('Set Schedule',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== FREQUENCY TABS =====
                  _frequencyTabs(),
                  const SizedBox(height: 20),

                  // ===== HOW MANY TIMES =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('How many times a day?',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black)),
                      GestureDetector(
                        onTap: () {},
                        child: const Text('Edit',
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D9488),
                                decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ===== DURATION RADIO =====
                  _durationRow(),
                  const SizedBox(height: 20),

                  // ===== DOSE CARDS =====
                  ...List.generate(
                      controller.doses.length, (i) => _doseCard(i)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ===== SAVE BUTTON =====
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                      colors: [Color(0xFF00897B), Color(0xFF1565C0)]),
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
                      Text('Save Schedule',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== FREQUENCY TABS =====
  Widget _frequencyTabs() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: controller.frequencies.map((f) {
              final bool isSelected = controller.selectedFrequency.value == f;
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.selectFrequency(f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF0D9488)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(26),
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
            return GestureDetector(
              onTap: () => controller.selectDuration(d),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? const Color(0xFF0D9488)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF0D9488)
                            : const Color(0xFFD1D5DB),
                        width: 1.5,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 13)
                        : null,
                  ),
                  const SizedBox(width: 6),
                  Text(d,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: Colors.black,
                      )),
                  const SizedBox(width: 16),
                ],
              ),
            );
          }).toList(),
        ));
  }

  // ===== DOSE CARD =====
  Widget _doseCard(int i) {
    final dose = controller.doses[i];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dose['label'] as String,
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 1)),
                  Text(dose['period'] as String,
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.black)),
                ],
              ),
              // Time display
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(dose['time'] as String,
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0D9488))),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(dose['ampm'] as String,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0D9488))),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Food options
          Obx(() => Row(
                children: (dose['options'] as List<String>).map((opt) {
                  final bool isSelected = controller.selectedOptions[i] == opt;
                  return GestureDetector(
                    onTap: () => controller.selectOption(i, opt),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0D9488)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF0D9488)
                              : const Color(0xFFD1D5DB),
                        ),
                      ),
                      child: Text(opt,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black,
                          )),
                    ),
                  );
                }).toList(),
              )),
        ],
      ),
    );
  }
}
