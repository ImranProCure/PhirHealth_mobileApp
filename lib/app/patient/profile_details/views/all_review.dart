import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/patient/profile_details/controllers/profile_details_controller.dart';

class AllReviewsView extends GetView<ProfileDetailsController> {
  const AllReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    // Trigger fresh review fetch when this screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllReview();
    });

    // Attach pagination listener
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.fetchAllReview(loadMore: true);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          "All Reviews",
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: const [
          // Padding(
          //   padding: EdgeInsets.only(right: 16),
          //   child: Icon(Icons.share_outlined, color: Colors.black),
          // )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _ShimmerWrapper(
                  child: _buildAllReviewsSkeleton(),
                );
              }

              if (controller.allReviews.isEmpty) {
                return _EmptyState(controller: controller);
              }

              return CustomScrollView(
                controller: scrollController,
                slivers: [
                  // ── Section label ──
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              '${controller.total.value} reviews',
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Review list ──
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final review = controller.allReviews[index];
                        return _ReviewCard(review: review, index: index);
                      },
                      childCount: controller.allReviews.length,
                    ),
                  ),

                  // ── Load more / End indicator ──
                  SliverToBoxAdapter(
                    child: Obx(() {
                      if (controller.isLoadingMoreReviews.value) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF00897B),
                              strokeWidth: 2.5,
                            ),
                          ),
                        );
                      }
                      if (!controller.hasMoreReviews.value &&
                          controller.allReviews.isNotEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              "You've seen all reviews",
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox(height: 100);
                    }),
                  ),
                ],
              );
            }),
          ),
        ],
      ),

      // ── FAB: Share Your Story ──
      floatingActionButton: controller.reviewStatus.value == 1
          ? Container()
          : _ShareStoryFab(controller: controller),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

Widget _buildAllReviewsSkeleton() {
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── "X reviews" label ──
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
          child: _skeletonBox(width: 80, height: 12),
        ),

        // ── Review cards ──
        ...List.generate(6, (index) => _skeletonReviewCard()),
      ],
    ),
  );
}

Widget _skeletonReviewCard() {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Avatar circle
            _skeletonBox(width: 42, height: 42, radius: 21),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _skeletonBox(width: 110, height: 14),
                  const SizedBox(height: 6),
                  // Star row
                  _skeletonBox(width: 80, height: 12),
                ],
              ),
            ),
            // Date
            _skeletonBox(width: 55, height: 11),
          ],
        ),
        const SizedBox(height: 12),
        // Review text lines
        _skeletonBox(width: double.infinity, height: 13),
        const SizedBox(height: 6),
        _skeletonBox(width: double.infinity, height: 13),
        const SizedBox(height: 6),
        _skeletonBox(width: 180, height: 13),
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

// ─────────────────────────────────────────────
//  Header
// ─────────────────────────────────────────────
class _Header extends StatelessWidget {
  final ProfileDetailsController controller;

  const _Header({required this.controller});

  static const _gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF00897B), Color(0xFF1565C0)],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: _gradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Patient Reviews',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller.doctorName.value,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Review Card
