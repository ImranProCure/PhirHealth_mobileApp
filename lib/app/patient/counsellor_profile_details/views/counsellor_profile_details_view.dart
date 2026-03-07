import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/counsellor_profile_details_controller.dart';

class CounsellorProfileDetailsView extends GetView<CounsellorProfileDetailsController> {
  const CounsellorProfileDetailsView({super.key});

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
          "Profile Details",
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
            child: Icon(Icons.share_outlined, color: Colors.black),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _doctorCard(),
            const SizedBox(height: 16),
            _appointmentCard(),
            const SizedBox(height: 16),
            _recommendedCard(),
            const SizedBox(height: 16),
            _locationCard(),
            const SizedBox(height: 16),
            _clinicPhotosCard(),
            const SizedBox(height: 16),
            _servicesCard(),
            const SizedBox(height: 16),
            _specializationsCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ================= DOCTOR CARD =================
  Widget _doctorCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  "assets/icons/freepik__female-doctor-in-white-coat-stethoscope-holding-cl__89801 1.png",
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Dr. Jyoti Wadhwani",
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "General Physician",
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "MBBS, MD - General Medicine",
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.favorite_border, color: Colors.black54),
            ],
          ),
          const SizedBox(height: 18),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _InfoItem(Icons.work_outline, "15 Years Exp."),
              _VerticalDivider(),
              _InfoItem(Icons.thumb_up_alt_outlined, "100%"),
              _VerticalDivider(),
              _InfoItem(Icons.chat_bubble_outline, "5 Review"),
            ],
          ),
        ],
      ),
    );
  }

  // ================= APPOINTMENT CARD =================
  Widget _appointmentCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TABS
          Obx(() => Row(
                children: [
                  _tab("Clinic Visit", Icons.local_hospital_outlined, 0),
                  const SizedBox(width: 10),
                  _tab("Video Consult", Icons.videocam_outlined, 1),
                ],
              )),

          const SizedBox(height: 20),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "In-Clinic Appointment",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "₹500",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(color: Color(0xFFE5E7EB)),
          const SizedBox(height: 12),

          _detailRow(Icons.medical_services_outlined, "Preventive Healthcare"),
          const SizedBox(height: 10),
          _detailRow(Icons.location_on_outlined,
              "Rasoma Square, AB Rd, Vijay Nagar, Indore"),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.hourglass_bottom_outlined,
                    size: 16, color: Colors.black54),
                SizedBox(width: 8),
                Text("Note: Max ",
                    style: TextStyle(fontFamily: 'Mulish', fontSize: 13)),
                Text(
                  "30 mins",
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      fontWeight: FontWeight.w700),
                ),
                Text(" wait",
                    style: TextStyle(fontFamily: 'Mulish', fontSize: 13)),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // MONTH ROW
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: controller.prevMonth,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.arrow_back_ios,
                          size: 14, color: Colors.black54),
                    ),
                  ),
                  Text(
                    controller.currentMonthLabel.value,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.nextMonth,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.arrow_forward_ios,
                          size: 14, color: Colors.black54),
                    ),
                  ),
                ],
              )),

          const SizedBox(height: 16),

          // DATE SLIDER
          Obx(() {
            final selectedIdx = controller.selectedDateIndex.value;
            return SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.dates.length,
                itemBuilder: (context, index) {
                  final item = controller.dates[index];
                  final bool selected = selectedIdx == index;
                  final int slots = item["slots"] as int;

                  return GestureDetector(
                    onTap: () => controller.selectDate(index),
                    child: SizedBox(
                      width: 66,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Stack(
                          children: [
                            // Base border container
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                                border:
                                    Border.all(color: const Color(0xFFE5E7EB)),
                              ),
                            ),
                            // Gradient layer
                            AnimatedOpacity(
                              opacity: selected ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 220),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF00897B),
                                      Color(0xFF1565C0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Content
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      item["date"].toString(),
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: selected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Center(
                                    child: Text(
                                      item["day"].toString(),
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: selected
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Center(
                                    child: Text(
                                      slots == 0 ? "Full" : "$slots Slots",
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: selected
                                            ? Colors.white
                                            : slots == 0
                                                ? Colors.redAccent
                                                : const Color(0xFF0D9488),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),

          const SizedBox(height: 16),

          // TIME SLOTS
          Obx(() => controller.timeSlots.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      "No slots available for this day",
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        color: Color(0xFF6B7280),
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.timeSlots
                      .map((time) => _timeChip(time))
                      .toList(),
                )),

          const SizedBox(height: 16),

          Center(
            child: GestureDetector(
              onTap: controller.viewAllSlots,
              child: const Text(
                "View all slots >",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  color: Color(0xFF0D9488),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HIGHLY RECOMMENDED CARD =================
  Widget _recommendedCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Highly Recommended for",
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Doctor Friendliness",
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "100% patients find the doctor friendly and approachable",
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.favorite_border,
                  color: Colors.black54, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE5E7EB)),
          const SizedBox(height: 16),
          const Text(
            "Patient Stories",
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "100% patients find the doctor friendly and approachable",
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 12,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          _reviewTile(
            name: "Dr. Snehal Mhaskar",
            rating: 3.5,
            time: "2 months ago",
            review:
                "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo con",
          ),
          const SizedBox(height: 12),
          _reviewTile(
            name: "Dr. Snehal Mhaskar",
            rating: 3.0,
            time: "7 months ago",
            review:
                "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo con",
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0D9488)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Share Your Story",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      color: Color(0xFF0D9488),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0D9488)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Read 10 Stories",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      color: Color(0xFF0D9488),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reviewTile({
    required String name,
    required double rating,
    required String time,
    required String review,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE0E7FF),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: const Text(
            "DS",
            style: TextStyle(
              fontFamily: 'Mulish',
              fontWeight: FontWeight.w700,
              color: Color(0xFF3730A3),
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.thumb_up_alt_outlined,
                      size: 16, color: Colors.black45),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _starRating(rating),
                  const SizedBox(width: 8),
                  Text(
                    time,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                review,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _starRating(double rating) {
    return Row(
      children: List.generate(5, (i) {
        if (i < rating.floor()) {
          return const Icon(Icons.star, size: 13, color: Color(0xFFFBBF24));
        } else if (i < rating && rating - i >= 0.5) {
          return const Icon(Icons.star_half,
              size: 13, color: Color(0xFFFBBF24));
        } else {
          return const Icon(Icons.star_border,
              size: 13, color: Color(0xFFFBBF24));
        }
      }),
    );
  }

  // ================= LOCATION CARD =================
  Widget _locationCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Location",
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          // 👇 Apni location image ki asset path yahan lagao
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              "assets/icons/Mask group copy 2.png",
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  // ================= CLINIC PHOTOS CARD =================
  Widget _clinicPhotosCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Clinic Photos",
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Photo 1
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    "assets/icons/Rectangle 39864.png",
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Photo 2
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    "assets/icons/Rectangle 39865.png",
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Photo 3 with overlay
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Image.asset(
                        "assets/icons/Rectangle 39865.png",
                        height: 90,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "2+ more\nphotos",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= SERVICES CARD =================
  Widget _servicesCard() {
    final services = [
      "Viral Fever Treatment",
      "Diabetes Management",
      "Blood Pressure & Hypertension",
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Services and Procedures",
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Dr. Snehal Mhaskar Specializes in the following services and procedures.",
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 12,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          ...services.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0D9488),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.check, size: 12, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    s,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {},
            child: const Text(
              "View all Services & Procedures >",
              style: TextStyle(
                fontFamily: 'Mulish',
                color: Color(0xFF0D9488),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SPECIALIZATIONS CARD =================
  Widget _specializationsCard() {
    final specs = [
      "Internal Medicine",
      "Infectious Diseases",
      "Preventive Healthcare",
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Specializations",
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: specs.map((s) {
              return SizedBox(
                width: (MediaQuery.of(Get.context!).size.width - 80) / 2,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D9488),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check,
                          size: 12, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: const Text(
              "View all Specializations >",
              style: TextStyle(
                fontFamily: 'Mulish',
                color: Color(0xFF0D9488),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== TAB WIDGET =====
  Widget _tab(String text, IconData icon, int index) {
    final selected = controller.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Stack(
          children: [
            // Base grey background — always visible
            Container(
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xFFE5E7EB),
              ),
            ),
            // Gradient layer — fades in/out using opacity, no null gradient flicker
            AnimatedOpacity(
              opacity: selected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 220),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                  ),
                ),
              ),
            ),
            // Icon + Text on top
            SizedBox(
              height: 46,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 17,
                    color: selected ? Colors.white : Colors.black54,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: selected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== TIME CHIP =====
  Widget _timeChip(String time) {
    final selected = controller.selectedSlot.value == time;
    return GestureDetector(
      onTap: () => controller.selectSlot(time),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: selected
              ? const Color(0xFF0D9488).withOpacity(0.08)
              : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFF0D9488) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          time,
          style: TextStyle(
            fontFamily: 'Mulish',
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: selected ? const Color(0xFF0D9488) : Colors.black87,
          ),
        ),
      ),
    );
  }

  // ===== DETAIL ROW =====
  Widget _detailRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: Colors.black54),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 13,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }
}

// ===== REUSABLE SMALL WIDGETS =====

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: Colors.black54),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontFamily: 'Mulish', fontSize: 12),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 22, width: 1, color: const Color(0xFFE5E7EB));
  }
}
