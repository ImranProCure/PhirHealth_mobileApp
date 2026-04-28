import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import '../controllers/booking_confirmation_controller.dart';

class BookingConfirmationView extends GetView<BookingConfirmationController> {
  const BookingConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          controller.appBarTitle,
          style: const TextStyle(
            fontFamily: 'Mulish',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ===== DOCTOR CARD =====
                  _doctorCard(),
                  const SizedBox(height: 12),

                  // ===== APPOINTMENT TIME + SLOT INFO — EK CARD =====
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.access_time_outlined,
                                size: 16, color: Color(0xFF6B7280)),
                            SizedBox(width: 6),
                            Text(
                              "Appointment time",
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 13,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${controller.selectedDate} | ${controller.selectedSlot}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Builder(
                          builder: (context) {
                            final relativeTime = _getRelativeTime(
                              controller.selectedDate,
                              controller.selectedSlot,
                            );
                            return relativeTime.isEmpty
                                ? const SizedBox.shrink()
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3F4F6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                            Icons.hourglass_bottom_outlined,
                                            size: 14,
                                            color: Color(0xFF6B7280)),
                                        const SizedBox(width: 6),
                                        Text(
                                          relativeTime,
                                          style: const TextStyle(
                                            fontFamily: 'Mulish',
                                            fontSize: 12,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                          },
                        ),
                        const SizedBox(height: 14),
                        const Divider(color: Color(0xFFE5E7EB)),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Icon(Icons.add_box_outlined,
                                size: 16, color: Color(0xFF0D9488)),
                            const SizedBox(width: 6),
                            Text(
                              controller.clinicName.value,
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0D9488),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 16, color: Color(0xFF6B7280)),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                controller.address.value,
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 13,
                                  color: Color(0xFF374151),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
// Inside build() → Column → after appointment time card:
                  const SizedBox(height: 12),
                  _reportsCard(), // ← ADD THIS
                  const SizedBox(height: 12),
                  _paymentCard(),
                  const SizedBox(height: 12),

                  // ===== BILL DETAILS =====
                  _billDetailsCard(),
                ],
              ),
            ),
          ),

          // ===== BOTTOM BAR =====
          _bottomBar(),
        ],
      ),
    );
  }

  String _getRelativeTime(String selectedDate, String selectedSlot) {
    try {
      // Parse the date (format: 2026-04-27)
      final dateParts = selectedDate.split('-');
      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);

      // Parse the time slot (format: 7:30 AM)
      final timeRegex = RegExp(r'(\d+):(\d+)\s*(AM|PM)', caseSensitive: false);
      final match = timeRegex.firstMatch(selectedSlot);
      if (match == null) return '';

      int hour = int.parse(match.group(1)!);
      final minute = int.parse(match.group(2)!);
      final period = match.group(3)!.toUpperCase();

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      final slotDateTime = DateTime(year, month, day, hour, minute);
      final now = DateTime.now();
      final diff = slotDateTime.difference(now);

      if (diff.isNegative) {
        // Past
        final absDiff = diff.abs();
        if (absDiff.inDays >= 1)
          return "${absDiff.inDays} day${absDiff.inDays > 1 ? 's' : ''} ago";
        if (absDiff.inHours >= 1)
          return "${absDiff.inHours} hour${absDiff.inHours > 1 ? 's' : ''} ago";
        return "${absDiff.inMinutes} minute${absDiff.inMinutes > 1 ? 's' : ''} ago";
      } else {
        // Future
        if (diff.inDays >= 1)
          return "in ${diff.inDays} day${diff.inDays > 1 ? 's' : ''}";
        if (diff.inHours >= 1)
          return "in ${diff.inHours} hour${diff.inHours > 1 ? 's' : ''}";
        return "in ${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''}";
      }
    } catch (e) {
      return '';
    }
  }

  // ===================================================