// ─────────────────────────────────────────────
class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  final int index;

  const _ReviewCard({required this.review, required this.index});

  static const _avatarColors = [
    Color(0xFF00897B),
    Color(0xFF1565C0),
    Color(0xFF7B1FA2),
    Color(0xFFE53935),
    Color(0xFFF57C00),
  ];

  @override
  Widget build(BuildContext context) {
    final name = review['reviewer_name']?.toString() ?? 'Anonymous';
    final initials = review['initials']?.toString().isNotEmpty == true
        ? review['initials'].toString()
        : (name.isNotEmpty ? name[0].toUpperCase() : 'A');
    final rating = (review['rating'] as double?) ?? 0.0;
    final text = review['review_text']?.toString() ?? '';
    final date = review['relative_date']?.toString() ?? '';
    final isYou = name == 'You';
    final avatarColor = _avatarColors[index % _avatarColors.length];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isYou
            ? Border.all(color: const Color(0xFF00897B).withOpacity(0.4))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [avatarColor, avatarColor.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        if (isYou) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00897B).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'You',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF00897B),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    _StarRow(rating: rating, size: 14),
                  ],
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          if (text.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 13,
                color: Color(0xFF4B5563),
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Star Row helper
// ─────────────────────────────────────────────
class _StarRow extends StatelessWidget {
  final double rating;
  final double size;

  const _StarRow({required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.floor();
        final half = !filled && i < rating;
        return Icon(
          filled
              ? Icons.star_rounded
              : half
                  ? Icons.star_half_rounded
                  : Icons.star_border_rounded,
          size: size,
          color: const Color(0xFFFBBF24),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
//  Empty State
// ─────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final ProfileDetailsController controller;

  const _EmptyState({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF00897B).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.rate_review_outlined,
                size: 44,
                color: Color(0xFF00897B),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Reviews Yet',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Be the first to share your experience\nwith this doctor.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 13,
                color: Color(0xFF9CA3AF),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            controller.reviewStatus.value == 1
                ? Container()
                : _ShareStoryFab(controller: controller, inline: true),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Share Your Story FAB
// ─────────────────────────────────────────────
class _ShareStoryFab extends StatelessWidget {
  final ProfileDetailsController controller;
  final bool inline;

  const _ShareStoryFab({required this.controller, this.inline = false});

  static const _gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF00897B), Color(0xFF1565C0)],
  );

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        _openReviewDialog(context);
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: controller.reviewStatus.value == 1
              ? Colors.grey
              : const Color(0xFF0D9488),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        controller.reviewStatus.value == 1
            ? "Already Reviewed"
            : "Share Your Story",
        style: TextStyle(
          fontFamily: 'Mulish',
          color: controller.reviewStatus.value == 1
              ? Colors.grey
              : const Color(0xFF0D9488),
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  void _openReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) => _InlineReviewDialog(
        doctorName: controller.doctorName.value,
        onSubmit: (rating, text) async {
          await controller.submitReview(rating: rating, reviewText: text);
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Inline Review Dialog
// ─────────────────────────────────────────────
class _InlineReviewDialog extends StatefulWidget {
  final String doctorName;
  final Future<void> Function(int rating, String reviewText) onSubmit;

  const _InlineReviewDialog({required this.doctorName, required this.onSubmit});

  @override
  State<_InlineReviewDialog> createState() => _InlineReviewDialogState();
}

class _InlineReviewDialogState extends State<_InlineReviewDialog>
    with SingleTickerProviderStateMixin {
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmitting = false;

  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  static const _gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF00897B), Color(0xFF1565C0)],
  );

  final List<String> _ratingLabels = [
    '',
    'Poor',
    'Fair',
    'Good',
    'Very Good',
    'Excellent',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _scaleAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOutBack);
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedRating == 0) {
      _showSnack('Please select a rating');
      return;
    }
    final text = _reviewController.text.trim();
    if (text.isEmpty) {
      _showSnack('Please write your review');
      return;
    }

    setState(() => _isSubmitting = true);
    await widget.onSubmit(_selectedRating, text);

    if (mounted) {
      setState(() => _isSubmitting = false);
      Navigator.of(context).pop();
      _showSuccessSnack();
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontFamily: 'Mulish')),
      backgroundColor: const Color(0xFF0D9488),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  void _showSuccessSnack() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Row(children: [
        Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
        SizedBox(width: 8),
        Text('Review submitted successfully!',
            style:
                TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.w600)),
      ]),
      backgroundColor: const Color(0xFF0D9488),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 30,
                    offset: const Offset(0, 8))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Header ──
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: const BoxDecoration(
                    gradient: _gradient,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Share Your Story',
                              style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                            Text(
                              widget.doctorName,
                              style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 12,
                                  color: Colors.white70),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Body ──
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Rating',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF374151)),
                      ),
                      const SizedBox(height: 12),

                      // Stars
                      Row(
                        children: List.generate(5, (index) {
                          final star = index + 1;
                          final isSelected = star <= _selectedRating;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedRating = star),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.only(right: 8),
                              child: Icon(
                                isSelected ? Icons.star : Icons.star_border,
                                size: 36,
                                color: isSelected
                                    ? const Color(0xFFFBBF24)
                                    : const Color(0xFFD1D5DB),
                              ),
                            ),
                          );
                        }),
                      ),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _selectedRating > 0
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Container(
                                  key: ValueKey(_selectedRating),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                      gradient: _gradient,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    _ratingLabels[_selectedRating],
                                    style: const TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            : const SizedBox(key: ValueKey(0), height: 8),
                      ),

                      const SizedBox(height: 18),
                      const Text(
                        'Your Review',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF374151)),
                      ),
                      const SizedBox(height: 10),

                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: TextField(
                          controller: _reviewController,
                          maxLines: 4,
                          maxLength: 300,
                          style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              color: Color(0xFF374151)),
                          decoration: const InputDecoration(
                            hintText:
                                'Describe your experience with the doctor...',
                            hintStyle: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 13,
                                color: Color(0xFF9CA3AF)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(14),
                            counterStyle: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 11,
                                color: Color(0xFF9CA3AF)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: _isSubmitting
                            ? Container(
                                decoration: BoxDecoration(
                                    gradient: _gradient,
                                    borderRadius: BorderRadius.circular(30)),
                                alignment: Alignment.center,
                                child: const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2.5),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: _gradient,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0xFF00897B)
                                            .withOpacity(0.35),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4))
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.send_rounded,
                                          color: Colors.white, size: 16),
                                      SizedBox(width: 8),
                                      Text(
                                        'Submit Review',
                                        style: TextStyle(
                                            fontFamily: 'Mulish',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
