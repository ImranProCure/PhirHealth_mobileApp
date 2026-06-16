// scan_report_pdf_service.dart
import 'dart:typed_data';
import 'package:flutter/material.dart' show Colors, EdgeInsets;
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Generates a branded PHIR Health wellness scan report PDF.
class ScanReportPdfService {
  ScanReportPdfService._();

  // ── Brand palette ────────────────────────────────────────────────────────────
  static const _brandDeepBlue  = PdfColor(0.10, 0.28, 0.55);
  static const _brandTeal      = PdfColor(0.00, 0.54, 0.48);
  static const _brandOrange    = PdfColor(0.91, 0.63, 0.13);
  static const _brandGreen     = PdfColor(0.30, 0.69, 0.31);
  static const _brandRed       = PdfColor(0.90, 0.22, 0.21);

  static const _lightGrey      = PdfColor(0.97, 0.97, 0.97);
  static const _borderGrey     = PdfColor(0.88, 0.88, 0.88);
  static const _bgBlue         = PdfColor(0.93, 0.96, 1.00);   // solid, no alpha
  static const _textDark       = PdfColor(0.10, 0.10, 0.10);
  static const _textMid        = PdfColor(0.38, 0.38, 0.38);
  static const _textLight      = PdfColor(0.62, 0.62, 0.62);
  static const _headerText     = PdfColor(0.80, 0.90, 1.00);   // light blue on dark

  static const _cardBgHeart    = PdfColor(1.00, 0.95, 0.95);
  static const _cardBgResp     = PdfColor(0.88, 0.97, 0.96);
  static const _cardBgStress   = PdfColor(0.97, 0.95, 1.00);
  static const _cardBgWellness = PdfColor(0.93, 0.97, 1.00);

  // ── Public entry point ────────────────────────────────────────────────────────

