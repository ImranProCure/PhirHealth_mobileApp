import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/save_report_controller.dart';

class SaveReportView extends GetView<SaveReportController> {
  SaveReportView({super.key});

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
                  _imageCard(),
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
                  const SizedBox(height: 20),
                  const Text(
                    "Date of Report",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _dateField(context),
                  const SizedBox(height: 20),
                  const Text(
                    "File Name (Optional)",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _fileNameField(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          _saveButton(),
        ],
      ),
    );
  }

  Widget _imageCard() {
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
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: controller.imagePath.isNotEmpty
                    ? Image.file(
                        File(controller.imagePath),
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 220,
                        color: const Color(0xFFF3F4F6),
                        child: const Center(
                          child: Icon(Icons.image_outlined,
                              size: 60, color: Color(0xFF9CA3AF)),
                        ),
                      ),
              ),
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
  }

  // ===== DOC TYPES — directly in view =====
  final List<Map<String, dynamic>> _docTypes = [
    {'label': 'Prescriptions', 'imagePath': 'assets/icons/prescription 1.png'},
    {
      'label': 'Lab Reports',
      'imagePath': 'assets/icons/chemical-analysis 1.png'
    },
    {'label': 'Medical Bill', 'imagePath': 'assets/icons/medical-bill 1.png'},
    {'label': 'X-Ray / Scan', 'imagePath': 'assets/icons/test-results 1.png'},
  ];

  Widget _docTypeGrid() {
    return Obx(() => Column(
          children: [
            Row(
              children: _docTypes.sublist(0, 2).map((type) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: _docTypeCard(type),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: _docTypes.sublist(2, 4).map((type) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: _docTypeCard(type),
                  ),
                );
              }).toList(),
            ),
          ],
        ));
  }

  Widget _docTypeCard(Map<String, dynamic> type) {
    final bool isSelected = controller.selectedType.value == type['label'];
    return GestureDetector(
      onTap: () => controller.selectType(type['label'] as String),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 110,
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
                  // ===== IMAGE.ASSET — not Icon =====
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset(
                      type['imagePath'] as String,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        _typeIcon(type['label'] as String),
                        size: 26,
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
      case 'Medical Bill':
        return Icons.receipt_long_outlined;
      case 'X-Ray / Scan':
        return Icons.image_search_outlined;
      default:
        return Icons.folder_outlined;
    }
  }

  Widget _dateField(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () => controller.pickDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.selectedDate.value,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(Icons.calendar_today_outlined,
                    size: 18, color: Color(0xFF6B7280)),
              ],
            ),
          ),
        ));
  }

  Widget _fileNameField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller.fileNameController,
        style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
        decoration: const InputDecoration(
          hintText: "Prescription_18Feb",
          hintStyle: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 14,
            color: Color(0xFF9CA3AF),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
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
