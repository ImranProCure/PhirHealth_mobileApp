import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MedicalRecordsController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // ===== FILTER TABS =====
  final RxString selectedFilter = 'All Records'.obs;
  final List<Map<String, dynamic>> filters = [
    {"label": "All Records", "icon": "add_box"},
    {"label": "Prescriptions", "icon": "assignment"},
    {"label": "Lab Reports", "icon": "biotech"},
  ];

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  // ===== RECORDS DATA =====
  final RxList<Map<String, dynamic>> allRecords = <Map<String, dynamic>>[
    {
      "type": "Lab Report",
      "title": "Blood Test - CBC",
      "date": "12 Feb 2026",
      "imagePath": "assets/icons/cbc test.png",
      "isAsset": true,
    },
    {
      "type": "Prescription",
      "title": "Dr. Anjali Prescription..",
      "date": "10 Jan 2026",
      "imagePath": "",
      "isAsset": false,
    },
    {
      "type": "Imaging",
      "title": "Chest X-Ray",
      "date": "05 Jan 2026",
      "imagePath": "assets/chest xray.png",
      "isAsset": true,
    },
  ].obs;

  List<Map<String, dynamic>> get filteredRecords {
    if (selectedFilter.value == 'All Records') return allRecords;
    if (selectedFilter.value == 'Prescriptions') {
      return allRecords.where((r) => r['type'] == 'Prescription').toList();
    }
    return allRecords
        .where((r) => r['type'] == 'Lab Report' || r['type'] == 'Imaging')
        .toList();
  }

  // ===== CAPTURE FROM CAMERA =====
  Future<void> captureNow() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (photo != null) {
      _goToSaveReport(photo.path);
    }
  }

  // ===== PICK FROM GALLERY =====
  Future<void> pickFromGallery() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (photo != null) {
      _goToSaveReport(photo.path);
    }
  }

  // ===== PICK PDF =====
  Future<void> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final String path = result.files.single.path!;
      final String name = result.files.single.name.replaceAll('.pdf', '');
      final now = DateTime.now();
      final dateStr = '${now.day} ${_monthName(now.month)} ${now.year}';
      allRecords.insert(0, {
        "type": "Prescription",
        "title": name,
        "date": dateStr,
        "imagePath": path,
        "isAsset": false,
        "isPdf": true,
      });
      Get.snackbar(
        "Saved!",
        "PDF added successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D9488),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
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

  // ===== NAVIGATE TO SAVE REPORT SCREEN =====
  Future<void> _goToSaveReport(String imagePath) async {
    final result = await Get.toNamed(
      '/save-report',
      arguments: {'imagePath': imagePath},
    );
    if (result != null && result is Map<String, dynamic>) {
      allRecords.insert(0, result);
      Get.snackbar(
        "Saved!",
        "Report added successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D9488),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void seeAll() {}

  void openRecord(Map<String, dynamic> record) {}

  // ===== BOTTOM SHEET: Camera or Gallery =====
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
                  borderRadius: BorderRadius.circular(30),
                ),
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
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
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
