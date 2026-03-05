import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/find_hospital_controller.dart';

class FindHospitalView extends GetView<FindHospitalController> {
  const FindHospitalView({super.key});

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
          'Find Hospital',
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
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                // ===== LOCATION =====
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: Color(0xFF0D9488), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        controller.location,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.keyboard_arrow_down,
                          color: Color(0xFF6B7280), size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ===== FILTERS =====
                Obx(() => Row(
                      children: controller.filters.map((f) {
                        final bool isSelected =
                            controller.selectedFilter.value == f;
                        IconData icon = Icons.grid_view_rounded;
                        if (f == 'Emergency') icon = Icons.emergency_outlined;
                        if (f == 'Pharmacy')
                          icon = Icons.local_pharmacy_outlined;

                        return GestureDetector(
                          onTap: () => controller.selectFilter(f),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF0D9488)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF0D9488)
                                    : const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(icon,
                                    size: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF0D9488)),
                                const SizedBox(width: 4),
                                Text(
                                  f,
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )),
              ],
            ),
          ),

          // ===== HOSPITAL LIST =====
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.hospitals.length,
              itemBuilder: (context, i) =>
                  _hospitalCard(controller.hospitals[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hospitalCard(Map<String, dynamic> hospital) {
    return GestureDetector(
      onTap: () => controller.goToDetails(hospital),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
            // Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                hospital['imagePath'] as String,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 150,
                  color: const Color(0xFFE5E7EB),
                  child: const Center(
                    child: Icon(Icons.local_hospital,
                        size: 50, color: Color(0xFF9CA3AF)),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    hospital['name'] as String,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Status + Distance
                  Row(
                    children: [
                      const Icon(Icons.access_time_outlined,
                          size: 14, color: Color(0xFF0D9488)),
                      const SizedBox(width: 4),
                      Text(
                        hospital['status'] as String,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 12,
                          color: Color(0xFF0D9488),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 4),
                      Text(
                        hospital['distance'] as String,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Tags
                  Wrap(
                    spacing: 8,
                    children: (hospital['tags'] as List<String>).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            color: Color(0xFF374151),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                              ),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  controller.call(hospital['phone'] as String),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              icon: const Icon(Icons.phone,
                                  color: Colors.white, size: 16),
                              label: const Text(
                                'Call',
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 42,
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
                            label: const Text(
                              'Directions',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D9488),
                              ),
                            ),
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
