import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_dashboard_controller.dart';

class DoctorDashboardView extends GetView<DoctorDashboardController> {
  const DoctorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isTablet = width >= 600;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F4F6),
        body: isTablet
            ? _TabletScaffold(controller: controller)
            : _PhoneScaffold(controller: controller),
      ),
    );
  }
}

class _PhoneScaffold extends StatelessWidget {
  final DoctorDashboardController controller;
  const _PhoneScaffold({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPhoneHeader(controller),
                const SizedBox(height: 20),
                _buildPhoneBody(controller),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 20,
          child: _PhoneBottomNav(controller: controller),
        ),
      ],
    );
  }
}

Widget _buildPhoneHeader(DoctorDashboardController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        Obx(
          () => ClipOval(
            child: controller.doctorImage.value.isNotEmpty
                ? Image.network(
                    controller.doctorImage.value,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 48,
                      height: 48,
                      color: const Color(0xFFE0F2F1),
                      child: const Icon(Icons.person,
                          color: Color(0xFF0D9488), size: 28),
                    ),
                  )
                : Container(
                    width: 48,
                    height: 48,
                    color: const Color(0xFFE0F2F1),
                    child: const Icon(Icons.person,
                        color: Color(0xFF0D9488), size: 28),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      color: Color(0xFF6B7280)),
                ),
                Text(
                  controller.doctorName.value,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.black),
                ),
              ],
            )),
        const Spacer(),
        GestureDetector(
          onTap: controller.onNotification,
          child: const Icon(Icons.notifications_none_outlined,
              color: Colors.black, size: 28),
        ),
      ],
    ),
  );
}

Widget _buildPhoneBody(DoctorDashboardController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => _EarningsCard(
              totalEarnings: controller.totalEarnings.value,
              padding: const EdgeInsets.all(20),
              iconSize: 44,
              valueSize: 30,
              labelSize: 13,
            )),

        const SizedBox(height: 18),

        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Overview",
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.black),
                ),
                _DateChip(date: controller.date.value, fontSize: 13),
              ],
            )),

        const SizedBox(height: 14),

        // ===== STATS GRID — cardHeight hataya =====
        Obx(() => _StatsGrid(
              stats: controller.stats.toList(),
              valueSize: 26,
              labelSize: 12,
            )),

        const SizedBox(height: 22),

        _AppointmentsHeader(onSeeAll: controller.seeAll),
        const SizedBox(height: 12),

        Obx(
          () => Column(
            children: controller.appointments
                .map(
                  (apt) => GestureDetector(
                    onTap: () {
                      controller.onAppointmentTap(
                        apt,
                      );
                    },
                    child: _AppointmentCard(
                      apt: apt,
                      controller: controller,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    ),
  );
}

class _TabletScaffold extends StatelessWidget {
  final DoctorDashboardController controller;
  const _TabletScaffold({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TabletSideRail(controller: controller),
        Expanded(
          child: SafeArea(
            left: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TabletHeader(controller: controller),
                  const SizedBox(height: 28),
                  Obx(() => _EarningsCard(
                        totalEarnings: controller.totalEarnings.value,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 24),
                        iconSize: 52,
                        valueSize: 36,
                        labelSize: 15,
                      )),
                  const SizedBox(height: 24),
                  const Text(
                    "Today's Overview",
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 18),
                  Obx(() => _TabletStatsRow(stats: controller.stats.toList())),
                  const SizedBox(height: 28),
                  _AppointmentsHeader(onSeeAll: controller.seeAll),
                  const SizedBox(height: 16),
                  _TabletAppointmentsGrid(controller: controller),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TabletSideRail extends StatelessWidget {
  final DoctorDashboardController controller;
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
            const SizedBox(height: 19),
            Expanded(
              child: Obx(() => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(4, (i) {
                      final labels = ['Home', 'Request', 'Schedule', 'Profile'];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: _RailNavItem(
                          iconPath: controller.navItems[i]['iconPath']!,
                          label: labels[i],
                          isActive: controller.currentIndex.value == i,
                          onTap: () => controller.onNavTap(i),
                        ),
                      );
                    }),
                  )),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _RailNavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _RailNavItem({
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.onTap,
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
            Image.asset(
              iconPath,
              width: 22,
              height: 22,
              color: Colors.white,
              colorBlendMode: BlendMode.srcIn,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.circle, color: Colors.white, size: 22),
            ),
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

class _TabletHeader extends StatelessWidget {
  final DoctorDashboardController controller;
  const _TabletHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Back',
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 2),
              Obx(() => Text(
                    controller.doctorName.value,
                    style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                  )),
            ],
          ),
        ),
        Obx(() => _DateChip(date: controller.date.value, fontSize: 14)),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: controller.onNotification,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: const Icon(Icons.notifications_none_outlined,
                color: Colors.black, size: 22),
          ),
        ),
      ],
    );
  }
}

