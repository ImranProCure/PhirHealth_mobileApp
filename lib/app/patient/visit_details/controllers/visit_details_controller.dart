import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitDetailsController extends GetxController {
  // ===== API =====
  Api api = Api.instance;

  // ===== ARGUMENTS =====
  late Map<String, dynamic> visit;

  // ===== LOADING / ERROR STATE =====
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isDownloading = false.obs;
  final RxDouble downloadProgress = 0.0.obs;

  // ===== VISIT DETAIL DATA =====
  final Rx<Map<String, dynamic>> visitDetail = Rx<Map<String, dynamic>>({});

  // ===== COMPUTED GETTERS =====
  String get doctorName => visitDetail.value['doctor']?['name'] != null
      ? 'Dr. ${visitDetail.value['doctor']['name']}'
      : visit['doctor'] ?? 'Dr. Jyoti Wadhwani';

  String get specialty =>
      visitDetail.value['doctor']?['specialty'] ??
      visit['specialty'] ??
      'General Physician';

  String get clinicAddress =>
      visitDetail.value['doctor']?['address'] ?? 'Bombay Hospital, Indore';

  String get clinicPhone => visitDetail.value['doctor']?['clinic_phone'] ?? '';

  String get doctorNotes =>
      visitDetail.value['doctor_notes'] ?? 'No notes available.';

  String get bp => visitDetail.value['vitals']?['bp'] != null
      ? '${visitDetail.value['vitals']['bp']}'
      : 'N/A';

  String get temperature => visitDetail.value['vitals']?['temperature'] != null
      ? '${visitDetail.value['vitals']['temperature']} F'
      : 'N/A';

  String get consultationFee {
    final fee = visitDetail.value['bill_summary']?['consultation_fee'];
    if (fee == null) return '₹0';
    return '₹${fee.toStringAsFixed(0)}';
  }

  String get paymentStatus =>
      visitDetail.value['bill_summary']?['payment_status'] ?? 'Paid via UPI';

  List<String> get prescriptionImages {
    final images = visitDetail.value['prescription']?['prescription_images'];
    if (images == null) return [];
    return List<String>.from(images);
  }

  String get invoicePdfUrl =>
      visitDetail.value['bill_summary']?['invoice_url'] ?? '';

  String get prescriptionUpdatedLabel {
    final rawDate = visitDetail.value['appointment_date'] as String? ?? '';
    final rawTime = visitDetail.value['appointment_time'] as String? ??
        visit['time'] as String? ??
        '';
    if (rawDate.isNotEmpty) {
      try {
        final date = DateFormat('yyyy-MM-dd').parse(rawDate);
        final formatted = DateFormat('dd MMM').format(date);
        return 'Updated on $formatted${rawTime.isNotEmpty ? ', $rawTime' : ''}';
      } catch (_) {}
    }
    return 'Updated on 12 Feb, 11:00 AM';
  }

  String get appBarTitle {
    final rawDate = visitDetail.value['appointment_date'] as String? ??
        visit['appointment_date'] as String? ??
        '';
    if (rawDate.isNotEmpty) {
      try {
        final date = DateFormat('yyyy-MM-dd').parse(rawDate);
        return 'Visit on ${DateFormat('d MMM yyyy').format(date)}';
      } catch (_) {}
    }
    return 'Visit Details';
  }

  // ===== LIFECYCLE =====
  @override
  void onInit() {
    super.onInit();
    visit = Get.arguments?['visit'] ??
        {
          "month": "February 2026",
          "date_short": "FEB\n12",
          "doctor": "Dr. Jyoti Wadhwani",
          "specialty": "General Physician",
          "time": "10:30 AM",
          "type": "Video Call",
          "status": "Completed",
          "note": "",
        };
    fetchVisitDetails();
  }

  // ===== FETCH =====
  Future<void> fetchVisitDetails() async {
    final appointmentId = visit['appointment_id'];
    if (appointmentId == null) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      ApiResponse response = await api.commonApi.doctorVisitApi
          .getVisitDetails(queryParams: {"appointment_id": appointmentId});

      final messageData = response.data['message'];

      if (messageData['status'] == true) {
        visitDetail.value =
            Map<String, dynamic>.from(messageData['data'] as Map);
      } else {
        errorMessage.value =
            messageData['message'] ?? 'Failed to fetch visit details';
        showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong: $e';
      showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // ===== ACTIONS =====

  /// Opens an inline full-screen image gallery dialog
  void viewPrescription() {
    if (prescriptionImages.isEmpty) {
      Get.snackbar(
        "No Prescription",
        "No prescription images available.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF6B7280),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    final RxInt currentIndex = 0.obs;
    final PageController pageController = PageController();

    Get.dialog(
      Dialog.fullscreen(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Obx(() => Text(
                  'Prescription (${currentIndex.value + 1}/${prescriptionImages.length})',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                )),
            actions: [
              Obx(() => isDownloading.value
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          value: downloadProgress.value > 0
                              ? downloadProgress.value
                              : null,
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.download_rounded,
                          color: Colors.white),
                      tooltip: 'Download PDF',
                      onPressed: downloadPdf,
                    )),
            ],
          ),
          body: Column(
            children: [
              // ── Image pager ──
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: prescriptionImages.length,
                  onPageChanged: (i) => currentIndex.value = i,
                  itemBuilder: (context, index) {
                    return InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Center(
                        child: Image.network(
                          ApiConstants.baseUrl + prescriptionImages[index],
                          fit: BoxFit.contain,
                          loadingBuilder: (ctx, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          },
                          errorBuilder: (ctx, err, stack) => const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image,
                                  color: Colors.white54, size: 64),
                              SizedBox(height: 8),
                              Text('Failed to load image',
                                  style: TextStyle(color: Colors.white54)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ── Dot indicators (only if multiple images) ──
              if (prescriptionImages.length > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        prescriptionImages.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: currentIndex.value == i ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: currentIndex.value == i
                                ? Colors.white
                                : Colors.white38,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Downloads all prescription images, compiles them into a single PDF, and opens it
  Future<void> downloadPdf() async {
    if (prescriptionImages.isEmpty) {
      Get.snackbar(
        "Unavailable",
        "No prescription images to download.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF6B7280),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (isDownloading.value) return;

    try {
      isDownloading.value = true;
      downloadProgress.value = 0.0;

      Get.snackbar(
        "Preparing Prescription",
        "Downloading images...",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D9488),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 60),
        isDismissible: false,
      );

      final dio = Dio();
      final dir = await getTemporaryDirectory();
      final List<File> imageFiles = [];

      // Download each image with progress tracking
      for (int i = 0; i < prescriptionImages.length; i++) {
        final imgPath = '${dir.path}/prescription_img_$i.jpg';
        await dio.download(
          ApiConstants.baseUrl + prescriptionImages[i],
          imgPath,
          onReceiveProgress: (received, total) {
            if (total > 0) {
              // Overall progress = current image progress fraction + completed images fraction
              downloadProgress.value =
                  (i + (received / total)) / prescriptionImages.length;
            }
          },
        );
        imageFiles.add(File(imgPath));
      }

      // Build PDF with all images
      final pdf = pw.Document();

      for (final imgFile in imageFiles) {
        final imageBytes = await imgFile.readAsBytes();
        final pdfImage = pw.MemoryImage(imageBytes);

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.zero,
            build: (pw.Context context) => pw.Center(
              child: pw.Image(pdfImage, fit: pw.BoxFit.contain),
            ),
          ),
        );
      }

      // Save PDF
      final docsDir = await getApplicationDocumentsDirectory();
      final fileName =
          'prescription_${visit['appointment_id'] ?? DateTime.now().millisecondsSinceEpoch}.pdf';
      final pdfFile = File('${docsDir.path}/$fileName');
      await pdfFile.writeAsBytes(await pdf.save());

      // Clean up temp image files
      for (final f in imageFiles) {
        if (await f.exists()) await f.delete();
      }

      if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

      Get.snackbar(
        "Download Complete",
        "Opening prescription PDF...",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D9488),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );

      await OpenFile.open(pdfFile.path);
    } catch (e) {
      if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
      Get.snackbar(
        "Download Failed",
        "Could not prepare prescription PDF. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isDownloading.value = false;
      downloadProgress.value = 0.0;
    }
  }

  Future<void> downloadInvoice() async {
    final url = invoicePdfUrl;

    if (url.isEmpty) {
      Get.snackbar(
        "Unavailable",
        "Invoice PDF not available.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF6B7280),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (isDownloading.value) return;

    try {
      isDownloading.value = true;
      downloadProgress.value = 0.0;

      Get.snackbar(
        "Downloading Invoice",
        "Please wait...",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D9488),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 60),
        isDismissible: false,
      );

      final dir = await getApplicationDocumentsDirectory();
      final fileName =
          'invoice_${visit['appointment_id'] ?? DateTime.now().millisecondsSinceEpoch}.pdf';
      final savePath = '${dir.path}/$fileName';

      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total > 0) downloadProgress.value = received / total;
        },
      );

      if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

      Get.snackbar(
        "Invoice Downloaded",
        "Opening file...",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D9488),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );

      await OpenFile.open(savePath);
    } catch (e) {
      if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
      Get.snackbar(
        "Download Failed",
        "Could not download invoice. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isDownloading.value = false;
      downloadProgress.value = 0.0;
    }
  }


void callClinic() async {
    if (clinicPhone.isEmpty) {
      Get.snackbar(
        "Unavailable",
        "Clinic phone number not available.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF6B7280),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    final Uri phoneUri = Uri(scheme: 'tel', path: clinicPhone);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar(
        "Unavailable",
        "Could not launch dialer for $clinicPhone.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF6B7280),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}
