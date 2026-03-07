import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_visits_controller.dart';

class DoctorVisitsView extends GetView<DoctorVisitsController> {
  const DoctorVisitsView({super.key});

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
          "My Doctor Visits",
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
          // ===== FILTER TABS — white card =====
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Obx(() => Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children:
                        controller.filters.map((f) => _filterTab(f)).toList(),
                  ),
                )),
          ),

          const SizedBox(height: 8),

          // ===== LIST =====
          Expanded(
            child: Obx(() {
              final visits = controller.filteredVisits;
              if (visits.isEmpty) {
                return const Center(
                  child: Text("No visits found",
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          color: Color(0xFF6B7280))),
                );
              }
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                children: _buildTimeline(visits),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Container(
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
                offset: const Offset(0, 4))
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  // ===== TIMELINE =====
  List<Widget> _buildTimeline(List<Map<String, dynamic>> visits) {
    final List<Widget> widgets = [];
    String? lastMonth;

    for (int i = 0; i < visits.length; i++) {
      final visit = visits[i];
      final month = visit['month'] as String;
      final isLastVisit = i == visits.length - 1;

      // Month header
      if (month != lastMonth) {
        // Gap before new month (except first)
        if (lastMonth != null) widgets.add(const SizedBox(height: 4));

        widgets.add(
          Row(
            children: [
              const SizedBox(width: 22),
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF0D9488),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                month,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
        lastMonth = month;
      }

      // Visit row: date circle ON line | card
      widgets.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // LEFT: dashed line with date circle centered on it
              SizedBox(
                width: 54,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Full dashed line
                    Positioned.fill(
                      child: CustomPaint(painter: _DashedLinePainter()),
                    ),
                    // Date circle ON top of line
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE0F2F1),
                          border: Border.all(
                              color: const Color(0xFF0D9488), width: 1.2),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              visit['date_short'].toString().split('\n')[0],
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF0D9488),
                                height: 1.2,
                              ),
                            ),
                            Text(
                              visit['date_short'].toString().split('\n')[1],
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0D9488),
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: _visitCard(visit),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Bottom dot
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            const SizedBox(width: 22),
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFF0D9488),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );

    return widgets;
  }

  // ===== FILTER TAB =====
  Widget _filterTab(String label) {
    final isSelected = controller.selectedFilter.value == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectFilter(label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }

  // ===== VISIT CARD =====
  Widget _visitCard(Map<String, dynamic> visit) {
    final isCompleted = visit['status'] == 'Completed';
    final isCancelled = visit['status'] == 'Cancelled';
    final bool showBookAgain = visit['show_book_again'] == true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor + status badge
          Row(
            children: [
              Expanded(
                child: Text(visit['doctor'],
                    style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
              ),
              _statusBadge(visit['status']),
            ],
          ),
          const SizedBox(height: 3),
          Text(visit['specialty'],
              style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 12,
                  color: Color(0xFF6B7280))),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time_outlined,
                  size: 14, color: Color(0xFF6B7280)),
              const SizedBox(width: 6),
              Text("${visit['time']} | ${visit['type']}",
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      color: Color(0xFF6B7280))),
            ],
          ),

          // Note
          if (visit['note'] != null && visit['note'].toString().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(visit['note'],
                style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 12,
                    color: Color(0xFF374151),
                    fontStyle: FontStyle.italic)),
          ],

          // View More Details button
          if (isCompleted) ...[
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: () => controller.viewMoreDetails(visit),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 46),
                side: const BorderSide(color: Color(0xFF0D9488)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined,
                      size: 18, color: Color(0xFF0D9488)),
                  SizedBox(width: 8),
                  Text("View More Details",
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D9488))),
                ],
              ),
            ),

            // Book Again — only if flagged
            if (showBookAgain) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => controller.bookAgain(visit),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.replay_outlined,
                        size: 16, color: Color(0xFF0D9488)),
                    SizedBox(width: 6),
                    Text("Book Again",
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D9488))),
                  ],
                ),
              ),
            ],
          ],

          if (isCancelled) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => controller.bookAgain(visit),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.replay_outlined,
                      size: 16, color: Color(0xFF0D9488)),
                  SizedBox(width: 6),
                  Text("Book Again",
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D9488))),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ===== STATUS BADGE =====
  Widget _statusBadge(String status) {
    final isCompleted = status == 'Completed';
    final isCancelled = status == 'Cancelled';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted
            ? const Color(0xFFE0F2F1)
            : isCancelled
                ? const Color(0xFFFEE2E2)
                : const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompleted
                ? Icons.check_circle_outline
                : isCancelled
                    ? Icons.cancel_outlined
                    : Icons.schedule,
            size: 13,
            color: isCompleted
                ? const Color(0xFF0D9488)
                : isCancelled
                    ? const Color(0xFFEF4444)
                    : const Color(0xFFD97706),
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isCompleted
                  ? const Color(0xFF0D9488)
                  : isCancelled
                      ? const Color(0xFFEF4444)
                      : const Color(0xFFD97706),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== DASHED LINE PAINTER =====
class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0D9488).withOpacity(0.6)
      ..strokeWidth = 1.5;

    double y = 0;
    const dashH = 5.0;
    const gapH = 4.0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, y + dashH),
        paint,
      );
      y += dashH + gapH;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => false;
}
