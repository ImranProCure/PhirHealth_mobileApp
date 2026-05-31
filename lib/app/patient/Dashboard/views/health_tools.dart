import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

/// Drop-in replacement for _SmartHealthToolsSection
/// Matches the "Health Metrics" grid screenshot:
///   • White card with rounded corners
///   • 3-column grid
///   • Each cell: icon top-center + two lines of text below
///   • Thin dividers between cells (vertical + horizontal)
class HealthMetricsSection extends StatelessWidget {
  final DashboardController controller;
  final bool isTablet;

  const HealthMetricsSection({
    super.key,
    required this.controller,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final tools = controller.healthTools; // List<Map<String,dynamic>>

    // Build rows of 3
    final List<List<Map<String, dynamic>>> rows = [];
    for (int i = 0; i < tools.length; i += 3) {
      rows.add(tools.sublist(i, i + 3 > tools.length ? tools.length : i + 3));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section title ──────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                "Health Metrics",
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            const SizedBox(height: 4),

            // ── Grid rows ──────────────────────────────────
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                childAspectRatio: 1.0, // adjust as needed
              ),
              itemCount: rows.fold(0, (sum, row) => sum! + row.length),
              itemBuilder: (context, index) {
                // Flatten rows into a single list
                int flatIndex = 0;
                Map<String, dynamic>? tool;
                int rowIndex = 0;
                int colIndex = 0;

                for (int r = 0; r < rows.length; r++) {
                  for (int c = 0; c < rows[r].length; c++) {
                    if (flatIndex == index) {
                      tool = rows[r][c] as Map<String, dynamic>;
                      rowIndex = r;
                      colIndex = c;
                      break;
                    }
                    flatIndex++;
                  }
                  if (tool != null) break;
                }

                if (tool == null) return const SizedBox.shrink();

                final isLastCol = (index + 1) % 3 == 0 ||
                    index == rows.fold(0, (sum, row) => sum + row.length) - 1;
                final isLastRow = rowIndex == rows.length - 1;

                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: isLastCol
                          ? BorderSide.none
                          : const BorderSide(
                              width: 1, color: Color(0xFFF3F4F6)),
                      bottom: isLastRow
                          ? BorderSide.none
                          : const BorderSide(
                              width: 1, color: Color(0xFFF3F4F6)),
                    ),
                  ),
                  child: _MetricCell(
                    iconPath: tool['icon'] as String,
                    line1: (tool['title'] as String).tr.split('\n').first,
                    line2: (tool['title'] as String).tr.contains('\n')
                        ? (tool['title'] as String).tr.split('\n').last
                        : (tool['subtitle'] as String? ?? ''),
                    isTablet: isTablet,
                    onTap: () =>
                        controller.onHealthToolTap(rowIndex * 3 + colIndex),
                  ),
                );
              },
            ),

            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

// ─── Single metric cell ───────────────────────────────────────────────────────

class _MetricCell extends StatelessWidget {
  final String iconPath;
  final String line1;
  final String line2;
  final bool isTablet;
  final VoidCallback onTap;

  const _MetricCell({
    required this.iconPath,
    required this.line1,
    required this.line2,
    required this.isTablet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Image.asset(
              iconPath,
              width: isTablet ? 62 : 52,
              height: isTablet ? 62 : 52,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  _PlaceholderIcon(size: isTablet ? 62 : 52),
            ),
            const SizedBox(height: 14),

            // Line 1
            Text(
              line1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: isTablet ? 14 : 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
                height: 1.3,
              ),
            ),

            // Line 2 (subtitle / second word)
            if (line2.isNotEmpty)
              Text(
                line2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: isTablet ? 14 : 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                  height: 1.3,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Fallback icon when asset missing ────────────────────────────────────────

class _PlaceholderIcon extends StatelessWidget {
  final double size;
  const _PlaceholderIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE6F5F3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(Icons.health_and_safety_outlined,
          size: size * 0.55, color: const Color(0xFF0D9488)),
    );
  }
}
