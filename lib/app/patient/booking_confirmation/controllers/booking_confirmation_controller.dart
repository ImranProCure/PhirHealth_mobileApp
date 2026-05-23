import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/db/db.dart';

const String _redirectScheme = 'phirhealth://';

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

// ===================================================
// CONTROLLER
// ===================================================
class BookingConfirmationController extends GetxController {
  // ===== ARGUMENTS =====
  late String selectedDate;
  late String selectedSlot;
  late int tabType;
  late String patientName;
  late String patientId;

  // ===== PAYMENT =====
  final RxString selectedPayment = ''.obs;
  void selectPayment(String method) => selectedPayment.value = method;

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
  final RxString type = ''.obs;
  final RxString id = ''.obs;
  final RxMap doctorData = {}.obs;

  final RxDouble walletBalance = 0.0.obs;
  final RxBool isWalletLoading = false.obs;
  final RxBool isBookingLoading = false.obs;

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
  final authStorage = AuthStorageService();

  String get appointmentType => tabType == 0
      ? 'patient_book_clinic_type'.tr
      : 'patient_book_video_type'.tr;

  String get appBarTitle => tabType == 0
      ? 'patient_book_clinic_title'.tr
      : 'patient_book_video_title'.tr;

  String get slotTypeLabel => tabType == 0
      ? 'patient_book_clinic_slots'.tr
      : 'patient_book_video_slots'.tr;

  bool get isWalletInsufficient => walletBalance.value < fees.value;

  // ─────────────────────────────────────────────
  // INIT
  // ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    selectedDate = Get.arguments?['date'] ?? 'Thu, 12 Feb';
    selectedSlot = Get.arguments?['slot'] ?? '03:00 PM';
    tabType = Get.arguments?['tabType'] ?? 0;
    patientName = Get.arguments?['patientName'] ?? '';
    patientId = Get.arguments?['patientId'] ?? '';
    doctorData.value = Get.arguments?['data'] ?? {};
    type.value = Get.arguments?['type']?.toString() ?? '';
    id.value = Get.arguments?['id']?.toString() ?? '';
    
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

