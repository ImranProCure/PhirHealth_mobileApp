import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      bottomNavigationBar: _BottomNav(controller: controller),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              const SizedBox(height: 16),
              _DoctorActionsSection(controller: controller),
              const SizedBox(height: 24),
              _AiMedicineFitnessSection(controller: controller),
              const SizedBox(height: 24),
              const _PromoBanner(),
              const SizedBox(height: 24),
              _SmartHealthToolsSection(controller: controller),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= HEADER =================
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/profile.png'),
              ),
              const SizedBox(width: 12),
              const Text(
                'Hey, John',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Icon(Icons.search, size: 24),
              SizedBox(width: 12),
              Icon(Icons.notifications_none, size: 24),
            ],
          ),
        ],
      ),
    );
  }
}

// ================= DOCTOR ACTIONS =================
class _DoctorActionsSection extends StatelessWidget {
  final DashboardController controller;
  const _DoctorActionsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Doctor & Quick Actions'),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.doctorActions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 20,
              crossAxisSpacing: 12,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (context, index) {
              final action = controller.doctorActions[index];
              return GestureDetector(
                onTap: () => controller.onDoctorActionTap(index),
                child: Column(
                  children: [
                    Image.asset(
                      action['icon']!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.local_hospital, size: 40),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 90,
                      child: Text(
                        action['label']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ================= AI + MEDICINE + FITNESS =================
class _AiMedicineFitnessSection extends StatelessWidget {
  final DashboardController controller;
  const _AiMedicineFitnessSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cancer AI Card
          Expanded(
            child: GestureDetector(
              onTap: controller.goToCancerAiScan,
              child: Container(
                height: 170,
                padding: const EdgeInsets.all(16),
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
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Cancer Risk AI Scan',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Early detection saves lives.\nCheck your risk now.',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/icons/cancer-cell 1.png',
                        width: 80,
                        height: 80,
                        errorBuilder: (_, __, ___) =>
                            const SizedBox(width: 80, height: 80),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Medicine & Fitness Cards
          Expanded(
            child: Column(
              children: [
                // ===== MEDICINES & LAB DISCOUNTS → /savings-offers =====
                GestureDetector(
                  onTap: controller.goToSavingsOffers,
                  child: Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Medicines &\nLab Discounts',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/icons/best-offer 1.png',
                          width: 40,
                          height: 40,
                          errorBuilder: (_, __, ___) =>
                              const SizedBox(width: 40, height: 40),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // ===== TRACK STEPS & FITNESS =====
                GestureDetector(
                  onTap: controller.goToFitnessTracker,
                  child: Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Track Steps\n& Fitness',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/icons/footprint 1.png',
                          width: 40,
                          height: 40,
                          errorBuilder: (_, __, ___) =>
                              const SizedBox(width: 40, height: 40),
                        ),
                      ],
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

// ================= PROMO BANNER =================
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 130,
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/Gemini_Generated_Image_rb2batrb2batrb2b.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFFE5E7EB),
              child: const Center(
                child: Icon(Icons.image, size: 50, color: Color(0xFF9CA3AF)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= SMART HEALTH TOOLS =================
class _SmartHealthToolsSection extends StatelessWidget {
  final DashboardController controller;
  const _SmartHealthToolsSection({required this.controller});

  static const List<Color> _colors = [
    Color(0xFFE6F5F3),
    Color(0xFFFFECEC),
    Color(0xFFFFF6E5),
  ];

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Smart Health Tools'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(controller.smartTools.length, (index) {
              final tool = controller.smartTools[index];
              return GestureDetector(
                onTap: () => controller.onSmartToolTap(index),
                child: Container(
                  width: 103,
                  height: 146,
                  decoration: BoxDecoration(
                    color: _colors[index],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                        child: Text(
                          tool['title'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Image.asset(
                          tool['icon'] as String,
                          height: 70,
                          width: 70,
                          errorBuilder: (_, __, ___) =>
                              const SizedBox(height: 70, width: 70),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ================= REUSABLE =================
class _WhiteCard extends StatelessWidget {
  final Widget child;
  const _WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: child,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Mulish',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1F2937),
      ),
    );
  }
}

// ================= BOTTOM NAV =================
class _BottomNav extends StatelessWidget {
  final DashboardController controller;
  const _BottomNav({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D9488), Color(0xFF2563EB)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D9488).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                  icon: Icons.home,
                  label: 'Home',
                  isActive: controller.selectedNavIndex.value == 0,
                  onTap: () => controller.selectNav(0)),
              _NavItem(
                  icon: Icons.medical_services_outlined,
                  label: 'Doctor',
                  isActive: controller.selectedNavIndex.value == 1,
                  onTap: () => controller.selectNav(1)),
              _NavItem(
                  icon: Icons.receipt_long_outlined,
                  label: 'Policy',
                  isActive: controller.selectedNavIndex.value == 2,
                  onTap: () => controller.selectNav(2)),
              _NavItem(
                  icon: Icons.person_outline,
                  label: 'My Profile',
                  isActive: controller.selectedNavIndex.value == 3,
                  onTap: () => controller.selectNav(3)),
            ],
          )),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: isActive ? 26 : 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
