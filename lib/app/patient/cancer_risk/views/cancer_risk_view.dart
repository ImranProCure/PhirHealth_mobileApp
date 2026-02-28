import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cancer_risk_controller.dart';

class CancerRiskView extends GetView<CancerRiskController> {
  const CancerRiskView({super.key});

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
          'Cancer Risk Detection',
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== HERO IMAGE =====
                  SizedBox(
                    width: double.infinity,
                    height: 220,
                    child: Image.asset(
                      'assets/icons/Mask group copy 3.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF0D2137),
                        child: const Center(
                          child: Icon(Icons.biotech_outlined,
                              size: 80, color: Colors.white54),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ===== TITLE =====
                        const Text(
                          'Advanced AI-Powered\nDiagnosis',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ===== SUBTITLE =====
                        const Text(
                          'Advanced analysis to identify potential cancer risk indicators an early stage. Our technology screens for subtle anomalies using clinical-grade diagnostic models.',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ===== DISCLAIMER =====
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2F1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('⚠️', style: TextStyle(fontSize: 18)),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Disclaimer: ',
                                        style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF0D9488),
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            'Results are indicative and for information purposes only. Please consult a qualified doctor for confirmation and treatment.',
                                        style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 13,
                                          color: Color(0xFF374151),
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ===== FEATURE CARDS =====
                        Row(
                          children: [
                            Expanded(
                                child: _featureCard(
                                    'assets/icons/encrypted.png',
                                    'Secure & Private',
                                    useImage: true)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _featureCard(null, 'Rapid Analysis',
                                    useImage: false)),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===== BUTTONS =====
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: controller.startDetection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageIcon(
                        const AssetImage('assets/icons/oncology.png'),
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Start Detection',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: OutlinedButton(
              onPressed: controller.consultDoctor,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                side: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                'Consult a Doctor Instead',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D9488),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureCard(String? imagePath, String label,
      {bool useImage = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          useImage
              ? Image.asset(
                  imagePath!,
                  width: 28,
                  height: 28,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.shield_outlined,
                    color: Color(0xFF0D9488),
                    size: 28,
                  ),
                )
              : const Icon(Icons.bar_chart_outlined,
                  color: Color(0xFF0D9488), size: 28),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
