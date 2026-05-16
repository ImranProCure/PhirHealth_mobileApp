import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/see_all_appointments_controller.dart';

class SeeAllAppointmentsView extends GetView<SeeAllAppointmentsController> {
  const SeeAllAppointmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'All Appointments',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildSkeleton();
        }

        if (controller.appointments.isEmpty) {
          return const Center(
            child: Text(
              'No appointments found',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 15,
                color: Color(0xFF6B7280),
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: controller.appointments.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (_, index) {
            final apt = controller.appointments[index];
            return _AppointmentCard(apt: apt, controller: controller);
          },
        );
      }),
    );
  }

  // ===== SKELETON =====
  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF9FAFB),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (_, __) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _sBox(width: 110, height: 14, radius: 6),
                            _sBox(width: 75, height: 24, radius: 20),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _sBox(width: 100, height: 12, radius: 6),
                        const SizedBox(height: 4),
                        _sBox(width: 130, height: 12, radius: 6),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _sBox(width: double.infinity, height: 48, radius: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sBox({
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ===== SAME CARD AS DASHBOARD =====
class _AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> apt;
  final SeeAllAppointmentsController controller;
  const _AppointmentCard({required this.apt, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ===== IMAGE 80x80 =====
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
                    // ===== NAME + TIME SAME ROW =====
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
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2F1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time_outlined,
                                size: 12,
                                color: Color(0xFF0D9488),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                apt['time'] as String,
                                style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0D9488),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      apt['details'] as String,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      apt['type'] as String,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

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
