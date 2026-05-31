import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MdrdGfrController extends GetxController {
  // ─────────────────────────────────────────────────────────────
  // Gender
  // ─────────────────────────────────────────────────────────────

  final RxString selectedGender = 'Male'.obs;

  final List<String> genderOptions = ['Male', 'Female'];

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  // ─────────────────────────────────────────────────────────────
  // Race
  // ─────────────────────────────────────────────────────────────

  final RxString selectedRace = 'White'.obs;

  final List<String> raceOptions = [
    'White',
    'Black / African American',
    'Other',
  ];

  void selectRace(String race) {
    selectedRace.value = race;
  }

  // ─────────────────────────────────────────────────────────────
  // Text Controllers
  // ─────────────────────────────────────────────────────────────

  final ageController = TextEditingController();
  final creatinineController = TextEditingController();

  // ─────────────────────────────────────────────────────────────
  // Errors
  // ─────────────────────────────────────────────────────────────

  final RxString ageError = ''.obs;
  final RxString creatinineError = ''.obs;

  void clearAgeError() => ageError.value = '';
  void clearCreatinineError() => creatinineError.value = '';

  // ─────────────────────────────────────────────────────────────
  // Results
  // ─────────────────────────────────────────────────────────────

  final RxDouble gfrResult = 0.0.obs;

  // ─────────────────────────────────────────────────────────────
  // Navigation
  // ─────────────────────────────────────────────────────────────

  void onContinueFromInfo() {
    Get.toNamed('/mdrd-form');
  }

  void onCalculate() {
    if (!_validateAll()) return;
    _calculateGFR();
    Get.toNamed('/mdrd-result');
  }

  // ─────────────────────────────────────────────────────────────
  // Validation
  // ─────────────────────────────────────────────────────────────

  bool _validateAll() {
    bool valid = true;

    final ageText = ageController.text.trim();
    if (ageText.isEmpty) {
      ageError.value = 'Age is required';
      valid = false;
    } else {
      final age = int.tryParse(ageText);
      if (age == null) {
        ageError.value = 'Enter a valid age';
        valid = false;
      } else if (age < 18 || age > 110) {
        ageError.value = 'Age must be between 18 and 110';
        valid = false;
      } else {
        ageError.value = '';
      }
    }

    final creatText = creatinineController.text.trim();
    if (creatText.isEmpty) {
      creatinineError.value = 'Creatinine is required';
      valid = false;
    } else {
      final creat = double.tryParse(creatText);
      if (creat == null) {
        creatinineError.value = 'Enter a valid value';
        valid = false;
      } else if (creat < 10 || creat > 2000) {
        creatinineError.value = 'Value should be between 10 and 2000 µmol/L';
        valid = false;
      } else {
        creatinineError.value = '';
      }
    }

    return valid;
  }

  // ─────────────────────────────────────────────────────────────
  // MDRD Formula  (4-variable)
  // Input: serum creatinine in µmol/L
  // GFR (mL/min/1.73m²) = 175 × (Scr_mg_dL)^−1.154 × Age^−0.203
  //                        × [0.742 if female] × [1.212 if AA]
  // ─────────────────────────────────────────────────────────────

  void _calculateGFR() {
    final age = double.tryParse(ageController.text.trim()) ?? 40;

    // Convert µmol/L → mg/dL  (÷ 88.4)
    final creatUmol = double.tryParse(creatinineController.text.trim()) ?? 80;
    final creatMgDl = creatUmol / 88.4;

    final isFemale = selectedGender.value == 'Female';
    final isAA = selectedRace.value == 'Black / African American';

    double gfr = 175 *
        pow(creatMgDl, -1.154) *
        pow(age, -0.203) *
        (isFemale ? 0.742 : 1.0) *
        (isAA ? 1.212 : 1.0);

    gfrResult.value = double.parse(gfr.toStringAsFixed(1));
  }

  // ─────────────────────────────────────────────────────────────
  // CKD Stage helpers
  // ─────────────────────────────────────────────────────────────

  String get ckdStage {
    final v = gfrResult.value;
    if (v >= 90) return 'Stage 1 (Normal or High)';
    if (v >= 60) return 'Stage 2 (Mildly Decreased)';
    if (v >= 45) return 'Stage 3a (Mildly–Moderately Decreased)';
    if (v >= 30) return 'Stage 3b (Moderately–Severely Decreased)';
    if (v >= 15) return 'Stage 4 (Severely Decreased)';
    return 'Stage 5 (Kidney Failure)';
  }

  String get ckdStageShort {
    final v = gfrResult.value;
    if (v >= 90) return 'Stage 1';
    if (v >= 60) return 'Stage 2 (Mildly Decreased Function)';
    if (v >= 45) return 'Stage 3a';
    if (v >= 30) return 'Stage 3b';
    if (v >= 15) return 'Stage 4';
    return 'Stage 5';
  }

  String get riskLevel {
    final v = gfrResult.value;
    if (v >= 60) return 'Low';
    if (v >= 30) return 'Moderate';
    return 'High';
  }

  String get medicationDosing {
    final v = gfrResult.value;
    if (v >= 60) return 'No renal dose adjustment required.';
    if (v >= 30) return 'Dose adjustment may be needed. Review medications.';
    return 'Significant dose adjustments required. Nephrology input essential.';
  }

  String get recommendation {
    final v = gfrResult.value;
    if (v >= 90) return 'Annual monitoring of GFR & BP.';
    if (v >= 60) return 'Routine annual monitoring of GFR & BP.';
    if (v >= 45) return 'Monitor every 3–6 months. Manage risk factors.';
    if (v >= 30) return 'Monitor every 3 months. Nephrology referral advised.';
    if (v >= 15) return 'Nephrology referral. Prepare for renal replacement.';
    return 'Immediate nephrology referral. Initiate renal replacement therapy.';
  }

  // Gauge needle: maps GFR to –1 (Low) → 0 (Moderate) → +1 (High risk)
  double get gaugeAngle {
    final v = gfrResult.value;
    if (v >= 60) return -0.75;
    if (v >= 30) return 0.0;
    return 0.75;
  }

  // ─────────────────────────────────────────────────────────────
  // Dispose
  // ─────────────────────────────────────────────────────────────

  @override
  void onClose() {
    ageController.dispose();
    creatinineController.dispose();
    super.onClose();
  }
}
