import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/api/common_api/ai_nutrition_api/ai_nutrition_api.dart';
import 'package:sample/app/service/db/db.dart';
import '../../ai_nutritionist/controllers/ai_nutritionist_controller.dart';

class AiNutritionistResultController extends GetxController {
  final AiNutritionApi _api = AiNutritionApi();

  // ===== LOADING =====
  final RxBool isSaving = false.obs;
  final RxBool isDownloadingPdf = false.obs;

  // ===== FLAG =====
  final RxBool isSavedPlan = false.obs;
  AuthStorageService authStorage = AuthStorageService();

  // ===== DATA =====
  final RxInt dailyCalories = 0.obs;
  final RxString summary = ''.obs;
  final RxString tagline = ''.obs;
  final RxList<Map<String, dynamic>> meals = <Map<String, dynamic>>[].obs;

  // ===== GOAL + ACTIVITY =====
  String goal = '';
  String activityLevel = '';

  final Map<String, Map<String, dynamic>> _mealIconConfig = {
    'BREAKFAST': {
      'imagePath': 'assets/icons/bakery_dining.png',
      'iconColor': 0xFFFF6B35,
      'iconBg': 0xFFFFF3EE,
    },
    'LUNCH': {
      'imagePath': 'assets/icons/washoku.png',
      'iconColor': 0xFF0D9488,
      'iconBg': 0xFFE0F2F1,
    },
    'SNACK': {
      'imagePath': 'assets/icons/local_cafe.png',
      'iconColor': 0xFFE91E8C,
      'iconBg': 0xFFFCE4F3,
    },
    'SNACKS': {
      'imagePath': 'assets/icons/local_cafe.png',
      'iconColor': 0xFFE91E8C,
      'iconBg': 0xFFFCE4F3,
    },
    'DINNER': {
      'imagePath': 'assets/icons/soup_kitchen.png',
      'iconColor': 0xFF7C3AED,
      'iconBg': 0xFFF3E8FF,
    },
    'BEFORE BED SNACK': {
      'imagePath': 'assets/icons/soup_kitchen.png',
      'iconColor': 0xFF7C3AED,
      'iconBg': 0xFFF3E8FF,
    },
  };

  // ===== LOAD FROM GROQ =====
  void loadFromGroq(Map<String, dynamic> json) {
    isSavedPlan.value = false;
    dailyCalories.value = json['daily_calories'] ?? 0;
    summary.value = json['summary'] ?? '';
    tagline.value = json['tagline'] ?? '';

    final rawMeals = json['meals'] as List? ?? [];
    meals.value = rawMeals.map((m) {
      final type = (m['type'] as String).toUpperCase();
      final iconConfig = _mealIconConfig[type] ?? _mealIconConfig['BREAKFAST']!;
      return {
        'type': type,
        'time': m['time'] ?? '',
        'cal': '${m['calories']} Cal',
        'meal': m['name'] ?? '',
        'tags': List<String>.from(m['tags'] ?? []),
        ...iconConfig,
      };
    }).toList();
  }

  // ===== LOAD FROM API =====
  void loadFromApi(Map<String, dynamic> data) {
    isSavedPlan.value = true;

    final cal = data['daily_calories'];
    dailyCalories.value =
        cal is int ? cal : int.tryParse(cal?.toString() ?? '0') ?? 0;

    goal = data['goal']?.toString() ?? '';
    summary.value = 'Your saved ${data['goal']} plan';
    tagline.value = 'Tap Go Back to return';

    final rawMeals = data['meals'] as List? ?? [];
    meals.value = rawMeals.map((m) {
      final type = (m['meal_type'] as String).toUpperCase();
      final iconConfig = _mealIconConfig[type] ?? _mealIconConfig['BREAKFAST']!;

      final mealCal = m['calories'];
      final calInt = mealCal is int
          ? mealCal
          : int.tryParse(mealCal?.toString() ?? '0') ?? 0;

      return {
        'type': type,
        'time': m['meal_time']?.toString() ?? '',
        'cal': '$calInt Cal',
        'meal': m['food_items']?.toString() ?? '',
        'tags': List<String>.from(m['tags'] ?? []),
        ...iconConfig,
      };
    }).toList();
  }

