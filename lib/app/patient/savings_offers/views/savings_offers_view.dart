import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/savings_offers_controller.dart';

class SavingsOffersView extends GetView<SavingsOffersController> {
  const SavingsOffersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          "Savings & Offers",
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined,
                color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _tabBar(),
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.currentOffers.length,
                  itemBuilder: (context, i) =>
                      _offerCard(controller.currentOffers[i]),
                )),
          ),
        ],
      ),
    );
  }

  // ===== TAB BAR =====
  Widget _tabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Obx(() => Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                _tabItem(0, 'Medicine Offers'),
                _tabItem(1, 'Lab Test Offers'),
              ],
            ),
          )),
    );
  }

  Widget _tabItem(int index, String label) {
    final bool isSelected = controller.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                  )
                : null,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
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

  // ===== OFFER CARD =====
  Widget _offerCard(Map<String, dynamic> offer) {
    final String badge = offer['badge'] as String? ?? '';
    final bool verified = offer['verified'] == true;
    final String expiry = offer['expiry'] as String? ?? '';
    final String code = offer['code'] as String? ?? '';
    final String buttonType = offer['buttonType'] as String? ?? '';
    final String minOrder = offer['minOrder'] as String? ?? '';
    final bool isApply = buttonType == 'apply';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: CustomPaint(
        painter: _TicketBorderPainter(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ===== CARD 1 STYLE: badge on top, then title, subtitle, minorder, button =====
                if (isApply) ...[
                  // Badge
                  if (badge.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD93D),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.black, // BLACK text as per figma
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    offer['title'] as String,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Subtitle
                  Text(
                    offer['subtitle'] as String,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Min order
                  if (minOrder.isNotEmpty)
                    Text(
                      minOrder,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Apply Now full width gradient button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () => controller.handleButton(offer),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          offer['buttonLabel'] as String,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]

                // ===== CARD 2 & 3 STYLE: title + verified row, subtitle, divider, code/expiry + button =====
                else ...[
                  // Title + verified row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        offer['title'] as String,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                      if (verified)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'VERIFIED',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    offer['subtitle'] as String,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Divider
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 16),

                  // Code/expiry + button row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (code.isNotEmpty) ...[
                            const Text(
                              'USE CODE',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 11,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              code,
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ] else if (expiry.isNotEmpty)
                            Text(
                              expiry,
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 11,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                        ],
                      ),
                      OutlinedButton(
                        onPressed: () => controller.handleButton(offer),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFF0D9488), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: Text(
                          offer['buttonLabel'] as String,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0D9488),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===== TICKET STYLE DASHED BORDER PAINTER =====
class _TicketBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0D9488)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double dashW = 5.0;
    const double gapW = 4.0;
    const double r = 16.0;
    const double notchR = 10.0;
    final double notchY = size.height * 0.72; // divider level for card 2/3

    // Top edge
    _dash(canvas, paint, Offset(r, 0), Offset(size.width - r, 0), dashW, gapW);
    // Bottom edge
    _dash(canvas, paint, Offset(r, size.height),
        Offset(size.width - r, size.height), dashW, gapW);

    // Left edge — with notch cutout if needed
    _dash(canvas, paint, Offset(0, r), Offset(0, size.height - r), dashW, gapW);
    // Right edge
    _dash(canvas, paint, Offset(size.width, r),
        Offset(size.width, size.height - r), dashW, gapW);

    // Corners
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
  bool shouldRepaint(_TicketBorderPainter old) => false;
}