    fetchWalletBalanceApi();
  }

  // ─────────────────────────────────────────────
  // CONFIRM BOOKING — entry point from UI button
  // ─────────────────────────────────────────────
  Future<void> confirmBooking() async {
    if (selectedPayment.value == 'Online') {
      await _initiateOnlinePayment();
    } else {
      await _callBookingApi(); // Wallet — no gateway needed
    }
  }

  // ─────────────────────────────────────────────
  // STEP 1 — Create PhonePe Payment Link
  // ─────────────────────────────────────────────
  Future<void> _initiateOnlinePayment() async {
    try {
      isBookingLoading.value = true;

      final data = await authStorage.getUserDetail();
      final mobile = data!['mobile_no'] ?? '';
      final email = data['email'] ?? '';

      final ApiResponse linkResponse =
          await api.commonApi.phonePayApi.createPaymentLink(
        merchantReferenceId: id.value,
        customerName: patientId,
        amount: fees.value.toDouble(),
        phoneNo: mobile,
        email: email,
       // redirectUrl: '${_redirectScheme}payment/callback',
      );

      isBookingLoading.value = false;

      final linkMessage = linkResponse.data['message'];
      if (linkMessage == null || linkMessage['success'] != true) {
        showError(linkMessage?['message'] ?? 'Failed to create payment link.');
        return;
      }

      final linkData = linkMessage['data'] as Map<String, dynamic>;
      final String paymentLink = linkData['payment_link']?.toString() ?? '';
      final String paymentId = linkData['payment_id']?.toString() ?? '';

      if (paymentLink.isEmpty) {
        showError('Payment link is empty. Please try again.');
        return;
      }

      // ── Suspend here until user finishes / cancels payment ───────────────
      final String? callbackUrl =
          await _launchPaymentAndWaitForCallback(paymentLink);




      // ── User closed the webview without completing payment ───────────────
      if (callbackUrl == null) {
        showError('Payment was cancelled. Please try again.');
        return;
      }

      // ── Parse status & payment_id from callback URL ──────────────────────
      // e.g. yourapp://payment/callback?status=SUCCESS&payment_id=xxx
      final Uri callbackUri = Uri.parse(callbackUrl);
      final String status =
          callbackUri.queryParameters['status']?.toUpperCase() ?? '';
      final String returnedPaymentId =
          callbackUri.queryParameters['payment_id'] ?? paymentId;

      debugPrint('[Payment] Callback URL : $callbackUrl');
      debugPrint('[Payment] Status       : $status');
      debugPrint('[Payment] Payment ID   : $returnedPaymentId');

      // if (status == 'SUCCESS') {
      //   await _createPaymentTransaction(
      //     paymentId: returnedPaymentId,
      //     merchantReferenceId: id.value,
      //     status: 'SUCCESS',
      //   );
      // } else if (status == 'PENDING') {
      //   // Record as PENDING — backend verifies via webhook
      //   await _createPaymentTransaction(
      //     paymentId: returnedPaymentId,
      //     merchantReferenceId: id.value,
      //     status: 'PENDING',
      //   );
      // } else {
      //   // FAILED or unknown
      //   showError('Payment failed. Please try again.');
      // }
    } catch (e) {
      isBookingLoading.value = false;
      debugPrint('[Payment] Exception: $e');
      showError('Unable to initiate payment. Please try again.');
    }
  }

  // ─────────────────────────────────────────────
  // LAUNCH — opens InAppWebView without awaiting
  // Get.to, then suspends on completer.future.
  // Resolves ONLY when:
  //   • PhonePe redirects  → onRedirect(url)
  //   • User closes webview → onCancelled()
  // ─────────────────────────────────────────────
  Future<String?> _launchPaymentAndWaitForCallback(String paymentLink) async {
    final completer = Completer<String?>();

    // Do NOT await — Get.to returns immediately.
    // The completer stays open until the webview fires a callback.
    Get.to(
      () => _InAppPaymentPage(
        paymentUrl: paymentLink,
        redirectScheme: _redirectScheme,
        onRedirect: (url) {
          if (!completer.isCompleted) completer.complete(url);
        },
        onCancelled: () {
          if (!completer.isCompleted) completer.complete(null);
        },
      ),
      transition: Transition.downToUp,
    );

    // Suspends here until onRedirect OR onCancelled fires
    return completer.future;
  }

  // ─────────────────────────────────────────────
  // STEP 2 — Record Payment Transaction
  // Called only after redirect confirms outcome
  // ─────────────────────────────────────────────
  Future<void> _createPaymentTransaction({
    required String paymentId,
    required String merchantReferenceId,
    String status = 'SUCCESS',
  }) async {
    try {
      isBookingLoading.value = true;

      final String transactionDate = DateTime.now()
          .toIso8601String()
          .replaceFirst('T', ' ')
          .substring(0, 19);

      final ApiResponse txnResponse =
          await api.commonApi.phonePayApi.createPaymentTransaction(
        transactionDate: transactionDate,
        transactionId: paymentId,
        merchantReferenceId: merchantReferenceId,
        customer: patientId,
        phonePeTransactionId: paymentId,
        mandateType: 'UPI',
        instrumentBreakdown: {'mode': 'UPI', 'bank': ''},
        transactionNote: 'Appointment payment',
        amount: fees.value.toDouble(),
        status: status,
      );

      isBookingLoading.value = false;

      final txnMessage = txnResponse.data['message'];
      if (txnMessage == null || txnMessage['success'] != true) {
        showError(txnMessage?['message'] ?? 'Failed to record transaction.');
        return;
      }

      // Proceed to booking only for SUCCESS or PENDING
      if (status != 'FAILED') {
        await _callBookingApi(transactionId: paymentId);
      }
    } catch (e) {
      isBookingLoading.value = false;
      debugPrint('[Transaction] Exception: $e');
      showError('Failed to record payment. Please contact support.');
    }
  }

  // ─────────────────────────────────────────────
  // STEP 3 — Book Appointment
  // Called after payment transaction recorded
  // OR directly for Wallet payments
  // ─────────────────────────────────────────────
  Future<void> _callBookingApi({String transactionId = ''}) async {
    try {
      isBookingLoading.value = true;

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

      final String doctorId = Get.arguments?['id']?.toString() ?? '';

      final ApiResponse response =
          await api.commonApi.doctorConsultApi.bookAppointment(
        practitioner: doctorId,
        appointmentDate: selectedDate,
        startTime: startTime,
        endTime: endTime,
        appointmentType: appointmentType,
        fees: fees.value,
        modeOfPayment: selectedPayment.value,
        patientId: patientId,
        reports: reports.map((r) => r.imageFile).toList(),
        reportData: reports
            .map((r) => {'reportType': r.reportType, 'subject': r.subject})
            .toList(),
        type: type.value,
        transactionId: transactionId,
      );

      isBookingLoading.value = false;

      final messageData = response.data['message'];
      if (messageData['status'] == true) {
        Get.toNamed('/appointment-confirmed', arguments: response.data);
      } else {
        showError(
            messageData['message'] ?? 'Booking failed. Please try again.');
      }
    } catch (e) {
      isBookingLoading.value = false;
      debugPrint('[Booking] Exception: $e');
      showError('Something went wrong. Please try again.');
    }
  }

  // ─────────────────────────────────────────────
  // WALLET BALANCE
  // ─────────────────────────────────────────────
  Future<void> fetchWalletBalanceApi() async {
    isWalletLoading.value = true;
    final ApiResponse response =
        await api.commonApi.doctorConsultApi.getWalletBalance();
    isWalletLoading.value = false;

    final messageData = response.data['message'];
    if (messageData['status'] == true) {
      walletBalance.value =
          (messageData['data']['wallet_balance'] as num?)?.toDouble() ?? 0.0;
    } else {
      showError(messageData['message'] ?? 'Failed to fetch wallet balance');
    }
  }

  // ─────────────────────────────────────────────
  // REPORTS — pick & remove
  // ─────────────────────────────────────────────
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
              'Select Image Source',
              style: TextStyle(
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _SourceButton(
                        icon: Icons.camera_alt_outlined,
                        label: 'Camera',
                        onTap: () => Get.back(result: ImageSource.camera))),
                const SizedBox(width: 12),
                Expanded(
                    child: _SourceButton(
                        icon: Icons.photo_library_outlined,
                        label: 'Gallery',
                        onTap: () => Get.back(result: ImageSource.gallery))),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );

    if (source == null) return;

    final XFile? picked =
        await _picker.pickImage(source: source, imageQuality: 85);
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

  void removeReport(String id) => reports.removeWhere((r) => r.id == id);
}

