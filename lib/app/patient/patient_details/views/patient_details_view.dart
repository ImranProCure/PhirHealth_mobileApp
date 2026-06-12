import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/patient_details_controller.dart';

class PatientDetailsView extends GetView<PatientDetailsController> {
  const PatientDetailsView({super.key});

  // ================= RESPONSIVE PATIENT CARD SIZE =================
  double _cardWidth(double available) => (available - 20) / 3;
  double _cardHeight(double cardWidth) => cardWidth / 0.88;

  // ================= SKELETON =================
  Widget _buildSkeleton() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
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
                      _skeletonBox(width: 160, height: 16),
                      const SizedBox(height: 8),
                      _skeletonBox(width: 220, height: 12),
                      const SizedBox(height: 20),
                      LayoutBuilder(builder: (context, constraints) {
                        final cw = _cardWidth(constraints.maxWidth);
                        final ch = _cardHeight(cw);
                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                            6,
                            (_) => SizedBox(
                              width: cw,
                              height: ch,
                              child: _skeletonCard(),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
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
                      _skeletonBox(width: 160, height: 16),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          6,
                          (_) =>
                              _skeletonBox(width: 80, height: 34, radius: 30),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 8),
          _skeletonBox(width: 50, height: 11),
          const SizedBox(height: 4),
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

  // ================= ADD OTHER DIALOG =================
  void _showAddOtherDialog(BuildContext context) {
    final TextEditingController otherCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Add Symptom",
          style: TextStyle(
              fontFamily: 'Mulish', fontWeight: FontWeight.w700, fontSize: 16),
        ),
        content: TextField(
          controller: otherCtrl,
          autofocus: true,
          style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
          decoration: InputDecoration(
            hintText: "e.g. Back pain",
            hintStyle: const TextStyle(
                fontFamily: 'Mulish', fontSize: 14, color: Color(0xFF9CA3AF)),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF0D9488), width: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Cancel",
              style: TextStyle(
                  fontFamily: 'Mulish',
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final val = otherCtrl.text.trim();
              if (val.isNotEmpty) {
                controller.addCustomSymptom(val);
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D9488),
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              "Add",
              style: TextStyle(
                  fontFamily: 'Mulish',
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  // ================= PATIENT CARD (fully responsive) =================
  Widget _patientCard({
    required String relation,
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
    required double width,
    required double height,
  }) {
    final double iconSize = (width * 0.38).clamp(28.0, 44.0);
    final double avatarSize = (width * 0.52).clamp(36.0, 52.0);
    final double relationFontSize = (width * 0.115).clamp(10.0, 13.0);
    final double nameFontSize = (width * 0.10).clamp(9.0, 11.5);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width,
        height: height,
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
                top: 7,
                right: 7,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? const Color(0xFF0D9488).withOpacity(0.12)
                          : const Color(0xFFF3F4F6),
                    ),
                    child: Icon(
                      Icons.account_circle_outlined,
                      size: iconSize,
                      color: isSelected
                          ? const Color(0xFF0D9488)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      relation,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: relationFontSize,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? const Color(0xFF0D9488)
                            : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: nameFontSize,
                        color: const Color(0xFF6B7280),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

  // ================= ADD MEMBER CARD (responsive) =================
  Widget _addMemberCard(BuildContext context, double width, double height) {
    return GestureDetector(
      onTap: () => controller.showAddMemberSheet(context),
      child: Container(
        width: width,
        height: height,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: (width * 0.52).clamp(36.0, 52.0),
                height: (width * 0.52).clamp(36.0, 52.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0D9488).withOpacity(0.09),
                  border:
                      Border.all(color: const Color(0xFF0D9488), width: 1.5),
                ),
                child: Icon(
                  Icons.add,
                  size: (width * 0.26).clamp(16.0, 24.0),
                  color: const Color(0xFF0D9488),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Add",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: (width * 0.115).clamp(10.0, 13.0),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D9488),
                ),
              ),
              Text(
                "Member",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: (width * 0.10).clamp(9.0, 11.5),
                  color: const Color(0xFF0D9488),
                ),
              ),
            ],
          ),
        ),
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
          style: const TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),

      // ✅ SINGLE Obx — covers ALL reactive values in this screen
      body: Obx(() {
        // Loading state
        if (controller.isPatientLoading.value) {
          return _ShimmerWrapper(child: _buildSkeleton());
        }

        // Read all reactive values ONCE at the top — no nested Obx needed
        final patients = controller.patients;
        final selectedIndex = controller.selectedPatientIndex.value;
        final isSymptomsLoading = controller.isSymptomsLoading.value;
        final symptoms = controller.symptoms;
        final selectedSymptoms = controller.selectedSymptoms;

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
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "patient_details_one_member".tr,
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ---- Responsive patient cards ----
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final cw = _cardWidth(constraints.maxWidth);
                              final ch = _cardHeight(cw);
                              return Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  // ✅ No inner Obx — outer Obx handles reactivity
                                  ...List.generate(patients.length, (i) {
                                    final patient = patients[i];
                                    return _patientCard(
                                      relation: patient["relation"] ?? "",
                                      name: patient["name"] ?? "",
                                      isSelected: selectedIndex == i,
                                      onTap: () => controller.selectPatient(i),
                                      width: cw,
                                      height: ch,
                                    );
                                  }),
                                  _addMemberCard(context, cw, ch),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ===== COMMON SYMPTOMS CARD =====
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
                          const Text(
                            "Common Symptoms",
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Select symptoms the patient is experiencing",
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // ✅ No inner Obx — outer Obx handles reactivity
                          if (isSymptomsLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: CircularProgressIndicator(
                                  color: Color(0xFF0D9488),
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ...symptoms.map((s) {
                                  final isSel = selectedSymptoms.contains(s);
                                  return GestureDetector(
                                    onTap: () => controller.toggleSymptom(s),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 150),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: isSel
                                            ? const Color(0xFF0D9488)
                                                .withOpacity(0.08)
                                            : const Color(0xFFF9FAFB),
                                        border: Border.all(
                                          color: isSel
                                              ? const Color(0xFF0D9488)
                                              : const Color(0xFFE5E7EB),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 16,
                                            height: 16,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isSel
                                                  ? const Color(0xFF0D9488)
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: isSel
                                                    ? const Color(0xFF0D9488)
                                                    : const Color(0xFFD1D5DB),
                                                width: 1.5,
                                              ),
                                            ),
                                            child: isSel
                                                ? const Icon(Icons.check,
                                                    size: 10,
                                                    color: Colors.white)
                                                : null,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            s,
                                            style: TextStyle(
                                              fontFamily: 'Mulish',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: isSel
                                                  ? const Color(0xFF0D9488)
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),

                                // Add Other chip
                                GestureDetector(
                                  onTap: () => _showAddOtherDialog(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: const Color(0xFF0D9488)
                                            .withOpacity(0.5),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.add,
                                            size: 14, color: Color(0xFF0D9488)),
                                        SizedBox(width: 4),
                                        Text(
                                          "Add Other",
                                          style: TextStyle(
                                            fontFamily: 'Mulish',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF0D9488),
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
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward,
                          color: Colors.white, size: 18),
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
