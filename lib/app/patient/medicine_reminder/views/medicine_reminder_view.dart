import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/medicine_reminder_controller.dart';

class MedicineReminderView extends GetView<MedicineReminderController> {
  const MedicineReminderView({super.key});

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
          'My Meds',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.calendar_month_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ===== DATE STRIP =====
            _dateStrip(),
            const SizedBox(height: 16),

            // ===== MEDICINE LIST =====
            Expanded(
              child: Obx(() => ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.medicines.length,
                    itemBuilder: (context, i) => _medCard(i),
                  )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addMedicine,
        backgroundColor: const Color(0xFF0D9488),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  // ===== DATE STRIP =====
  Widget _dateStrip() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(controller.dates.length, (i) {
              final d = controller.dates[i];
              final bool isSelected = controller.selectedDateIndex.value == i;
              return GestureDetector(
                onTap: () => controller.selectDate(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0D9488) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF0D9488)
                          : const Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        d['date'] as String,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        d['day'] as String,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          )),
    );
  }

  // ===== MED CARD =====
  Widget _medCard(int i) {
    final med = controller.medicines[i];
    final String status = med['status'] as String;

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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== ROW 1: image + time + status =====
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Medicine image
              Image.asset(
                med['imagePath'] as String,
                width: 44,
                height: 44,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.medication,
                  color: Color(0xFFF97316),
                  size: 40,
                ),
              ),
              const SizedBox(width: 12),

              // Time + name + detail
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          med['time'] as String,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        _statusBadge(status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      med['name'] as String,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      med['detail'] as String,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ===== TAKE + SNOOZE (only pending) =====
          if (status == 'pending') ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                        ),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () => controller.takeMedicine(i),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        icon: const Icon(Icons.check_circle_outline,
                            color: Colors.white, size: 18),
                        label: const Text(
                          'Take',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: () => controller.snoozeMedicine(i),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(0xFF0D9488), width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      icon: const Icon(Icons.snooze_outlined,
                          color: Color(0xFF0D9488), size: 18),
                      label: const Text(
                        'Snooze',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ===== STATUS BADGE =====
  Widget _statusBadge(String status) {
    if (status == 'taken') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 14),
            SizedBox(width: 4),
            Text(
              'Taken',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF22C55E),
              ),
            ),
          ],
        ),
      );
    } else if (status == 'upcoming') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.access_time_rounded, color: Color(0xFF9CA3AF), size: 14),
            SizedBox(width: 4),
            Text(
              'Upcoming',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }
}
