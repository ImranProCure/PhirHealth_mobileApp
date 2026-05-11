import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import '../../../routes/app_routes.dart';

class SelectDoctorController extends GetxController {
  Api api = Api.instance;

  // ================= SEARCH =================
  final searchText = ''.obs;

  // ================= SPECIALTIES =================
  final RxList<String> specialties = <String>[].obs;
  final RxList<String> selectedSpecialties = <String>[].obs;
  final RxBool isSpecialitiesLoading = false.obs;

  // ================= DOCTORS =================
  final RxList<Map<String, dynamic>> doctors = <Map<String, dynamic>>[].obs;
  final RxBool isDoctorsLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;

  // ================= PAGINATION =================
  int _currentPage = 1;
  static const int _pageSize = 10;

  // ================= SCROLL CONTROLLER =================
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchSpecialitiesApi();
    fetchDoctorsApi();

    // Listen for scroll to bottom → load next page
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore.value &&
          !isDoctorsLoading.value &&
          hasMoreData.value) {
        loadMoreDoctors();
      }
    });
  }

  // ================= FETCH SPECIALITIES FROM API =================
  Future<void> fetchSpecialitiesApi() async {
    isSpecialitiesLoading.value = true;

    ApiResponse response =
        await api.commonApi.doctorConsultApi.getSpecialities();
    isSpecialitiesLoading.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      final List<dynamic> data = messageData["data"] as List<dynamic>;
      final fetchedSpecialities =
          data.map((e) => e['name'].toString()).toList();
      specialties.assignAll(fetchedSpecialities);
    } else {
      showError(messageData["message"] ?? "Failed to fetch specialities");
    }
  }

  // ================= FETCH DOCTORS (fresh load, resets page) =================
  Future<void> fetchDoctorsApi() async {
    isDoctorsLoading.value = true;
    _currentPage = 1;
    hasMoreData.value = true;

    final Map<String, String> queryParams = _buildQueryParams(page: 1);

    ApiResponse response = await api.commonApi.doctorConsultApi
        .getDoctors(queryParams: queryParams);
    isDoctorsLoading.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      final List<dynamic> data = messageData["data"] as List<dynamic>;
      final fetchedDoctors = data.map(_mapDoctor).toList();
      doctors.assignAll(fetchedDoctors);

      // If returned less than page size, no more data
      if (fetchedDoctors.length < _pageSize) {
        hasMoreData.value = false;
      }
    } else {
      showError(messageData["message"] ?? "Failed to fetch doctors");
    }
  }

  // ================= LOAD MORE (appends next page) =================
  Future<void> loadMoreDoctors() async {
    isLoadingMore.value = true;
    _currentPage++;

    final Map<String, String> queryParams =
        _buildQueryParams(page: _currentPage);

    ApiResponse response = await api.commonApi.doctorConsultApi
        .getDoctors(queryParams: queryParams);
    isLoadingMore.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      final List<dynamic> data = messageData["data"] as List<dynamic>;
      final fetchedDoctors = data.map(_mapDoctor).toList();

      if (fetchedDoctors.isEmpty || fetchedDoctors.length < _pageSize) {
        hasMoreData.value = false;
      }

      doctors.addAll(fetchedDoctors);
    } else {
      // Rollback page increment on failure
      _currentPage--;
      showError(messageData["message"] ?? "Failed to load more doctors");
    }
  }

  // ================= HELPERS =================
  Map<String, String> _buildQueryParams({required int page}) {
    final Map<String, String> params = {
      'page': page.toString(),
    };
    if (searchText.value.trim().isNotEmpty) {
      params['name'] = searchText.value.trim();
    }
    if (selectedSpecialties.isNotEmpty) {
      params['speciality'] = selectedSpecialties.join(',');
    }
    return params;
  }

  Map<String, dynamic> _mapDoctor(dynamic e) => {
        "id": e['id']?.toString() ?? '',
        "name": e['name']?.toString() ?? '',
        "degree": e['degree']?.toString() ?? '',
        "fee": e['fee'] ?? 0,
        "rating": (e['rating'] as num?)?.toDouble() ?? 0.0,
        "speciality": e['speciality']?.toString() ?? '',
        "image": e['image']?.toString() ?? '',
        "available": e['availability_status']?.toString() == 'available',
        "availability_label": e['availability_label']?.toString() ?? '',
        "gender": e['gender']?.toString() ?? '',
      };

  // ================= SEARCH =================
  void onSearchSubmitted() {
    fetchDoctorsApi();
  }

  void onSearchChanged(String value) {
    searchText.value = value;
    if (value.trim().isEmpty) {
      fetchDoctorsApi();
    }
  }

  // ================= SPECIALTY TOGGLE =================
  void selectSpecialty(String value) {
    if (selectedSpecialties.contains(value)) {
      selectedSpecialties.clear();
    } else {
      selectedSpecialties
        ..clear()
        ..add(value);
    }
    fetchDoctorsApi();
  }

  // ================= BOOK DOCTOR =================
  void bookDoctor(doctor) {
    Get.toNamed(Routes.PROFILE_DETAILS, arguments: {
      'id': doctor["id"],
    });
  }

  // ================= CLEANUP =================
  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
