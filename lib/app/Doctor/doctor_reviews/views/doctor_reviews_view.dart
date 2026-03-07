import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_reviews_controller.dart';

class DoctorReviewsView extends GetView<DoctorReviewsController> {
  const DoctorReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text('Patient Reviews',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== OVERALL RATING CARD =====
            _overallRatingCard(),
            const SizedBox(height: 16),

            // ===== FILTER CHIPS =====
            _filterChips(),
            const SizedBox(height: 16),

            // ===== REVIEW CARDS =====
            ...controller.reviews.map((r) => _reviewCard(r)),
          ],
        ),
      ),
    );
  }

  // ===== OVERALL RATING CARD =====
  Widget _overallRatingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF00897B), Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Overall Rating',
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70)),
              Text('${controller.totalReviews}',
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white)),
            ],
          ),
          const SizedBox(height: 6),
          // Rating + Total label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text('${controller.overallRating}',
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white)),
                  const SizedBox(width: 6),
                  const Icon(Icons.star, color: Color(0xFFFBBF24), size: 26),
                ],
              ),
              const Text('Total Reviews',
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 14),

          // ===== RATING BREAKDOWN BARS =====
          ...controller.ratingBreakdown.map((r) => _ratingBar(r)),
        ],
      ),
    );
  }

  Widget _ratingBar(Map<String, dynamic> r) {
    final int star = r['star'] as int;
    final int count = r['count'] as int;
    final double fraction =
        count / (controller.totalReviews == 0 ? 1 : controller.totalReviews);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text('$star',
              style: const TextStyle(
                  fontFamily: 'Mulish', fontSize: 12, color: Colors.white70)),
          const SizedBox(width: 4),
          const Icon(Icons.star, color: Color(0xFFFBBF24), size: 12),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 6,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 16,
            child: Text('$count',
                textAlign: TextAlign.end,
                style: const TextStyle(
                    fontFamily: 'Mulish', fontSize: 12, color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  // ===== FILTER CHIPS =====
  Widget _filterChips() {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.filters.map((f) {
              final bool isSelected = controller.selectedFilter.value == f;
              return GestureDetector(
                onTap: () => controller.selectFilter(f),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0D9488) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF0D9488)
                          : const Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(f,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black,
                          )),
                      if (!isSelected) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.star_border,
                            size: 14, color: Colors.black54),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }

  // ===== REVIEW CARD =====
  Widget _reviewCard(Map<String, dynamic> r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
        children: [
          // Name row
          Row(
            children: [
              // Initials circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: Center(
                  child: Text(r['initials'] as String,
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r['name'] as String,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.black)),
                    Text(r['service'] as String,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            color: Color(0xFF6B7280))),
                  ],
                ),
              ),
              // Star + rating
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFFBBF24), size: 16),
                  const SizedBox(width: 4),
                  Text('${r['rating']}',
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Review text
          Text(r['review'] as String,
              style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 13,
                  color: Color(0xFF374151),
                  height: 1.5)),
          const SizedBox(height: 12),

          // Date + helpful
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(r['date'] as String,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      color: Color(0xFF9CA3AF))),
              Row(
                children: [
                  const Icon(Icons.thumb_up_outlined,
                      size: 14, color: Color(0xFF0D9488)),
                  const SizedBox(width: 5),
                  Text('${r['helpful']} helpful',
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 12,
                          color: Color(0xFF0D9488),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
