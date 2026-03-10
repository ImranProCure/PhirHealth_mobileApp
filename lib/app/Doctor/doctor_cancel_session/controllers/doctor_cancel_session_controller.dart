import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorCancelSessionController extends GetxController {
  final RxString selectedReason = ''.obs;

  final List<Map<String, dynamic>> reasons = [
    {
      'icon': Icons.local_hospital_outlined,
      'label': 'Medical / Personal emergency',
      'color': Color(0xFFEF4444)
    },
    {
      'icon': Icons.home_outlined,
      'label': 'Clinic unavailable / Unplanned leave',
      'color': Color(0xFF6B7280)
    },
    {
      'icon': Icons.calendar_today_outlined,
      'label': 'Schedule conflict',
      'color': Color(0xFF8B5CF6)
    },
    {
      'icon': Icons.laptop_outlined,
      'label': 'Technical difficulties',
      'color': Color(0xFF374151)
    },
    {
      'icon': Icons.person_outline,
      'label': 'Patient requested cancellation',
      'color': Color(0xFF6B7280)
    },
    {
      'icon': Icons.edit_outlined,
      'label': 'Other reason',
      'color': Color(0xFFF59E0B)
    },
  ];

  final List<String> impactPoints = [
    'Patient always gets a 100% refund when you cancel.',
    'You will lose the consultation earnings (₹500).',
    'More than 24 hours: Minimal rating impact.',
    '2-24 hours before: Moderate rating impact.',
    'Less than 2 hours: High rating impact & reduced visibility.',
    'Frequent cancellations may affect future patient bookings.',
  ];

  void selectReason(String reason) => selectedReason.value = reason;

  void proceedToCancel() {
    Get.dialog(
      _ConfirmCancelDialog(),
      barrierDismissible: false,
    );
  }

  void keepSession() => Get.back();

  void confirmCancel() {
    Get.back(); // close dialog
    Get.offAllNamed('/doctor-todays-session');
  }

  void goBack() => Get.back(); // close dialog
}

class _ConfirmCancelDialog extends StatelessWidget {
  final TextEditingController reasonCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<DoctorCancelSessionController>();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close icon
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: ctrl.goBack,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Title
            const Text('Are you sure you\nwant to cancel',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    height: 1.3)),
            const SizedBox(height: 16),

            // Text field
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: TextField(
                controller: reasonCtrl,
                maxLines: 3,
                style: const TextStyle(fontFamily: 'Mulish', fontSize: 13),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Please provide a reason (Optional)',
                  hintStyle: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      color: Color(0xFF9CA3AF)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Confirm Cancel button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                      colors: [Color(0xFF00897B), Color(0xFF1565C0)]),
                ),
                child: ElevatedButton(
                  onPressed: ctrl.confirmCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Confirm Cancel',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Go Back button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: ctrl.goBack,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Go Back',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
