import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_requests_controller.dart';

class DoctorRequestsView extends GetView<DoctorRequestsController> {
  const DoctorRequestsView({super.key});

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
  final DoctorRequestsController controller;
  const _PhoneLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.offAllNamed('/doctor-dashboard'),
        ),
        centerTitle: true,
        title: const Text('Pending Requests',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
      body: Obx(() {
        final requests = controller.requests;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                'You have ${requests.length} new appointment requests',
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: requests.length,
                itemBuilder: (context, i) =>
                    _RequestCard(r: requests[i], index: i, controller: controller),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  TABLET LAYOUT  — side rail + 2-column grid
// ══════════════════════════════════════════════════════════════
class _TabletLayout extends StatelessWidget {
  final DoctorRequestsController controller;
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
                // ── Top bar ──────────────────────────────────
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.offAllNamed('/doctor-dashboard'),
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
                      const Text('Pending Requests',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.black)),
                    ],
                  ),
                ),

                // ── Subtitle + grid ───────────────────────────
                Expanded(
                  child: Obx(() {
                    final requests = controller.requests;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(28, 20, 28, 16),
                          child: Text(
                            'You have ${requests.length} new appointment requests',
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _TwoColumnGrid(
                              requests: requests, controller: controller),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── 2-column grid ─────────────────────────────────────────────
class _TwoColumnGrid extends StatelessWidget {
  final List requests;
  final DoctorRequestsController controller;
  const _TwoColumnGrid(
      {required this.requests, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 32),
      itemCount: (requests.length / 2).ceil(),
      itemBuilder: (context, rowIndex) {
        final leftIndex = rowIndex * 2;
        final rightIndex = leftIndex + 1;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _RequestCard(
                  r: requests[leftIndex],
                  index: leftIndex,
                  controller: controller,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: rightIndex < requests.length
                    ? _RequestCard(
                        r: requests[rightIndex],
                        index: rightIndex,
                        controller: controller,
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  SHARED REQUEST CARD
// ══════════════════════════════════════════════════════════════
class _RequestCard extends StatelessWidget {
  final Map<String, dynamic> r;
  final int index;
  final DoctorRequestsController controller;

  const _RequestCard({
    required this.r,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Patient info ────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  r['imagePath'] as String,
                  width: 66,
                  height: 66,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.person,
                        color: Color(0xFF0D9488), size: 36),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      r['name'] as String,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time_outlined,
                            size: 13, color: Color(0xFF6B7280)),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            r['time'] as String,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.video_call_outlined,
                            size: 13, color: Color(0xFF6B7280)),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            r['type'] as String,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
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
          const SizedBox(height: 14),

          // ── Accept + Decline buttons ─────────────────────
          Row(
            children: [
              // Accept — solid green gradient
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF16A34A), Color(0xFF15803D)],
                      ),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => controller.accept(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      icon: const Icon(Icons.check_circle_outline,
                          color: Colors.white, size: 17),
                      label: const Text('Accept',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Decline — red outlined
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () => controller.decline(index),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color(0xFFEF4444), width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    icon: const Icon(Icons.cancel_outlined,
                        color: Color(0xFFEF4444), size: 17),
                    label: const Text('Decline',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFEF4444))),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  TABLET SIDE RAIL  (matches dashboard style exactly)
// ══════════════════════════════════════════════════════════════
class _TabletSideRail extends StatelessWidget {
  final DoctorRequestsController controller;
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

            // Nav items — Request tab is active
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _RailNavItem(
                    label: 'Home',
                    isActive: false,
                    onTap: () => Get.offAllNamed('/doctor-dashboard'),
                    icon: Icons.home_outlined,
                  ),
                  const SizedBox(height: 4),
                  _RailNavItem(
                    label: 'Request',
                    isActive: true,
                    onTap: () {},
                    icon: Icons.inbox_outlined,
                  ),
                  const SizedBox(height: 4),
                  _RailNavItem(
                    label: 'Schedule',
                    isActive: false,
                    onTap: () => Get.offAllNamed('/doctor-schedule'),
                    icon: Icons.calendar_today_outlined,
                  ),
                  const SizedBox(height: 4),
                  _RailNavItem(
                    label: 'Profile',
                    isActive: false,
                    onTap: () => Get.offAllNamed('/doctor-profile'),
                    icon: Icons.person_outline,
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
          color: isActive
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
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
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w400,
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