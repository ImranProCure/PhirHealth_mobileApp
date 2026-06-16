import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ai_nutritionist_result_controller.dart';

class AiNutritionistResultView extends GetView<AiNutritionistResultController> {
  const AiNutritionistResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text('ai_nutritionist_result_title'.tr,
            style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),

        // ===== DOWNLOAD ICON — TOP RIGHT =====
        actions: [
          Obx(() => controller.isDownloadingPdf.value
              ? const Padding(
                  padding: EdgeInsets.only(right: 14),
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Color(0xFF0D9488),
                      strokeWidth: 2,
                    ),
                  ),
                )
              : IconButton(
                  onPressed: controller.downloadPdf,
                  icon: const Icon(
                    Icons.picture_as_pdf_outlined,
                    color: Color(0xFF0D9488),
                    size: 26,
                  ),
                  tooltip: 'Download PDF',
                )),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _dailyTargetCard(),
                    const SizedBox(height: 22),
                    Text('ai_nutritionist_daily_timeline'.tr,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black)),
                    const SizedBox(height: 14),
                    _mealTimeline(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buttons(),
          ],
        ),
      ),
    );
  }

  // ===== DAILY TARGET CARD — DYNAMIC =====
  Widget _dailyTargetCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge + updated
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Daily Target',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
              const SizedBox(width: 10),
              Text('ai_nutritionist_just_now'.tr,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      color: Color(0xFF9CA3AF))),
            ],
          ),
          const SizedBox(height: 12),

          // DYNAMIC — calories from Groq
          Obx(() => RichText(
                text: TextSpan(
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      color: Colors.black,
                      height: 1.5,
                      fontWeight: FontWeight.w600),
                  children: [
                    const TextSpan(
                        text: 'Your personalized plan is ready. You need '),
                    TextSpan(
                      text: '${controller.dailyCalories.value} Calories',
                      style: const TextStyle(
                          color: Color(0xFF0D9488),
                          fontWeight: FontWeight.w800),
                    ),
                    const TextSpan(text: ' to achieve your goal.'),
                  ],
                ),
              )),
          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 68,
                height: 40,
                child: Stack(
                  children: [
                    _iconCircle(
                        'assets/icons/exercise.png', Icons.fitness_center, 0),
                    Positioned(
                      left: 26,
                      child: _iconCircle('assets/icons/weight.png',
                          Icons.shopping_bag_outlined, 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // DYNAMIC — tagline from Groq
              Expanded(
                child: Obx(() => Text(
                      '"${controller.tagline.value}"',
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconCircle(String path, IconData fallback, double leftOffset) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Image.asset(
          path,
          fit: BoxFit.contain,
          color: const Color(0xFF0D9488),
          errorBuilder: (_, __, ___) =>
              Icon(fallback, color: const Color(0xFF0D9488), size: 18),
        ),
      ),
    );
  }

  // ===== MEAL TIMELINE — DYNAMIC =====
  Widget _mealTimeline() {
    return Obx(() {
      final meals = controller.meals;

      // Loading state
      if (meals.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(color: Color(0xFF0D9488)),
          ),
        );
      }

      return Column(
        children: List.generate(meals.length, (i) {
          final meal = meals[i];
          final bool isFirst = i == 0;
          final bool isLast = i == meals.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TIMELINE COLUMN
              SizedBox(
                width: 54,
                child: Column(
                  children: [
                    if (isFirst)
                      Column(children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: Color(0xFF0D9488), shape: BoxShape.circle),
                        ),
                        const SizedBox(height: 4),
                      ]),
                    if (!isFirst)
                      SizedBox(
                        height: 16,
                        child: CustomPaint(
                            painter: _DashedLinePainter(),
                            child: const SizedBox(width: 2)),
                      ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Color(meal['iconBg'] as int),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(11),
                        child: Image.asset(
                          meal['imagePath'] as String,
                          fit: BoxFit.contain,
                          color: Color(meal['iconColor'] as int),
                          errorBuilder: (_, __, ___) => Icon(Icons.restaurant,
                              color: Color(meal['iconColor'] as int), size: 20),
                        ),
                      ),
                    ),
                    if (!isLast)
                      SizedBox(
                        height: 148,
                        child: CustomPaint(
                            painter: _DashedLinePainter(),
                            child: const SizedBox(width: 2)),
                      ),
                    if (isLast)
                      Column(children: [
                        const SizedBox(height: 4),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: Color(0xFF0D9488), shape: BoxShape.circle),
                        ),
                      ]),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // MEAL CARD
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(meal['type'] as String,
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(meal['iconColor'] as int),
                                letterSpacing: 0.5,
                              )),
                          Text(meal['cal'] as String,
                              style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(meal['time'] as String,
                          style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              color: Color(0xFF9CA3AF))),
                      const SizedBox(height: 8),
                      Text(meal['meal'] as String,
                          style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              height: 1.4)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        children: (meal['tags'] as List<String>)
                            .map((tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: const Color(0xFFE5E7EB),
                                        width: 1),
                                  ),
                                  child: Text(tag,
                                      style: const TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 11,
                                          color: Color(0xFF6B7280))),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      );
    });
  }

  // ===== BUTTONS =====
  Widget _buttons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        children: [
          // ===== ACCEPT PLAN — saved plan pe hide =====
          Obx(() => controller.isSavedPlan.value
              ? const SizedBox.shrink()
              : Obx(() => SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                            colors: [Color(0xFF00897B), Color(0xFF1565C0)]),
                      ),
                      child: ElevatedButton(
                        onPressed: controller.isSaving.value
                            ? null
                            : controller.acceptPlan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: controller.isSaving.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('ai_nutritionist_accept_plan'.tr,
                                      style: const TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white)),
                                  const SizedBox(width: 8),
                                  Image.asset(
                                    'assets/icons/wand_stars.png',
                                    width: 20,
                                    height: 20,
                                    color: Colors.white,
                                    errorBuilder: (_, __, ___) => const Icon(
                                        Icons.auto_awesome,
                                        color: Colors.white,
                                        size: 20),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ))),

          const SizedBox(height: 10),

          // ===== REGENERATE / GO BACK =====
          Obx(() => SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: controller.regenerate,
                  style: OutlinedButton.styleFrom(
                    side:
                        const BorderSide(color: Color(0xFF0D9488), width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.isSavedPlan.value
                            ? 'ai_nutritionist_go_back'.tr
                            : 'ai_nutritionist_regenerate'.tr,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0D9488)),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        controller.isSavedPlan.value
                            ? Icons.arrow_back
                            : Icons.rotate_right,
                        color: const Color(0xFF0D9488),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              )),
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
      ..color = const Color(0xFF0D9488)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashH = 5.0;
    const gap = 4.0;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(
          Offset(size.width / 2, y), Offset(size.width / 2, y + dashH), paint);
      y += dashH + gap;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => false;
}