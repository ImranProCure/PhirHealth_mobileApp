import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_patient_detail_controller.dart';

class DoctorPatientDetailView extends GetView<DoctorPatientDetailController> {
  const DoctorPatientDetailView({super.key});

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
        title: const Text('Patient Details',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
      // ✅ FIX: Obx wrap kiya - ab API data aane pe screen rebuild hogi
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF0D9488),
            ),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== PATIENT CARD =====
              _whiteCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Text(controller.patientInitials,
                                style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(controller.patientName,
                                style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black)),
                            const SizedBox(height: 4),
                            Text(controller.patientInfo,
                                style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 13,
                                    color: Color(0xFF6B7280))),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Color(0xFFE5E7EB)),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _actionBtn(
                            Icons.call_outlined, 'Call', controller.onCall),
                        _actionBtn(Icons.chat_bubble_outline, 'Chat',
                            controller.onChat),
                        _actionBtn(Icons.assignment_outlined, 'Records',
                            controller.onRecords),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ===== SESSION INFORMATION =====
              _whiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Session Information',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.black)),
                    const SizedBox(height: 14),
                    _infoRow(Icons.access_time_outlined, 'Chief Complaint',
                        controller.complaint),
                    const SizedBox(height: 12),
                    _infoRow(Icons.calendar_month_outlined, 'Date & Time',
                        controller.dateTime),
                    const SizedBox(height: 12),
                    _infoRow(Icons.video_call_outlined, 'Session Type',
                        controller.sessionType),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.currency_rupee_outlined,
                              size: 18, color: Color(0xFF6B7280)),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Earnings',
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 12,
                                    color: Color(0xFF6B7280))),
                            const SizedBox(height: 3),
                            Text(controller.earnings,
                                style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0D9488))),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ===== PATIENT'S DESCRIPTION =====
              _whiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Patient's Description",
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.black)),
                    const SizedBox(height: 10),
                    Text(controller.description,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            color: Color(0xFF374151),
                            height: 1.6)),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFFBFDBFE), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.info_outline,
                                  size: 14, color: Color(0xFF3B82F6)),
                              SizedBox(width: 6),
                              Text('Alert/Allergies',
                                  style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1E40AF))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(controller.alertText,
                              style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 13,
                                  color: Color(0xFF1E40AF))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ===== VITALS & MEDICAL NOTES =====
              _whiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Vitals & Medical Notes',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.black)),
                    const SizedBox(height: 12),
                    ...controller.vitals.map((v) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                margin:
                                    const EdgeInsets.only(top: 6, right: 10),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0D9488),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Text(v,
                                    style: const TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 13,
                                        color: Color(0xFF374151),
                                        height: 1.4)),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ===== CONTACT DETAILS =====
              _whiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Contact Details',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.black)),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(Icons.email_outlined,
                            size: 18, color: Color(0xFF6B7280)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Email',
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 12,
                                    color: Color(0xFF6B7280))),
                            const SizedBox(height: 2),
                            Text(controller.email,
                                style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.phone_outlined,
                            size: 18, color: Color(0xFF6B7280)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Phone',
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 12,
                                    color: Color(0xFF6B7280))),
                            const SizedBox(height: 2),
                            Text(controller.phone,
                                style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ===== START CONSULTATION =====
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
                    onPressed: controller.startConsultation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    icon: const Icon(Icons.video_call_outlined,
                        color: Colors.white, size: 20),
                    label: const Text('Start Consultation',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // ===== RESCHEDULE + CANCEL =====
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: controller.reschedule,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFF0D9488), width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('Reschedule',
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D9488))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: controller.cancelSession,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFF0D9488), width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('Cancel Session',
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
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _whiteCard({required Widget child}) {
    return Container(
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
      child: child,
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 18, color: const Color(0xFF6B7280)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      color: Color(0xFF6B7280))),
              const SizedBox(height: 3),
              Text(value,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      height: 1.3)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 22, color: const Color(0xFF374151)),
          const SizedBox(height: 5),
          Text(label,
              style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 12,
                  color: Color(0xFF374151))),
        ],
      ),
    );
  }
}
