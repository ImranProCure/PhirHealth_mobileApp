import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import '../../../patient/medical_records/controllers/medical_records_controller.dart';

class AllMedicalRecordsView extends GetView<MedicalRecordsController> {
  const AllMedicalRecordsView({super.key});

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
          "All Medical Records",
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _filterTabs(),
            const SizedBox(height: 20),
            const Text(
              "All Files",
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.isLoading.value) return _skeletonGrid();
              return _recordsGrid();
            }),
          ],
        ),
      ),
    );
  }

  // ===== FILTER TABS =====
  Widget _filterTabs() {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.filters.map((f) {
              final isSelected = controller.selectedFilter.value == f['label'];
              return GestureDetector(
                onTap: () => controller.selectFilter(f['label'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF0D9488).withOpacity(0.08)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF0D9488)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _filterIcon(f['icon'] as String),
                        size: 15,
                        color: isSelected
                            ? const Color(0xFF0D9488)
                            : const Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        f['label'] as String,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? const Color(0xFF0D9488)
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }

  IconData _filterIcon(String icon) {
    switch (icon) {
      case 'add_box':
        return Icons.add_box_outlined;
      case 'biotech':
        return Icons.biotech_outlined;
      case 'assignment':
        return Icons.assignment_outlined;
      case 'notes':
        return Icons.notes_outlined;
      case 'monitor_heart':
        return Icons.monitor_heart_outlined;
      case 'image':
        return Icons.image_outlined;
      case 'summarize':
        return Icons.summarize_outlined;
      case 'history':
        return Icons.history_outlined;
      default:
        return Icons.folder_outlined;
    }
  }

  // ===== RECORDS GRID =====
  Widget _recordsGrid() {
    final records = controller.allFilteredRecords;
    if (records.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Text(
            "No records found",
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: records.length,
      itemBuilder: (context, i) => _recordCard(records[i]),
    );
  }

  // ===== SKELETON GRID =====
  Widget _skeletonGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: 4,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: const Color(0xFFE5E7EB),
        highlightColor: const Color(0xFFF9FAFB),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  // ===== RECORD CARD =====
  Widget _recordCard(Map<String, dynamic> record) {
    final String imagePath = record['imagePath'] as String? ?? '';
    final bool isPdf = record['isPdf'] == true;
    final bool isAsset = record['isAsset'] == true;
    final bool isNetwork = record['isNetwork'] == true;
    final bool hasImage = imagePath.isNotEmpty && !isPdf;
    final int totalFiles = record['totalFiles'] as int? ?? 0;

    return GestureDetector(
      onTap: () => controller.openRecord(record),
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  // ===== IMAGE =====
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: hasImage
                          ? (isNetwork
                              ? _GridPrivateImage(
                                  key: ValueKey(imagePath), // ← yeh add karo
                                  url: imagePath,
                                  type: record['type'] as String,
                                )
                              : isAsset
                                  ? Image.asset(imagePath,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _imagePlaceholder(
                                              record['type'] as String))
                                  : Image.file(File(imagePath),
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _imagePlaceholder(
                                              record['type'] as String)))
                          : isPdf
                              ? _pdfPlaceholder()
                              : _imagePlaceholder(record['type'] as String),
                    ),
                  ),

                  // ===== TYPE BADGE — top left =====
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_typeIcon(record['type'] as String),
                              size: 12, color: const Color(0xFF0D9488)),
                          const SizedBox(width: 4),
                          Text(
                            record['type'] as String,
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ===== FILES COUNT BADGE — top right =====
                  if (totalFiles > 1)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$totalFiles files',
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ===== TITLE + DATE =====
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record['type'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    record['date'] as String,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pdfPlaceholder() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFEF2F2),
      child: const Center(
        child: Icon(Icons.picture_as_pdf, size: 40, color: Color(0xFFEF4444)),
      ),
    );
  }

  Widget _imagePlaceholder(String type) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF3F4F6),
      child: Center(
        child: Icon(_typeIcon(type), size: 40, color: const Color(0xFF0D9488)),
      ),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'Lab Reports':
        return Icons.biotech_outlined;
      case 'Prescriptions':
        return Icons.assignment_outlined;
      case 'Doctor Notes':
        return Icons.notes_outlined;
      case 'Vitals Tracking':
        return Icons.monitor_heart_outlined;
      case 'Imaging Reports':
        return Icons.image_outlined;
      case 'Discharge Summary':
        return Icons.summarize_outlined;
      case 'Medical History':
        return Icons.history_outlined;
      default:
        return Icons.folder_outlined;
    }
  }
}

// =====================================================
// GRID PRIVATE IMAGE
// =====================================================
class _GridPrivateImage extends StatefulWidget {
  final String url;
  final String type;
  const _GridPrivateImage({
    super.key, // ← yeh add karo
    required this.url,
    required this.type,
  });

  @override
  State<_GridPrivateImage> createState() => _GridPrivateImageState();
}

class _GridPrivateImageState extends State<_GridPrivateImage> {
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
      return Shimmer.fromColors(
        baseColor: const Color(0xFFE5E7EB),
        highlightColor: const Color(0xFFF9FAFB),
        child: Container(color: Colors.white),
      );
    }
    if (_bytes == null) {
      return Container(
        color: const Color(0xFFF3F4F6),
        child: Center(
          child: Icon(_typeIcon(widget.type),
              size: 40, color: const Color(0xFF0D9488)),
        ),
      );
    }
    return Image.memory(_bytes!, width: double.infinity, fit: BoxFit.cover);
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'Lab Reports':
        return Icons.biotech_outlined;
      case 'Prescriptions':
        return Icons.assignment_outlined;
      case 'Doctor Notes':
        return Icons.notes_outlined;
      case 'Vitals Tracking':
        return Icons.monitor_heart_outlined;
      case 'Imaging Reports':
        return Icons.image_outlined;
      case 'Discharge Summary':
        return Icons.summarize_outlined;
      case 'Medical History':
        return Icons.history_outlined;
      default:
        return Icons.folder_outlined;
    }
  }
}