  // ===== ACCEPT PLAN — POST API + DOWNLOAD PDF =====
  Future<void> acceptPlan() async {
    try {
      isSaving.value = true;

      final mealsForApi = meals.map((m) {
        final calStr = m['cal'].toString().replaceAll(' Cal', '').trim();
        final calories = double.tryParse(calStr)?.toInt() ?? 0;

        return {
          'meal_type': m['type'],
          'meal_time': m['time'],
          'calories': calories,
          'food_items': m['meal'],
          'tags': List<String>.from(m['tags'] ?? []),
        };
      }).toList();

      final ApiResponse response = await _api.saveNutritionPlan(
        goal: goal,
        activityLevel: activityLevel,
        dailyCalories: dailyCalories.value,
        meals: mealsForApi,
        tags: [],
      );

      final message = response.data['message'];

      if (message != null && message['status'] == true) {
        showMessage('Plan saved successfully!');

        // ===== DOWNLOAD PDF AFTER SUCCESSFUL SAVE =====
        await downloadPdf();

        Get.offAllNamed('/dashboard');
      } else {
        showError(message?['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  // ===== STANDALONE DOWNLOAD PDF — AppBar icon OR after acceptPlan =====
  Future<void> downloadPdf() async {
    if (isDownloadingPdf.value) return;

    if (meals.isEmpty) {
      showError('No plan available to download.');
      return;
    }

    try {
      isDownloadingPdf.value = true;
    final userDetail = await authStorage.getUserDetail();
    String userName = (userDetail?['full_name'] as String? ?? '').trim();
      // ── Get user name safely ──────────────────────────────────
      // Adjust controller type & field to match your project.
      // Examples:
      //   Get.find<ProfileController>().profileData.value?.name ?? 'User'
      //   Get.find<AuthController>().currentUser.value?.fullName ?? 'User'
      try {
        final dynamic authCtrl = Get.find(tag: 'auth') ??
            Get.find(tag: 'profile') ??
            Get.find(tag: 'user');
        final dynamic nameVal =
            authCtrl?.user?.value?.name ?? authCtrl?.name?.value;
        if (nameVal != null && nameVal.toString().trim().isNotEmpty) {
          userName = nameVal.toString().trim();
        }
      } catch (_) {
        // Controller not found — keep default 'User'
      }

      await _generateAndSharePdf(userName: userName);
    } catch (e) {
      showError('Could not generate PDF. Please try again.');
    } finally {
      isDownloadingPdf.value = false;
    }
  }

  // ===== PDF GENERATION =====
  Future<void> _generateAndSharePdf({required String userName}) async {
    // ── Colours ────────────────────────────────────────────────
    final tealColor = PdfColor.fromHex('#0D9488');
    final blueColor = PdfColor.fromHex('#1565C0');
    final greyColor = PdfColor.fromHex('#6B7280');
    final lightGreyColor = PdfColor.fromHex('#F3F4F6');
    final darkColor = PdfColor.fromHex('#1F2937');
    final borderColor = PdfColor.fromHex('#E5E7EB');
    final tagBgColor = PdfColor.fromHex('#E0F2F1');
    final avatarBg = PdfColor.fromHex('#E0F2F1');

    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year}';

    // ── Load PHIR Health logo ────────────────────────────────────
    // Place the logo file at this path in your project and register
    // it under `assets:` in pubspec.yaml. Falls back gracefully
    // (header just shows text) if the asset can't be loaded.
    pw.MemoryImage? logoImage;
    try {
      final logoData =
          await rootBundle.load('assets/phir_health_app_icon.png');
      logoImage = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (_) {
      logoImage = null;
    }

    final pdf = pw.Document();

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
          // ── Header banner ───────────────────────────────────
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
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // Logo chip
                if (logoImage != null) ...[
                  pw.Container(
                    width: 56,
                    height: 56,
                    padding: const pw.EdgeInsets.all(6),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: pw.BorderRadius.circular(12),
                    ),
                    child: pw.Image(logoImage, fit: pw.BoxFit.contain),
                  ),
                  pw.SizedBox(width: 14),
                ],
                pw.Expanded(
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
                        tagline.isNotEmpty
                            ? tagline.value
                            : 'Your personalized Indian diet plan',
                        style: pw.TextStyle(fontSize: 12, color: PdfColors.white),
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
              ],
            ),
          ),
          pw.SizedBox(height: 16),

          // ── User name card ──────────────────────────────────
          pw.Container(
            width: double.infinity,
            padding:
                const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: pw.BoxDecoration(
              color: avatarBg,
              borderRadius: pw.BorderRadius.circular(12),
              border: pw.Border.all(color: tealColor, width: 0.5),
            ),
            child: pw.Row(
              children: [
                // Avatar circle with first-letter initial
                pw.Container(
                  width: 42,
                  height: 42,
                  decoration: pw.BoxDecoration(
                    color: tealColor,
                    shape: pw.BoxShape.circle,
                  ),
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                ),
                pw.SizedBox(width: 14),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Prepared for',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: greyColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      userName,
                      style: pw.TextStyle(
                        fontSize: 15,
                        fontWeight: pw.FontWeight.bold,
                        color: darkColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),

          // ── Info cards row ──────────────────────────────────
          pw.Row(
            children: [
              _pdfInfoCard('Goal', goal.isNotEmpty ? goal : '—', tealColor),
              pw.SizedBox(width: 10),
              _pdfInfoCard(
                'Activity',
                activityLevel.isNotEmpty ? activityLevel : '—',
                blueColor,
              ),
              pw.SizedBox(width: 10),
              _pdfInfoCard(
                'Daily Calories',
                '${dailyCalories.value} kcal',
                PdfColor.fromHex('#059669'),
              ),
            ],
          ),
          pw.SizedBox(height: 14),

          // ── Summary box ─────────────────────────────────────
          if (summary.isNotEmpty) ...[
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
                summary.value,
                style: pw.TextStyle(
                  fontSize: 11,
                  color: PdfColor.fromHex('#065F46'),
                ),
              ),
            ),
            pw.SizedBox(height: 20),
          ],

          // ── Meal plan heading ────────────────────────────────
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
                'Daily Meal Plan',
                style: pw.TextStyle(
                  fontSize: 17,
                  fontWeight: pw.FontWeight.bold,
                  color: darkColor,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 14),

          // ── Meal cards ───────────────────────────────────────
          ...meals.map((meal) {
            final mealColor = _mealTypeColor(meal['type'] as String);
            final calStr =
                (meal['cal'] as String).replaceAll(' Cal', '').trim();

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
                          meal['type'] as String,
                          style: pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Text(
                        meal['time'] as String,
                        style: pw.TextStyle(fontSize: 11, color: greyColor),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),

                  // Meal name
                  pw.Text(
                    meal['meal'] as String,
                    style: pw.TextStyle(
                      fontSize: 13,
                      fontWeight: pw.FontWeight.bold,
                      color: darkColor,
                    ),
                  ),
                  pw.SizedBox(height: 5),

                  // Calories badge
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#FEF3C7'),
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Text(
                      '$calStr kcal',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#D97706'),
                      ),
                    ),
                  ),

                  // Tags
                  if ((meal['tags'] as List).isNotEmpty) ...[
                    pw.SizedBox(height: 8),
                    pw.Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: (meal['tags'] as List<String>)
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
                                style:
                                    pw.TextStyle(fontSize: 9, color: tealColor),
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

          // ── Footer divider ───────────────────────────────────
          pw.Divider(color: borderColor, thickness: 0.8),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Generated by PHIR Health  •  $userName',
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
          'nutrition_plan_${userName.replaceAll(' ', '_')}_${now.day}${now.month}${now.year}.pdf',
    );
  }

  // ── PDF helpers ─────────────────────────────────────────────
  pw.Expanded _pdfInfoCard(String label, String value, PdfColor color) {
    return pw.Expanded(
      child: pw.Container(
        padding:
            const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

  // ===== REGENERATE / GO BACK =====
  void regenerate() {
    dailyCalories.value = 0;
    summary.value = '';
    tagline.value = '';
    meals.clear();
    isSavedPlan.value = false;
    Get.back();
  }
}