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
        title: Text(
          'set_schedule_title'.tr,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'set_schedule_times_day'.tr,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showDoseCountPicker(context),
                          child: Text(
                            'set_schedule_edit'.tr,
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
                    _durationRow(),
                    const SizedBox(height: 8),
                    _customDateDisplay(),
                    const SizedBox(height: 20),

                    // ===== DOSE CARDS =====
                    Obx(() => Column(
                          children: List.generate(
                            controller.doseList.length,
                            (i) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _doseCard(i),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),

            // ===== SAVE BUTTON =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Obx(() => SizedBox(
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
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.saveSchedule,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'set_schedule_save'.tr,
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
                  )),
            ),
          ],
        ),
      ),
    );
  }

  // ===== DURATION ROW =====
  Widget _durationRow() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: controller.durations.map((d) {
            final bool isSelected = controller.selectedDuration.value == d;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.selectDuration(d),
                child: Container(
                  height: 34,
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 16,
                        height: 16,
                        decoration: isSelected
                            ? const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF00897B),
                                    Color(0xFF1565C0),
                                  ],
                                ),
                              )
                            : BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFD1D5DB),
                                  width: 1.5,
                                ),
                              ),
                        child: isSelected
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 10)
                            : null,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          d,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 11,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ));
  }

  // ===== CUSTOM DATE DISPLAY =====
  Widget _customDateDisplay() {
    return Obx(() {
      if (controller.selectedDuration.value != 'set_schedule_custom'.tr) {
        return const SizedBox();
      }
      final start = controller.customStartDate.value;
      final end = controller.customEndDate.value;
      if (start == null || end == null) return const SizedBox();

      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF0D9488).withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF0D9488), width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.date_range, color: Color(0xFF0D9488), size: 16),
            const SizedBox(width: 8),
            Text(
              '${start.day}/${start.month}/${start.year}  →  ${end.day}/${end.month}/${end.year}',
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D9488),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ===== DOSE COUNT PICKER =====
  void _showDoseCountPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
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
                Text(
                  'set_schedule_times_per_day'.tr,
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                // ✅ Obx — doseList.length reactive hai
                Obx(() => Column(
                      children: List.generate(4, (i) {
                        final count = i + 1;
                        final label = [
                          'set_schedule_once'.tr,
                          'set_schedule_twice'.tr,
                          'set_schedule_3_times'.tr,
                          'set_schedule_4_times'.tr
                        ][i];
                        final isSelected = controller.doseList.length == count;
                        return GestureDetector(
                          onTap: () {
                            controller.setDoseCount(count);
                            Navigator.pop(ctx);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF0D9488).withOpacity(0.08)
                                  : const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF0D9488)
                                    : const Color(0xFFE5E7EB),
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '$label ($count ${count > 1 ? 'set_schedule_doses'.tr : 'set_schedule_dose'.tr})',
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? const Color(0xFF0D9488)
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle,
                                      color: Color(0xFF0D9488), size: 20),
                              ],
                            ),
                          ),
                        );
                      }),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===== DOSE CARD =====
  Widget _doseCard(int i) {
    return Obx(() {
      // ✅ Safe check
      if (i >= controller.doseList.length) return const SizedBox();
      final dose = controller.doseList[i];

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dose.label,
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
                      dose.period,
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
                GestureDetector(
                  onTap: () => controller.pickTime(i),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        dose.time,
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
                        dose.ampm,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: dose.options.map((opt) {
                final bool isSelected = dose.selectedOption == opt;
                return GestureDetector(
                  onTap: () => controller.selectOption(i, opt),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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
            ),
          ],
        ),
      );
    });
  }
}
