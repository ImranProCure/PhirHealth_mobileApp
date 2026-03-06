import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/labs_near_you_controller.dart';

class LabsNearYouView extends GetView<LabsNearYouController> {
  const LabsNearYouView({super.key});

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
        title: const Text('Labs Near you',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
      body: Column(
        children: [
          // Location bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      color: Colors.black, size: 20),
                  const SizedBox(width: 8),
                  Text(controller.location,
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                  const Spacer(),
                  const Icon(Icons.keyboard_arrow_down,
                      color: Colors.black, size: 20),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              itemCount: controller.labs.length,
              itemBuilder: (context, i) => _labCard(controller.labs[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _labCard(Map<String, dynamic> lab) {
    return GestureDetector(
      onTap: () => controller.goToDetails(lab),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                lab['imagePath'] as String,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  color: const Color(0xFFE5E7EB),
                  child: const Center(
                      child: Icon(Icons.science,
                          size: 50, color: Color(0xFF9CA3AF))),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lab['name'] as String,
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Color(0xFFFBBF24), size: 16),
                      const SizedBox(width: 4),
                      Text(lab['rating'] as String,
                          style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.black)),
                      Text('  (${lab['reviews']})',
                          style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              color: Color(0xFF9CA3AF))),
                      const SizedBox(width: 14),
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 4),
                      Text(lab['distance'] as String,
                          style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              color: Color(0xFF9CA3AF))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: (lab['tags'] as List<String>)
                        .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: const Color(0xFFE5E7EB), width: 1.2),
                              ),
                              child: Text(tag,
                                  style: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF374151))),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(colors: [
                                Color(0xFF00897B),
                                Color(0xFF1565C0)
                              ]),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  controller.call(lab['phone'] as String),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              icon: const Icon(Icons.phone,
                                  color: Colors.white, size: 16),
                              label: const Text('Call',
                                  style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: OutlinedButton.icon(
                            onPressed: controller.directions,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Color(0xFF0D9488), width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            icon: const Icon(Icons.navigation_outlined,
                                color: Color(0xFF0D9488), size: 16),
                            label: const Text('Directions',
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0D9488))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