class _TabletStatsRow extends StatelessWidget {
  final List<Map<String, dynamic>> stats;
  const _TabletStatsRow({required this.stats});

  static const _fallbackIcons = [
    Icons.group_outlined,
    Icons.check_circle_outline,
    Icons.access_time_outlined,
    Icons.cancel_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (i) {
        final s = stats[i];
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 3 ? 14 : 0),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  s['iconPath'] as String,
                  width: 30,
                  height: 30,
                  color: Color(s['iconColor'] as int),
                  colorBlendMode: BlendMode.srcIn,
                  errorBuilder: (_, __, ___) => Icon(
                    _fallbackIcons[i],
                    color: Color(s['iconColor'] as int),
                    size: 30,
                  ),
                ),
                const SizedBox(height: 12),
                Text(s['value'] as String,
                    style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.black)),
                const SizedBox(height: 2),
                Text(s['label'] as String,
                    style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        color: Color(0xFF6B7280))),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _TabletAppointmentsGrid extends StatelessWidget {
  final DoctorDashboardController controller;
  const _TabletAppointmentsGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    final apts = controller.appointments;
    final List<Widget> rows = [];
    for (int i = 0; i < apts.length; i += 2) {
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: _AppointmentCard(apt: apts[i], controller: controller)),
          const SizedBox(width: 16),
          Expanded(
            child: i + 1 < apts.length
                ? _AppointmentCard(apt: apts[i + 1], controller: controller)
                : const SizedBox(),
          ),
        ],
      ));
    }
    return Column(children: rows);
  }
}

class _DateChip extends StatelessWidget {
  final String date;
  final double fontSize;
  const _DateChip({required this.date, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Text(date,
          style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: Colors.black)),
    );
  }
}

class _EarningsCard extends StatelessWidget {
  final String totalEarnings;
  final EdgeInsetsGeometry padding;
  final double iconSize;
  final double valueSize;
  final double labelSize;

  const _EarningsCard({
    required this.totalEarnings,
    required this.padding,
    required this.iconSize,
    required this.valueSize,
    required this.labelSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF00897B), Color(0xFF1565C0)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.account_balance_wallet_outlined,
              color: Colors.white, size: iconSize),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total Earnings',
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: labelSize,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              Text(totalEarnings,
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: valueSize,
                      fontWeight: FontWeight.w900,
                      color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final List<Map<String, dynamic>> stats;
  final double valueSize;
  final double labelSize;

  const _StatsGrid({
    required this.stats,
    required this.valueSize,
    required this.labelSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Expanded(
              child: _StatCard(
                  s: stats[0],
                  i: 0,
                  valueSize: valueSize,
                  labelSize: labelSize)),
          const SizedBox(width: 12),
          Expanded(
              child: _StatCard(
                  s: stats[1],
                  i: 1,
                  valueSize: valueSize,
                  labelSize: labelSize)),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
              child: _StatCard(
                  s: stats[2],
                  i: 2,
                  valueSize: valueSize,
                  labelSize: labelSize)),
          const SizedBox(width: 12),
          Expanded(
              child: _StatCard(
                  s: stats[3],
                  i: 3,
                  valueSize: valueSize,
                  labelSize: labelSize)),
        ]),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final Map<String, dynamic> s;
  final int i;
  final double valueSize;
  final double labelSize;

  const _StatCard({
    required this.s,
    required this.i,
    required this.valueSize,
    required this.labelSize,
  });