// ===================================================
// IN-APP PAYMENT WEBVIEW PAGE
// ===================================================
class _InAppPaymentPage extends StatelessWidget {
  final String paymentUrl;
  final String redirectScheme;
  final void Function(String url) onRedirect;
  final VoidCallback onCancelled;

  const _InAppPaymentPage({
    required this.paymentUrl,
    required this.redirectScheme,
    required this.onRedirect,
    required this.onCancelled,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) => onCancelled(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Complete Payment',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              onCancelled();
              Get.back();
            },
          ),
          backgroundColor: const Color(0xFF0D9488),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(paymentUrl)),
          initialSettings: InAppWebViewSettings(
            useShouldOverrideUrlLoading: true,
            javaScriptEnabled: true,
            domStorageEnabled: true,
            useHybridComposition: true,
            allowsInlineMediaPlayback: true,
          ),
          // Fires before EVERY navigation — catches PhonePe redirect
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            final url = navigationAction.request.url?.toString() ?? '';
            debugPrint('[WebView] Navigating to: $url');

            if (url.startsWith(redirectScheme)) {
              onRedirect(url);
              Get.back();
              return NavigationActionPolicy.CANCEL;
            }

            return NavigationActionPolicy.ALLOW;
          },
        ),
      ),
    );
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
              'Report Details',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Report Subject',
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
                hintText: 'e.g. Blood Test Report',
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
              'Report Type',
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
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
                        color:
                            isSel ? Colors.white : const Color(0xFF374151),
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
                      'Cancel',
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
                        'Confirm',
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