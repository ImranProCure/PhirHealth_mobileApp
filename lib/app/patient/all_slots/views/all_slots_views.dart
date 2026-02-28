import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/all_slots_controller.dart';

class AllSlotsView extends GetView<AllSlotsController> {
  const AllSlotsView({super.key});

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
        centerTitle: false,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Dr. Jyoti Wadhwani",
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "General Physician",
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            const CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(
                "assets/icons/freepik__female-doctor-in-white-coat-stethoscope-holding-cl__89801 1.png",
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== TITLE =====
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              controller.tabType == 0
                                  ? Icons.add_box_outlined
                                  : Icons.videocam_outlined,
                              color: const Color(0xFF0D9488),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              controller.screenTitle.value,
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D9488),
                              ),
                            ),
                          ],
                        )),

                    const SizedBox(height: 20),

                    // ===== MONTH ROW =====
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: controller.prevMonth,
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.arrow_back_ios,
                                    size: 14, color: Colors.black54),
                              ),
                            ),
                            Text(
                              controller.currentMonthLabel.value,
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: controller.nextMonth,
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.arrow_forward_ios,
                                    size: 14, color: Colors.black54),
                              ),
                            ),
                          ],
                        )),

                    const SizedBox(height: 16),

                    // ===== DATE SLIDER =====
                    Obx(() {
                      final selectedIdx = controller.selectedDateIndex.value;
                      return SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.dates.length,
                          itemBuilder: (context, index) {
                            final item = controller.dates[index];
                            final bool selected = selectedIdx == index;
                            final int slots = item["slots"] as int;

                            return GestureDetector(
                              onTap: () => controller.selectDate(index),
                              child: SizedBox(
                                width: 72,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: const Color(0xFFE5E7EB)),
                                        ),
                                      ),
                                      AnimatedOpacity(
                                        opacity: selected ? 1.0 : 0.0,
                                        duration:
                                            const Duration(milliseconds: 220),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xFF00897B),
                                                Color(0xFF1565C0),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Text(
                                                item["date"].toString(),
                                                style: TextStyle(
                                                  fontFamily: 'Mulish',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800,
                                                  color: selected
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Center(
                                              child: Text(
                                                item["day"].toString(),
                                                style: TextStyle(
                                                  fontFamily: 'Mulish',
                                                  fontSize: 12,
                                                  color: selected
                                                      ? Colors.white70
                                                      : Colors.black54,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Center(
                                              child: Text(
                                                slots == 0
                                                    ? "Full"
                                                    : "$slots Slots",
                                                style: TextStyle(
                                                  fontFamily: 'Mulish',
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: selected
                                                      ? Colors.white
                                                      : slots == 0
                                                          ? Colors.redAccent
                                                          : const Color(
                                                              0xFF0D9488),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    // ===== DATE LABEL =====
                    Obx(() => Text(
                          controller.selectedDateLabel.value,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        )),

                    const SizedBox(height: 16),

                    // ===== SESSION SLOTS WITH DASHED LINE =====
                    Obx(() => _buildSessionList()),
                  ],
                ),
              ),
            ),
          ),

          // ===== NEXT STEP BUTTON =====
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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
                onPressed: controller.goToPatientDetails,
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
                    Text(
                      "Next Step",
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== SESSIONS WITH DASHED LINE =====
  Widget _buildSessionList() {
    final sessions = [
      {"label": "Morning", "slots": controller.morningSlots},
      {"label": "Afternoon", "slots": controller.afternoonSlots},
      {"label": "Evening", "slots": controller.eveningSlots},
      {"label": "Night", "slots": controller.nightSlots},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(sessions.length, (i) {
        final label = sessions[i]["label"] as String;
        final slots = sessions[i]["slots"] as RxList<String>;
        final bool isEmpty = slots.isEmpty;
        final bool isLast = i == sessions.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT: dot + dashed line
              SizedBox(
                width: 20,
                child: Column(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D9488),
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: CustomPaint(
                            painter: _DashedLinePainter(),
                            child: const SizedBox(width: 1),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // RIGHT: content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            label,
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isEmpty) ...[
                            const SizedBox(width: 8),
                            const Text(
                              "No Slots",
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 13,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (!isEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              slots.map((time) => _timeChip(time)).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _timeChip(String time) {
    final selected = controller.selectedSlot.value == time;
    return GestureDetector(
      onTap: () => controller.selectSlot(time),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: selected
              ? const Color(0xFF0D9488).withOpacity(0.08)
              : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFF0D9488) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          time,
          style: TextStyle(
            fontFamily: 'Mulish',
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: selected ? const Color(0xFF0D9488) : Colors.black87,
          ),
        ),
      ),
    );
  }
}

// ===== DASHED LINE PAINTER =====
class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD1D5DB)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashHeight = 5.0;
    const dashSpace = 4.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
