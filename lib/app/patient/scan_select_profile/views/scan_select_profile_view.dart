import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/scan_select_profile_controller.dart';

class ScanSelectProfileView extends GetView<ScanSelectProfileController> {
  const ScanSelectProfileView({super.key});

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
        title: const Text('Select Profile',
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
            const SizedBox(height: 4),

            // ===== WHO IS THIS SCAN FOR =====
            const Text('Who is this scan for?',
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.black)),
            const SizedBox(height: 6),
            const Text(
                'Select a profile to keep health records organized and personalized.',
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    height: 1.4)),
            const SizedBox(height: 20),

            // ===== PROFILE CARDS =====
            Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Existing profiles
                      ...List.generate(controller.profiles.length, (i) {
                        final bool isSelected =
                            controller.selectedIndex.value == i;
                        return GestureDetector(
                          onTap: () {
                            controller.selectProfile(i);
                            controller.proceed();
                          },
                          child: Container(
                            width: 90,
                            height: 110,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF0D9488)
                                    : const Color(0xFFE5E7EB),
                                width: isSelected ? 1.5 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2))
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    controller.profiles[i]['imagePath'],
                                    width: 54,
                                    height: 54,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 54,
                                      height: 54,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE0F2F1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.person_outline,
                                          color: Color(0xFF0D9488), size: 30),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(controller.profiles[i]['name'],
                                    style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? const Color(0xFF0D9488)
                                            : Colors.black)),
                              ],
                            ),
                          ),
                        );
                      }),

                      // Add button
                      GestureDetector(
                        onTap: controller.addProfile,
                        child: Container(
                          width: 90,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2))
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: const Color(0xFF0D9488),
                                      width: 1.5),
                                ),
                                child: const Icon(Icons.add,
                                    color: Color(0xFF0D9488), size: 26),
                              ),
                              const SizedBox(height: 8),
                              const Text('Add',
                                  style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0D9488))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 20),

            // ===== RECENT HISTORY =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent History',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.black)),
                      Icon(Icons.tune, color: Colors.black, size: 22),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // History items
                  ...List.generate(controller.recentHistory.length, (i) {
                    final h = controller.recentHistory[i];
                    final bool isLast =
                        i == controller.recentHistory.length - 1;
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () => controller.onHistoryTap(i),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                // Photo
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    h['imagePath'],
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFF3E0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.person,
                                          color: Color(0xFFF59E0B), size: 28),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Name + date
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(h['name'],
                                          style: const TextStyle(
                                              fontFamily: 'Mulish',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(h['date'],
                                              style: const TextStyle(
                                                  fontFamily: 'Mulish',
                                                  fontSize: 12,
                                                  color: Color(0xFF6B7280))),
                                          const Text('  |  ',
                                              style: TextStyle(
                                                  fontFamily: 'Mulish',
                                                  fontSize: 12,
                                                  color: Color(0xFF6B7280))),
                                          Text(h['time'],
                                              style: const TextStyle(
                                                  fontFamily: 'Mulish',
                                                  fontSize: 12,
                                                  color: Color(0xFF6B7280))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Arrow button
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0F2F1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.arrow_forward,
                                      color: Color(0xFF0D9488), size: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (!isLast)
                          const Divider(height: 1, color: Color(0xFFE5E7EB)),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
