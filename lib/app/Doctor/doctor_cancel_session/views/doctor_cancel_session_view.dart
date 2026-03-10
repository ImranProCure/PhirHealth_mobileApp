import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_cancel_session_controller.dart';

class DoctorCancelSessionView extends GetView<DoctorCancelSessionController> {
  const DoctorCancelSessionView({super.key});

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
        title: const Text('Cancel Session',
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
            const Text('Review cancellation details',
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    color: Color(0xFF6B7280))),
            const SizedBox(height: 12),

            // ===== APPOINTMENT CARD =====
            Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Appointment to be cancelled tag
                  Row(
                    children: const [
                      Icon(Icons.cancel_outlined,
                          size: 14, color: Color(0xFFEF4444)),
                      SizedBox(width: 6),
                      Text('Appointment to be cancelled',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFEF4444))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Akansha Tripathi',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.black)),
                  const SizedBox(height: 2),
                  const Text('General Consultation',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          color: Color(0xFF6B7280))),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.access_time_outlined,
                          size: 14, color: Color(0xFF6B7280)),
                      SizedBox(width: 6),
                      Text('February 12, 2026 | 10:00 AM • 30 min',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              color: Color(0xFF6B7280))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ===== REFUND CARD =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFED7AA), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.warning_amber_outlined,
                          size: 16, color: Color(0xFFD97706)),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                            'Cancelling within 24 hours - Patient gets full refund',
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFEF4444))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFFED7AA)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Consultation Fee',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              color: Color(0xFF6B7280))),
                      Text('₹500',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.black)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Patient Refund',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              color: Color(0xFF6B7280))),
                      Text('₹500',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0D9488))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ===== REASON FOR CANCELLATION =====
            const Text('Reason for Cancellation',
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.black)),
            const SizedBox(height: 12),

            Obx(() => Column(
                  children: controller.reasons.map((r) {
                    final String label = r['label'] as String;
                    final bool isSelected =
                        controller.selectedReason.value == label;
                    return GestureDetector(
                      onTap: () => controller.selectReason(label),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF0D9488)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 1))
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(r['icon'] as IconData,
                                size: 20, color: r['color'] as Color),
                            const SizedBox(width: 12),
                            Text(label,
                                style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )),
            const SizedBox(height: 20),

            // ===== CANCELLATION IMPACT =====
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
                  const Icon(Icons.warning_amber_outlined,
                      size: 18, color: Color(0xFFD97706)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Cancellation Impact',
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF92400E))),
                        const SizedBox(height: 8),
                        ...controller.impactPoints.map((p) => Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ',
                                      style: TextStyle(
                                          color: Color(0xFFD97706),
                                          fontSize: 13)),
                                  Expanded(
                                    child: Text(p,
                                        style: const TextStyle(
                                            fontFamily: 'Mulish',
                                            fontSize: 12,
                                            color: Color(0xFF92400E),
                                            height: 1.4)),
                                  ),
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

            // ===== PROCEED TO CANCEL =====
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
                  onPressed: controller.proceedToCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  icon: const Icon(Icons.video_call_outlined,
                      color: Colors.white, size: 20),
                  label: const Text('Proceed to Cancel',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ===== KEEP SESSION =====
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: controller.keepSession,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Keep Session',
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
}