// REPORTS CARD  (optional)
// ===================================================
  Widget _reportsCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Header row ----
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.folder_open_outlined,
                  size: 16,
                  color: Color(0xFF0D9488),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Attach Reports",
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Optional · Share with doctor before visit",
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              // Optional badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Optional",
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),

          // ---- Existing report cards ----
          Obx(() {
            if (controller.reports.isEmpty) return const SizedBox(height: 14);
            return Column(
              children: [
                const SizedBox(height: 14),
                ...controller.reports.map(
                  (report) => _ReportCard(
                    report: report,
                    onRemove: () => controller.removeReport(report.id),
                  ),
                ),
              ],
            );
          }),

          // ---- Add File button ----
          const SizedBox(height: 4),
          GestureDetector(
            onTap: controller.pickAndAddReport,
            child: DottedBorderBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF0D9488).withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 16,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Add File",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Supported: Prescription, Lab Report, X-Ray, Imaging, Medical Bill",
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 10,
              color: Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ================= DOCTOR CARD =================
  Widget _doctorCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Obx(() => Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: controller.doctorImage.value.isNotEmpty
                        ? Image.network(
                            ApiConstants.baseUrl + controller.doctorImage.value,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _doctorImageFallback(),
                          )
                        : _doctorImageFallback(),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.doctorName.value,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          controller.doctorSpecialty.value,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          controller.doctorDegree.value,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //const Icon(Icons.favorite_border, color: Colors.black54),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _InfoItem(Icons.work_outline,
                      "${controller.doctorExperience.value} Years Exp."),
                  const _VerticalDivider(),
                  _InfoItem(Icons.star,
                      "${controller.doctorRating.value.toStringAsFixed(1)}"),
                  const _VerticalDivider(),
                  _InfoItem(Icons.chat_bubble_outline,
                      "${controller.reviewCount.value} Review"),
                ],
              ),
            ],
          )),
    );
  }

  Widget _doctorImageFallback() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E7FF),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 40, color: Color(0xFF3730A3)),
    );
  }

  // ===== SLOT INFO CARD =====
  Widget _slotInfoCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.add_box_outlined,
                  size: 16, color: Color(0xFF0D9488)),
              const SizedBox(width: 6),
              Text(
                controller.slotTypeLabel,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0D9488),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE5E7EB)),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.location_on_outlined,
                  size: 16, color: Color(0xFF6B7280)),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  "Rasoma Square, AB Rd, Vijay Nagar, Indore",
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _paymentCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment Options",
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Obx(() {
            final insufficient = controller.isWalletInsufficient;
            final isLoading = controller.isWalletLoading.value;

            return Row(
              children: [
                // ---- Pay Online ----
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.selectPayment('PayOnline'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.selectedPayment.value == 'PayOnline'
                              ? const Color(0xFF0D9488)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Pay Online",
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "₹${controller.fees.value}",
                                style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          _radioCircle(
                              controller.selectedPayment.value == 'PayOnline'),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // ---- Wallet (disabled if insufficient) ----
                Expanded(
                  child: GestureDetector(
                    onTap: insufficient || isLoading
                        ? null // disabled
                        : () => controller.selectPayment('Wallet'),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: insufficient
                            ? const Color(0xFFF9FAFB)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: insufficient
                              ? const Color(0xFFE5E7EB)
                              : controller.selectedPayment.value == 'Wallet'
                                  ? const Color(0xFF0D9488)
                                  : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top row: label + radio
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Wallet",
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: insufficient
                                      ? const Color(0xFFD1D5DB)
                                      : Colors.black,
                                ),
                              ),
                              _radioCircle(
                                controller.selectedPayment.value == 'Wallet' &&
                                    !insufficient,
                                disabled: insufficient,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Balance row
                          isLoading
                              ? const SizedBox(
                                  height: 14,
                                  width: 14,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF0D9488),
                                    strokeWidth: 1.5,
                                  ),
                                )
                              : Text(
                                  "₹${controller.walletBalance.value.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: insufficient
                                        ? const Color(0xFFD1D5DB)
                                        : Colors.black,
                                  ),
                                ),

                          // Insufficient warning
                          if (insufficient && !isLoading) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: const [
                                Icon(Icons.info_outline,
                                    size: 11, color: Color(0xFFF59E0B)),
                                SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    "Insufficient balance",
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 10,
                                      color: Color(0xFFF59E0B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _radioCircle(bool selected, {bool disabled = false}) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: disabled
              ? const Color(0xFFE5E7EB)
              : selected
                  ? const Color(0xFF0D9488)
                  : const Color(0xFFD1D5DB),
          width: 1.5,
        ),
      ),
      child: selected && !disabled
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF0D9488),
                ),
              ),
            )
          : null,
    );
  }

  // ===== BILL DETAILS CARD =====
  Widget _billDetailsCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bill Details",
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),

          // Consultation fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Consultation Fee",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),
              Text(
                "₹${controller.fees.value.toString()}",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 13,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Services fee
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Row(
          //       children: const [
          //         Text(
          //           "Services Fee & Tax",
          //           style: TextStyle(
          //             fontFamily: 'Mulish',
          //             fontSize: 13,
          //             color: Color(0xFF6B7280),
          //           ),
          //         ),
          //         SizedBox(width: 4),
          //         Icon(Icons.info_outline, size: 14, color: Color(0xFF9CA3AF)),
          //       ],
          //     ),
          //     Row(
          //       children: const [
          //         Text(
          //           "₹69 ",
          //           style: TextStyle(
          //             fontFamily: 'Mulish',
          //             fontSize: 13,
          //             color: Color(0xFF9CA3AF),
          //             decoration: TextDecoration.lineThrough,
          //           ),
          //         ),
          //         Text(
          //           "FREE",
          //           style: TextStyle(
          //             fontFamily: 'Mulish',
          //             fontSize: 13,
          //             fontWeight: FontWeight.w700,
          //             color: Color(0xFF0D9488),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 6),

          // const Text(
          //   "We care for you & provide a free booking",
          //   style: TextStyle(
          //     fontFamily: 'Mulish',
          //     fontSize: 11,
          //     color: Color(0xFF0D9488),
          //   ),
          // ),

          // const SizedBox(height: 12),
          // const Divider(color: Color(0xFFE5E7EB)),
          // const SizedBox(height: 12),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "₹${controller.fees.value.toString()}",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          // const SizedBox(height: 12),

          // Saved amount
          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          //   decoration: BoxDecoration(
          //     color: const Color(0xFFE0F2F1),
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          //   child: Row(
          //     children: const [
          //       Text("🎉", style: TextStyle(fontSize: 14)),
          //       SizedBox(width: 8),
          //       Text(
          //         "You have saved ₹49 on this appointment",
          //         style: TextStyle(
          //           fontFamily: 'Mulish',
          //           fontSize: 12,
          //           color: Color(0xFF0D9488),
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  // ===== BOTTOM BAR =====
  Widget _bottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ===== TOP ROW: Patient info =====
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    controller.patientName
                        .split(' ')
                        .map((e) => e[0])
                        .take(2)
                        .join(),
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.patientName,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "${controller.appointmentType} for",
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.back();
                  },
                  child: const Text(
                    "CHANGE",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // ===== BOTTOM ROW: Price + Confirm button =====
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            child: Row(
              children: [
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "₹${controller.fees.value.toString()}",
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      "View Bill",
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        color: Color(0xFF0D9488),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Confirm button
                Expanded(
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
                      onPressed: controller.confirmBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            controller.tabType == 0
                                ? Icons.add_box_outlined
                                : Icons.videocam_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            controller.tabType == 0
                                ? "Confirm Clinic Visit"
                                : "Confirm Video Visit",
                            style: const TextStyle(
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
                ),
              ],
            ),
          ),
        ],
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
}

