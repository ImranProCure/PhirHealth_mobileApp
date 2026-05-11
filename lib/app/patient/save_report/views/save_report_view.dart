import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/save_report_controller.dart';

class SaveReportView extends GetView<SaveReportController> {
  SaveReportView({super.key});

  final List<Map<String, dynamic>> _docTypes = [
    {'label': 'Prescriptions', 'imagePath': 'assets/icons/prescription 1.png'},
    {
      'label': 'Lab Reports',
      'imagePath': 'assets/icons/chemical-analysis 1.png'
    },
    {'label': 'Doctor Notes', 'imagePath': 'assets/icons/doctors-note 1.png'},
    {
      'label': 'Vitals Tracking',
      'imagePath': 'assets/icons/electrocardiogram 1.png'
    },
    {
      'label': 'Imaging Reports',
      'imagePath': 'assets/icons/test-results 1.png'
    },
    {'label': 'Discharge Summary', 'imagePath': 'assets/icons/hospital 1.png'},
    {
      'label': 'Medical History',
      'imagePath': 'assets/icons/medical-bill 1.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          "Save Report",
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _imagePreview(),
                  const SizedBox(height: 20),
                  const Text(
                    "What is this document?",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _docTypeGrid(),
                ],
              ),
            ),
          ),
          _saveButton(),
        ],
      ),
    );
  }

  // ===== IMAGE PREVIEW — multiple images =====
  Widget _imagePreview() {
    return Obx(() {
      final paths = controller.imagePaths;
      if (paths.isEmpty) return const SizedBox();

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // ===== MAIN IMAGE =====
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.file(
                    File(controller.currentImagePath),
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
                // Image count badge
                if (paths.length > 1)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${controller.currentImageIndex.value + 1} / ${paths.length}',
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                // Delete button
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: controller.retakePhoto,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.delete_outline,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),

            // ===== THUMBNAIL ROW — multiple images =====
            if (paths.length > 1)
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: paths.length,
                    itemBuilder: (context, index) {
                      final bool isSelected =
                          controller.currentImageIndex.value == index;
                      return GestureDetector(
                        onTap: () => controller.goToImage(index),
                        child: Container(
                          width: 60,
                          height: 60,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF0D9488)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(
                              File(paths[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // ===== RETAKE BUTTON =====
            GestureDetector(
              onTap: controller.retakePhoto,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.replay_outlined,
                        size: 16, color: Color(0xFF0D9488)),
                    SizedBox(width: 6),
                    Text(
                      "Retake",
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
          ],
        ),
      );
    });
  }

  // ===== DOC TYPE GRID =====
  Widget _docTypeGrid() {
    return Obx(() {
      List<Widget> rows = [];
      for (int i = 0; i < _docTypes.length; i += 2) {
        final bool hasSecond = i + 1 < _docTypes.length;
        rows.add(Row(
          children: [
            Expanded(child: _docTypeCard(_docTypes[i])),
            const SizedBox(width: 12),
            hasSecond
                ? Expanded(child: _docTypeCard(_docTypes[i + 1]))
                : const Expanded(child: SizedBox()),
          ],
        ));
        if (i + 2 < _docTypes.length) rows.add(const SizedBox(height: 12));
      }
      return Column(children: rows);
    });
  }

  Widget _docTypeCard(Map<String, dynamic> type) {
    final bool isSelected = controller.selectedType.value == type['label'];
    return GestureDetector(
      onTap: () => controller.selectType(type['label'] as String),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 130,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0D9488).withOpacity(0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF0D9488) : const Color(0xFFE5E7EB),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 62,
                    height: 62,
                    child: Image.asset(
                      type['imagePath'] as String,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        _typeIcon(type['label'] as String),
                        size: 32,
                        color: const Color(0xFF0D9488),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    type['label'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isSelected ? const Color(0xFF0D9488) : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0D9488)
                        : const Color(0xFFD1D5DB),
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'Prescriptions':
        return Icons.medication_outlined;
      case 'Lab Reports':
        return Icons.biotech_outlined;
      case 'Doctor Notes':
        return Icons.notes_outlined;
      case 'Vitals Tracking':
        return Icons.monitor_heart_outlined;
      case 'Imaging Reports':
        return Icons.image_search_outlined;
      case 'Discharge Summary':
        return Icons.summarize_outlined;
      case 'Medical History':
        return Icons.history_outlined;
      default:
        return Icons.folder_outlined;
    }
  }

  Widget _saveButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
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
          onPressed: controller.saveRecord,
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
              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                "Save Record",
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
}
