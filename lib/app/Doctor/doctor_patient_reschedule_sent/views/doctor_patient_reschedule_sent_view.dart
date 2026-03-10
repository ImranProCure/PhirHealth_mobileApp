import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorPatientRescheduleSentView extends StatelessWidget {
  const DoctorPatientRescheduleSentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.offAllNamed('/doctor-dashboard'),
        ),
        centerTitle: true,
        title: const Text('Your Activity',
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
            children: [
              const Spacer(),

              // ===== TITLE =====
              const Text(
                'Reschedule\nRequest Sent!',
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'The patient will be notified about the new date and time. You will receive a confirmation once they accept.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.5),
                ),
              ),
              const SizedBox(height: 24),

              // ===== NEW SCHEDULE BOX =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('New Schedule:',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              color: Color(0xFF374151))),
                      SizedBox(height: 6),
                      Text('Tomorrow, Dec 10 at 6:00 AM',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0D9488))),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // ===== GO TO SESSION =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => Get.offAllNamed('/doctor-todays-session'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color(0xFF0D9488), width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Go to Session',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0D9488))),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // ===== GO HOME =====
              GestureDetector(
                onTap: () => Get.offAllNamed('/doctor-dashboard'),
                child: const Text('Go Home',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    )),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
