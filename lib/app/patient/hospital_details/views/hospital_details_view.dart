import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hospital_details_controller.dart';

class HospitalDetailsView extends GetView<HospitalDetailsController> {
  const HospitalDetailsView({super.key});

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
          'Hospital Details',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== MAP IMAGE =====
                  Stack(
                    children: [
                      Image.asset(
                        'assets/Mask group copy.png',
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 180,
                          color: const Color(0xFFE5E7EB),
                          child: const Center(
                            child: Icon(Icons.map_outlined,
                                size: 60, color: Color(0xFF9CA3AF)),
                          ),
                        ),
                      ),
                      // Open Now badge
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D9488),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.circle, color: Colors.white, size: 8),
                              SizedBox(width: 6),
                              Text(
                                'OPEN NOW',
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ===== DETAILS CARD =====
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.name,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.address,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.access_time_outlined,
                                size: 14, color: Color(0xFF0D9488)),
                            const SizedBox(width: 4),
                            Text(
                              controller.status,
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF0D9488),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.location_on_outlined,
                                size: 14, color: Color(0xFF9CA3AF)),
                            const SizedBox(width: 4),
                            Text(
                              '${controller.distance} - 5 mins away',
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ===== SERVICES =====
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Services Available',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: controller.services.map((s) {
                            return Column(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0F2F1),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Image.asset(
                                      s['icon'] as String,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.local_hospital_outlined,
                                        color: Color(0xFF0D9488),
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  s['label'] as String,
                                  style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 11,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ===== DEPARTMENTS =====
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Department & Specialists',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(controller.departments.length, (i) {
                          final d = controller.departments[i];
                          final bool isLast =
                              i == controller.departments.length - 1;
                          return Column(
                            children: [
                              _departmentTile(d),
                              if (!isLast)
                                const Divider(
                                    height: 1, color: Color(0xFFF3F4F6)),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),

          // ===== BOTTOM BUTTONS =====
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                        ),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: controller.call,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        icon: const Icon(Icons.phone,
                            color: Colors.white, size: 18),
                        label: const Text(
                          'Call',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: controller.directions,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(0xFF0D9488), width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      icon: const Icon(Icons.navigation_outlined,
                          color: Color(0xFF0D9488), size: 18),
                      label: const Text(
                        'Directions',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _departmentTile(Map<String, dynamic> d) {
    final bool isAvailable = d['isAvailable'] as bool;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.medical_services_outlined,
                color: Color(0xFF0D9488), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d['name'] as String,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Text(
                  d['sub'] as String,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: isAvailable
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      d['available'] as String,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isAvailable
                            ? const Color(0xFF22C55E)
                            : const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 14, color: Color(0xFF9CA3AF)),
        ],
      ),
    );
  }
}
