import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/coach_step4_controller.dart';

class CoachStep4View extends GetView<CoachStep4Controller> {
  const CoachStep4View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.chevron_left, size: 28, color: Colors.black),
        ),
        title: const Text('Step 4 of 6',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text('Availability & Logistics',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.black)),
                  ),
                  const SizedBox(height: 8),
                  _buildProgressBar(4, 6),
                  const SizedBox(height: 24),

                  // Work Preferences
                  const Text('Work Preferences',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  const SizedBox(height: 12),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildInlineToggle(
                          label: 'Available for Tele consultation?',
                          rxValue: controller.teleconsultation,
                          onChanged: (v) =>
                              controller.teleconsultation.value = v,
                        ),
                        Divider(height: 1, color: Colors.grey.shade100),
                        _buildInlineToggle(
                          label: 'Willing to work in\nmultidisciplinary teams?',
                          rxValue: controller.multidisciplinary,
                          onChanged: (v) =>
                              controller.multidisciplinary.value = v,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Experience Metrics — Languages
                  const Text('Experience Metrics',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  const SizedBox(height: 12),
                  const Text('Languages Spoken',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  const SizedBox(height: 10),

                  Obx(() => Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ...controller.allLanguages.map((lang) {
                            final sel =
                                controller.selectedLanguages.contains(lang);
                            return GestureDetector(
                              onTap: () => controller.toggleLanguage(lang),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: sel
                                        ? const Color(0xFF0D9488)
                                        : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (sel)
                                      const Padding(
                                        padding: EdgeInsets.only(right: 6),
                                        child: Icon(Icons.check_circle,
                                            size: 16, color: Color(0xFF0D9488)),
                                      ),
                                    Text(lang,
                                        style: TextStyle(
                                            fontFamily: 'Mulish',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: sel
                                                ? const Color(0xFF0D9488)
                                                : Colors.black87)),
                                  ],
                                ),
                              ),
                            );
                          }),
                          GestureDetector(
                            onTap: () =>
                                controller.showAddLanguageDialog(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: const Color(0xFF0D9488),
                                  width: 1.5,
                                ),
                              ),
                              child: const Text('+ Add',
                                  style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0D9488))),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 20),

                  // Primary Communication Mode
                  _buildLabel('Primary communication Mode'),
                  const SizedBox(height: 8),
                  Obx(() => GestureDetector(
                        onTap: () => controller.showCommModeSheet(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(controller.selectedCommMode.value,
                                  style: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 14,
                                      color: Colors.black87)),
                              Icon(Icons.keyboard_arrow_down,
                                  color: Colors.grey.shade500),
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(height: 28),

                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 20),

                  // Availability
                  const Text('Availability',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  const SizedBox(height: 12),
                  const Text('Working Days',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87)),
                  const SizedBox(height: 12),

                  // Days — teal = working, grey = off
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: controller.days.asMap().entries.map((entry) {
                          final index = entry.key;
                          final day = entry.value;
                          final isWorking =
                              controller.selectedDays.contains(index);
                          return GestureDetector(
                            onTap: () => controller.toggleDay(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isWorking
                                    ? const Color(0xFF0D9488)
                                    : Colors.white,
                                border: Border.all(
                                  color: isWorking
                                      ? const Color(0xFF0D9488)
                                      : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                day,
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isWorking
                                        ? Colors.white
                                        : Colors.grey.shade400),
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                  const SizedBox(height: 20),

                  // Daily From / To
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Daily From'),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _pickTime(context, isFrom: true),
                              child: Obx(() =>
                                  _buildTimeBox(controller.fromTime.value)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Daily To'),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _pickTime(context, isFrom: false),
                              child: Obx(
                                  () => _buildTimeBox(controller.toTime.value)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Per Session Fee
                  _buildLabel('Per Session Fee'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('₹',
                              style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 16,
                                  color: Colors.grey.shade600)),
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller.feeController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                            decoration: InputDecoration(
                              hintText: '1500',
                              hintStyle: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 14,
                                  color: Colors.grey.shade400),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Per Hour',
                              style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 13,
                                  color: Colors.grey.shade400)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                      'Coaches in your speciality typically charge between ₹100-150',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 12,
                          color: Colors.grey.shade500)),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildNextButton(onTap: controller.goToNext),
        ],
      ),
    );
  }

  Future<void> _pickTime(BuildContext context, {required bool isFrom}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF0D9488)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      final h = picked.hourOfPeriod.toString().padLeft(2, '0');
      final m = picked.minute.toString().padLeft(2, '0');
      final p = picked.period == DayPeriod.am ? 'AM' : 'PM';
      final fmt = '$h:$m $p';
      if (isFrom) {
        controller.fromTime.value = fmt;
      } else {
        controller.toTime.value = fmt;
      }
    }
  }

  Widget _buildTimeBox(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(time,
              style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
          const Icon(Icons.access_time_rounded,
              size: 18, color: Color(0xFF0D9488)),
        ],
      ),
    );
  }

  Widget _buildInlineToggle({
    required String label,
    required RxBool rxValue,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87)),
          ),
          Obx(() => Switch(
                value: rxValue.value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF0D9488),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade300,
              )),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int step, int total) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: step / total,
        minHeight: 5,
        backgroundColor: Colors.grey.shade300,
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(text,
      style: const TextStyle(
          fontFamily: 'Mulish',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87));

  Widget _buildNextButton({required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00897B), Color(0xFF1565C0)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Next Step',
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
    );
  }
}
