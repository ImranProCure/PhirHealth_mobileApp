import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/patient/select_doctor/controllers/select_doctor_controller.dart';

class SelectDoctorView extends GetView<SelectDoctorController> {
  const SelectDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Select a Doctor",
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color: Colors.black),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= SEARCH =================
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Color(0xFF6B7280)),
                        SizedBox(width: 8),
                        Text(
                          "Search doctor or specialty",
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF00786F),
                        Color(0xFF009689),
                        Color(0xFF1447E6),
                      ],
                    ),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ================= SPECIALTIES =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Specialties",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "See All",
                  style: TextStyle(
                    color: Color(0xFF0D9488),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.specialties.map((item) {
                      final selected =
                          controller.selectedSpecialties.contains(item);

                      IconData icon;

                      switch (item) {
                        case "General":
                          icon = Icons.add_box_outlined;
                          break;
                        case "Skin":
                          icon = Icons.spa_outlined;
                          break;
                        case "Kids":
                          icon = Icons.child_care_outlined;
                          break;
                        case "Women":
                          icon = Icons.female_outlined;
                          break;
                        default:
                          icon = Icons.medical_services_outlined;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: GestureDetector(
                          onTap: () => controller.selectSpecialty(item),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF0D9488)
                                    : const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  icon,
                                  size: 18,
                                  color: const Color(0xFF0D9488), // ALWAYS TEAL
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0D9488), // ALWAYS TEAL
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )),

            const SizedBox(height: 24),

            // ================= DOCTOR LIST =================
            Obx(() => Column(
                  children: controller.doctors
                      .map((doctor) => _doctorCard(doctor))
                      .toList(),
                )),
          ],
        ),
      ),
    );
  }

  Widget _doctorCard(Map doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ================= TOP SECTION =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== IMAGE =====
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    doctor["image"],
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 14),

                // ===== DETAILS =====
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor["name"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor["degree"],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: doctor["available"]
                                  ? const Color(0xFF16A34A)
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            doctor["available"]
                                ? "Available Today"
                                : "Next Tomorrow",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: doctor["available"]
                                  ? const Color(0xFF16A34A)
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ===== RATING =====
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBD3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        doctor["rating"].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Color(0XFFA76D24)
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE5E7EB),
          ),

          // ================= BOTTOM SECTION =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(text: "Fee "),
                      TextSpan(
                        text: " ₹ ${doctor["fee"]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: doctor["available"]
                      ? () => controller.bookDoctor(doctor)
                      : null,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF0D9488),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 10),
                  ),
                  child: Text(
                    doctor["available"] ? "Book Now" : "Slots Full",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: doctor["available"]
                          ? const Color(0xFF0D9488)
                          : Colors.grey,
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
}