  static const _fallbackIcons = [
    Icons.group_outlined,
    Icons.check_circle_outline,
    Icons.access_time_outlined,
    Icons.cancel_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            s['iconPath'] as String,
            width: 28,
            height: 28,
            color: Color(s['iconColor'] as int),
            colorBlendMode: BlendMode.srcIn,
            errorBuilder: (_, __, ___) => Icon(
              _fallbackIcons[i],
              color: Color(s['iconColor'] as int),
              size: 28,
            ),
          ),
          const SizedBox(height: 10),
          Text(s['value'] as String,
              style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: valueSize,
                  fontWeight: FontWeight.w900,
                  color: Colors.black)),
          const SizedBox(height: 2),
          Text(
            s['label'] as String,
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: labelSize,
                color: const Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}

class _AppointmentsHeader extends StatelessWidget {
  final VoidCallback onSeeAll;
  const _AppointmentsHeader({required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Upcoming Appointments',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.black)),
        GestureDetector(
          onTap: onSeeAll,
          child: const Text('See All',
              style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D9488))),
        ),
      ],
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> apt;
  final DoctorDashboardController controller;
  const _AppointmentCard({required this.apt, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ===== IMAGE — 80x80 =====
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: apt['imagePath'].toString().startsWith('http')
                    ? Image.network(
                        apt['imagePath'] as String,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : Image.asset(
                        apt['imagePath'] as String,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== NAME + TIME IN SAME ROW =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            apt['name'] as String,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2F1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.access_time_outlined,
                                  size: 12, color: Color(0xFF0D9488)),
                              const SizedBox(width: 4),
                              Text(apt['time'] as String,
                                  style: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0D9488))),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(apt['details'] as String,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            color: Color(0xFF6B7280))),

                    const SizedBox(height: 2),

                    Text(apt['type'] as String,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            color: Color(0xFF6B7280))),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===== JOIN CALL BUTTON =====
          // ===== JOIN CALL BUTTON =====
          Builder(
            builder: (_) {
              final canJoin = controller.canJoin(apt);
              final timeStr = apt['time']?.toString() ?? '';
              return SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => controller.joinCall(apt),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: canJoin
                          ? const Color(0xFF0D9488)
                          : const Color(0xFFD1D5DB),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor:
                        canJoin ? Colors.transparent : const Color(0xFFF9FAFB),
                  ),
                  icon: Icon(
                    Icons.video_call_outlined,
                    color: canJoin
                        ? const Color(0xFF0D9488)
                        : const Color(0xFF9CA3AF),
                    size: 22,
                  ),
                  label: Text(
                    canJoin ? 'Join Call' : 'Available at $timeStr',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: canJoin
                          ? const Color(0xFF0D9488)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.person, color: Color(0xFF0D9488), size: 36),
    );
  }
}

class _PhoneBottomNav extends StatelessWidget {
  final DoctorDashboardController controller;
  const _PhoneBottomNav({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D9488), Color(0xFF2563EB)],
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _PhoneNavItem(
                  icon: controller.navItems[0]['iconPath']!,
                  label: 'Home',
                  isActive: controller.currentIndex.value == 0,
                  onTap: () => controller.onNavTap(0)),
              _PhoneNavItem(
                  icon: controller.navItems[1]['iconPath']!,
                  label: 'Request',
                  isActive: controller.currentIndex.value == 1,
                  onTap: () => controller.onNavTap(1)),
              _PhoneNavItem(
                  icon: controller.navItems[2]['iconPath']!,
                  label: 'Schedule',
                  isActive: controller.currentIndex.value == 2,
                  onTap: () => controller.onNavTap(2)),
              _PhoneNavItem(
                  icon: controller.navItems[3]['iconPath']!,
                  label: 'Profile',
                  isActive: controller.currentIndex.value == 3,
                  onTap: () => controller.onNavTap(3)),
            ],
          )),
    );
  }
}

class _PhoneNavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _PhoneNavItem({
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
          Image.asset(
            icon,
            color: Colors.white,
            colorBlendMode: BlendMode.srcIn,
            height: isActive ? 26 : 24,
            errorBuilder: (_, __, ___) => Icon(Icons.circle,
                color: Colors.white, size: isActive ? 26 : 24),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                fontFamily: 'Mulish',
                color: Colors.white,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              )),
        ],
      ),
    );
  }
}
