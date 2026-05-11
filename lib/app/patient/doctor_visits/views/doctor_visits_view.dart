import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/doctor_visits_controller.dart';

class DoctorVisitsView extends GetView<DoctorVisitsController> {
  const DoctorVisitsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          "My Doctor Visits",
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          // ===== FILTER TABS =====
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Obx(() => Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children:
                        controller.filters.map((f) => _filterTab(f)).toList(),
                  ),
                )),
          ),
          const SizedBox(height: 8),

          // ===== LIST / STATES =====
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _ShimmerWrapper(child: _buildSkeleton());
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.wifi_off_outlined,
                            size: 48, color: Color(0xFF9CA3AF)),
                        const SizedBox(height: 12),
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton.icon(
                          onPressed: controller.refreshVisits,
                          icon: const Icon(Icons.refresh,
                              color: Color(0xFF0D9488)),
                          label: const Text(
                            "Retry",
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0D9488),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final visits = controller.filteredVisits;

              if (visits.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.event_busy_outlined,
                          size: 48, color: Color(0xFF9CA3AF)),
                      const SizedBox(height: 12),
                      Text(
                        "No ${controller.selectedFilter.value == 'All' ? '' : '${controller.selectedFilter.value} '}visits found",
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: const Color(0xFF0D9488),
                onRefresh: controller.refreshVisits,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: _buildTimeline(visits),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ===== SKELETON =====
  Widget _buildSkeleton() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        _skeletonMonthHeader(),
        const SizedBox(height: 8),
        _skeletonVisitRow(showButton: false),
        _skeletonVisitRow(showButton: true),
        _skeletonVisitRow(showButton: false),
        const SizedBox(height: 12),
        _skeletonMonthHeader(),
        const SizedBox(height: 8),
        _skeletonVisitRow(showButton: false),
        _skeletonVisitRow(showButton: true),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              const SizedBox(width: 22),
              _skBox(width: 10, height: 10, radius: 5),
            ],
          ),
        ),
      ],
    );
  }

  Widget _skeletonMonthHeader() {
    return Row(
      children: [
        const SizedBox(width: 22),
        _skBox(width: 10, height: 10, radius: 5),
        const SizedBox(width: 20),
        _skBox(width: 100, height: 14, radius: 6),
      ],
    );
  }

  Widget _skeletonVisitRow({bool showButton = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 54,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: _DashedLinePainter()),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: _skBox(width: 54, height: 54, radius: 27),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: _skeletonCard(showButton: showButton),
            ),
          ),
        ],
      ),
    );
  }

  Widget _skeletonCard({bool showButton = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: _skBox(width: double.infinity, height: 14, radius: 6)),
              const SizedBox(width: 12),
              _skBox(width: 80, height: 24, radius: 12),
            ],
          ),
          const SizedBox(height: 8),
          _skBox(width: 120, height: 12, radius: 6),
          const SizedBox(height: 10),
          Row(
            children: [
              _skBox(width: 14, height: 14, radius: 3),
              const SizedBox(width: 6),
              _skBox(width: 140, height: 12, radius: 6),
            ],
          ),
          if (showButton) ...[
            const SizedBox(height: 14),
            _skBox(width: double.infinity, height: 46, radius: 30),
          ],
        ],
      ),
    );
  }

  Widget _skBox({
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

  // ===== TIMELINE =====
  List<Widget> _buildTimeline(List<Map<String, dynamic>> visits) {
    final List<Widget> widgets = [];
    String? lastMonth;

    for (int i = 0; i < visits.length; i++) {
      final visit = visits[i];
      final month = visit['month'] as String;

      if (month != lastMonth) {
        if (lastMonth != null) widgets.add(const SizedBox(height: 4));
        widgets.add(
          Row(
            children: [
              const SizedBox(width: 22),
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF0D9488),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                month,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
        lastMonth = month;
      }

      widgets.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 54,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(painter: _DashedLinePainter()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE0F2F1),
                          border: Border.all(
                              color: const Color(0xFF0D9488), width: 1.2),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              visit['date_short'].toString().split('\n')[0],
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF0D9488),
                                height: 1.2,
                              ),
                            ),
                            Text(
                              visit['date_short'].toString().split('\n')[1],
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0D9488),
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: _visitCard(visit),
                ),
              ),
            ],
          ),
        ),
      );
    }

    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            const SizedBox(width: 22),
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFF0D9488),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );

    return widgets;
  }

  // ===== FILTER TAB =====
  Widget _filterTab(String label) {
    final isSelected = controller.selectedFilter.value == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectFilter(label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }

  // ===== VISIT CARD =====
  Widget _visitCard(Map<String, dynamic> visit) {
    final status = visit['status'] as String;
    final isCompleted = status == 'Completed';
    final isCancelled = status == 'Cancelled';
    final bool showBookAgain = visit['show_book_again'] == true;
    final bool showJoinButton = visit['show_join_button'] == true;
    final userRole = visit['user_roles'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row: role badge + status badge ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (userRole.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: userRole == 'Doctor'
                        ? const Color(0xFF0D9488)
                        : const Color(0xFF81C784),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    userRole,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              _statusBadge(status),
            ],
          ),
          const SizedBox(height: 8),

          // ── Doctor name ──
          Text(
            visit['doctor'],
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),

          // ── Specialty ──
          Text(
            visit['specialty'],
            style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 12,
                color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 8),

          // ── Time | Type ──
          Row(
            children: [
              const Icon(Icons.access_time_outlined,
                  size: 14, color: Color(0xFF6B7280)),
              const SizedBox(width: 6),
              Text(
                "${visit['time']} | ${visit['type']}",
                style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 12,
                    color: Color(0xFF6B7280)),
              ),
            ],
          ),

          // ── Note ──
          if (visit['note'] != null &&
              visit['note'].toString().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              visit['note'],
              style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 12,
                  color: Color(0xFF374151),
                  fontStyle: FontStyle.italic),
            ),
          ],

          // ── Join Video Call button (Upcoming video appointments) ──
          if (showJoinButton) ...[
            const SizedBox(height: 14),
            _JoinButton(visit: visit, controller: controller),
          ],

          // ── View More Details (Completed) ──
          if (isCompleted) ...[
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: () => controller.viewMoreDetails(visit),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 46),
                side: const BorderSide(color: Color(0xFF0D9488)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined,
                      size: 18, color: Color(0xFF0D9488)),
                  SizedBox(width: 8),
                  Text(
                    "View More Details",
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D9488)),
                  ),
                ],
              ),
            ),
            if (showBookAgain) ...[
              const SizedBox(height: 12),
              _bookAgainButton(visit),
            ],
          ],

          // ── Book Again (Cancelled) ──
          if (isCancelled) ...[
            const SizedBox(height: 12),
            _bookAgainButton(visit),
          ],
        ],
      ),
    );
  }

  // ===== BOOK AGAIN BUTTON =====
  Widget _bookAgainButton(Map<String, dynamic> visit) {
    return GestureDetector(
      onTap: () => controller.bookAgain(visit),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.replay_outlined, size: 16, color: Color(0xFF0D9488)),
          SizedBox(width: 6),
          Text(
            "Book Again",
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D9488)),
          ),
        ],
      ),
    );
  }

  // ===== STATUS BADGE =====
  Widget _statusBadge(String status) {
    final isCompleted = status == 'Completed';
    final isCancelled = status == 'Cancelled';

    Color bgColor;
    Color fgColor;
    IconData icon;

    if (isCompleted) {
      bgColor = const Color(0xFFE0F2F1);
      fgColor = const Color(0xFF0D9488);
      icon = Icons.check_circle_outline;
    } else if (isCancelled) {
      bgColor = const Color(0xFFFEE2E2);
      fgColor = const Color(0xFFEF4444);
      icon = Icons.cancel_outlined;
    } else {
      bgColor = const Color(0xFFEFF6FF);
      fgColor = const Color(0xFF3B82F6);
      icon = Icons.schedule;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: fgColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fgColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ===== JOIN BUTTON (stateful — ticks every second) =====
class _JoinButton extends StatefulWidget {
  final Map<String, dynamic> visit;
  final DoctorVisitsController controller;

  const _JoinButton({required this.visit, required this.controller});

  @override
  State<_JoinButton> createState() => _JoinButtonState();
}

class _JoinButtonState extends State<_JoinButton> {
  late Timer _timer;
  bool _isEnabled = false;
  String _countdownLabel = '';

  @override
  void initState() {
    super.initState();
    _update();
    // Refresh every second so the countdown stays live
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _update());
  }

  void _update() {
    final enabled = widget.controller.isJoinEnabled(widget.visit);
    final label = widget.controller.joinCountdownLabel(widget.visit);
    if (mounted) {
      setState(() {
        _isEnabled = enabled;
        _countdownLabel = label;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _launchMeetingLink() async {
    final link = widget.visit['meeting_link'] as String? ?? '';
    if (link.isEmpty) return;
    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Join button
        AnimatedOpacity(
          opacity: _isEnabled ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 300),
          child: ElevatedButton.icon(
            onPressed: _isEnabled ? _launchMeetingLink : null,
            icon: const Icon(Icons.videocam_outlined,
                size: 18, color: Colors.white),
            label: const Text(
              "Join Video Call",
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 46),
              backgroundColor: const Color(0xFF0D9488),
              disabledBackgroundColor: const Color(0xFF9CA3AF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
          ),
        ),

        // Countdown label shown only when button is disabled
        if (!_isEnabled && _countdownLabel.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_clock_outlined,
                  size: 13, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 4),
              Text(
                _countdownLabel,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// ===== DASHED LINE PAINTER =====
class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0D9488).withOpacity(0.6)
      ..strokeWidth = 1.5;

    double y = 0;
    const dashH = 5.0;
    const gapH = 4.0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, y + dashH),
        paint,
      );
      y += dashH + gapH;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => false;
}

// ===== SHIMMER WRAPPER =====
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