// ===== REUSABLE SMALL WIDGETS =====
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black54),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(fontFamily: 'Mulish', fontSize: 12),
        ),
      ],
    );
  }
}

class _VDivider extends StatelessWidget {
  const _VDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 20, width: 1, color: const Color(0xFFE5E7EB));
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 22, width: 1, color: const Color(0xFFE5E7EB));
  }
}

// ===================================================
// DOTTED BORDER BOX  (pure Flutter — no extra package)
// ===================================================
class DottedBorderBox extends StatelessWidget {
  final Widget child;
  const DottedBorderBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: child,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 6;
    const double dashSpace = 4;
    final paint = Paint()
      ..color = const Color(0xFF0D9488)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    const radius = Radius.circular(12);
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, radius);
    final path = Path()..addRRect(rrect);

    final PathMetrics metrics = path.computeMetrics();
    for (final PathMetric metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final extracted = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extracted, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) => false;
}

// ===================================================
// REPORT CARD
// ===================================================
class _ReportCard extends StatelessWidget {
  final ReportEntry report;
  final VoidCallback onRemove;
  const _ReportCard({required this.report, required this.onRemove});

  IconData _iconForType(String type) {
    switch (type) {
      case 'Prescription':
        return Icons.medication_outlined;
      case 'Lab Report':
        return Icons.science_outlined;
      case 'Medical Bill':
        return Icons.receipt_long_outlined;
      case 'X-Ray/Scan':
        return Icons.blur_on_outlined;
      case 'Imaging':
        return Icons.image_search_outlined;
      default:
        return Icons.description_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              report.imageFile,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.subject.isEmpty ? "No subject" : report.subject,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(_iconForType(report.reportType),
                        size: 12, color: const Color(0xFF0D9488)),
                    const SizedBox(width: 4),
                    Text(
                      report.reportType,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 11,
                        color: Color(0xFF0D9488),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Remove
          GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEDED),
                borderRadius: BorderRadius.circular(7),
              ),
              child:
                  const Icon(Icons.close, size: 13, color: Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }
}
