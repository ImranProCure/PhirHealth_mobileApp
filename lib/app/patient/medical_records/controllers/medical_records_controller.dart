import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sample/app/service/api/common_api/medical_records_api/medical_records_api.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import '../../../patient/all_medical_records/views/all_medical_record_view.dart';
import 'dart:typed_data';

class MedicalRecordsController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final MedicalRecordsApi _api = MedicalRecordsApi();

  final RxBool isLoading = false.obs;
  final String baseUrl = ApiConstants.baseUrl;

  // ===== FILTER TABS =====
  final RxString selectedFilter = 'All Records'.obs;
  final List<Map<String, dynamic>> filters = [
    {"label": "All Records", "icon": "add_box"},
    {"label": "Lab Reports", "icon": "biotech"},
    {"label": "Prescriptions", "icon": "assignment"},
    {"label": "Doctor Notes", "icon": "notes"},
    {"label": "Vitals Tracking", "icon": "monitor_heart"},
    {"label": "Imaging Reports", "icon": "image"},
    {"label": "Discharge Summary", "icon": "summarize"},
    {"label": "Medical History", "icon": "history"},
  ];

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  // ===== RECORDS DATA =====
  final RxList<Map<String, dynamic>> allRecords = <Map<String, dynamic>>[].obs;

  List<Map<String, dynamic>> get filteredRecords {
    return _getFiltered().take(4).toList();
  }

  List<Map<String, dynamic>> get allFilteredRecords {
    return _getFiltered();
  }

  List<Map<String, dynamic>> _getFiltered() {
    if (selectedFilter.value == 'All Records') return allRecords.toList();
    return allRecords.where((r) => r['type'] == selectedFilter.value).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchRecords();
  }

  // ===== GET RECORDS FROM API =====
  Future<void> fetchRecords() async {
    isLoading.value = true;
    final response = await _api.getMedicalRecords();
    isLoading.value = false;

    if (response.statusCode == 200 && response.data != null) {
      final List data = response.data['message']['data'] ?? [];
      allRecords.value = data.map((item) => _mapRecord(item)).toList();
    } else {
      Get.snackbar(
        "Error",
        "Failed to load records",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  // ===== COMMON RECORD MAPPER =====
  Map<String, dynamic> _mapRecord(dynamic item) {
    final List filesRaw = item['files'] ?? [];
    final List<String> fileUrls = filesRaw
        .take(5)
        .map((f) {
          final String url = f['file_url'] ?? '';
          return url.startsWith('http') ? url : '$baseUrl$url';
        })
        .where((u) => u.isNotEmpty)
        .cast<String>()
        .toList();

    final String firstUrl = fileUrls.isNotEmpty ? fileUrls.first : '';
    final bool isPdf = firstUrl.split('.').last.toLowerCase() == 'pdf';

    return {
      "record_id": item['record_id'] ?? '',
      "type": item['record_type'] ?? '',
      "title": item['record_type'] ?? '',
      "date": _formatDate(item['date'] ?? ''),
      "imagePath": firstUrl,
      "fileUrls": fileUrls,
      "totalFiles": item['total_files'] ?? fileUrls.length,
      "isAsset": false,
      "isPdf": isPdf,
      "isNetwork": firstUrl.isNotEmpty,
    };
  }

  // Date format — "2026-05-06" → "06 May 2026"
  String _formatDate(String raw) {
    try {
      final parts = raw.split('-');
      if (parts.length == 3) {
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ];
        final month = int.tryParse(parts[1]);
        if (month != null && month >= 1 && month <= 12) {
          return '${parts[2]} ${months[month - 1]} ${parts[0]}';
        }
      }
    } catch (_) {}
    return raw;
  }

  // ===== CAPTURE FROM CAMERA =====
  Future<void> captureNow() async {
    final List<String> capturedPaths = [];

    while (true) {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo == null) break;
      capturedPaths.add(photo.path);

      final bool? takeMore = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Add More?',
              style:
                  TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.w700)),
          content: const Text('Do you want to take another photo?',
              style: TextStyle(fontFamily: 'Mulish')),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('No, Done',
                  style: TextStyle(color: Color(0xFF6B7280))),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child:
                  const Text('Yes', style: TextStyle(color: Color(0xFF0D9488))),
            ),
          ],
        ),
      );
      if (takeMore != true) break;
    }

    if (capturedPaths.isNotEmpty) {
      await _goToSaveReport(capturedPaths);
    }
  }

  // ===== PICK FROM GALLERY =====
  Future<void> pickFromGallery() async {
    final List<XFile> photos = await _picker.pickMultiImage(
      imageQuality: 85,
    );
    if (photos.isNotEmpty) {
      final List<String> paths = photos.map((p) => p.path).toList();
      await _goToSaveReport(paths);
    }
  }

  // ===== PICK PDF =====
  Future<void> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final File file = File(result.files.single.path!);
      isLoading.value = true;
      final response = await _api.uploadMedicalRecord(
        files: [file],
        recordType: 'Prescriptions',
      );
      if (response.statusCode == 200) {
        await fetchRecords();
      } else {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          "PDF upload failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  // ===== NAVIGATE TO SAVE REPORT =====
  Future<void> _goToSaveReport(List<String> imagePaths) async {
    final result = await Get.toNamed(
      '/save-report',
      arguments: {'imagePaths': imagePaths},
    );

    if (result != null && result is Map<String, dynamic>) {
      final List<String> paths = List<String>.from(result['imagePaths'] ?? []);
      final String recordType = result['type'] ?? 'Prescriptions';
      if (paths.isEmpty) return;

      // FIXED: Loop hata diya — ek hi API call saari files ke saath
      final List<File> files = paths.map((p) => File(p)).toList();
      final response = await _api.uploadMedicalRecord(
        files: files,
        recordType: recordType,
      );

      if (response.statusCode == 200) {
        await fetchRecords(); // Fresh data lo
      } else {
        Get.snackbar(
          "Error",
          "Upload failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    }
  }

  // ===== SEE ALL =====
  void seeAll() {
    Get.to(
      () => const AllMedicalRecordsView(),
      transition: Transition.rightToLeft,
    );
  }

  // ===== OPEN RECORD =====
  void openRecord(Map<String, dynamic> record) {
    final List<String> urls =
        List<String>.from(record['fileUrls'] ?? [record['imagePath'] ?? '']);

    if (urls.isEmpty || (urls.length == 1 && urls.first.isEmpty)) return;

    Get.to(
      () => RecordFullView(
        fileUrls: urls,
        title: record['type'] as String? ?? '',
        date: record['date'] as String? ?? '',
        isPdf: record['isPdf'] == true,
      ),
      transition: Transition.fadeIn,
    );
  }

  // ===== BOTTOM SHEET =====
  void showPickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
            const SizedBox(height: 20),
            const Text(
              "How do you want to upload?",
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            _pickerTile(
              icon: Icons.camera_alt_outlined,
              title: "Take a Photo",
              subtitle: "Use Camera to scan report",
              onTap: () {
                Get.back();
                captureNow();
              },
            ),
            const SizedBox(height: 12),
            _pickerTile(
              icon: Icons.photo_library_outlined,
              title: "Select from Gallery",
              subtitle: "If you already took a photo",
              onTap: () {
                Get.back();
                pickFromGallery();
              },
            ),
            const SizedBox(height: 12),
            _pickerTile(
              icon: Icons.picture_as_pdf_outlined,
              title: "Upload PDF File",
              subtitle: "Downloaded from WhatsApp/Email",
              onTap: () {
                Get.back();
                pickPdf();
              },
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                side: const BorderSide(color: Color(0xFF0D9488)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0D9488),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _pickerTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488).withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF0D9488), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D9488),
                      )),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      )),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Color(0xFF6B7280)),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// RECORD FULL VIEW — saari files swipe karo
