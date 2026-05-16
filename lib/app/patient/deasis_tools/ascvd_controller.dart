import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AscvdController extends GetxController {
  // ─────────────────────────────────────────────────────────────
  // Gender
  // ─────────────────────────────────────────────────────────────

  final RxString selectedGender = 'Male'.obs;

  final List<String> genderOptions = [
    'Male',
    'Female',
  ];

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  // ─────────────────────────────────────────────────────────────
  // Race
  // ─────────────────────────────────────────────────────────────

  final RxString selectedRace = 'White'.obs;

  final List<String> raceOptions = [
    'White',
    'African American',
    'Other',
  ];

  void selectRace(String race) {
    selectedRace.value = race;
  }

  // ─────────────────────────────────────────────────────────────
  // Controllers
  // ─────────────────────────────────────────────────────────────

  final nameController = TextEditingController();

  final ageController = TextEditingController();

  final totalCholesterolController = TextEditingController();

  final hdlCholesterolController = TextEditingController();

  final systolicBpController = TextEditingController();

  // ─────────────────────────────────────────────────────────────
  // Errors
  // ─────────────────────────────────────────────────────────────

  final RxString nameError = ''.obs;

  final RxString ageError = ''.obs;

  final RxString totalCholesterolError = ''.obs;

  final RxString hdlCholesterolError = ''.obs;

  final RxString systolicBpError = ''.obs;

  // ─────────────────────────────────────────────────────────────
  // Lifestyle
  // ─────────────────────────────────────────────────────────────

  final RxBool hasDiabetes = false.obs;

  final RxBool isSmoker = false.obs;

  final RxBool hasTreatmentForHypertension = false.obs;

  // ─────────────────────────────────────────────────────────────
  // Results
  // ─────────────────────────────────────────────────────────────

  final RxDouble tenYearRisk = 0.0.obs;

  final RxDouble optimalRisk = 0.0.obs;

  final RxBool statinRecommended = false.obs;

  // ─────────────────────────────────────────────────────────────
  // Navigation
  // ─────────────────────────────────────────────────────────────

  void onContinueFromInfo() {
    Get.toNamed('/ascvd-form');
  }

  void onContinueFromForm() {
    if (!_validateAll()) return;

    _calculateRisk();

    Get.toNamed('/ascvd-result');
  }

  // ─────────────────────────────────────────────────────────────
  // Clear Errors
  // ─────────────────────────────────────────────────────────────

  void clearNameError() => nameError.value = '';

  void clearAgeError() => ageError.value = '';

  void clearTotalCholesterolError() => totalCholesterolError.value = '';

  void clearHdlError() => hdlCholesterolError.value = '';

  void clearSystolicBpError() => systolicBpError.value = '';

  // ─────────────────────────────────────────────────────────────
  // Validation
  // ─────────────────────────────────────────────────────────────

  bool _validateAll() {
    bool valid = true;

    // Name
    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Full name is required';
      valid = false;
    } else {
      nameError.value = '';
    }

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
      } else if (age < 20 || age > 79) {
        ageError.value = 'Age must be between 20 and 79';
        valid = false;
      } else {
        ageError.value = '';
      }
    }

    // Total Cholesterol
    final tcText = totalCholesterolController.text.trim();

    if (tcText.isEmpty) {
      totalCholesterolError.value = 'Total cholesterol is required';
      valid = false;
    } else {
      final tc = double.tryParse(tcText);

      if (tc == null) {
        totalCholesterolError.value = 'Enter valid value';
        valid = false;
      } else if (tc < 2 || tc > 15) {
        totalCholesterolError.value = 'Value should be between 2 and 15 mmol/L';
        valid = false;
      } else {
        totalCholesterolError.value = '';
      }
    }

    // HDL
    final hdlText = hdlCholesterolController.text.trim();

    if (hdlText.isEmpty) {
      hdlCholesterolError.value = 'HDL cholesterol is required';
      valid = false;
    } else {
      final hdl = double.tryParse(hdlText);

      if (hdl == null) {
        hdlCholesterolError.value = 'Enter valid value';
        valid = false;
      } else if (hdl < 0.5 || hdl > 6) {
        hdlCholesterolError.value = 'Value should be between 0.5 and 6 mmol/L';
        valid = false;
      } else {
        hdlCholesterolError.value = '';
      }
    }

    // Systolic BP
    final sbpText = systolicBpController.text.trim();

    if (sbpText.isEmpty) {
      systolicBpError.value = 'Systolic BP is required';
      valid = false;
    } else {
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
  // Conversion
  // ─────────────────────────────────────────────────────────────

  double _mmolToMgdl(double mmol) {
    return mmol * 38.67;
  }

  // ─────────────────────────────────────────────────────────────
  // Main PCE Formula
  // ─────────────────────────────────────────────────────────────

  double _pce({
    required double age,
    required double totalChol,
    required double hdl,
    required double sbp,
    required bool treated,
    required bool smoker,
    required bool diabetic,
    required bool isMale,
    required bool isAA,
  }) {
    final lnAge = log(age);
    final lnTc = log(totalChol);
    final lnHdl = log(hdl);
    final lnSbp = log(sbp);

    double sum = 0;

    double baselineSurvival = 0;

    double meanCoeff = 0;

    // WHITE WOMEN
    if (!isMale && !isAA) {
      sum = (-29.799 * lnAge) +
          (4.884 * pow(lnAge, 2)) +
          (13.540 * lnTc) +
          (-3.114 * lnAge * lnTc) +
          (-13.578 * lnHdl) +
          (3.149 * lnAge * lnHdl) +
          (2.019 * (treated ? lnSbp : 0.0)) +
          (1.957 * (!treated ? lnSbp : 0.0)) +
          (7.574 * (smoker ? 1.0 : 0.0)) +
          (-1.665 * lnAge * (smoker ? 1.0 : 0.0)) +
          (0.661 * (diabetic ? 1.0 : 0.0));

      baselineSurvival = 0.9665;

      meanCoeff = -29.18;
    }

    // AFRICAN AMERICAN WOMEN
    else if (!isMale && isAA) {
      sum = (17.114 * lnAge) +
          (0.940 * lnTc) +
          (-18.920 * lnHdl) +
          (4.475 * lnAge * lnHdl) +
          (29.291 * (treated ? lnSbp : 0.0)) +
          (-6.432 * lnAge * (treated ? lnSbp : 0.0)) +
          (27.820 * (!treated ? lnSbp : 0.0)) +
          (-6.087 * lnAge * (!treated ? lnSbp : 0.0)) +
          (0.691 * (smoker ? 1.0 : 0.0)) +
          (0.874 * (diabetic ? 1.0 : 0.0));

      baselineSurvival = 0.9533;

      meanCoeff = 86.61;
    }

    // WHITE MEN
    else if (isMale && !isAA) {
      sum = (12.344 * lnAge) +
          (11.853 * lnTc) +
          (-2.664 * lnAge * lnTc) +
          (-7.990 * lnHdl) +
          (1.769 * lnAge * lnHdl) +
          (1.797 * (treated ? lnSbp : 0.0)) +
          (1.764 * (!treated ? lnSbp : 0.0)) +
          (7.837 * (smoker ? 1.0 : 0.0)) +
          (-1.795 * lnAge * (smoker ? 1.0 : 0.0)) +
          (0.658 * (diabetic ? 1.0 : 0.0));

      baselineSurvival = 0.9144;

      meanCoeff = 61.18;
    }

    // AFRICAN AMERICAN MEN
    else {
      sum = (2.469 * lnAge) +
          (0.302 * lnTc) +
          (-0.307 * lnHdl) +
          (1.916 * (treated ? lnSbp : 0.0)) +
          (1.809 * (!treated ? lnSbp : 0.0)) +
          (0.549 * (smoker ? 1.0 : 0.0)) +
          (0.645 * (diabetic ? 1.0 : 0.0));

      baselineSurvival = 0.8954;

      meanCoeff = 19.54;
    }

    final risk = 1 -
        pow(
          baselineSurvival,
          exp(sum - meanCoeff),
        );

    return ((risk * 100).clamp(0.0, 100.0)).toDouble();
  }

  // ─────────────────────────────────────────────────────────────
  // Optimal Risk
  // ─────────────────────────────────────────────────────────────

  double _calculateOptimalRisk({
    required bool isMale,
    required bool isAA,
    required double age,
  }) {
    return _pce(
      age: age,
      totalChol: 170,
      hdl: 50,
      sbp: 110,
      treated: false,
      smoker: false,
      diabetic: false,
      isMale: isMale,
      isAA: isAA,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Main Calculation
  // ─────────────────────────────────────────────────────────────

  void _calculateRisk() {
    final age = double.tryParse(
          ageController.text.trim(),
        ) ??
        40;

    final totalChol = _mmolToMgdl(
      double.tryParse(
            totalCholesterolController.text.trim(),
          ) ??
          4.5,
    );

    final hdl = _mmolToMgdl(
      double.tryParse(
            hdlCholesterolController.text.trim(),
          ) ??
          1.3,
    );

    final sbp = double.tryParse(
          systolicBpController.text.trim(),
        ) ??
        120;

    final isMale = selectedGender.value == 'Male';

    final isAA = selectedRace.value == 'African American';

    final risk = _pce(
      age: age,
      totalChol: totalChol,
      hdl: hdl,
      sbp: sbp,
      treated: hasTreatmentForHypertension.value,
      smoker: isSmoker.value,
      diabetic: hasDiabetes.value,
      isMale: isMale,
      isAA: isAA,
    );

    final optimal = _calculateOptimalRisk(
      isMale: isMale,
      isAA: isAA,
      age: age,
    );

    tenYearRisk.value = double.parse(
      risk.toStringAsFixed(1),
    );

    optimalRisk.value = double.parse(
      optimal.toStringAsFixed(1),
    );

    final hasRiskFactor = hasDiabetes.value ||
        isSmoker.value ||
        hasTreatmentForHypertension.value;

    statinRecommended.value = risk >= 7.5 && hasRiskFactor;
  }

  // ─────────────────────────────────────────────────────────────
  // Risk Level
  // ─────────────────────────────────────────────────────────────

  String get riskLevel {
    if (tenYearRisk.value < 5) {
      return 'Low';
    }

    if (tenYearRisk.value < 7.5) {
      return 'Borderline';
    }

    if (tenYearRisk.value < 20) {
      return 'Intermediate';
    }

    return 'High';
  }

  // ─────────────────────────────────────────────────────────────
  // Gauge
  // ─────────────────────────────────────────────────────────────

  double get gaugeAngle {
    if (tenYearRisk.value < 5) {
      return -0.8;
    }

    if (tenYearRisk.value < 7.5) {
      return 0.0;
    }

    if (tenYearRisk.value < 20) {
      return 0.5;
    }

    return 1.0;
  }

  // ─────────────────────────────────────────────────────────────
  // Dispose
  // ─────────────────────────────────────────────────────────────

  @override
  void onClose() {
    nameController.dispose();

    ageController.dispose();

    totalCholesterolController.dispose();

    hdlCholesterolController.dispose();

    systolicBpController.dispose();

    super.onClose();
  }
}
