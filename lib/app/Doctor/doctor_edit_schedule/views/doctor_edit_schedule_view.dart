import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_edit_schedule_controller.dart';

class DoctorEditScheduleView extends GetView<DoctorEditScheduleController> {
  const DoctorEditScheduleView({super.key});

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
        title: const Text('Edit Schedule',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== DAY HEADER =====
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      Obx(() => Text(
                          'Edit ${controller.dayName.value} Schedule',
                          style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black))),
                      Obx(() => Switch(
                            value: controller.isDayEnabled.value,
                            onChanged: (v) => controller.isDayEnabled.value = v,
                            activeColor: Colors.white,
                            activeTrackColor: const Color(0xFF0D9488),
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: const Color(0xFFD1D5DB),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // ===== MORNING CARD =====
                _sessionCard(
                  name: 'Morning',
                  icon: Icons.wb_twilight,
                  slots: controller.morningSlots,
                  selected: controller.morningSelected,
                  onToggle: controller.toggleMorningSlot,
                  onDelete: controller.deleteMorning,
                ),
                const SizedBox(height: 14),

                // ===== AFTERNOON CARD =====
                _sessionCard(
                  name: 'Afternoon',
                  icon: Icons.wb_sunny_outlined,
                  slots: controller.afternoonSlots,
                  selected: controller.afternoonSelected,
                  onToggle: controller.toggleAfternoonSlot,
                  onDelete: controller.deleteAfternoon,
                ),
                const SizedBox(height: 14),

                // ===== ADD AFTERNOON SLOT =====
                GestureDetector(
                  onTap: controller.addAfternoonSlot,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFF0D9488), width: 1.5),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline,
                            color: Color(0xFF0D9488), size: 20),
                        SizedBox(width: 8),
                        Text('Add Afternoon Slot',
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D9488))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // ===== APPLY TO OTHER DAYS =====
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      const Text('Apply these timings\nto other days?',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              height: 1.4)),
                      Obx(() => Switch(
                            value: controller.applyToOtherDays.value,
                            onChanged: (v) =>
                                controller.applyToOtherDays.value = v,
                            activeColor: Colors.white,
                            activeTrackColor: const Color(0xFF0D9488),
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: const Color(0xFFD1D5DB),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ===== UPDATE SLOTS BUTTON =====
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
                child: ElevatedButton(
                  onPressed: controller.updateSlots,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Update Slots',
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

  Widget _sessionCard({
    required String name,
    required IconData icon,
    required List<String> slots,
    required RxSet<String> selected,
    required void Function(String) onToggle,
    required VoidCallback onDelete,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(name,
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                ],
              ),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.delete_outline,
                    color: Color(0xFFEF4444), size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: slots.map((slot) {
                  final bool isSelected = selected.contains(slot);
                  return GestureDetector(
                    onTap: () => onToggle(slot),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFFE0F2F1) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
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
                            color: isSelected
                                ? const Color(0xFF0D9488)
                                : const Color(0xFF6B7280),
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
