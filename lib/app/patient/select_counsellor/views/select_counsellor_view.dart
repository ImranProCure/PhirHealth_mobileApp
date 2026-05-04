import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/patient/select_counsellor/controllers/select_counsellor_controller.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';

class SelectCounsellorView extends GetView<SelectCounsellorController> {
  const SelectCounsellorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Select Your Expert Counsellor",
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: const [],
      ),
      // ================= BODY =================
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ================= SEARCH =================
                TextField(
                  onChanged: (value) => controller.onSearchChanged(value),
                  onSubmitted: (_) => controller.onSearchSubmitted(),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: "Search Counsellor or specialty",
                    hintStyle: const TextStyle(
                      fontFamily: 'Mulish',
                      color: Color(0xFF9CA3AF),
                    ),
                    prefixIcon:
                        const Icon(Icons.search, color: Color(0xFF6B7280)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),

                const SizedBox(height: 24),

                // ================= SPECIALTIES TITLE =================
                const Text(
                  "Specialties",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 16),

                // ================= SPECIALTIES CHIPS =================
                Obx(() {
                  if (controller.isSpecialitiesLoading.value) {
                    return _ShimmerWrapper(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            5,
                            (i) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: _skeletonBox(
                                  width: 90, height: 40, radius: 30),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: controller.specialties.map((item) {
                        final selected =
                            controller.selectedSpecialties.contains(item);
                        IconData icon;
                        switch (item.toLowerCase()) {
                          case "general":
                            icon = Icons.add_box_outlined;
                            break;
                          case "skin":
                            icon = Icons.spa_outlined;
                            break;
                          case "kids":
                            icon = Icons.child_care_outlined;
                            break;
                          case "women":
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
                                  Icon(icon,
                                      size: 18, color: const Color(0xFF0D9488)),
                                  const SizedBox(width: 4),
                                  Text(
                                    item,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0D9488),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // ================= DOCTOR LIST =================
                Obx(() {
                  if (controller.isDoctorsLoading.value) {
                    return _ShimmerWrapper(
                      child: Column(
                        children:
                            List.generate(4, (_) => _doctorCardSkeleton()),
                      ),
                    );
                  }

                  if (controller.doctors.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Text(
                          "No doctors found",
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                            fontFamily: 'Mulish',
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: controller.doctors
                        .map((doctor) => _doctorCard(doctor))
                        .toList(),
                  );
                }),

                // ================= LOAD MORE INDICATOR =================
                Obx(() {
                  if (!controller.isLoadingMore.value)
                    return const SizedBox.shrink();
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF0D9488),
                      ),
                    ),
                  );
                }),

                // ================= END OF LIST =================
                Obx(() {
                  if (controller.hasMoreData.value ||
                      controller.isDoctorsLoading.value ||
                      controller.doctors.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        "No more doctors",
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 13,
                          fontFamily: 'Mulish',
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SKELETON BOX =================
  Widget _skeletonBox({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  // ================= DOCTOR CARD SKELETON =================
  Widget _doctorCardSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Top row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              _skeletonBox(width: 80, height: 80, radius: 16),
              const SizedBox(width: 14),
              // Text placeholders
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _skeletonBox(width: 140, height: 16),
                    const SizedBox(height: 8),
                    _skeletonBox(width: 180, height: 13),
                    const SizedBox(height: 10),
                    _skeletonBox(width: 110, height: 12),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Rating placeholder
              _skeletonBox(width: 52, height: 28, radius: 14),
            ],
          ),
          const SizedBox(height: 16),
          // Divider placeholder
          _skeletonBox(width: double.infinity, height: 1),
          const SizedBox(height: 14),
          // Bottom row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _skeletonBox(width: 80, height: 24),
              _skeletonBox(width: 100, height: 40, radius: 12),
            ],
          ),
        ],
      ),
    );
  }

  // ================= DOCTOR CARD =================
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: (doctor["image"] != null &&
                          doctor["image"].toString().isNotEmpty)
                      ? Image.network(
                          ApiConstants.baseUrl + doctor["image"],
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 80,
                              width: 80,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.person,
                                  size: 40, color: Colors.grey),
                            );
                          },
                        )
                      : doctor["gender"] == "Female"
                          ? Container(
                              height: 80,
                              width: 80,
                              color: Colors.grey.shade200,
                              child: Image.asset("assets/female-Doctor.png"),
                            )
                          : Container(
                              height: 80,
                              width: 80,
                              color: Colors.grey.shade200,
                              child: Image.asset("assets/male-Doctor.png"),
                            ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor["name"],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${doctor["degree"]} : ${doctor["speciality"]}",
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFF6B7280)),
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
                            color: Color(0XFFA76D24)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    children: [
                      const TextSpan(text: "Fee "),
                      TextSpan(
                        text: " ₹ ${doctor["fee"]}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: doctor["available"]
                      ? () => controller.bookDoctor(doctor)
                      : null,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: doctor["available"]
                          ? const Color(0xFF0D9488)
                          : Colors.grey,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
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

// ================= SHIMMER WRAPPER =================
class _ShimmerWrapper extends StatefulWidget {
  final Widget child;
  const _ShimmerWrapper({required this.child});

  @override
  State<_ShimmerWrapper> createState() => _ShimmerWrapperState();
}

class _ShimmerWrapperState extends State<_ShimmerWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFEEEEEE),
                Color(0xFFFFFFFF),
                Color(0xFFEEEEEE),
              ],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
              transform: GradientRotation(_animation.value),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
