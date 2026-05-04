import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/patient_details_controller.dart';

class PatientDetailsView extends GetView<PatientDetailsController> {
  const PatientDetailsView({super.key});

  // ================= SKELETON =================
  Widget _buildSkeleton() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Who is the patient?" title
                  _skeletonBox(width: 160, height: 16),
                  const SizedBox(height: 8),
                  // Subtitle
                  _skeletonBox(width: 220, height: 12),
                  const SizedBox(height: 20),
                  // Grid of skeleton patient cards (3 columns × 2 rows)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: 6,
                    itemBuilder: (_, __) => _skeletonCard(),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Bottom button skeleton
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: _skeletonBox(width: double.infinity, height: 54, radius: 30),
        ),
      ],
    );
  }

  Widget _skeletonCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 8),
          // Relation label
          _skeletonBox(width: 50, height: 11),
          const SizedBox(height: 4),
          // Name label
          _skeletonBox(width: 40, height: 10),
        ],
      ),
    );
  }

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
        title: Text(
          "patient_details_title".tr,
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: const [
          // Padding(
          //   padding: EdgeInsets.only(right: 16),
          //   child: Icon(Icons.share_outlined, color: Colors.black),
          // ),
        ],
      ),
      body: Obx(() {
        if (controller.isPatientLoading.value) {
          return _ShimmerWrapper(child: _buildSkeleton());
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // ===== WHO IS PATIENT — GRID =====
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "patient_details_who".tr,
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "patient_details_one_member".tr,
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ---- Grid of patient cards ----
                          Obx(() {
                            final itemCount = controller.patients.length + 1;
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.85,
                              ),
                              itemCount: itemCount,
                              itemBuilder: (context, i) {
                                if (i == controller.patients.length) {
                                  return _addMemberCard(context);
                                }
                                final patient = controller.patients[i];
                                return Obx(() => _patientCard(
                                      // ← Obx per card
                                      relation: patient["relation"] ?? "",
                                      name: patient["name"] ?? "",
                                      isSelected: controller
                                              .selectedPatientIndex.value ==
                                          i, // ← reads reactive value
                                      onTap: () => controller.selectPatient(i),
                                    ));
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===== NEXT STEP BUTTON =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: controller.goToNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "next_button".tr,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ===== PATIENT CARD =====
  Widget _patientCard({
    required String relation,
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0D9488).withOpacity(0.07)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF0D9488) : const Color(0xFFE5E7EB),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF0D9488),
                  ),
                  child: const Icon(Icons.check, size: 11, color: Colors.white),
                ),
              ),
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? const Color(0xFF0D9488).withOpacity(0.12)
                            : const Color(0xFFF3F4F6),
                      ),
                      child: Icon(
                        Icons.account_circle_outlined,
                        size: 28,
                        color: isSelected
                            ? const Color(0xFF0D9488)
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      relation,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? const Color(0xFF0D9488)
                            : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== ADD MEMBER CARD =====
  Widget _addMemberCard(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.showAddMemberSheet(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF0D9488).withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0D9488).withOpacity(0.09),
                  border: Border.all(
                    color: const Color(0xFF0D9488),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  size: 20,
                  color: Color(0xFF0D9488),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Add",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D9488),
                ),
              ),
              const Text(
                "Member",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 11,
                  color: Color(0xFF0D9488),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= SHIMMER WRAPPER (same as MedicalHistoryEditView) =================
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
