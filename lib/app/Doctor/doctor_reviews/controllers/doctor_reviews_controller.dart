import 'package:get/get.dart';

class DoctorReviewsController extends GetxController {
  final double overallRating = 4.9;
  final int totalReviews = 5;

  final List<Map<String, dynamic>> ratingBreakdown = [
    {'star': 5, 'count': 3},
    {'star': 4, 'count': 1},
    {'star': 3, 'count': 1},
    {'star': 2, 'count': 0},
    {'star': 1, 'count': 0},
  ];

  final RxString selectedFilter = 'All'.obs;
  final List<String> filters = ['All', '5 Stars', '4Stars', '3 Stars'];

  final List<Map<String, dynamic>> reviews = [
    {
      'initials': 'AS',
      'name': 'Amit S.',
      'service': 'Advanced UI/UX Design',
      'rating': 5,
      'review':
          '"Dr. Rajesh is an excellent listener. He gave me ample time to explain my symptoms and didn\'t rush the consultation at all. The prescribed medicines worked perfectly and I felt better within 2 days. Highly recommended!"',
      'date': '20 Nov 2024',
      'helpful': 12,
    },
    {
      'initials': 'SP',
      'name': 'Sneha P.',
      'service': 'Advanced UI/UX Design',
      'rating': 5,
      'review':
          '"Dr. Rajesh is an excellent listener. He gave me ample time to explain my symptoms and didn\'t rush the consultation at all. The prescribed medicines worked perfectly and I felt better within 2 days. Highly recommended!"',
      'date': '20 Nov 2024',
      'helpful': 12,
    },
    {
      'initials': 'MA',
      'name': 'Mohd. A.',
      'service': 'Advanced UI/UX Design',
      'rating': 5,
      'review':
          '"Very polite and professional. Clinic hygiene and staff behavior are top-notch."',
      'date': '20 Nov 2024',
      'helpful': 12,
    },
  ];

  void selectFilter(String f) => selectedFilter.value = f;
}
