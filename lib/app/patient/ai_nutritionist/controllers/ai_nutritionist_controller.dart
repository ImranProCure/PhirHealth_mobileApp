import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/api/common_api/ai_nutrition_api/ai_nutrition_api.dart';
import '../../ai_nutritionist_result/controllers/ai_nutritionist_result_controller.dart';

class AiNutritionistController extends GetxController {
  final AiNutritionApi _api = AiNutritionApi();

  final RxString selectedGoal = 'Weight Loss'.obs;
  final RxString selectedFood = 'Vegetarian'.obs;
  final RxInt activityLevel = 3.obs;
  final RxList<String> selectedAllergies = <String>['Peanuts'].obs;
  final RxList<String> customAllergies = <String>[].obs;

  // Loading + error state
  final RxBool isLoading = false.obs;
  final RxBool isLoadingSaved = false.obs;
  final RxBool isDownloadingPdf = false.obs;
  final RxString errorMessage = ''.obs;

  final List<Map<String, dynamic>> goals = [
    {
      'label': 'Weight Loss',
      'sub': 'Burn Fat',
      'imagePath': 'assets/icons/measuring-tape 1.png'
    },
    {
      'label': 'Muscle Gain',
      'sub': 'Build Strength',
      'imagePath': 'assets/icons/muscle 1.png'
    },
  ];

  final List<Map<String, dynamic>> foods = [
    {'label': 'Vegetarian', 'imagePath': 'assets/icons/broccoli 1.png'},
    {'label': 'Non-Veg', 'imagePath': 'assets/icons/chicken-leg 1.png'},
    {'label': 'Vegan', 'imagePath': 'assets/icons/salad (1) 1.png'},
    {'label': 'Eggitarian', 'imagePath': 'assets/icons/eggs 1.png'},
  ];

  final List<String> activityLabels = [
    'Sedentary',
    'Lightly',
    'Moderate',
    'Active',
    'Very Active'
  ];

  final List<String> allergies = ['Peanuts', 'Antibiotics', 'Dust'];

  void selectGoal(String g) => selectedGoal.value = g;
  void selectFood(String f) => selectedFood.value = f;
  void setActivity(int i) => activityLevel.value = i;

  void toggleAllergy(String a) {
    selectedAllergies.contains(a)
        ? selectedAllergies.remove(a)
        : selectedAllergies.add(a);
  }

  void addCustomAllergy(String a) => customAllergies.add(a);
  void removeCustomAllergy(String a) => customAllergies.remove(a);

  List<String> get allAllergies => [...selectedAllergies, ...customAllergies];
  String get activityLabel => activityLabels[activityLevel.value];

  // ===== GENERATE PLAN — GROQ =====
  Future<void> generatePlan() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final dio = Dio();
      final apiKey = dotenv.env['GROQ_API_KEY'] ?? '';

