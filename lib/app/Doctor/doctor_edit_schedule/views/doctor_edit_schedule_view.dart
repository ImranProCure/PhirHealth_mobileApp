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
        title: Obx(() => Text(
              'Edit ${controller.dayName.value} Schedule',
              style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            )),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF0D9488)),
          );
        }
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== DAY HEADER =====
                  Container(
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
                            Obx(() => Text(
                                  controller.dayName.value,
                                  style: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                )),
                            const SizedBox(height: 2),
                            Obx(() => Text(
                                  controller.scheduleName.value,
                                  style: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      color: Color(0xFF6B7280)),
                                )),
                          ],
                        ),
                        Obx(() => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD1FAE5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${controller.totalSlots.value} Slots',
                                style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF065F46)),
                              ),
                            )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ===== SESSION CARDS =====
                  Obx(() {
                    if (controller.sessionAllSlots.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'No sessions available',
                            style: TextStyle(
                                fontFamily: 'Mulish', color: Color(0xFF6B7280)),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: controller.sessionAllSlots.keys.map((session) {
                        final slots = controller.sessionAllSlots[session] ?? [];
                        final times = controller.sessionTimes[session] ?? {};

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _sessionCard(
                            name: session,
                            timeRange:
                                '${times['from'] ?? ''} - ${times['to'] ?? ''}',
                            slots: slots,
                            session: session,
                          ),
                        );
                      }).toList(),
                    );
                  }),

                  // ===== ADD SESSION BUTTON =====
                  Obx(() {
                    final available = controller.availableSessionsToAdd;
                    if (available.isEmpty) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: GestureDetector(
                        onTap: () => _showAddSessionSheet(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF0D9488),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2))
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline,
                                  color: Color(0xFF0D9488), size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Add Session',
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0D9488),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  // ===== APPLY TO OTHER DAYS =====
                  Container(
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
                        const Text(
                          'Apply these timings\nto other days?',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              height: 1.4),
                        ),
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

            // ===== UPDATE BUTTON =====
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Obx(() => SizedBox(
                    height: 54,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                            colors: [Color(0xFF00897B), Color(0xFF1565C0)]),
                      ),
                      child: ElevatedButton(
                        onPressed: controller.isSaving.value
                            ? null
                            : controller.updateSlots,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: controller.isSaving.value
                            ? const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2)
                            : const Text(
                                'Update Slots',
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                      ),
                    ),
                  )),
            ),
          ],
        );
      }),
    );
  }

  // ===== ADD SESSION BOTTOM SHEET =====
  void _showAddSessionSheet(BuildContext context) {
    final available = controller.availableSessionsToAdd;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Add Session',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Select a session to add',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 16),
            ...available.map((session) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _sessionIcon(session),
                      color: const Color(0xFF0D9488),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    session,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    _sessionTime(session),
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 14, color: Color(0xFF6B7280)),
                  onTap: () {
                    Get.back();
                    controller.addSessionByName(session);
                  },
                )),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  // ===== SESSION CARD =====
  Widget _sessionCard({
    required String name,
    required String timeRange,
    required List<String> slots,
    required String session,
  }) {
    const Map<String, IconData> sessionIcons = {
      'Morning': Icons.wb_twilight,
      'Afternoon': Icons.wb_sunny_outlined,
      'Evening': Icons.nights_stay_outlined,
    };

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
                  Icon(sessionIcons[name] ?? Icons.access_time,
                      size: 18, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(name,
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  const SizedBox(width: 8),
                  Text(
                    timeRange,
                    style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 11,
                        color: Color(0xFF6B7280)),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => controller.deleteSession(session),
                child: const Icon(Icons.delete_outline,
                    color: Color(0xFFEF4444), size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            final selected = controller.sessionSelected[session] ?? {};
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: slots.map((slot) {
                final bool isSelected = selected.contains(slot);
                return GestureDetector(
                  onTap: () => controller.toggleSlot(session, slot),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
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
                    child: Text(
                      slot,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? const Color(0xFF0D9488)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  // ===== HELPERS =====
  IconData _sessionIcon(String name) {
    switch (name) {
      case 'Morning':
        return Icons.wb_twilight;
      case 'Afternoon':
        return Icons.wb_sunny_outlined;
      case 'Evening':
        return Icons.nights_stay_outlined;
      default:
        return Icons.schedule;
    }
  }

  String _sessionTime(String name) {
    switch (name) {
      case 'Morning':
        return '09:00 AM - 12:00 PM';
      case 'Afternoon':
        return '12:00 PM - 05:00 PM';
      case 'Evening':
        return '05:00 PM - 08:00 PM';
      default:
        return '';
    }
  }
}
