import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/patient/profile_details/controllers/profile_details_controller.dart';

/// Call this anywhere to show the review dialog:
///   showReviewDialog(context, doctorName: controller.doctorName.value);
/// 

void showReviewDialog(
  BuildContext context, {
  required String doctorName,
  void Function(int rating, String reviewText)? onSubmit,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (_) => _ReviewDialog(
      doctorName: doctorName,
      onSubmit: onSubmit,
    ),
  );
}

class _ReviewDialog extends StatefulWidget {
  final String doctorName;
  final void Function(int rating, String reviewText)? onSubmit;

  const _ReviewDialog({required this.doctorName, this.onSubmit});

  @override
  State<_ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<_ReviewDialog>
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
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please select a rating',
            style: TextStyle(fontFamily: 'Mulish'),
          ),
          backgroundColor: const Color(0xFF0D9488),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final text = _reviewController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please write your review',
            style: TextStyle(fontFamily: 'Mulish'),
          ),
          backgroundColor: const Color(0xFF0D9488),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate API delay — replace with your actual API call
    await Future.delayed(const Duration(milliseconds: 800));

    widget.onSubmit?.call(_selectedRating, text);

    if (mounted) {
      setState(() => _isSubmitting = false);
      Navigator.of(context).pop();
      _showSuccessSnack();
    }
  }

  void _showSuccessSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Review submitted successfully!',
              style:
                  TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0D9488),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
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
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Header with gradient ──
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
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.doctorName,
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Colors.white70,
                              ),
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
                            borderRadius: BorderRadius.circular(8),
                          ),
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
                      // Rating label
                      const Text(
                        'Your Rating',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Star row
                      Row(
                        children: List.generate(5, (index) {
                          final starIndex = index + 1;
                          final isSelected = starIndex <= _selectedRating;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedRating = starIndex),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeOut,
                              margin: const EdgeInsets.only(right: 8),
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(
                                    begin: 1.0, end: isSelected ? 1.2 : 1.0),
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOutBack,
                                builder: (_, scale, child) => Transform.scale(
                                  scale: scale,
                                  child: child,
                                ),
                                child: Icon(
                                  isSelected ? Icons.star : Icons.star_border,
                                  size: 36,
                                  color: isSelected
                                      ? const Color(0xFFFBBF24)
                                      : const Color(0xFFD1D5DB),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      // Rating label text
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
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _ratingLabels[_selectedRating],
                                    style: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(key: ValueKey(0), height: 8),
                      ),

                      const SizedBox(height: 18),

                      // Review text label
                      const Text(
                        'Your Review',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Text field
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
                            color: Color(0xFF374151),
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Describe your experience with the doctor...',
                            hintStyle: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              color: Color(0xFF9CA3AF),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(14),
                            counterStyle: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 11,
                              color: Color(0xFF9CA3AF),
                            ),
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
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                alignment: Alignment.center,
                                child: const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
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
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
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
                                          color: Colors.white,
                                        ),
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