      final response = await dio.post(
        'https://api.groq.com/openai/v1/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': 'llama-3.3-70b-versatile',
          'temperature': 0.9,
          'response_format': {'type': 'json_object'},
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are an expert Indian nutritionist. Always respond with valid JSON only. No markdown, no explanation, no extra text.',
            },
            {
              'role': 'user',
              'content': _buildPrompt(),
            }
          ],
        },
      );

      final content =
          response.data['choices'][0]['message']['content'] as String;
      final json = jsonDecode(content) as Map<String, dynamic>;

      // Filter out any meals that are not in the allowed types
      const allowedTypes = {'BREAKFAST', 'LUNCH', 'SNACK', 'DINNER'};
      if (json['meals'] != null) {
        json['meals'] = (json['meals'] as List)
            .where((m) => allowedTypes.contains(m['type']))
            .toList();
      }

      final resultCtrl = Get.find<AiNutritionistResultController>();
      resultCtrl.dailyCalories.value = 0;
      resultCtrl.meals.clear();
      resultCtrl.goal = selectedGoal.value;
      resultCtrl.activityLevel = activityLabel;
      resultCtrl.loadFromGroq(json);

      Get.toNamed('/ai-nutritionist-result');
    } on DioException catch (e) {
      errorMessage.value = 'Network error. Please try again.';
      Get.snackbar(
        'Error',
        'Network error. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'Something went wrong. Please try again.';
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ===== VIEW SAVED PLAN — GET API =====
  Future<void> viewSavedPlan() async {
    try {
      isLoadingSaved.value = true;

      final ApiResponse response = await _api.getNutritionPlan();
      final message = response.data['message'];

      if (message != null && message['status'] == true) {
        final data = message['data'] as Map<String, dynamic>;
        final resultCtrl = Get.find<AiNutritionistResultController>();
        resultCtrl.dailyCalories.value = 0;
        resultCtrl.meals.clear();
        resultCtrl.loadFromApi(data);
        Get.toNamed('/ai-nutritionist-result');
      } else {
        Get.snackbar(
          'No Plan Found',
          message?['message'] ?? 'No saved plan found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    } finally {
      isLoadingSaved.value = false;
    }
  }

  // ===== DOWNLOAD PDF REPORT =====
  Future<void> downloadPdfReport() async {
    isDownloadingPdf.value = true;
    try {
      final resultCtrl = Get.find<AiNutritionistResultController>();

      if (resultCtrl.meals.isEmpty) {
        Get.snackbar(
          'No Plan Available',
          'Please generate or load a plan first before downloading.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
        );
        return;
      }

      final pdf = pw.Document();

      final tealColor = PdfColor.fromHex('#0D9488');
      final blueColor = PdfColor.fromHex('#1565C0');
      final greyColor = PdfColor.fromHex('#6B7280');
      final lightGreyColor = PdfColor.fromHex('#F3F4F6');
      final darkColor = PdfColor.fromHex('#1F2937');
      final borderColor = PdfColor.fromHex('#E5E7EB');
      final tagBgColor = PdfColor.fromHex('#E0F2F1');

      final now = DateTime.now();
      final dateStr = '${now.day}/${now.month}/${now.year}';

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 32),
          footer: (pw.Context context) => pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 8),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.TextStyle(fontSize: 9, color: greyColor),
            ),
          ),
          build: (pw.Context context) => [
            // ── Header banner ──────────────────────────────
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(22),
              decoration: pw.BoxDecoration(
                gradient: pw.LinearGradient(
                  colors: [tealColor, blueColor],
                  begin: pw.Alignment.centerLeft,
                  end: pw.Alignment.centerRight,
                ),
                borderRadius: pw.BorderRadius.circular(14),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'AI Nutrition Plan',
                    style: pw.TextStyle(
                      fontSize: 26,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    resultCtrl.tagline.isNotEmpty
                        ? resultCtrl.tagline.value
                        : 'Your personalized Indian diet plan',
                    style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Text(
                    'Generated on $dateStr',
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColor.fromHex('#B2DFDB'),
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // ── Info cards row ──────────────────────────────
            pw.Row(
              children: [
                _pdfInfoCard('Goal', resultCtrl.goal, tealColor),
                pw.SizedBox(width: 10),
                _pdfInfoCard(
                    'Activity', resultCtrl.activityLevel, blueColor),
                pw.SizedBox(width: 10),
                _pdfInfoCard(
                  'Daily Calories',
                  '${resultCtrl.dailyCalories.value} kcal',
                  PdfColor.fromHex('#059669'),
                ),
              ],
            ),
            pw.SizedBox(height: 14),

            // ── Summary box ────────────────────────────────
            if (resultCtrl.summary.isNotEmpty) ...[
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: pw.BoxDecoration(
                  color: tagBgColor,
                  borderRadius: pw.BorderRadius.circular(10),
                  border: pw.Border.all(color: tealColor, width: 0.5),
                ),
                child: pw.Text(
                  resultCtrl.summary.value,
                  style: pw.TextStyle(
                    fontSize: 11,
                    color: PdfColor.fromHex('#065F46'),
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
            ],

            // ── Meal plan heading ──────────────────────────
            pw.Row(
              children: [
                pw.Container(
                  width: 4,
                  height: 20,
                  decoration: pw.BoxDecoration(
                    color: tealColor,
                    borderRadius: pw.BorderRadius.circular(2),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Text(
                  'Meal Plan',
                  style: pw.TextStyle(
                    fontSize: 17,
                    fontWeight: pw.FontWeight.bold,
                    color: darkColor,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 14),

            // ── Meal cards ─────────────────────────────────
            ...resultCtrl.meals.map((meal) {
              final mealColor = _mealTypeColor(meal["type"]);
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 12),
                padding: const pw.EdgeInsets.all(14),
                decoration: pw.BoxDecoration(
                  color: lightGreyColor,
                  borderRadius: pw.BorderRadius.circular(10),
                  border: pw.Border.all(color: borderColor, width: 0.8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Type badge + time
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: pw.BoxDecoration(
                            color: mealColor,
                            borderRadius: pw.BorderRadius.circular(20),
                          ),
                          child: pw.Text(
                            meal["type"],
                            style: pw.TextStyle(
                              fontSize: 9,
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Text(
                          meal["time"],
                          style: pw.TextStyle(
                            fontSize: 11,
                            color: greyColor,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 8),

                    // Meal name
                    pw.Text(
                      meal["name"],
                      style: pw.TextStyle(
                        fontSize: 13,
                        fontWeight: pw.FontWeight.bold,
                        color: darkColor,
                      ),
                    ),
                    pw.SizedBox(height: 5),

                    // Calories
                    pw.Row(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex('#FEF3C7'),
                            borderRadius: pw.BorderRadius.circular(6),
                          ),
                          child: pw.Text(
                            '${meal["calories"]} kcal',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex('#D97706'),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Tags
                    if (meal["tags"].isNotEmpty) ...[
                      pw.SizedBox(height: 8),
                      pw.Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: meal["tags"]
                            .map(
                              (tag) => pw.Container(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: pw.BoxDecoration(
                                  color: tagBgColor,
                                  borderRadius: pw.BorderRadius.circular(12),
                                  border: pw.Border.all(
                                      color: tealColor, width: 0.4),
                                ),
                                child: pw.Text(
                                  tag,
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    color: tealColor,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),

            pw.SizedBox(height: 16),

            // ── Footer divider ─────────────────────────────
            pw.Divider(color: borderColor, thickness: 0.8),
            pw.SizedBox(height: 8),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Generated by AI Nutritionist',
                  style: pw.TextStyle(fontSize: 9, color: greyColor),
                ),
                pw.Text(
                  dateStr,
                  style: pw.TextStyle(fontSize: 9, color: greyColor),
                ),
              ],
            ),
          ],
        ),
      );

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename:
            'nutrition_plan_${now.day}${now.month}${now.year}.pdf',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not generate PDF. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    } finally {
      isDownloadingPdf.value = false;
    }
  }

  // ── PDF helpers ────────────────────────────────────────────

  pw.Expanded _pdfInfoCard(String label, String value, PdfColor color) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: pw.BoxDecoration(
          color: color,
          borderRadius: pw.BorderRadius.circular(10),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label.toUpperCase(),
              style: pw.TextStyle(
                fontSize: 8,
                color: PdfColor.fromHex('#B2EBF2'),
                letterSpacing: 0.8,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              value.isNotEmpty ? value : '—',
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PdfColor _mealTypeColor(String type) {
    switch (type.toUpperCase()) {
      case 'BREAKFAST':
        return PdfColor.fromHex('#F59E0B');
      case 'LUNCH':
        return PdfColor.fromHex('#0D9488');
      case 'SNACK':
        return PdfColor.fromHex('#8B5CF6');
      case 'DINNER':
        return PdfColor.fromHex('#1565C0');
      default:
        return PdfColor.fromHex('#6B7280');
    }
  }

  String _buildPrompt() {
    return '''
Generate a personalized Indian diet plan for:
- Goal: ${selectedGoal.value}
- Diet Type: ${selectedFood.value}
- Activity Level: $activityLabel
- Allergies: ${allAllergies.isEmpty ? 'None' : allAllergies.join(', ')}

STRICT RULE: The "type" field in each meal must be EXACTLY one of these 4 values only: "BREAKFAST", "LUNCH", "SNACK", "DINNER". Do NOT use any other values. No "POST WORKOUT", no "BEFORE BED SNACK", nothing else. Only these 4 types are allowed.

Return ONLY this exact JSON format, nothing else:
{
  "daily_calories": 1800,
  "summary": "Based on your profile, you need 1,800 Calories to achieve your goal.",
  "tagline": "This plan is optimized for fat loss with muscle retention.",
  "meals": [
    {
      "type": "BREAKFAST",
      "time": "8:30 AM",
      "calories": 450,
      "name": "Poha with Peanuts + 1 Cup Tea",
      "tags": ["Low Fat", "Quick Prep"]
    },
    {
      "type": "LUNCH",
      "time": "1:30 PM",
      "calories": 650,
      "name": "2 Multigrain Roti + Dal Tadka + Salad",
      "tags": ["High Fiber", "Iron Rich"]
    },
    {
      "type": "SNACK",
      "time": "5:00 PM",
      "calories": 250,
      "name": "Green Tea + Roasted Makhana",
      "tags": ["Antioxidants"]
    },
    {
      "type": "DINNER",
      "time": "8:30 PM",
      "calories": 500,
      "name": "Grilled Paneer Salad / Dal Khichdi",
      "tags": ["High Protein", "Easy Digest"]
    }
  ]
}
''';
  }
}