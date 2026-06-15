import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_availability_controller.dart';

class DoctorAvailabilityView extends StatelessWidget {
  final bool isFromRegistration;
  const DoctorAvailabilityView({
    super.key,
    this.isFromRegistration = false,
  });

  static const Map<String, IconData> _sessionIcons = {
    'Morning': Icons.wb_twilight,
    'Afternoon': Icons.wb_sunny_outlined,
    'Evening': Icons.nights_stay_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DoctorAvailabilityController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: isFromRegistration
            ? const SizedBox.shrink()
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Get.back(),
              ),
        centerTitle: true,
        title: const Text(
          'Availability & Slots',
          style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF0D9488)),
          );
        }

        // Registration flow — create form
        if (isFromRegistration) {
          return _buildCreateForm(context, controller);
        }

        // Dashboard flow — day cards
        return _buildDayCards(controller);
      }),
    );
  }

  // ===== CREATE FORM (registration) =====
  Widget _buildCreateForm(
      BuildContext context, DoctorAvailabilityController controller) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Set Your Availability',
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select your working days and consultation hours',
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 20),

              // ===== DAYS =====
              _sectionLabel('Working Days'),
              const SizedBox(height: 10),
              Container(
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
                  children: List.generate(
                    controller.dayNames.length,
                    (i) => Obx(() => CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(
                            controller.dayNames[i],
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          value: controller.enabledList[i].value,
                          onChanged: (val) =>
                              controller.toggleDay(i, val ?? false),
                          activeColor: const Color(0xFF0D9488),
                          checkColor: Colors.white,
                          controlAffinity: ListTileControlAffinity.leading,
                        )),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ===== TIME =====
              _sectionLabel('Consultation Hours'),
              const SizedBox(height: 10),
              Container(
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
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(() => _timeTile(
                            context: context,
                            label: 'From',
                            value: controller.fromTime.value,
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime:
                                    const TimeOfDay(hour: 9, minute: 0),
                              );
                              if (picked != null) {
                                controller.fromTime.value =
                                    picked.format(context);
                              }
                            },
                          )),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(() => _timeTile(
                            context: context,
                            label: 'To',
                            value: controller.toTime.value,
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime:
                                    const TimeOfDay(hour: 17, minute: 0),
                              );
                              if (picked != null) {
                                controller.toTime.value =
                                    picked.format(context);
                              }
                            },
                          )),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===== CONSULTATION TYPE =====
              _sectionLabel('Consultation Type'),
              const SizedBox(height: 10),
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
                child: Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              controller.isClinic.value
                                  ? Icons.local_hospital_outlined
                                  : Icons.videocam_outlined,
                              color: const Color(0xFF0D9488),
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              controller.isClinic.value
                                  ? 'Clinic Visit'
                                  : 'Video Consultation',
                              style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        Switch(
                          value: controller.isClinic.value,
                          onChanged: (val) => controller.isClinic.value = val,
                          activeColor: Colors.white,
                          activeTrackColor: const Color(0xFF0D9488),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: const Color(0xFFD1D5DB),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),

        // ===== CREATE BUTTON =====
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
                  child: ElevatedButton.icon(
                    onPressed: controller.isSaving.value
                        ? null
                        : () => controller.createSlots(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    icon: controller.isSaving.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.arrow_forward_rounded,
                            color: Colors.white, size: 20),
                    label: Text(
                      controller.isSaving.value
                          ? 'Creating...'
                          : 'Create Slots & Continue',
                      style: const TextStyle(
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
  }

  // ===== DAY CARDS (dashboard) =====
  Widget _buildDayCards(DoctorAvailabilityController controller) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            children: [
              // Schedule Type
              Container(
                width: double.infinity,
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
                  children: [
                    const Icon(Icons.video_call_outlined,
                        color: Color(0xFF0D9488)),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Schedule Type',
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF6B7280))),
                        const SizedBox(height: 2),
                        Obx(() => Text(
                              controller.scheduleType.value,
                              style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              ...List.generate(
                  controller.dayNames.length, (i) => _dayCard(controller, i)),
            ],
          ),
        ),

        // Save Button
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
                  child: ElevatedButton.icon(
                    onPressed: controller.isSaving.value
                        ? null
                        : () => controller.saveSchedule(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    icon: controller.isSaving.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.calendar_month_outlined,
                            color: Colors.white, size: 20),
                    label: Text(
                      controller.isSaving.value ? 'Saving...' : 'Save Schedule',
                      style: const TextStyle(
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
  }

  // ===== HELPERS =====
  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontFamily: 'Mulish',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.black),
    );
  }

  Widget _timeTile({
    required BuildContext context,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 11,
                    color: Color(0xFF6B7280))),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time,
                    size: 14, color: Color(0xFF0D9488)),
                const SizedBox(width: 4),
                Text(value,
                    style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dayCard(DoctorAvailabilityController controller, int i) {
    return Obx(() {
      final bool isOn = controller.enabledList[i].value;
      final List<String> sessions = controller.daySessions[i];
      final List<Map<String, dynamic>> sessionDetails =
          controller.daySessionDetails[i];

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
                      Obx(() => Text(controller.dayTimes[i].value,
                          style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              color: Color(0xFF6B7280)))),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                      fontWeight: active
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: active
                                          ? Colors.black
                                          : const Color(0xFFD1D5DB))),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    ...sessionDetails
                        .where((s) => s['active'] == true)
                        .map((s) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Icon(
                                      _sessionIcons[s['name']] ??
                                          Icons.access_time,
                                      size: 13,
                                      color: const Color(0xFF0D9488)),
                                  const SizedBox(width: 6),
                                  Text(
                                      '${s['name']}: ${s['from']} - ${s['to']}',
                                      style: const TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 12,
                                          color: Color(0xFF374151))),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD1FAE5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text('${s['slot_count']} slots',
                                        style: const TextStyle(
                                            fontFamily: 'Mulish',
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF065F46))),
                                  ),
                                ],
                              ),
                            )),
                  ],
                ),
            ],
          ),
        ),
      );
    });
  }
}
