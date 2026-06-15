import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_profile_controller.dart';
import '../../../modules/google_calendar_controller_/google_calendar_controller.dart';

class DoctorProfileView extends GetView<DoctorProfileController> {
  const DoctorProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isTablet = width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: isTablet
          ? _TabletLayout(controller: controller)
          : _PhoneLayout(controller: controller),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  PHONE LAYOUT  (original — untouched)
// ══════════════════════════════════════════════════════════════
class _PhoneLayout extends StatelessWidget {
  final DoctorProfileController controller;
  const _PhoneLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0, // ✅ 0 rakho
        surfaceTintColor: Colors.transparent, // ✅ yeh add karo
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text('My Profile',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: controller.onShare,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ProfileCard(controller: controller),
            const SizedBox(height: 14),
            _MenuCard(items: controller.section1, controller: controller),
            const SizedBox(height: 14),
            _MenuCard(items: controller.section2, controller: controller),
            const SizedBox(height: 14),
            _MenuCard(items: controller.section4, controller: controller),
            const SizedBox(height: 20),
            _LogoutButton(controller: controller),
            const SizedBox(height: 16),
            const _VersionText(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  TABLET LAYOUT — side rail + two-column content
// ══════════════════════════════════════════════════════════════
class _TabletLayout extends StatelessWidget {
  final DoctorProfileController controller;
  const _TabletLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Side rail ──────────────────────────────────────
        _TabletSideRail(controller: controller),

        // ── Main content ───────────────────────────────────
        Expanded(
          child: SafeArea(
            left: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.black, size: 18),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text('My Profile',
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.black)),
                      ),
                      // Share button
                      GestureDetector(
                        onTap: controller.onShare,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.share_outlined,
                              color: Colors.black, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile card — full width
                        _ProfileCard(controller: controller, isTablet: true),
                        const SizedBox(height: 20),

                        // Two-column menu sections
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left column: section1 + section2
                            Expanded(
                              child: Column(
                                children: [
                                  _MenuCard(
                                      items: controller.section1,
                                      controller: controller),
                                  const SizedBox(height: 16),
                                  _MenuCard(
                                      items: controller.section2,
                                      controller: controller),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Right column: section4
                            Expanded(
                              child: _MenuCard(
                                  items: controller.section4,
                                  controller: controller),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Logout — constrained width on tablet
                        Center(
                          child: SizedBox(
                            width: 320,
                            child: _LogoutButton(controller: controller),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(child: _VersionText()),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  PROFILE CARD
// ══════════════════════════════════════════════════════════════
// ══════════════════════════════════════════════════════════════
//  PROFILE CARD
// ══════════════════════════════════════════════════════════════
// ══════════════════════════════════════════════════════════════
//  PROFILE CARD
// ══════════════════════════════════════════════════════════════
class _ProfileCard extends StatelessWidget {
  final DoctorProfileController controller;
  final bool isTablet;

  const _ProfileCard({
    required this.controller,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    final double avatarSize = isTablet ? 80 : 60;

    final double nameSize = isTablet ? 20 : 16;

    final double subSize = isTablet ? 13 : 12;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        isTablet ? 20 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.04,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= AVATAR =================
              Obx(
                () => ClipOval(
                  child: controller.imagePath.value.startsWith(
                    'http',
                  )
                      ? Image.network(
                          controller.imagePath.value,
                          width: avatarSize,
                          height: avatarSize,
                          fit: BoxFit.cover,
                          errorBuilder: (
                            _,
                            __,
                            ___,
                          ) =>
                              Container(
                            width: avatarSize,
                            height: avatarSize,
                            color: const Color(
                              0xFFE0F2F1,
                            ),
                            child: Icon(
                              Icons.person,
                              color: const Color(
                                0xFF0D9488,
                              ),
                              size: avatarSize * 0.55,
                            ),
                          ),
                        )
                      : Image.asset(
                          controller.imagePath.value,
                          width: avatarSize,
                          height: avatarSize,
                          fit: BoxFit.cover,
                          errorBuilder: (
                            _,
                            __,
                            ___,
                          ) =>
                              Container(
                            width: avatarSize,
                            height: avatarSize,
                            color: const Color(
                              0xFFE0F2F1,
                            ),
                            child: Icon(
                              Icons.person,
                              color: const Color(
                                0xFF0D9488,
                              ),
                              size: avatarSize * 0.55,
                            ),
                          ),
                        ),
                ),
              ),

              const SizedBox(width: 14),

              /// ================= PROFILE INFO =================
              Expanded(
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.name.value,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: nameSize,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      if (controller.credentials.value.isNotEmpty)
                        Text(
                          controller.credentials.value,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: subSize,
                            color: const Color(
                              0xFF6B7280,
                            ),
                          ),
                        ),
                      if (controller.credentials.value.isNotEmpty)
                        const SizedBox(
                          height: 3,
                        ),
                      if (controller.regNo.value.isNotEmpty)
                        Text(
                          controller.regNo.value,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: subSize,
                            color: const Color(
                              0xFF6B7280,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              /// ================= EDIT BUTTON =================
              GestureDetector(
                onTap: controller.onEdit,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFE0F2F1,
                    ),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    color: Color(
                      0xFF0D9488,
                    ),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// ================= ONLINE + VERIFIED =================
          /// ================= GOOGLE CALENDAR BUTTON =================
          Obx(() {
            final calCtrl = Get.find<GoogleCalendarController>();
            return SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed:
                    calCtrl.isLoading.value ? null : calCtrl.connectCalendar,
                icon: calCtrl.isLoading.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.calendar_month, size: 18),
                label: Text(
                  calCtrl.isConnected.value
                      ? 'Calendar Connected ✓'
                      : 'Connect Google Calendar',
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: calCtrl.isConnected.value
                      ? const Color(0xFF16A34A)
                      : const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  MENU CARD
// ══════════════════════════════════════════════════════════════
class _MenuCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final DoctorProfileController controller;
  const _MenuCard({required this.items, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (i) {
          final item = items[i];
          final bool isLast = i == items.length - 1;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => controller.onTileRoute(item['route'] as String),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      // Icon box
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2F1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(9),
                          child: Image.asset(
                            item['iconPath'] as String,
                            fit: BoxFit.contain,
                            color: const Color(0xFF0D9488),
                            colorBlendMode: BlendMode.srcIn,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.circle_outlined,
                                color: Color(0xFF0D9488),
                                size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(item['label'] as String,
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                      ),
                      // Trailing: rating star
                      if (item['trailing'] != null) ...[
                        const Icon(Icons.star,
                            color: Color(0xFFFBBF24), size: 16),
                        const SizedBox(width: 4),
                        Text(item['trailing'] as String,
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black)),
                        const SizedBox(width: 6),
                      ],
                      // Trailing: value text
                      if (item['value'] != null) ...[
                        Text(item['value'] as String,
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 13,
                                color: Color(0xFF6B7280))),
                        const SizedBox(width: 6),
                      ],
                      const Icon(Icons.arrow_forward_ios,
                          size: 14, color: Color(0xFF9CA3AF)),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: Color(0xFFF3F4F6)),
            ],
          );
        }),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  SHARED SMALL WIDGETS
// ══════════════════════════════════════════════════════════════
class _LogoutButton extends StatelessWidget {
  final DoctorProfileController controller;
  const _LogoutButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: controller.logout,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        icon: const Icon(Icons.logout, color: Color(0xFFEF4444), size: 20),
        label: const Text('Log Out',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFFEF4444))),
      ),
    );
  }
}

class _VersionText extends StatelessWidget {
  const _VersionText();

  @override
  Widget build(BuildContext context) {
    return const Text('PHIR Health version 1.0.2',
        style: TextStyle(
            fontFamily: 'Mulish', fontSize: 12, color: Color(0xFF9CA3AF)));
  }
}

// ══════════════════════════════════════════════════════════════
//  TABLET SIDE RAIL
// ══════════════════════════════════════════════════════════════
class _TabletSideRail extends StatelessWidget {
  final DoctorProfileController controller;
  const _TabletSideRail({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      right: false,
      child: Container(
        width: 90,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D9488), Color(0xFF2563EB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 28),
            // Avatar
            ClipOval(
              child: Image.asset(
                'assets/profile.png',
                width: 46,
                height: 46,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 46,
                  height: 46,
                  color: Colors.white24,
                  child:
                      const Icon(Icons.person, color: Colors.white, size: 26),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(width: 28, height: 1.5, color: Colors.white38),
            const SizedBox(height: 20),
            // Nav items — Profile is active
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _RailNavItem(
                    label: 'Home',
                    isActive: false,
                    icon: Icons.home_outlined,
                    onTap: () => Get.offAllNamed('/doctor-dashboard'),
                  ),
                  const SizedBox(height: 4),
                  _RailNavItem(
                    label: 'Request',
                    isActive: false,
                    icon: Icons.inbox_outlined,
                    onTap: () => Get.offAllNamed('/doctor-requests'),
                  ),
                  const SizedBox(height: 4),
                  _RailNavItem(
                    label: 'Schedule',
                    isActive: false,
                    icon: Icons.calendar_today_outlined,
                    onTap: () => Get.offAllNamed('/doctor-schedule'),
                  ),
                  const SizedBox(height: 4),
                  _RailNavItem(
                    label: 'Profile',
                    isActive: true,
                    icon: Icons.person_outline,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _RailNavItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final IconData icon;

  const _RailNavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Mulish',
                color: Colors.white,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 4),
              Container(
                width: 20,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
