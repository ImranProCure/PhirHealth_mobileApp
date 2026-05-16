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
            ...List.generate(rows.length, (rowIndex) {
              final row = rows[rowIndex];
              final isLastRow = rowIndex == rows.length - 1;

              return Column(
                children: [
                  // Horizontal divider above every row except the first
                  if (rowIndex > 0)
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

                  IntrinsicHeight(
                    child: Row(
                      children: List.generate(row.length, (colIndex) {
                        final tool = row[colIndex];
                        final isLastCol = colIndex == row.length - 1;

                        // Fill empty slots when last row has < 3 items
                        Widget cell = _MetricCell(
                          iconPath: tool['icon'] as String,
                          line1: (tool['title'] as String).tr.split('\n').first,
                          line2: (tool['title'] as String).tr.contains('\n')
                              ? (tool['title'] as String).tr.split('\n').last
                              : (tool['subtitle'] as String? ?? ''),
                          isTablet: isTablet,
                          onTap: () => controller
                              .onSmartToolTap(rowIndex * 3 + colIndex),
                        );

                        return Expanded(
                          child: Row(
                            children: [
                              Expanded(child: cell),
                              if (!isLastCol)
                                Container(
                                  width: 1,
                                  color: const Color(0xFFF3F4F6),
                                ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              );
            }),

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
