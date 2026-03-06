import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/routes/app_routes.dart';

class AppointmentConfirmedView extends StatelessWidget {
  const AppointmentConfirmedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ===== BACK =====
              GestureDetector(
                onTap: () => Get.back(),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 18, color: Colors.black),
                    SizedBox(width: 6),
                    Text(
                      "Back",
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ===== CHECKMARK =====
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 36,
                    color: Color(0xFF0D9488),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ===== TITLE =====
              const Center(
                child: Text(
                  "Appointment\nConfirmed!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ===== DOCTOR + BOOKING ID =====
              const Center(
                child: Text(
                  "Dr. Jyoti Wadhwani",
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  "Booking ID: #PHIR-2026-8892",
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),

              const Spacer(),

              // ===== VIEW MY APPOINTMENTS BUTTON =====
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Get.offAllNamed(Routes.MY_APPOINTMENTS);
                    Get.toNamed(Routes.DOCTOR_VISITS);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "View My Appointments",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ===== GO TO HOME =====
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Get.offAllNamed(Routes.HOME);
                    Get.toNamed(Routes.DASHBOARD);
                  },
                  child: const Text(
                    "Go to Home",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