  static Future<void> downloadReport({
    required String time,
    required String status,
    required int? heartRate,
    required int? respiration,
    required int? stress,
    required int wellnessScore,
    required String aiInsight,
    required String comparisonText,
    required bool scanSuccess,
    required String userName,
  }) async {
    try {
      pw.MemoryImage? logoImage;
      for (final assetPath in [
        'assets/icons/phir_health_app_icon.png',
        'assets/images/phir_health_app_icon.png',
        'assets/phir_health_app_icon.png',
      ]) {
        try {
          final bytes = await rootBundle.load(assetPath);
          logoImage = pw.MemoryImage(bytes.buffer.asUint8List());
          break;
        } catch (_) {}
      }

      final pdfBytes = await _buildPdf(
        time: time,
        status: status,
        heartRate: heartRate,
        respiration: respiration,
        stress: stress,
        wellnessScore: wellnessScore,
        aiInsight: aiInsight,
        comparisonText: comparisonText,
        scanSuccess: scanSuccess,
        userName: userName,
        logoImage: logoImage,
      );

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'phir_health_scan_report.pdf',
      );
    } catch (e) {
      Get.snackbar(
        'Download Failed',
        'Could not generate the report. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // ── PDF builder ───────────────────────────────────────────────────────────────

  static Future<Uint8List> _buildPdf({
    required String time,
    required String status,
    required int? heartRate,
    required int? respiration,
    required int? stress,
    required int wellnessScore,
    required String aiInsight,
    required String comparisonText,
    required bool scanSuccess,
    required String userName,
    required pw.MemoryImage? logoImage,
  }) async {
    final doc = pw.Document(
      title: 'PHIR Health Wellness Scan Report',
      author: 'PHIR Health',
    );

    // A4 usable width = 595 - (36*2) margins = 523pt
    const trackWidth = 523.0;

    final vitals = <_VitalData>[
      _VitalData(
        label: 'Heart Rate',
        value: heartRate != null ? '$heartRate' : '--',
        unit: 'bpm',
        accent: _heartRateColor(heartRate),
        statusLabel: _heartRateStatus(heartRate),
        cardBg: _cardBgHeart,
        iconLabel: 'HR',
      ),
      _VitalData(
        label: 'Respiration',
        value: respiration != null ? '$respiration' : '--',
        unit: 'br/min',
        accent: _respirationColor(respiration),
        statusLabel: _respirationStatus(respiration),
        cardBg: _cardBgResp,
        iconLabel: 'BR',
      ),
      _VitalData(
        label: 'Stress Level',
        value: stress != null ? '$stress' : '--',
        unit: '',
        accent: _stressColor(stress),
        statusLabel: _stressStatus(stress),
        cardBg: _cardBgStress,
        iconLabel: 'ST',
      ),
      _VitalData(
        label: 'Wellness Score',
        value: '$wellnessScore',
        unit: '/ 100',
        accent: _wellnessColor(wellnessScore, scanSuccess),
        statusLabel: _wellnessStatus(wellnessScore, scanSuccess),
        cardBg: _cardBgWellness,
        iconLabel: 'WS',
      ),
    ];

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 32),
        build: (pw.Context ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [

            // ── HEADER ──────────────────────────────────────────────────────────
            _buildHeader(
              logoImage: logoImage,
              time: time,
              status: status,
              userName: userName,
              scanSuccess: scanSuccess,
            ),

            pw.SizedBox(height: 20),

            // ── VITAL MEASUREMENTS ───────────────────────────────────────────────
            _sectionLabel('Vital Measurements'),
            pw.SizedBox(height: 10),

            pw.Row(children: [
              pw.Expanded(child: _vitalCard(vitals[0])),
              pw.SizedBox(width: 10),
              pw.Expanded(child: _vitalCard(vitals[1])),
            ]),
            pw.SizedBox(height: 10),
            pw.Row(children: [
              pw.Expanded(child: _vitalCard(vitals[2])),
              pw.SizedBox(width: 10),
              pw.Expanded(child: _vitalCard(vitals[3])),
            ]),

            pw.SizedBox(height: 18),

            // ── WELLNESS PROGRESS BAR ────────────────────────────────────────────
            if (scanSuccess) ...[
              _buildScoreBar(wellnessScore, trackWidth),
              pw.SizedBox(height: 18),
            ],

            // ── COMPARISON BANNER ────────────────────────────────────────────────
            _buildComparisonBanner(comparisonText),

            pw.SizedBox(height: 18),

            // ── AI INSIGHT ───────────────────────────────────────────────────────
            _sectionLabel('AI Insight'),
            pw.SizedBox(height: 8),
            _buildInsightBox(aiInsight),

            pw.Spacer(),

            // ── FOOTER ───────────────────────────────────────────────────────────
            _buildFooter(),
          ],
        ),
      ),
    );

