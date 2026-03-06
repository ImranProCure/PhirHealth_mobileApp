import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_consult_controller.dart';

class DoctorConsultView extends GetView<DoctorConsultController> {
  const DoctorConsultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          "Doctor Consult",
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color: Colors.black),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= IMAGE CARD =================
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "assets/Mask group.png",
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: Colors.white,
                  child: const Center(
                    child: Icon(Icons.image, size: 60),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ================= TITLE =================
            const Text(
              "Doctor Consultation",
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              "Connect with certified medical professionals for expert advice and diagnosis.",
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 50),

            // ================= PRIMARY BUTTON =================
            _gradientButton(
              text: "Book a Consultation",
              imagePath: "assets/icons/stethoscope.png",
              onTap: controller.bookConsultation,
            ),

            const SizedBox(height: 15),

            // ================= OUTLINE BUTTON 1 =================
            _outlineButton(
              text: "View Consultation History",
              onTap: controller.viewHistory,
            ),

            const SizedBox(height: 15),

            // ================= OUTLINE BUTTON 2 =================
            _outlineButton(
              text: "Upload Medical Reports",
              onTap: controller.uploadReports,
            ),
          ],
        ),
      ),
    );
  }

  // ================= GRADIENT BUTTON =================
  Widget _gradientButton({
    required String text,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF00786F),
              Color(0xFF009689),
              Color(0xFF1447E6),
            ],
          ),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          onPressed: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 20,
                width: 20,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= OUTLINE BUTTON =================
  Widget _outlineButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Color(0xFF0D9488),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0D9488),
          ),
        ),
      ),
    );
  }
}
