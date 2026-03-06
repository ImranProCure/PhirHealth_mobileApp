import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lab_tests_controller.dart';

class LabTestsView extends GetView<LabTestsController> {
  const LabTestsView({super.key});

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
        title: const Text('Lab Tests & Checkups',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== SEARCH =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                  SizedBox(width: 10),
                  Text('Search test (e.g. CBC, Sugar)',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          color: Color(0xFF9CA3AF))),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ===== COMMON TESTS =====
            Container(
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
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Text('Common Tests',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black)),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: controller.commonTests.length,
                    itemBuilder: (context, i) {
                      final t = controller.commonTests[i];
                      final int row = i ~/ 3;
                      final int col = i % 3;
                      final bool isLastRow = row == 1;
                      final bool isLastCol = col == 2;
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              right: isLastCol
                                  ? BorderSide.none
                                  : const BorderSide(
                                      color: Color(0xFFF0F0F0), width: 1),
                              bottom: isLastRow
                                  ? BorderSide.none
                                  : const BorderSide(
                                      color: Color(0xFFF0F0F0), width: 1),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE0F2F1),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Image.asset(
                                    t['imagePath'] as String,
                                    fit: BoxFit.contain,
                                    color: const Color(0xFF0D9488),
                                    colorBlendMode: BlendMode.srcIn,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.science_outlined,
                                      color: Color(0xFF0D9488),
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                t['label'] as String,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ===== BANNER IMAGE ONLY =====
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                'assets/image 7.png',
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7F4),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child:
                        Icon(Icons.elderly, size: 60, color: Color(0xFF0D9488)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ===== RECOMMENDED =====
            const Text('Recommended for your',
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.black)),
            const SizedBox(height: 12),

            ...controller.recommended.map((r) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                      Text(r['title'] as String,
                          style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.black)),
                      const SizedBox(height: 4),
                      Text(r['sub'] as String,
                          style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              color: Color(0xFF6B7280))),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(r['price'] as String,
                              style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0D9488))),
                          SizedBox(
                            height: 40,
                            child: OutlinedButton(
                              onPressed: controller.bookNow,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Color(0xFF0D9488), width: 1.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                              ),
                              child: const Text('Book Now',
                                  style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0D9488))),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