    return doc.save();
  }

  // ── Header ────────────────────────────────────────────────────────────────────
  // Layout: [Logo] | [Title + status] | spacer | [Time + Patient box]
  // Uses a simple Row so nothing gets clipped.

  static pw.Widget _buildHeader({
    required pw.MemoryImage? logoImage,
    required String time,
    required String status,
    required String userName,
    required bool scanSuccess,
  }) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          colors: [_brandDeepBlue, _brandTeal],
          begin: pw.Alignment.centerLeft,
          end: pw.Alignment.centerRight,
        ),
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [

          // ── Logo ──────────────────────────────────────────────────────────────
          pw.Container(
            width: 52,
            height: 52,
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(10),
            ),
            padding: const pw.EdgeInsets.all(3),
            child: logoImage != null
                ? pw.Image(logoImage, fit: pw.BoxFit.contain)
                : pw.Center(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        text: 'PH',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: _brandDeepBlue,
                        ),
                      ),
                    ),
                  ),
          ),

          pw.SizedBox(width: 14),

          // ── Title + status ────────────────────────────────────────────────────
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.RichText(
                  text: pw.TextSpan(
                    text: 'PHIR HEALTH',
                    style: pw.TextStyle(
                      fontSize: 8,
                      color: _headerText,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
                pw.SizedBox(height: 3),
                pw.RichText(
                  text: pw.TextSpan(
                    text: 'Wellness Scan Report',
                    style: pw.TextStyle(
                      fontSize: 17,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                ),
                pw.SizedBox(height: 6),
                // Status pill — solid bg, no alpha
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: pw.BoxDecoration(
                    color: scanSuccess
                        ? PdfColor(0.20, 0.50, 0.22)   // dark green
                        : PdfColor(0.65, 0.16, 0.16),  // dark red
                    borderRadius: pw.BorderRadius.circular(20),
                  ),
                  child: pw.RichText(
                    text: pw.TextSpan(
                      text: status,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(width: 12),

          // ── Time + Patient ─────────────────────────────────────────────────────
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.RichText(
                text: pw.TextSpan(
                  text: time,
                  style: pw.TextStyle(fontSize: 9, color: _headerText),
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: pw.BoxDecoration(
                  color: PdfColor(0.0, 0.0, 0.0, 0.20), // semi-dark overlay
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(
                    color: PdfColor(1, 1, 1, 0.30),
                    width: 0.5,
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.RichText(
                      text: pw.TextSpan(
                        text: 'PATIENT',
                        style: pw.TextStyle(
                          fontSize: 7,
                          color: _headerText,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.RichText(
                      text: pw.TextSpan(
                        text: userName,
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Section label (no icon — avoids glyph rendering issues) ──────────────────

  static pw.Widget _sectionLabel(String title) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        // Solid coloured square accent
        pw.Container(
          width: 4,
          height: 16,
          decoration: pw.BoxDecoration(
            color: _brandDeepBlue,
            borderRadius: pw.BorderRadius.circular(2),
          ),
        ),
        pw.SizedBox(width: 8),
        pw.RichText(
          text: pw.TextSpan(
            text: title,
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
              color: _textDark,
            ),
          ),
        ),
      ],
    );
  }

  // ── Vital card ────────────────────────────────────────────────────────────────

  static pw.Widget _vitalCard(_VitalData v) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: v.cardBg,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: v.accent, width: 0.7),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          // Icon circle — 2-letter abbreviation, always renders
          pw.Container(
            width: 34,
            height: 34,
            decoration: pw.BoxDecoration(
              color: v.accent,
              shape: pw.BoxShape.circle,
            ),
            child: pw.Center(
              child: pw.RichText(
                text: pw.TextSpan(
                  text: v.iconLabel,
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ),
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.RichText(
                text: pw.TextSpan(
                  text: v.label,
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: _textMid,
                  ),
                ),
              ),
              pw.SizedBox(height: 2),
              pw.RichText(
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text: v.value,
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                    if (v.unit.isNotEmpty)
                      pw.TextSpan(
                        text: ' ${v.unit}',
                        style: pw.TextStyle(fontSize: 9, color: _textMid),
                      ),
                  ],
                ),
              ),
              if (v.statusLabel.isNotEmpty) ...[
                pw.SizedBox(height: 3),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: pw.BoxDecoration(
                    color: v.accent,
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.RichText(
                    text: pw.TextSpan(
                      text: v.statusLabel,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ── Wellness progress bar ─────────────────────────────────────────────────────

  static pw.Widget _buildScoreBar(int score, double trackWidth) {
    final fraction = (score / 100).clamp(0.0, 1.0);
    final fillWidth = trackWidth * fraction;
    final color = score >= 80
        ? _brandGreen
        : score >= 60
            ? _brandOrange
            : _brandRed;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.RichText(
              text: pw.TextSpan(
                text: 'Overall Wellness',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: _textDark,
                ),
              ),
            ),
            pw.RichText(
              text: pw.TextSpan(
                text: '$score / 100',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 6),
        // Track
        pw.Container(
          width: trackWidth,
          height: 10,
          decoration: pw.BoxDecoration(
            color: _borderGrey,
            borderRadius: pw.BorderRadius.circular(5),
          ),
          child: pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Container(
              width: fillWidth,
              height: 10,
              decoration: pw.BoxDecoration(
                gradient: pw.LinearGradient(
                  colors: [_brandDeepBlue, color],
                ),
                borderRadius: pw.BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Comparison banner — solid bg, no alpha ────────────────────────────────────

  static pw.Widget _buildComparisonBanner(String text) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: pw.BoxDecoration(
        color: _bgBlue,                                      // solid, always visible
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: _brandDeepBlue, width: 0.6),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          // Info badge — solid bg
          pw.Container(
            width: 18,
            height: 18,
            decoration: pw.BoxDecoration(
              color: _brandDeepBlue,
              shape: pw.BoxShape.circle,
            ),
            child: pw.Center(
              child: pw.RichText(
                text: pw.TextSpan(
                  text: 'i',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ),
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Expanded(
            child: pw.RichText(
              text: pw.TextSpan(
                text: text,
                style: pw.TextStyle(
                  fontSize: 10,
                  color: _brandDeepBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── AI Insight box ────────────────────────────────────────────────────────────

  static pw.Widget _buildInsightBox(String text) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: _lightGrey,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: _borderGrey, width: 0.8),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Left accent bar — gradient
          pw.Container(
            width: 3,
            height: 60,
            decoration: pw.BoxDecoration(
              gradient: pw.LinearGradient(
                colors: [_brandDeepBlue, _brandTeal],
                begin: pw.Alignment.topCenter,
                end: pw.Alignment.bottomCenter,
              ),
              borderRadius: pw.BorderRadius.circular(2),
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Expanded(
            child: pw.RichText(
              text: pw.TextSpan(
                text: text,
                style: pw.TextStyle(
                  fontSize: 10,
                  color: _textMid,
                  lineSpacing: 5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Footer ────────────────────────────────────────────────────────────────────

  static pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        // 3-colour gradient rule
        pw.Container(
          height: 2,
          decoration: pw.BoxDecoration(
            gradient: pw.LinearGradient(
              colors: [_brandDeepBlue, _brandTeal, _brandOrange],
            ),
            borderRadius: pw.BorderRadius.circular(1),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: 'PHIR ',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: _brandDeepBlue,
                    ),
                  ),
                  pw.TextSpan(
                    text: 'Health — Wellness Scan Report',
                    style: pw.TextStyle(fontSize: 9, color: _textLight),
                  ),
                ],
              ),
            ),
            pw.RichText(
              text: pw.TextSpan(
                text: 'For informational purposes only. Not a medical diagnosis.',
                style: pw.TextStyle(fontSize: 8, color: _textLight),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Colour / status helpers ───────────────────────────────────────────────────

  static PdfColor _heartRateColor(int? hr) {
    if (hr == null) return _textLight;
    if (hr < 60 || hr > 100) return _brandRed;
    return _brandGreen;
  }

  static String _heartRateStatus(int? hr) {
    if (hr == null) return '';
    if (hr < 60) return 'Low';
    if (hr <= 100) return 'Normal';
    return 'Elevated';
  }

  static PdfColor _respirationColor(int? r) {
    if (r == null) return _textLight;
    if (r < 12 || r > 20) return _brandOrange;
    return _brandTeal;
  }

  static String _respirationStatus(int? r) {
    if (r == null) return '';
    if (r < 12) return 'Low';
    if (r <= 20) return 'Normal';
    return 'Elevated';
  }

  static PdfColor _stressColor(int? s) {
    if (s == null) return _textLight;
    if (s <= 30) return _brandGreen;
    if (s <= 60) return _brandOrange;
    return _brandRed;
  }

  static String _stressStatus(int? s) {
    if (s == null) return '';
    if (s <= 30) return 'Low';
    if (s <= 60) return 'Moderate';
    return 'High';
  }

  static PdfColor _wellnessColor(int score, bool success) {
    if (!success || score == 0) return _textLight;
    if (score >= 80) return _brandGreen;
    if (score >= 60) return _brandOrange;
    return _brandRed;
  }

  static String _wellnessStatus(int score, bool success) {
    if (!success || score == 0) return '';
    if (score >= 80) return 'Great';
    if (score >= 60) return 'Fair';
    return 'Needs attention';
  }
}

// ── Model ─────────────────────────────────────────────────────────────────────

class _VitalData {
  const _VitalData({
    required this.label,
    required this.value,
    required this.unit,
    required this.accent,
    required this.statusLabel,
    required this.cardBg,
    required this.iconLabel,
  });

  final String label;
  final String value;
  final String unit;
  final PdfColor accent;
  final String statusLabel;
  final PdfColor cardBg;
  final String iconLabel;   // 2-letter abbrev always renders: HR, BR, ST, WS
}