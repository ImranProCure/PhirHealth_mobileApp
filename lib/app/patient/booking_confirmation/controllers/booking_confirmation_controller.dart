import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

// ===================================================
// REPORT ENTRY MODEL
// ===================================================
class ReportEntry {
  final String id;
  File imageFile;
  String subject;
  String reportType;

  ReportEntry({
    required this.id,
    required this.imageFile,
    required this.subject,
    required this.reportType,
  });
}

class BookingConfirmationController extends GetxController {
  // ===== ARGUMENTS =====
  late String selectedDate;
  late String selectedSlot;
  late int tabType;
  late String patientName;
  late String patientId;

  // ===== PAYMENT METHOD =====
  final RxString selectedPayment = ''.obs;

  void selectPayment(String method) {
    selectedPayment.value = method;
  }

  final RxString doctorName = ''.obs;
  final RxString doctorDegree = ''.obs;
  final RxString doctorSpecialty = ''.obs;
  final RxString doctorExperience = ''.obs;
  final RxDouble doctorRating = 0.0.obs;
  final RxInt reviewCount = 0.obs;
  final RxInt fees = 0.obs;
  final RxString doctorImage = ''.obs;
  final RxString clinicName = ''.obs;
  final RxString address = ''.obs;
  final RxMap doctorData = {}.obs;

  final RxDouble walletBalance = 0.0.obs;
  final RxBool isWalletLoading = false.obs;

  // ===== REPORTS =====
  final RxList<ReportEntry> reports = <ReportEntry>[].obs;
  final ImagePicker _picker = ImagePicker();

  final List<String> reportTypes = [
    'Prescription',
    'Lab Report',
    'Medical Bill',
    'X-Ray/Scan',
    'Imaging',
  ];
  Api api = Api.instance;

  String get appointmentType =>
      tabType == 0 ? 'In-Clinic Appointment' : 'Video Consultation';

  String get appBarTitle =>
      tabType == 0 ? 'Book In-Clinic Appointment' : 'Book Video Consultation';

  String get slotTypeLabel =>
      tabType == 0 ? 'Clinic Visit Slots' : 'Video Consult Slots';

