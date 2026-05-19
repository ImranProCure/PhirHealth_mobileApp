import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Qrisk3Controller extends GetxController {
  // ─────────────────────────────────────────────────────────────
  // Gender
  // ─────────────────────────────────────────────────────────────

  final RxString selectedGender = 'Male'.obs;

  final List<String> genderOptions = ['Male', 'Female'];

  void selectGender(String gender) => selectedGender.value = gender;

  // ─────────────────────────────────────────────────────────────
  // Ethnicity (QRISK3 categories)
  // ─────────────────────────────────────────────────────────────

  final RxString selectedEthnicity = 'White or not stated'.obs;

  final List<String> ethnicityOptions = [
    'White or not stated',
    'Indian',
    'Pakistani',
    'Bangladeshi',
    'Other Asian',
    'Black Caribbean',
    'Black African',
    'Chinese',
    'Other ethnic group',
  ];

  void selectEthnicity(String v) => selectedEthnicity.value = v;

  // ─────────────────────────────────────────────────────────────
  // Smoking Status
  // ─────────────────────────────────────────────────────────────

  final RxString selectedSmokingStatus = 'Non-smoker'.obs;

  final List<String> smokingOptions = [
    'Non-smoker',
    'Ex-smoker',
    'Light smoker (< 10/day)',
    'Moderate smoker (10–19/day)',
    'Heavy smoker (≥ 20/day)',
  ];

  void selectSmokingStatus(String v) => selectedSmokingStatus.value = v;

  // ─────────────────────────────────────────────────────────────
  // Diabetes Status
  // ─────────────────────────────────────────────────────────────

  final RxString selectedDiabetesStatus = 'Non'.obs;

  final List<String> diabetesOptions = [
    'Non',
    'Type 1',
    'Type 2',
  ];

  void selectDiabetesStatus(String v) => selectedDiabetesStatus.value = v;

  // ─────────────────────────────────────────────────────────────
  // Text Controllers
  // ─────────────────────────────────────────────────────────────

  final ageController = TextEditingController();
  final postcodeController = TextEditingController();
  final cholHdlRatioController = TextEditingController();
  final systolicBpController = TextEditingController();
  final systolicBpSdController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  // ─────────────────────────────────────────────────────────────
  // Errors
  // ─────────────────────────────────────────────────────────────

  final RxString ageError = ''.obs;
  final RxString cholHdlRatioError = ''.obs;
  final RxString systolicBpError = ''.obs;

  void clearAgeError() => ageError.value = '';
  void clearCholHdlRatioError() => cholHdlRatioError.value = '';
  void clearSystolicBpError() => systolicBpError.value = '';

  // ─────────────────────────────────────────────────────────────
  // Clinical Checkboxes
  // ─────────────────────────────────────────────────────────────

  final RxBool hasFamilyHeartHistory = false.obs;
  final RxBool hasCKD = false.obs;
  final RxBool hasAtrialFibrillation = false.obs;
  final RxBool hasTreatmentForHypertension = false.obs;
  final RxBool hasMigraines = false.obs;
  final RxBool hasRheumatoidArthritis = false.obs;
  final RxBool hasSLE = false.obs;
  final RxBool hasSevereMentalIllness = false.obs;
  final RxBool hasAntipsychoticMedication = false.obs;
  final RxBool hasRegularSteroids = false.obs;
  final RxBool hasErectileDysfunction = false.obs;

  // ─────────────────────────────────────────────────────────────
  // Results
  // ─────────────────────────────────────────────────────────────

  final RxDouble tenYearRisk = 0.0.obs;
  final RxDouble optimalRisk = 0.0.obs;

  // ─────────────────────────────────────────────────────────────
  // Navigation
  // ─────────────────────────────────────────────────────────────

  void onContinueFromInfo() => Get.toNamed('/qrisk3-form');

  void onContinueFromForm() {
    if (!_validateAll()) return;
    _calculateRisk();
    Get.toNamed('/qrisk3-result');
  }

  // ─────────────────────────────────────────────────────────────
  // Validation
  // ─────────────────────────────────────────────────────────────

  bool _validateAll() {
    bool valid = true;

    // Age
    final ageText = ageController.text.trim();
    if (ageText.isEmpty) {
      ageError.value = 'Age is required';
      valid = false;
    } else {
      final age = int.tryParse(ageText);
      if (age == null) {
        ageError.value = 'Enter valid age';
        valid = false;
      } else if (age < 25 || age > 84) {
        ageError.value = 'Age must be between 25 and 84';
        valid = false;
      } else {
        ageError.value = '';
      }
    }

    // Cholesterol/HDL (optional, validate only if provided)
    final cholText = cholHdlRatioController.text.trim();
    if (cholText.isNotEmpty) {
      final chol = double.tryParse(cholText);
      if (chol == null) {
        cholHdlRatioError.value = 'Enter valid value';
        valid = false;
      } else if (chol < 1 || chol > 12) {
        cholHdlRatioError.value = 'Value should be between 1 and 12';
        valid = false;
      } else {
        cholHdlRatioError.value = '';
      }
    }

    // Systolic BP (optional, validate only if provided)
    final sbpText = systolicBpController.text.trim();
    if (sbpText.isNotEmpty) {
      final sbp = double.tryParse(sbpText);
      if (sbp == null) {
        systolicBpError.value = 'Enter valid value';
        valid = false;
      } else if (sbp < 60 || sbp > 250) {
        systolicBpError.value = 'Value should be between 60 and 250';
        valid = false;
      } else {
        systolicBpError.value = '';
      }
    }

    return valid;
  }

  // ─────────────────────────────────────────────────────────────
  // QRISK3 Calculation (simplified PCE-based approximation)
  // Full QRISK3 requires regression coefficients by sex
  // ─────────────────────────────────────────────────────────────

  void _calculateRisk() {
    final age = double.tryParse(ageController.text.trim()) ?? 40;
    final cholHdl = double.tryParse(cholHdlRatioController.text.trim()) ?? 4.0;
    final sbp = double.tryParse(systolicBpController.text.trim()) ?? 125.0;
    final sbpSd = double.tryParse(systolicBpSdController.text.trim()) ?? 0.0;
    final heightCm = double.tryParse(heightController.text.trim());
    final weightKg = double.tryParse(weightController.text.trim());

    final isMale = selectedGender.value == 'Male';

    // BMI
    double bmi = 25.0;
    if (heightCm != null && weightKg != null && heightCm > 0) {
      final hm = heightCm / 100;
      bmi = weightKg / (hm * hm);
    }

    // Smoking score
    int smokingCat = 0;
    switch (selectedSmokingStatus.value) {
      case 'Ex-smoker':
        smokingCat = 1;
        break;
      case 'Light smoker (< 10/day)':
        smokingCat = 2;
        break;
      case 'Moderate smoker (10–19/day)':
        smokingCat = 3;
        break;
      case 'Heavy smoker (≥ 20/day)':
        smokingCat = 4;
        break;
    }

    // Diabetes
    int diabetesType = 0;
    if (selectedDiabetesStatus.value == 'Type 1') diabetesType = 1;
    if (selectedDiabetesStatus.value == 'Type 2') diabetesType = 2;

    // Ethnicity multiplier (simplified)
    double ethnicityMult = 1.0;
    switch (selectedEthnicity.value) {
      case 'Indian':
        ethnicityMult = 1.4;
        break;
      case 'Pakistani':
        ethnicityMult = 1.6;
        break;
      case 'Bangladeshi':
        ethnicityMult = 1.7;
        break;
      case 'Black Caribbean':
        ethnicityMult = 1.2;
        break;
      case 'Chinese':
        ethnicityMult = 0.7;
        break;
      case 'Other Asian':
        ethnicityMult = 1.3;
        break;
    }

    // Base QRISK3-like score
    double score = 0.0;

    if (isMale) {
      score = -22.60
          + 4.71 * log(age)
          + 0.66 * cholHdl
          + 0.018 * sbp
          + 0.006 * sbpSd
          + [0.0, 0.6, 0.7, 0.85, 1.0][smokingCat]
          + [0.0, 0.4, 0.7][diabetesType.clamp(0, 2)]
          + (hasAtrialFibrillation.value ? 1.0 : 0.0)
          + (hasTreatmentForHypertension.value ? 0.5 : 0.0)
          + (hasFamilyHeartHistory.value ? 0.55 : 0.0)
          + (hasCKD.value ? 0.8 : 0.0)
          + (hasSLE.value ? 0.7 : 0.0)
          + (hasRheumatoidArthritis.value ? 0.45 : 0.0)
          + (hasSevereMentalIllness.value ? 0.35 : 0.0)
          + (hasRegularSteroids.value ? 0.3 : 0.0)
          + (hasErectileDysfunction.value ? 0.4 : 0.0)
          + (hasAntipsychoticMedication.value ? 0.2 : 0.0)
          + 0.06 * (bmi - 25).clamp(0, double.infinity);
    } else {
      score = -28.30
          + 5.50 * log(age)
          + 0.55 * cholHdl
          + 0.017 * sbp
          + 0.005 * sbpSd
          + [0.0, 0.5, 0.6, 0.75, 0.9][smokingCat]
          + [0.0, 0.5, 0.8][diabetesType.clamp(0, 2)]
          + (hasAtrialFibrillation.value ? 1.1 : 0.0)
          + (hasTreatmentForHypertension.value ? 0.55 : 0.0)
          + (hasFamilyHeartHistory.value ? 0.45 : 0.0)
          + (hasCKD.value ? 0.7 : 0.0)
          + (hasSLE.value ? 1.0 : 0.0)
          + (hasRheumatoidArthritis.value ? 0.5 : 0.0)
          + (hasMigraines.value ? 0.3 : 0.0)
          + (hasSevereMentalIllness.value ? 0.3 : 0.0)
          + (hasRegularSteroids.value ? 0.35 : 0.0)
          + (hasAntipsychoticMedication.value ? 0.2 : 0.0)
          + 0.05 * (bmi - 25).clamp(0, double.infinity);
    }

    final baselineSurvival = isMale ? 0.914 : 0.966;
    final risk = (1 - pow(baselineSurvival, exp(score))) * 100;
    final clampedRisk = risk.clamp(0.0, 100.0).toDouble();

    // Optimal risk (ideal profile, same age/sex/ethnicity)
    double optScore = 0.0;
    if (isMale) {
      optScore = -22.60 + 4.71 * log(age) + 0.66 * 3.5 + 0.018 * 110;
    } else {
      optScore = -28.30 + 5.50 * log(age) + 0.55 * 3.5 + 0.017 * 110;
    }
    final optRisk = (1 - pow(baselineSurvival, exp(optScore))) * 100;
    final clampedOptRisk = (optRisk * ethnicityMult).clamp(0.0, 100.0).toDouble();

    tenYearRisk.value = double.parse((clampedRisk * ethnicityMult).clamp(0.0, 99.9).toStringAsFixed(1));
    optimalRisk.value = double.parse(clampedOptRisk.toStringAsFixed(1));
  }

  // ─────────────────────────────────────────────────────────────
  // Derived Properties
  // ─────────────────────────────────────────────────────────────

  String get riskLevel {
    if (tenYearRisk.value < 10) return 'Low';
    if (tenYearRisk.value < 20) return 'Moderate';
    return 'High';
  }

  double get gaugeAngle {
    if (tenYearRisk.value < 10) return -0.7;
    if (tenYearRisk.value < 20) return 0.0;
    return 0.75;
  }

  double get relativeRisk {
    if (optimalRisk.value <= 0) return 0.0;
    return double.parse(
      (tenYearRisk.value / optimalRisk.value).toStringAsFixed(1),
    );
  }

  String get relativeRiskLabel {
    final rr = relativeRisk;
    if (rr <= 1.0) return 'Normal';
    if (rr < 2.0) return 'Slightly Elevated';
    if (rr < 4.0) return 'Elevated';
    return 'Highly Elevated';
  }

  String get heartAge {
    final age = int.tryParse(ageController.text.trim()) ?? 40;
    final bonus = ((tenYearRisk.value - optimalRisk.value) / 5).round();
    final estimated = age + bonus;
    if (estimated >= 84) return '84+';
    return '$estimated';
  }

  // ─────────────────────────────────────────────────────────────
  // Dispose
  // ─────────────────────────────────────────────────────────────

  @override
  void onClose() {
    ageController.dispose();
    postcodeController.dispose();
    cholHdlRatioController.dispose();
    systolicBpController.dispose();
    systolicBpSdController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.onClose();
  }
}