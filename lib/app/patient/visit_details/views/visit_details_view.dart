import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/visit_details_controller.dart';

class VisitDetailsView extends GetView<VisitDetailsController> {
  const VisitDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Obx(() => Text(
              controller.appBarTitle,
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            )),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
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
                    // ===== DOCTOR CARD =====
                    _doctorCard(),
                    const SizedBox(height: 20),

                    // ===== DIGITAL PRESCRIPTION =====
                    _sectionLabel("Doctor's Prescription"),
                    const SizedBox(height: 10),
                    _digitalPrescriptionCard(),
                    const SizedBox(height: 20),

                    // ===== DOCTOR NOTES =====
                    _sectionLabel("Doctor's Notes"),
                    const SizedBox(height: 10),
                    _doctorNotesCard(),
                    const SizedBox(height: 20),

                    // ===== BILL SUMMARY =====
                    _sectionLabel("Bill Summary"),
                    const SizedBox(height: 10),
                    _billSummaryCard(),
                   // const SizedBox(height: 80),
                  ],
                ),
              );
            }),
          ),

          // ===== CALL CLINIC BUTTON =====
          _bottomBar(),
        ],
      ),
    );
  }

  // ===== DOCTOR CARD =====
  Widget _doctorCard() {
    return Obx(() => _card(
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.add_box_outlined,
                  color: Color(0xFF0D9488),
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.doctorName,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      controller.specialty,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: Color(0xFF6B7280)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            controller.clinicAddress,
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  // ===== DIGITAL PRESCRIPTION CARD =====
  Widget _digitalPrescriptionCard() {
    return _card(
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF0D9488).withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.assignment_outlined,
              color: Color(0xFF0D9488),
              size: 30,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "Digital Prescription",
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),

          // Only this text is reactive
          Obx(() => Text(
                controller.prescriptionUpdatedLabel,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              )),
          const SizedBox(height: 16),

          // View button — gradient
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
              onPressed: controller.viewPrescription,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_red_eye_outlined,
                      color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "View",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Download PDF — outlined
          OutlinedButton(
            onPressed: controller.downloadPdf,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              side: const BorderSide(color: Color(0xFF0D9488)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download_outlined,
                    color: Color(0xFF0D9488), size: 18),
                SizedBox(width: 8),
                Text(
                  "Download PDF",
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D9488),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  // ===== DOCTOR NOTES CARD =====
  Widget _doctorNotesCard() {
    return Obx(() => _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.doctorNotes,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF374151),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(
                  height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
              const SizedBox(height: 16),

              // BP | Temp row with vertical separator
              IntrinsicHeight(
                child: Row(
                  children: [
                    // BP
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.monitor_heart_outlined,
                            size: 22,
                            color: Color(0xFFEF4444),
                          ),
                          const SizedBox(width: 10),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontFamily: 'Mulish', fontSize: 13),
                              children: [
                                const TextSpan(
                                  text: "BP: ",
                                  style:
                                      TextStyle(color: Color(0xFF6B7280)),
                                ),
                                TextSpan(
                                  text: controller.bp,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Vertical separator
                    Container(
                      width: 1,
                      color: const Color(0xFFE5E7EB),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),

                    // Temp
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.thermostat_outlined,
                            size: 22,
                            color: Color(0xFFFF9800),
                          ),
                          const SizedBox(width: 10),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontFamily: 'Mulish', fontSize: 13),
                              children: [
                                const TextSpan(
                                  text: "Temp: ",
                                  style:
                                      TextStyle(color: Color(0xFF6B7280)),
                                ),
                                TextSpan(
                                  text: controller.temperature,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ));
  }

  // ===== BILL SUMMARY CARD =====
  Widget _billSummaryCard() {
    return Obx(() => _card(
          child: Column(
            children: [
              // Consultation Fee
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Consultation Fee",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  Text(
                    controller.consultationFee,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Status",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.check_circle,
                          size: 15, color: Color(0xFF0D9488)),
                      const SizedBox(width: 5),
                      Text(
                        controller.paymentStatus,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Download Invoice
              OutlinedButton(
                onPressed: controller.downloadInvoice,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: Color(0xFF0D9488)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long_outlined,
                        color: Color(0xFF0D9488), size: 18),
                    SizedBox(width: 8),
                    Text(
                      "Download Invoice",
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D9488),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  // ===== BOTTOM BAR =====
  Widget _bottomBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF00897B), Color(0xFF1565C0)],
          ),
        ),
        child: ElevatedButton(
          onPressed: controller.callClinic,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.call_outlined, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                "Call Clinic",
                style: TextStyle(
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

  // ===== REUSABLE CARD =====
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // ===== SECTION LABEL =====
  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Mulish',
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }


}