  // ================= PICK & ADD REPORT =================
  Future<void> pickAndAddReport() async {
    final source = await Get.bottomSheet<ImageSource>(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Select Image Source",
              style: TextStyle(
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SourceButton(
                    icon: Icons.camera_alt_outlined,
                    label: "Camera",
                    onTap: () => Get.back(result: ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SourceButton(
                    icon: Icons.photo_library_outlined,
                    label: "Gallery",
                    onTap: () => Get.back(result: ImageSource.gallery),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );

    if (source == null) return;

    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked == null) return;

    final result = await Get.dialog<Map<String, String>>(
      ReportDetailsDialog(reportTypes: reportTypes),
      barrierDismissible: false,
    );

    if (result == null) return;

    reports.add(ReportEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imageFile: File(picked.path),
      subject: result['subject'] ?? '',
      reportType: result['reportType'] ?? reportTypes.first,
    ));
  }

  void removeReport(String id) {
    reports.removeWhere((r) => r.id == id);
  }

  // // ===== CONFIRM =====
  // void confirmBooking() {
  // }

  Future<void> fetchWalletBalanceApi() async {
    isWalletLoading.value = true;
    ApiResponse response =
        await api.commonApi.doctorConsultApi.getWalletBalance();
    isWalletLoading.value = false;

    final messageData = response.data['message'];
    if (messageData["status"] == true) {
      walletBalance.value =
          (messageData["data"]["wallet_balance"] as num?)?.toDouble() ?? 0.0;
    } else {
      showError(messageData["message"] ?? "Failed to fetch wallet balance");
    }
  }

// Add a getter for easy insufficient check:
  bool get isWalletInsufficient => walletBalance.value < fees.value;

  @override
  void onInit() {
    super.onInit();
    selectedDate = Get.arguments?['date'] ?? 'Thu, 12 Feb';
    selectedSlot = Get.arguments?['slot'] ?? '03:00 PM';
    tabType = Get.arguments?['tabType'] ?? 0;
    patientName = Get.arguments?['patientName'] ?? '';
    patientId = Get.arguments?['patientId'] ?? '';
    doctorData.value = Get.arguments?['data'] ?? {};

    doctorName.value = doctorData.value['name']?.toString() ?? '';
    doctorDegree.value = doctorData.value['degree']?.toString() ?? '';
    doctorSpecialty.value = doctorData.value['specialty']?.toString() ?? '';
    doctorExperience.value = doctorData.value['experience']?.toString() ?? '';
    doctorRating.value =
        (doctorData.value['rating'] as num?)?.toDouble() ?? 0.0;
    reviewCount.value = (doctorData.value['review_count'] as int?) ?? 0;
    doctorImage.value = doctorData.value['image']?.toString() ?? '';
    fees.value = (doctorData.value['fees'] as int?) ?? 0;
    clinicName.value = doctorData.value['clinic_name']?.toString() ?? '';

    final addr = doctorData.value['address'] as Map<String, dynamic>?;
    if (addr != null) {
      final parts = [
        addr['address_line1']?.toString() ?? '',
        addr['address_line2']?.toString() ?? '',
        addr['city']?.toString() ?? '',
      ].where((s) => s.isNotEmpty).toList();
      address.value = parts.join(', ');
    }
    fetchWalletBalanceApi(); // ← ADD THIS
  }

// ===== CONFIRM =====
  Future<void> confirmBooking() async {
    try {
      // ── Parse start_time & end_time from selectedSlot ──────────────────
      // selectedSlot format: "7:30 AM" or "03:00 PM"
      String startTime = '';
      String endTime = '';

      final timeRegex = RegExp(r'(\d+):(\d+)\s*(AM|PM)', caseSensitive: false);
      final match = timeRegex.firstMatch(selectedSlot);
      if (match != null) {
        int hour = int.parse(match.group(1)!);
        final minute = int.parse(match.group(2)!);
        final period = match.group(3)!.toUpperCase();

        if (period == 'PM' && hour != 12) hour += 12;
        if (period == 'AM' && hour == 12) hour = 0;

        final start = DateTime(0, 1, 1, hour, minute);
        final end = start.add(const Duration(minutes: 30));

        startTime =
            '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}:00';
        endTime =
            '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}:00';
      }

      // ── Call API ────────────────────────────────────────────────────────
      final ApiResponse response =
          await api.commonApi.doctorConsultApi.bookAppointment(
        practitioner: "HLC-PRAC-2026-00002",
        appointmentDate: selectedDate, // "2026-04-27"
        startTime: startTime, // "07:30:00"
        endTime: endTime, // "08:00:00"
        appointmentType:
            appointmentType, // "In-Clinic Appointment" | "Video Consultation"
        fees: fees.value,
        modeOfPayment: selectedPayment.value, // "Wallet" | "PayOnline"
        patientId: patientId,
        reports: reports.map((r) => r.imageFile).toList(),
        reportData: reports
            .map((r) => {
                  'reportType': r.reportType,
                  'subject': r.subject,
                })
            .toList(),
      );

      final messageData = response.data['message'];
      if (messageData['status'] == true) {
        Get.toNamed('/appointment-confirmed', arguments: response.data);
      } else {
        showError(
            messageData['message'] ?? 'Booking failed. Please try again.');
      }
    } catch (e) {
      showError('Something went wrong. Please try again.');
    }
  }
}

// ===================================================
// SOURCE BUTTON HELPER
// ===================================================
class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SourceButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF0D9488).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF0D9488), size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D9488),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================================================
// REPORT DETAILS DIALOG
// ===================================================
class ReportDetailsDialog extends StatefulWidget {
  final List<String> reportTypes;
  const ReportDetailsDialog({super.key, required this.reportTypes});

  @override
  State<ReportDetailsDialog> createState() => _ReportDetailsDialogState();
}

class _ReportDetailsDialogState extends State<ReportDetailsDialog> {
  final subjectCtrl = TextEditingController();
  late String selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = widget.reportTypes.first;
  }

  @override
  void dispose() {
    subjectCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Report Details",
              style: TextStyle(
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Report Subject",
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: subjectCtrl,
              style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
              decoration: InputDecoration(
                hintText: "e.g. Blood Test Report",
                hintStyle: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF0D9488), width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Report Type",
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.reportTypes.map((type) {
                final isSel = selectedType == type;
                return GestureDetector(
                  onTap: () => setState(() => selectedType = type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: isSel
                          ? const Color(0xFF0D9488)
                          : const Color(0xFFF9FAFB),
                      border: Border.all(
                        color: isSel
                            ? const Color(0xFF0D9488)
                            : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSel ? Colors.white : const Color(0xFF374151),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF0D9488)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      minimumSize: const Size(double.infinity, 44),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D9488),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () => Get.back(result: {
                        'subject': subjectCtrl.text.trim(),
                        'reportType': selectedType,
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
