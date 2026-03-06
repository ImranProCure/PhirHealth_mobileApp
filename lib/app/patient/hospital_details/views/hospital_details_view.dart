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
                children: [
                  // ===== MAP =====
                  Stack(
                    children: [
                      Image.asset(
                        'assets/map_placeholder.png',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 200,
                          color: const Color(0xFFE5E7EB),
                          child: const Center(
                            child: Icon(Icons.map_outlined,
                                size: 60, color: Color(0xFF9CA3AF)),
                          ),
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
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
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
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ===== HOSPITAL INFO =====
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
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
                                  Image.asset(
                                    'assets/icons/open_24.png',
                                    width: 16,
                                    height: 16,
                                    errorBuilder: (_, __, ___) => const Icon(
                                        Icons.access_time_outlined,
                                        size: 16,
                                        color: Color(0xFF0D9488)),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    controller.status,
                                    style: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0D9488),
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  Image.asset(
                                    'assets/icons/location_pin.png',
                                    width: 16,
                                    height: 16,
                                    errorBuilder: (_, __, ___) => const Icon(
                                        Icons.location_on_outlined,
                                        size: 16,
                                        color: Color(0xFF9CA3AF)),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${controller.distance} - 5 mins away',
                                    style: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 13,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const Divider(height: 1, color: Color(0xFFF3F4F6)),

                        // ===== SERVICES =====
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: controller.services.map((s) {
                                  return Column(
                                    children: [
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3F4F6),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Image.asset(
                                            s['imagePath'] as String,
                                            fit: BoxFit.contain,
                                            color: const Color(0xFF0D9488),
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(
                                              Icons.local_hospital_outlined,
                                              color: Color(0xFF0D9488),
                                              size: 28,
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

                        const Divider(height: 1, color: Color(0xFFF3F4F6)),

                        // ===== DEPARTMENTS =====
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                              const SizedBox(height: 8),
                              ...List.generate(
                                controller.departments.length,
                                (i) {
                                  final d = controller.departments[i];
                                  final bool isLast =
                                      i == controller.departments.length - 1;
                                  return Column(
                                    children: [
                                      _departmentTile(d),
                                      if (!isLast)
                                        const Divider(
                                            height: 1,
                                            color: Color(0xFFF3F4F6)),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const Divider(height: 1, color: Color(0xFFF3F4F6)),

                        // ===== CALL + DIRECTIONS =====
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF00897B),
                                          Color(0xFF1565C0)
                                        ],
                                      ),
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
                                  height: 50,
                                  child: OutlinedButton.icon(
                                    onPressed: controller.directions,
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Color(0xFF0D9488), width: 1.5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
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

  Widget _departmentTile(Map<String, dynamic> d) {
    final bool isAvailable = d['isAvailable'] as bool;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                d['imagePath'] as String,
                fit: BoxFit.contain,
                color: const Color(0xFF0D9488),
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.medical_services_outlined,
                  color: Color(0xFF0D9488),
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d['name'] as String,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  d['sub'] as String,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: isAvailable
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      d['available'] as String,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
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
