import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_availability_controller.dart';

class DoctorAvailabilityView extends GetView<DoctorAvailabilityController> {
  const DoctorAvailabilityView({super.key});

  static const Map<String, IconData> _sessionIcons = {
    'Morning': Icons.wb_twilight,
    'Afternoon': Icons.wb_sunny_outlined,
    'Evening': Icons.nights_stay_outlined,
  };

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
        title: const Text('Availability & Slots',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: Column(
              children: [
                // ===== SLOT DURATION =====
                GestureDetector(
                  onTap: controller.showSlotPicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Slot Duration',
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 12,
                                    color: Color(0xFF6B7280))),
                            const SizedBox(height: 2),
                            Obx(() => Text(controller.slotDuration.value,
                                style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0D9488)))),
                          ],
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded,
                            color: Colors.black54),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // ===== DAY CARDS =====
                ...List.generate(
                    controller.dayNames.length, (i) => _dayCard(i)),
              ],
            ),
          ),

          // ===== SAVE BUTTON =====
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: SizedBox(
              height: 54,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                      colors: [Color(0xFF00897B), Color(0xFF1565C0)]),
                ),
                child: ElevatedButton.icon(
                  onPressed: controller.saveSchedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  icon: const Icon(Icons.calendar_month_outlined,
                      color: Colors.white, size: 20),
                  label: const Text('Save Schedule',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayCard(int i) {
    final List<String> sessions = controller.daySessions[i];
    return Obx(() {
      final bool isOn = controller.enabledList[i].value;
      return GestureDetector(
        onTap: isOn ? () => controller.editDay(i) : null,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(controller.dayNames[i],
                          style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.black)),
                      const SizedBox(height: 2),
                      Text(controller.dayTimes[i],
                          style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              color: Color(0xFF6B7280))),
                    ],
                  ),
                  Switch(
                    value: isOn,
                    onChanged: (val) => controller.toggleDay(i, val),
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFF0D9488),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFFD1D5DB),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (!isOn)
                const Row(
                  children: [
                    Icon(Icons.do_not_disturb_alt_outlined,
                        size: 16, color: Color(0xFF9CA3AF)),
                    SizedBox(width: 6),
                    Text('Day Off',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            color: Color(0xFF9CA3AF))),
                  ],
                )
              else
                Row(
                  children: ['Morning', 'Afternoon', 'Evening'].map((s) {
                    final bool active = sessions.contains(s);
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Row(
                        children: [
                          Icon(_sessionIcons[s],
                              size: 15,
                              color: active
                                  ? Colors.black54
                                  : const Color(0xFFD1D5DB)),
                          const SizedBox(width: 4),
                          Text(s,
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                fontWeight:
                                    active ? FontWeight.w600 : FontWeight.w400,
                                color: active
                                    ? Colors.black
                                    : const Color(0xFFD1D5DB),
                              )),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      );
    });
  }
}
