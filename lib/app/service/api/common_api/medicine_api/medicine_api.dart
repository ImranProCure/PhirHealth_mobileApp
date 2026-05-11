import 'dart:convert';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

class MedicineApi {
  final ApiClient _client = ApiClient();

  // ===== POST 1 — Add Medicine =====
  Future<ApiResponse> addMedicine({
    required String name,
    required String type,
    required int strength,
    required String unit,
  }) async {
    final data = {
      'name': name,
      'type': type,
      'strength': strength,
      'unit': unit,
      'medication_class': 'antibiotic', // ✅ Default,
    };
    return await _client.post(
      ApiConstants.commonApiConstants.addMedicine,
      data: data,
      authenticated: true,
    );
  }

  // ===== POST 2 — Set Schedule =====
  Future<ApiResponse> setSchedule({
    required String medication, // "Tablet Crocinn 500mg" — POST 1 response se
    required String dosageForm, // "Tablet"
    required String startDate, // "2026-05-09"
    required String customEndDate, // "2026-05-19"
    required List<Map<String, String>> schedule, // JSON array
    required String dosage, // "1-0-1"
  }) async {
    final data = {
      'medication': medication,
      'dosage_form': dosageForm,
      'start_date': startDate,
      'custom_end_date': customEndDate,
      'schedule': jsonEncode(schedule),
      'dosage': dosage,
    };
    return await _client.post(
      ApiConstants.commonApiConstants.setSchedule,
      data: data,
      authenticated: true,
    );
  }

  // ===== GET — My Medications =====
  Future<ApiResponse> getMyMedications({
    required String selectedDate, // "2026-05-12"
  }) async {
    return await _client.get(
      ApiConstants.commonApiConstants.getMyMedications,
      queryParameters: {'selected_date': selectedDate},
      authenticated: true,
    );
  }
}
