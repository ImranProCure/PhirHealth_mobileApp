import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/db/db.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(isTablet: tablet),
                      const SizedBox(height: 16),
                      _DoctorActionsSection(
                          controller: controller, isTablet: tablet),
                      const SizedBox(height: 24),
                      _AiMedicineFitnessSection(
                          controller: controller, isTablet: tablet),
                      const SizedBox(height: 24),
                      const _PromoBanner(),
                      const SizedBox(height: 24),
                      _SmartHealthToolsSection(
                          controller: controller, isTablet: tablet),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// Bottom Navigation
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: _BottomNav(controller: controller, isTablet: tablet),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// HEADER
///////////////////////////////////////////////////////////////

class _Header extends StatelessWidget {
  final bool isTablet;
  _Header({required this.isTablet});
  final authStorage = AuthStorageService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder(
              future: authStorage.getUserDetail(),
              builder: (context, snapshot) {
                final fullName = snapshot.data?['full_name'] ?? '';
                final image = snapshot.data?['user_image'] ?? '';
                return Row(
                  children: [
                    CircleAvatar(
                      radius: isTablet ? 30 : 24,
                      backgroundImage:
                          NetworkImage("${ApiConstants.baseUrl}$image"),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      fullName,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: isTablet ? 22 : 18,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                );
              }),
          const Row(
            children: [
              Icon(Icons.search),
              SizedBox(width: 12),
              Icon(Icons.notifications_none),
            ],
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// DOCTOR ACTIONS
///////////////////////////////////////////////////////////////

class _DoctorActionsSection extends StatelessWidget {
  final DashboardController controller;
  final bool isTablet;

  const _DoctorActionsSection({
    required this.controller,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Doctor & Quick Actions'),
          const SizedBox(height: 16),

          // ── TABLET: horizontal two-column list ────────────
          if (isTablet)
            _buildTabletList()
          // ── PHONE: 3-col icon grid ─────────────────────────
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.doctorActions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final action = controller.doctorActions[index];
                return GestureDetector(
                  onTap: () => controller.onDoctorActionTap(index),
                  child: Column(
                    children: [
                      Image.asset(
                        action['icon']!,
                        width: 55,
                        height: 55,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.local_hospital, size: 40),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        child: Text(
                          action['label']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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

  /// Two-column list layout for tablet
  Widget _buildTabletList() {
    final actions = controller.doctorActions;
    // Split into two columns
    final int half = (actions.length / 2).ceil();
    final leftCol = actions.sublist(0, half);
    final rightCol = actions.sublist(half);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column
        Expanded(child: _buildColumn(leftCol, 0)),
        const SizedBox(width: 12),
        // Vertical divider
        Container(width: 1, color: const Color(0xFFF3F4F6)),
        const SizedBox(width: 12),
        // Right column
        Expanded(child: _buildColumn(rightCol, half)),
      ],
    );
  }

  Widget _buildColumn(List<Map<String, String>> items, int offset) {
    return Column(
      children: List.generate(items.length, (i) {
        final action = items[i];
        final bool isLast = i == items.length - 1;
        return Column(
          children: [
            GestureDetector(
              onTap: () => controller.onDoctorActionTap(offset + i),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Image.asset(
                          action['icon']!,
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.local_hospital,
                              size: 24,
                              color: Color(0xFF0D9488)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        action['label']!,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        size: 13, color: Color(0xFF9CA3AF)),
                  ],
                ),
              ),
            ),
            if (!isLast) const Divider(height: 1, color: Color(0xFFF3F4F6)),
          ],
        );
      }),
    );
  }
}

///////////////////////////////////////////////////////////////
/// AI + MEDICINE + FITNESS
///////////////////////////////////////////////////////////////

class _AiMedicineFitnessSection extends StatelessWidget {
  final DashboardController controller;
  final bool isTablet;

  const _AiMedicineFitnessSection({
    required this.controller,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: controller.goToCancerAiScan,
              child: Container(
                height: isTablet ? 210 : 170,
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Stack(
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cancer Risk AI Scan',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Early detection saves lives.\nCheck your risk now.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/icons/cancer-cell 1.png',
                        width: isTablet ? 80 : 60,
                        height: isTablet ? 80 : 60,
                        errorBuilder: (_, __, ___) =>
                            const SizedBox(width: 60, height: 60),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                GestureDetector(
                  onTap: controller.goToSavingsOffers,
                  child: Container(
                    height: isTablet ? 100 : 80,
                    padding: const EdgeInsets.all(12),
                    decoration: _cardDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Medicines &\nLab Discounts',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w700,
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
                GestureDetector(
                  onTap: controller.goToFitnessTracker,
                  child: Container(
                    height: isTablet ? 100 : 80,
                    padding: const EdgeInsets.all(12),
                    decoration: _cardDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Track Steps\n& Fitness',
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w700),
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

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////
/// PROMO BANNER
///////////////////////////////////////////////////////////////

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/Gemini_Generated_Image_rb2batrb2batrb2b 1.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Container(
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(Icons.image, size: 50, color: Color(0xFF9CA3AF)),
            ),
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// SMART HEALTH TOOLS
///////////////////////////////////////////////////////////////

class _SmartHealthToolsSection extends StatelessWidget {
  final DashboardController controller;
  final bool isTablet;

  const _SmartHealthToolsSection({
    required this.controller,
    required this.isTablet,
  });

  static const List<Color> colors = [
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
            children: List.generate(controller.smartTools.length, (index) {
              final tool = controller.smartTools[index];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: index < controller.smartTools.length - 1 ? 12 : 0),
                  child: GestureDetector(
                    onTap: () => controller.onSmartToolTap(index),
                    child: Container(
                      height: isTablet ? 170 : 146,
                      decoration: BoxDecoration(
                        color: colors[index],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                            child: Text(
                              tool['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: isTablet ? 13 : 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Image.asset(
                              tool['icon'],
                              height: isTablet ? 90 : 70,
                              width: isTablet ? 90 : 70,
                              errorBuilder: (_, __, ___) => SizedBox(
                                  height: isTablet ? 90 : 70,
                                  width: isTablet ? 90 : 70),
                            ),
                          ),
                        ],
                      ),
                    ),
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

///////////////////////////////////////////////////////////////
/// REUSABLE
///////////////////////////////////////////////////////////////

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
              color: Colors.black.withOpacity(.05),
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

///////////////////////////////////////////////////////////////
/// BOTTOM NAV
///////////////////////////////////////////////////////////////

class _BottomNav extends StatelessWidget {
  final DashboardController controller;
  final bool isTablet;

  const _BottomNav({
    required this.controller,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isTablet ? 80 : 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D9488), Color(0xFF2563EB)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavItem(
                icon: "assets/home.png",
                label: 'Home',
                isActive: controller.selectedNavIndex.value == 0,
                onTap: () => controller.selectNav(0)),
            _NavItem(
                icon: "assets/stethoscope.png",
                label: 'Doctor',
                isActive: controller.selectedNavIndex.value == 1,
                onTap: () => controller.selectNav(1)),
            _NavItem(
                icon: "assets/article.png",
                label: 'Policy',
                isActive: controller.selectedNavIndex.value == 2,
                onTap: () => controller.selectNav(2)),
            _NavItem(
                icon: "assets/account_circle.png",
                label: 'My Profile',
                isActive: controller.selectedNavIndex.value == 3,
                onTap: () => controller.selectNav(3)),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
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
          Image.asset(icon, color: Colors.white, height: isActive ? 26 : 24),
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
