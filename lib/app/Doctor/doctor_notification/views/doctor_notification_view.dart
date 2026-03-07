import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_notification_controller.dart';

class DoctorNotificationView extends GetView<DoctorNotificationController> {
  const DoctorNotificationView({super.key});

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
        title: const Text('Notification',
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
            // ===== EMERGENCY CARD =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEF4444), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Red circle icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFE4E4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.error_outline,
                            color: Color(0xFFEF4444), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  child: Text('Emergency Reschedule Request',
                                      style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black)),
                                ),
                                const SizedBox(width: 8),
                                Text(controller.emergency['time'] as String,
                                    style: const TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF9CA3AF))),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(controller.emergency['body'] as String,
                                style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 13,
                                    color: Color(0xFF6B7280),
                                    height: 1.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Accept + Decline buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                              ),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: controller.accept,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              icon: const Icon(Icons.check_circle_outline,
                                  color: Colors.white, size: 18),
                              label: const Text('Accept',
                                  style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: OutlinedButton.icon(
                            onPressed: controller.decline,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Color(0xFF0D9488), width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            icon: const Icon(Icons.cancel_outlined,
                                color: Color(0xFF0D9488), size: 18),
                            label: const Text('Decline',
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0D9488))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ===== TODAY'S OVERVIEW =====
            const Text("Today's Overview",
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black)),
            const SizedBox(height: 12),

            ...controller.notifications.map((n) => _notificationCard(n)),
          ],
        ),
      ),
    );
  }

  Widget _notificationCard(Map<String, dynamic> n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(n['iconBg'] as int),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                n['iconPath'] as String,
                fit: BoxFit.contain,
                color: Color(n['iconColor'] as int),
                colorBlendMode: BlendMode.srcIn,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.notifications_outlined,
                  color: Color(n['iconColor'] as int),
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(n['title'] as String,
                          style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              height: 1.3)),
                    ),
                    const SizedBox(width: 8),
                    Text(n['time'] as String,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            color: Color(0xFF9CA3AF))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(n['body'] as String,
                    style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
