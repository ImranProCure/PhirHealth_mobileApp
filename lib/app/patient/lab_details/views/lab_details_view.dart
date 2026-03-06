import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lab_details_controller.dart';

class LabDetailsView extends GetView<LabDetailsController> {
  const LabDetailsView({super.key});

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
        title: const Text('Lab Details',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ===== MAP =====
                  Stack(
                    children: [
                      Image.asset(
                        'assets/Group 1171274920.png',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 200,
                          color: const Color(0xFFE5E7EB),
                          child: const Center(
                              child: Icon(Icons.map_outlined,
                                  size: 60, color: Color(0xFF9CA3AF))),
                        ),
                      ),
                      Positioned(
                        bottom: 14,
                        left: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                              color: const Color(0xFF0D9488),
                              borderRadius: BorderRadius.circular(20)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, color: Colors.white, size: 8),
                              SizedBox(width: 6),
                              Text('OPEN NOW',
                                  style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ===== MAIN CARD =====
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
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
                        // ===== LAB INFO =====
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller.name,
                                  style: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black)),
                              const SizedBox(height: 4),
                              Text(controller.address,
                                  style: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      color: Color(0xFF6B7280),
                                      height: 1.4)),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Color(0xFFFBBF24), size: 16),
                                  const SizedBox(width: 4),
                                  Text(controller.rating,
                                      style: const TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black)),
                                  Text('  (${controller.reviews})',
                                      style: const TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 12,
                                          color: Color(0xFF9CA3AF))),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.location_on_outlined,
                                      size: 14, color: Color(0xFF9CA3AF)),
                                  const SizedBox(width: 4),
                                  Text(controller.distance,
                                      style: const TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 12,
                                          color: Color(0xFF6B7280))),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const Divider(height: 1, color: Color(0xFFF3F4F6)),

                        // ===== SERVICES =====
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Services Available',
                                  style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black)),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: controller.services
                                    .map((s) => Column(
                                          children: [
                                            Container(
                                              width: 56,
                                              height: 56,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFF3F4F6),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: Image.asset(
                                                  s['imagePath'] as String,
                                                  fit: BoxFit.contain,
                                                  color:
                                                      const Color(0xFF0D9488),
                                                  errorBuilder: (_, __, ___) =>
                                                      const Icon(
                                                          Icons
                                                              .science_outlined,
                                                          color:
                                                              Color(0xFF0D9488),
                                                          size: 26),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(s['label'] as String,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontFamily: 'Mulish',
                                                    fontSize: 10,
                                                    color: Color(0xFF6B7280),
                                                    height: 1.3)),
                                          ],
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),

                        const Divider(height: 1, color: Color(0xFFF3F4F6)),

                        // ===== TOP TESTS =====
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: const Text('Top Tests & Prices',
                              style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black)),
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(controller.tests.length, (i) {
                          final t = controller.tests[i];
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(t['name'] as String,
                                              style: const TextStyle(
                                                  fontFamily: 'Mulish',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black)),
                                          const SizedBox(height: 2),
                                          Text(t['sub'] as String,
                                              style: const TextStyle(
                                                  fontFamily: 'Mulish',
                                                  fontSize: 12,
                                                  color: Color(0xFF9CA3AF))),
                                        ],
                                      ),
                                    ),
                                    Text(t['price'] as String,
                                        style: const TextStyle(
                                            fontFamily: 'Mulish',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF0D9488))),
                                  ],
                                ),
                              ),
                              if (i < controller.tests.length - 1)
                                const Divider(
                                    height: 1,
                                    indent: 16,
                                    endIndent: 16,
                                    color: Color(0xFFF3F4F6)),
                            ],
                          );
                        }),

                        // View All
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: GestureDetector(
                            onTap: controller.viewAll,
                            child: const Center(
                              child: Text('View All',
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0D9488),
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFF0D9488),
                                  )),
                            ),
                          ),
                        ),

                        const Divider(height: 1, color: Color(0xFFF3F4F6)),

                        // ===== CALL + BOOK BUTTONS =====
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      gradient: const LinearGradient(colors: [
                                        Color(0xFF00897B),
                                        Color(0xFF1565C0)
                                      ]),
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: controller.call,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                      ),
                                      icon: const Icon(Icons.phone,
                                          color: Colors.white, size: 18),
                                      label: const Text('Call',
                                          style: TextStyle(
                                              fontFamily: 'Mulish',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: OutlinedButton.icon(
                                    onPressed: controller.book,
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Color(0xFF0D9488), width: 1.5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                    ),
                                    icon: const Icon(Icons.three_p_outlined,
                                        color: Color(0xFF0D9488), size: 18),
                                    label: const Text('Book',
                                        style: TextStyle(
                                            fontFamily: 'Mulish',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF0D9488))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
