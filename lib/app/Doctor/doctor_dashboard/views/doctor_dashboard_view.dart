import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_dashboard_controller.dart';

class DoctorDashboardView extends GetView<DoctorDashboardController> {
  const DoctorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: const Color(0xFFF3F4F6),
          body: Stack(
            children: [
              // ===== MAIN CONTENT =====
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 90),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildOverviewSection(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // ===== FLOATING NAV =====
              Positioned(
                left: 16,
                right: 16,
                bottom: 20,
                child: _BottomNav(controller: controller),
              ),
            ],
          ),
        ));
  }

  // ===== HEADER =====
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              'assets/profile.png',
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
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome Back',
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      color: Color(0xFF6B7280))),
              Text(controller.doctorName,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.black)),
            ],
          ),
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

  // ===== OVERVIEW SECTION =====
  Widget _buildOverviewSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + date row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Today's Overview",
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.black)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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
                child: Text(controller.date,
                    style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ===== EARNINGS CARD =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
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
                // Plain wallet icon — no background box
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 44,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Earnings',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(controller.totalEarnings,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ===== 4 STAT CARDS =====
          // Use Column of Rows instead of GridView to avoid overflow
          Row(
            children: [
              Expanded(child: _statCard(controller.stats[0], 0)),
              const SizedBox(width: 12),
              Expanded(child: _statCard(controller.stats[1], 1)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _statCard(controller.stats[2], 2)),
              const SizedBox(width: 12),
              Expanded(child: _statCard(controller.stats[3], 3)),
            ],
          ),
          const SizedBox(height: 22),

          // ===== UPCOMING APPOINTMENTS =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Upcoming Appointments',
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.black)),
              GestureDetector(
                onTap: controller.seeAll,
                child: const Text('See All',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D9488))),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...controller.appointments.map((apt) => _appointmentCard(apt)),
        ],
      ),
    );
  }

  // ===== STAT CARD =====
  Widget _statCard(Map<String, dynamic> s, int i) {
    return Container(
      height: 110,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            s['iconPath'] as String,
            width: 28,
            height: 28,
            color: Color(s['iconColor'] as int),
            colorBlendMode: BlendMode.srcIn,
            errorBuilder: (_, __, ___) => Icon(
              i == 0
                  ? Icons.group_outlined
                  : i == 1
                      ? Icons.check_circle_outline
                      : i == 2
                          ? Icons.access_time_outlined
                          : Icons.cancel_outlined,
              color: Color(s['iconColor'] as int),
              size: 28,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s['value'] as String,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.black)),
              Text(s['label'] as String,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      color: Color(0xFF6B7280))),
            ],
          ),
        ],
      ),
    );
  }

  // ===== APPOINTMENT CARD =====
  Widget _appointmentCard(Map<String, dynamic> apt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  apt['imagePath'] as String,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                        color: const Color(0xFFE0F2F1),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.person,
                        color: Color(0xFF0D9488), size: 34),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(apt['name'] as String,
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.black)),
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
                                  size: 13, color: Color(0xFF0D9488)),
                              const SizedBox(width: 4),
                              Text(apt['time'] as String,
                                  style: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0D9488))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(apt['details'] as String,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            color: Color(0xFF6B7280))),
                    const SizedBox(height: 2),
                    Text(apt['type'] as String,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            color: Color(0xFF6B7280))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              onPressed: () => controller.joinCall(apt),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              icon: const Icon(Icons.video_call_outlined,
                  color: Color(0xFF0D9488), size: 20),
              label: const Text('Join Call',
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D9488))),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== BOTTOM NAV — exact same structure as patient dashboard =====
class _BottomNav extends StatelessWidget {
  final DoctorDashboardController controller;
  const _BottomNav({required this.controller});

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
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                  icon: controller.navItems[0]['iconPath']!,
                  label: 'Home',
                  isActive: controller.currentIndex.value == 0,
                  onTap: () => controller.onNavTap(0)),
              _NavItem(
                  icon: controller.navItems[1]['iconPath']!,
                  label: 'Request',
                  isActive: controller.currentIndex.value == 1,
                  onTap: () => controller.onNavTap(1)),
              _NavItem(
                  icon: controller.navItems[2]['iconPath']!,
                  label: 'Schedule',
                  isActive: controller.currentIndex.value == 2,
                  onTap: () => controller.onNavTap(2)),
              _NavItem(
                  icon: controller.navItems[3]['iconPath']!,
                  label: 'Profile',
                  isActive: controller.currentIndex.value == 3,
                  onTap: () => controller.onNavTap(3)),
            ],
          )),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.isActive = false});

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
