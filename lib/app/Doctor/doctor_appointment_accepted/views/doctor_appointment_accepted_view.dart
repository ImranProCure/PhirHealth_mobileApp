import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_appointment_accepted_controller.dart';

class DoctorAppointmentAcceptedView
    extends GetView<DoctorAppointmentAcceptedController> {
  const DoctorAppointmentAcceptedView({super.key});

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
        title: const Text('Appointment Accepted!',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // ===== TITLE =====
              const Text(
                'Appointment\nAccepted!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2937),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              // ===== SUBTITLE =====
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.5),
                  children: [
                    TextSpan(
                        text: controller.patientName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.black)),
                    const TextSpan(
                        text:
                            ' has been notified. The appointment has been added to your schedule.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ===== SESSION DETAILS BOX =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Session Details:',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            color: Color(0xFF374151))),
                    const SizedBox(height: 6),
                    Text(controller.sessionType,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0D9488))),
                    const SizedBox(height: 4),
                    Text(
                        '${controller.appointmentTime} • ${controller.duration}',
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            color: Color(0xFF374151))),
                    const SizedBox(height: 4),
                    Text('Earnings: ${controller.earnings}',
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D9488))),
                  ],
                ),
              ),

              const Spacer(),

              // ===== GO TO REQUESTS =====
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => Get.offAllNamed('/doctor-requests'),
                  style: OutlinedButton.styleFrom(
                    side:
                        const BorderSide(color: Color(0xFF0D9488), width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Go to Requests',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0D9488))),
                ),
              ),
              const SizedBox(height: 14),

              // ===== GO HOME =====
              GestureDetector(
                onTap: () => Get.offAllNamed('/doctor-dashboard'),
                child: const Text(
                  'Go Home',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
