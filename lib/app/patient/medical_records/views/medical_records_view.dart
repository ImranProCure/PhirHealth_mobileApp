import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/medical_records_controller.dart';

class MedicalRecordsView extends GetView<MedicalRecordsController> {
  const MedicalRecordsView({super.key});

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
          "My Medical Records",
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
            _addReportCard(),
            const SizedBox(height: 20),
            _filterTabs(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Files",
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: controller.seeAll,
                  child: const Text(
                    "See All",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() => _recordsGrid()),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: controller.showPickerOptions,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF00897B), Color(0xFF1565C0)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00897B).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  // ===== ADD REPORT CARD =====
  Widget _addReportCard() {
    return GestureDetector(
      onTap: controller.showPickerOptions,
      child: CustomPaint(
        painter: _DashedBorderPainter(),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Color(0xFF0D9488),
                  size: 28,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "Add New Report",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Tab to take a photo of your report",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 18),
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
                  onPressed: controller.showPickerOptions,
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
                      Icon(Icons.crop_free_outlined,
                          color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Capture Now",
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
            ],
          ),
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
      case 'assignment':
        return Icons.assignment_outlined;
      case 'biotech':
        return Icons.biotech_outlined;
      default:
        return Icons.folder_outlined;
    }
  }

  // ===== RECORDS GRID =====
  Widget _recordsGrid() {
    final records = controller.filteredRecords;
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

  // ===== RECORD CARD =====
  Widget _recordCard(Map<String, dynamic> record) {
    final String imagePath = record['imagePath'] as String? ?? '';
    final bool isPdf = record['isPdf'] == true;
    final bool isAsset = record['isAsset'] == true;
    final bool hasImage = imagePath.isNotEmpty && !isPdf;

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
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: hasImage
                        ? (isAsset
                            ? Image.asset(
                                imagePath,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _imagePlaceholder(record['type'] as String),
                              )
                            : Image.file(
                                File(imagePath),
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _imagePlaceholder(record['type'] as String),
                              ))
                        : isPdf
                            ? _pdfPlaceholder(record['title'] as String)
                            : _imagePlaceholder(record['type'] as String),
                  ),
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
                          Icon(
                            _typeIcon(record['type'] as String),
                            size: 12,
                            color: const Color(0xFF0D9488),
                          ),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record['title'] as String,
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

  Widget _pdfPlaceholder(String title) {
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
        child: Icon(
          _typeIcon(type),
          size: 40,
          color: const Color(0xFF0D9488),
        ),
      ),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'Lab Report':
        return Icons.biotech_outlined;
      case 'Prescription':
        return Icons.assignment_outlined;
      case 'Imaging':
        return Icons.image_outlined;
      default:
        return Icons.folder_outlined;
    }
  }
}

// ===== DASHED BORDER PAINTER — no PathMetrics =====
class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0D9488)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double dashW = 6.0;
    const double gapW = 4.0;
    const double r = 16.0;

    _dash(canvas, paint, Offset(r, 0), Offset(size.width - r, 0), dashW, gapW);
    _dash(canvas, paint, Offset(r, size.height),
        Offset(size.width - r, size.height), dashW, gapW);
    _dash(canvas, paint, Offset(0, r), Offset(0, size.height - r), dashW, gapW);
    _dash(canvas, paint, Offset(size.width, r),
        Offset(size.width, size.height - r), dashW, gapW);

    canvas.drawArc(
        Rect.fromLTWH(0, 0, r * 2, r * 2), 3.14159, 3.14159 / 2, false, paint);
    canvas.drawArc(Rect.fromLTWH(size.width - r * 2, 0, r * 2, r * 2),
        3.14159 * 1.5, 3.14159 / 2, false, paint);
    canvas.drawArc(Rect.fromLTWH(0, size.height - r * 2, r * 2, r * 2),
        3.14159 / 2, 3.14159 / 2, false, paint);
    canvas.drawArc(
        Rect.fromLTWH(size.width - r * 2, size.height - r * 2, r * 2, r * 2),
        0,
        3.14159 / 2,
        false,
        paint);
  }

  void _dash(Canvas canvas, Paint paint, Offset start, Offset end, double dashW,
      double gapW) {
    final double dx = end.dx - start.dx;
    final double dy = end.dy - start.dy;
    final double dist = dx.abs() + dy.abs();
    if (dist == 0) return;
    final double ux = dx / dist;
    final double uy = dy / dist;
    double drawn = 0;
    double cx = start.dx;
    double cy = start.dy;
    while (drawn < dist) {
      final double ex = cx + ux * dashW;
      final double ey = cy + uy * dashW;
      canvas.drawLine(Offset(cx, cy), Offset(ex, ey), paint);
      cx = ex + ux * gapW;
      cy = ey + uy * gapW;
      drawn += dashW + gapW;
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => false;
}
