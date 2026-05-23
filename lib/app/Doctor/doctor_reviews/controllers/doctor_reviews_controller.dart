import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import '../../../service/api/common_api/doctor_review_api/doctor_review_api.dart';

class DoctorReviewsController extends GetxController {
  final DoctorReviewsApi _api = DoctorReviewsApi();

  // ===== LOADING =====
  final RxBool isLoading = false.obs;

  // ===== OVERVIEW =====
  final RxDouble overallRating = 0.0.obs;
  final RxInt totalReviews = 0.obs;

  // ===== RATING BREAKDOWN =====
  final RxList<Map<String, dynamic>> ratingBreakdown = <Map<String, dynamic>>[
    {'star': 5, 'count': 0},
    {'star': 4, 'count': 0},
    {'star': 3, 'count': 0},
    {'star': 2, 'count': 0},
    {'star': 1, 'count': 0},
  ].obs;

  // ===== FILTER =====
  final RxString selectedFilter = 'All'.obs;
  final List<String> filters = [
    'All',
    '5 Stars',
    '4 Stars',
    '3 Stars',
    '2 Stars',
    '1 Star'
  ];

  // ===== REVIEWS =====
  final RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  // ===== FETCH REVIEWS =====
  Future<void> fetchReviews({String? filter}) async {
    try {
      isLoading.value = true;

      final ApiResponse response = await _api.getDoctorReviews(
        filter: filter ?? selectedFilter.value,
      );

      final message = response.data['message'];

      if (message != null && message['status'] == true) {
        final data = message['data'] as Map<String, dynamic>? ?? {};

        // ===== OVERVIEW =====
        overallRating.value =
            double.tryParse(data['average_rating']?.toString() ?? '0') ?? 0.0;
        totalReviews.value =
            int.tryParse(data['total_reviews']?.toString() ?? '0') ?? 0;

        // ===== REVIEWS LIST =====
        final reviewList = data['reviews'] as List? ?? [];
        reviews.assignAll(
          reviewList.map((r) {
            final name = r['reviewer_name']?.toString() ?? '';
            return {
              'initials': _getInitials(name),
              'name': name,
              'rating': (r['rating'] as num?)?.toDouble() ?? 0.0,
              'review': r['review_text']?.toString() ?? '',
              'date': r['date']?.toString() ?? '',
            };
          }).toList(),
        );

        // ===== RATING BREAKDOWN — reviews se calculate karo =====
        _calculateBreakdown(reviewList);
      } else {
        showError(message?['message']?.toString() ?? 'Failed to load reviews');
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ===== FILTER SELECT =====
  void selectFilter(String f) {
    selectedFilter.value = f;
    // Filter value nikalo — "4 Stars" → "4"
    String? filterParam;
    if (f != 'All') {
      filterParam = f.replaceAll(' Stars', '').replaceAll(' Star', '').trim();
    }
    fetchReviews(filter: filterParam ?? 'All');
  }

  // ===== INITIALS HELPER =====
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  // ===== BREAKDOWN CALCULATE =====
  void _calculateBreakdown(List reviewList) {
    final counts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final r in reviewList) {
      final rating = (r['rating'] as num?)?.round() ?? 0;
      if (counts.containsKey(rating)) {
        counts[rating] = counts[rating]! + 1;
      }
    }
    ratingBreakdown.assignAll([
      {'star': 5, 'count': counts[5]},
      {'star': 4, 'count': counts[4]},
      {'star': 3, 'count': counts[3]},
      {'star': 2, 'count': counts[2]},
      {'star': 1, 'count': counts[1]},
    ]);
  }
}
