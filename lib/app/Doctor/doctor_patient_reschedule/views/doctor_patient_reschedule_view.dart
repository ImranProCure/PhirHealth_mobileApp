import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_patient_reschedule_controller.dart';

class DoctorPatientRescheduleView
    extends GetView<DoctorPatientRescheduleController> {
  const DoctorPatientRescheduleView({super.key});

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
        title: const Text('Reschedule Session',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select new date & time',
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    color: Color(0xFF6B7280))),
            const SizedBox(height: 12),

            // ===== CURRENT SESSION =====
            _whiteCard(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Current Session',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black)),
                const SizedBox(height: 14),
                _infoRow(Icons.calendar_month_outlined, 'Date & Time',
                    controller.currentDateTime),
                const SizedBox(height: 12),
                _infoRow(
                    Icons.person_outline, 'Patient', controller.patientName),
                const SizedBox(height: 12),
                _infoRow(Icons.video_call_outlined, 'Session Type',
                    controller.sessionType),
              ],
            )),
            const SizedBox(height: 14),

            // ===== CALENDAR =====
            _whiteCard(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select New Date & Time',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black)),
                const SizedBox(height: 14),

                // Month header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.chevron_left,
                            color: Colors.black)),
                    Obx(() => Text(controller.currentMonth.value,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black))),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.chevron_right,
                            color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 8),

                // Week day headers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: controller.weekDays
                      .map((d) => SizedBox(
                            width: 36,
                            child: Text(d,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 11,
                                    color: Color(0xFF9CA3AF))),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),

                // Calendar grid
                Obx(() {
                  final selected = controller.selectedDay.value;
                  return Column(
                    children: List.generate(
                        (controller.calendarDays.length / 7).ceil(), (row) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(7, (col) {
                          final idx = row * 7 + col;
                          if (idx >= controller.calendarDays.length)
                            return const SizedBox(width: 36);
                          final day = controller.calendarDays[idx];
                          if (day == null) return const SizedBox(width: 36);
                          final bool isCurrentMonth = day >= 1 && day <= 28;
                          final bool isSelected =
                              selected == day && isCurrentMonth;
                          final int dots = controller.dayDots[day] ?? 0;
                          return GestureDetector(
                            onTap: isCurrentMonth
                                ? () => controller.selectDay(day)
                                : null,
                            child: SizedBox(
                              width: 36,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF0D9488)
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text('$day',
                                          style: TextStyle(
                                            fontFamily: 'Mulish',
                                            fontSize: 13,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w400,
                                            color: isSelected
                                                ? Colors.white
                                                : isCurrentMonth
                                                    ? Colors.black
                                                    : const Color(0xFFD1D5DB),
                                          )),
                                    ),
                                  ),
                                  if (dots > 0 && isCurrentMonth)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                          dots.clamp(0, 3),
                                          (_) => Container(
                                                width: 4,
                                                height: 4,
                                                margin: const EdgeInsets.only(
                                                    right: 1),
                                                decoration: const BoxDecoration(
                                                    color: Color(0xFF0D9488),
                                                    shape: BoxShape.circle),
                                              )),
                                    )
                                  else
                                    const SizedBox(height: 6),
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  );
                }),
                const SizedBox(height: 16),

                // Selected day label
                Text(controller.selectedDayLabel,
                    style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black)),
                const SizedBox(height: 14),

                // Morning slots
                _slotSection(
                    Icons.wb_twilight, 'Morning', controller.morningSlots),
                const SizedBox(height: 14),

                // Afternoon slots
                _slotSection(Icons.wb_sunny_outlined, 'Afternoon (No Slots)',
                    controller.afternoonSlots),
                const SizedBox(height: 14),

                // Evening slots
                _slotSection(Icons.nights_stay_outlined, 'Evening',
                    controller.eveningSlots),
              ],
            )),
            const SizedBox(height: 14),

            // ===== REASON =====
            _whiteCard(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Reason for Rescheduling',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black)),
                const SizedBox(height: 4),
                const Text('This will be shared with the student',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        color: Color(0xFF6B7280))),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: TextField(
                    controller: controller.reasonController,
                    maxLines: 4,
                    style: const TextStyle(fontFamily: 'Mulish', fontSize: 13),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          'Please provide a brief reason for rescheduling...',
                      hintStyle: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 12,
                          color: Color(0xFF9CA3AF)),
                    ),
                  ),
                ),
              ],
            )),
            const SizedBox(height: 14),

            // ===== RESCHEDULING POLICY =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFDE68A), width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline,
                      color: Color(0xFFD97706), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Rescheduling Policy',
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF92400E))),
                        const SizedBox(height: 8),
                        ...[
                          'The patient will be notified to accept the new time within 24 hours.',
                          'If the patient declines, the appointment will be automatically cancelled and refunded.',
                          'Frequent rescheduling may negatively affect your profile rating and visibility.',
                        ].map((t) => Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ',
                                      style: TextStyle(
                                          color: Color(0xFFD97706),
                                          fontSize: 13)),
                                  Expanded(
                                      child: Text(t,
                                          style: const TextStyle(
                                              fontFamily: 'Mulish',
                                              fontSize: 12,
                                              color: Color(0xFF92400E),
                                              height: 1.4))),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ===== START CONSULTATION BUTTON =====
            SizedBox(
              width: double.infinity,
              height: 54,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                      colors: [Color(0xFF00897B), Color(0xFF1565C0)]),
                ),
                child: ElevatedButton.icon(
                  onPressed: controller.sendRescheduleRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  icon: const Icon(Icons.video_call_outlined,
                      color: Colors.white, size: 20),
                  label: const Text('Start Consultation',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ===== CANCEL SESSION =====
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: controller.cancelSession,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Cancel Session',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D9488))),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _slotSection(IconData icon, String label, List<String> slots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.black54),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black)),
          ],
        ),
        const SizedBox(height: 10),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: slots.map((slot) {
                final bool isSelected = controller.selectedSlot.value == slot;
                final bool isBooked = controller.bookedSlots.contains(slot);
                return GestureDetector(
                  onTap: () => controller.selectSlot(slot),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xFFE0F2F1) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isBooked
                            ? const Color(0xFF0D9488)
                            : isSelected
                                ? const Color(0xFF0D9488)
                                : const Color(0xFFE5E7EB),
                        width: 1.5,
                      ),
                    ),
                    child: Text(slot,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isBooked
                              ? const Color(0xFF0D9488)
                              : isSelected
                                  ? const Color(0xFF0D9488)
                                  : const Color(0xFF374151),
                        )),
                  ),
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _whiteCard({required Widget child}) {
    return Container(
      width: double.infinity,
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
      child: child,
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 18, color: const Color(0xFF6B7280)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      color: Color(0xFF6B7280))),
              const SizedBox(height: 3),
              Text(value,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
            ],
          ),
        ),
      ],
    );
  }
}
