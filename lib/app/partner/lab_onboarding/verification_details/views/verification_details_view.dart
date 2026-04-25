import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/verification_details_controller.dart';

class VerificationDetailsView extends GetView<VerificationDetailsController> {
  const VerificationDetailsView({super.key});

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
        title: const Text(
          'Step 4 of 4',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
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
                  // ── Centered Heading ──
                  const Center(
                    child: Text(
                      'Operations & Tech',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildProgressBar(4),
                  const SizedBox(height: 28),

                  // Working Days & Hours
                  const Text(
                    'Working Days & Hours',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Operating Days',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tap a day to mark it as Holiday (turns red)',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 11,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Days selector — index-based to handle duplicate 'T'
                        Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:
                                  controller.days.asMap().entries.map((entry) {
                                final index = entry.key;
                                final day = entry.value;
                                final isHoliday =
                                    controller.selectedDays.contains(index);
                                return GestureDetector(
                                  onTap: () =>
                                      controller.toggleDayByIndex(index),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isHoliday
                                          ? const Color(0xFFE53935)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isHoliday
                                            ? const Color(0xFFE53935)
                                            : const Color(0xFF0D9488),
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
                                        color: isHoliday
                                            ? Colors.white
                                            : const Color(0xFF0D9488),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            )),
                        const SizedBox(height: 18),

                        // FROM - TO time pickers
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'FROM',
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: () =>
                                        _pickTime(context, isFrom: true),
                                    child: Obx(() => Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                          ),
                                          child: Text(
                                            controller.fromTime.value,
                                            style: const TextStyle(
                                              fontFamily: 'Mulish',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TO',
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: () =>
                                        _pickTime(context, isFrom: false),
                                    child: Obx(() => Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                          ),
                                          child: Text(
                                            controller.toTime.value,
                                            style: const TextStyle(
                                              fontFamily: 'Mulish',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Service Settings
                  const Text(
                    'Service Settings',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 14),

                  _buildServiceToggleCard(
                    icon: Icons.medical_services_outlined,
                    title: 'Emergency Service Available (24x7)',
                    subtitle: 'Allow AI analysis of your records',
                    rxValue: controller.emergencyService,
                    onChanged: (v) => controller.emergencyService.value = v,
                  ),
                  const SizedBox(height: 12),
                  _buildServiceToggleCard(
                    icon: Icons.calendar_today_outlined,
                    title: 'Do you accept online bookings?',
                    subtitle:
                        'Allow patients to schedule appointments via the portal.',
                    rxValue: controller.onlineBookings,
                    onChanged: (v) => controller.onlineBookings.value = v,
                  ),
                  const SizedBox(height: 12),
                  _buildServiceToggleCard(
                    icon: Icons.api_outlined,
                    title: 'Integration with APIs/LIS System?',
                    subtitle:
                        'Sync data automatically with external hospital systems.',
                    rxValue: controller.apiIntegration,
                    onChanged: (v) => controller.apiIntegration.value = v,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Submit Registration Button — logic via controller
          _buildSubmitButton(onTap: controller.submitRegistration),
        ],
      ),
    );
  }

  Future<void> _pickTime(BuildContext context, {required bool isFrom}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0D9488),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final hour = picked.hourOfPeriod.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
      final formatted = '$hour:$minute $period';
      if (isFrom) {
        controller.fromTime.value = formatted;
      } else {
        controller.toTime.value = formatted;
      }
    }
  }

  Widget _buildProgressBar(int step) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: step / 4,
        minHeight: 5,
        backgroundColor: Colors.grey.shade300,
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
      ),
    );
  }

  Widget _buildServiceToggleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required RxBool rxValue,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5F4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22, color: const Color(0xFF0D9488)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D9488),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Obx(() => Switch(
                value: rxValue.value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF0D9488),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade400,
              )),
        ],
      ),
    );
  }

  Widget _buildSubmitButton({required VoidCallback onTap}) {
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
              Text(
                'Submit Registration',
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
