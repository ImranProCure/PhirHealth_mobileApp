import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controlllers/doctor_todays_session_controller.dart';

class DoctorTodaysSessionView extends GetView<DoctorTodaysSessionController> {
  const DoctorTodaysSessionView({super.key});

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
        title: const Text("Today's Sessions",
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== DATE =====
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Text(
                  controller.todayDate,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),

              // ===== SESSION LIST =====
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: controller.sessions.length,
                  itemBuilder: (context, i) => _sessionCard(i),
                ),
              ),
            ],
          ),

          // ===== BOTTOM NAVBAR =====
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: _BottomNav(),
          ),
        ],
      ),
    );
  }

  Widget _sessionCard(int i) {
    final s = controller.sessions[i];
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
                  s['imagePath'] as String,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.person,
                        color: Color(0xFF0D9488), size: 38),
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
                        Text(s['name'] as String,
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 16,
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
                            children: [
                              const Icon(Icons.access_time_outlined,
                                  size: 13, color: Color(0xFF0D9488)),
                              const SizedBox(width: 4),
                              Text(s['time'] as String,
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
                    const SizedBox(height: 5),
                    Text('${s['gender']} | ${s['age']}',
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            color: Color(0xFF6B7280))),
                    const SizedBox(height: 3),
                    Text(s['type'] as String,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
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
              onPressed: () => controller.joinCall(i),
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
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D9488))),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: const LinearGradient(
            colors: [Color(0xFF0D9488), Color(0xFF2563EB)]),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
              icon: 'assets/home.png',
              label: 'Home',
              active: false,
              onTap: () => Get.offAllNamed('/doctor-dashboard')),
          _NavItem(
              icon: 'assets/stethoscope.png',
              label: 'Request',
              active: false,
              onTap: () => Get.offAllNamed('/doctor-requests')),
          _NavItem(
              icon: 'assets/article.png',
              label: 'Schedule',
              active: true,
              onTap: () {}),
          _NavItem(
              icon: 'assets/account_circle.png',
              label: 'Profile',
              active: false,
              onTap: () => Get.offAllNamed('/doctor-profile')),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem(
      {required this.icon,
      required this.label,
      required this.active,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon,
              width: active ? 26 : 22,
              height: active ? 26 : 22,
              color: Colors.white),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 11,
                fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                color: Colors.white,
              )),
        ],
      ),
    );
  }
}