// =====================================================
class RecordFullView extends StatefulWidget {
  final List<String> fileUrls;
  final String title;
  final String date;
  final bool isPdf;

  const RecordFullView({
    super.key,
    required this.fileUrls,
    required this.title,
    required this.date,
    required this.isPdf,
  });

  @override
  State<RecordFullView> createState() => _RecordFullViewState();
}

class _RecordFullViewState extends State<RecordFullView> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Mulish',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          if (widget.fileUrls.length > 1)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_currentIndex + 1} / ${widget.fileUrls.length}',
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.fileUrls.length,
        onPageChanged: (i) => setState(() => _currentIndex = i),
        itemBuilder: (context, index) {
          final String url = widget.fileUrls[index];
          final bool isPdf =
              widget.isPdf || url.split('.').last.toLowerCase() == 'pdf';

          return Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: isPdf
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.picture_as_pdf, size: 80, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          "PDF Preview not available",
                          style: TextStyle(
                            color: Colors.white54,
                            fontFamily: 'Mulish',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  : _FullPrivateImage(url: url),
            ),
          );
        },
      ),
      bottomNavigationBar: widget.fileUrls.length > 1
          ? Container(
              color: Colors.black,
              padding: const EdgeInsets.only(bottom: 20, top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.fileUrls.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == i ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == i
                          ? const Color(0xFF0D9488)
                          : Colors.white24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

// =====================================================
// FULL PRIVATE IMAGE — full screen ke liye
// =====================================================
class _FullPrivateImage extends StatefulWidget {
  final String url;
  const _FullPrivateImage({required this.url});

  @override
  State<_FullPrivateImage> createState() => _FullPrivateImageState();
}

class _FullPrivateImageState extends State<_FullPrivateImage> {
  Uint8List? _bytes;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bytes = await ApiClient().fetchPrivateFile(widget.url);
    if (mounted) {
      setState(() {
        _bytes = bytes;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF0D9488)),
      );
    }
    if (_bytes == null) {
      return const Icon(Icons.broken_image_outlined,
          size: 80, color: Colors.white30);
    }
    return Image.memory(_bytes!, fit: BoxFit.contain);
  }
}
