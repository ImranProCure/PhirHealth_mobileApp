import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/coach_step5_controller.dart';

class CoachStep5View extends GetView<CoachStep5Controller> {
  const CoachStep5View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.chevron_left, size: 28, color: Colors.black),
        ),
        title: const Text('Step 5 of 6',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text('Professional Practice',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.black)),
                  ),
                  const SizedBox(height: 8),
                  _buildProgressBar(5, 6),
                  const SizedBox(height: 24),

                  // Commercials
                  // const Text('Commercials',
                  //     style: TextStyle(
                  //         fontFamily: 'Mulish',
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w700,
                  //         color: Colors.black)),
                  // const SizedBox(height: 16),

                  // _buildLabel('Professional Fees'),
                  // const SizedBox(height: 8),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(10),
                  //     border: Border.all(color: Colors.grey.shade200),
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 12),
                  //         child: Text('₹',
                  //             style: TextStyle(
                  //                 fontFamily: 'Mulish',
                  //                 fontSize: 16,
                  //                 color: Colors.grey.shade600)),
                  //       ),
                  //       Expanded(
                  //         child: TextField(
                  //           controller: controller.feeController,
                  //           keyboardType: TextInputType.number,
                  //           style: const TextStyle(
                  //               fontFamily: 'Mulish',
                  //               fontSize: 15,
                  //               fontWeight: FontWeight.w700,
                  //               color: Colors.black87),
                  //           decoration: InputDecoration(
                  //             hintText: '1500',
                  //             hintStyle: TextStyle(
                  //                 fontFamily: 'Mulish',
                  //                 fontSize: 14,
                  //                 color: Colors.grey.shade400),
                  //             border: InputBorder.none,
                  //             contentPadding:
                  //                 const EdgeInsets.symmetric(vertical: 14),
                  //           ),
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 12),
                  //         child: Text('Per Session',
                  //             style: TextStyle(
                  //                 fontFamily: 'Mulish',
                  //                 fontSize: 13,
                  //                 color: Colors.grey.shade400)),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 20),

                  // _buildLabel('Package Inclusions'),
                  // const SizedBox(height: 8),
                  // _buildMultilineField(
                  //     controller: controller.packageController,
                  //     hint:
                  //         "What's included in your session package?\n(e.g., worksheets, follow-up notes)",
                  //     minLines: 4),
                  // const SizedBox(height: 28),

                  // const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  // const SizedBox(height: 20),

                  // Policies
                  const Text('Policies',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  const SizedBox(height: 16),

                  _buildLabel('Cancellation & Confidentiality Policy'),
                  const SizedBox(height: 8),
                  _buildMultilineField(
                      controller: controller.cancellationController,
                      hint:
                          'Outline your standard policy for cancellations and how you maintain client privacy...',
                      minLines: 4),
                  const SizedBox(height: 20),

                  _buildLabel('Support Between Sessions'),
                  const SizedBox(height: 8),
                  _buildMultilineField(
                      controller: controller.supportController,
                      hint:
                          'Describe your availability for urgent queries or check-ins between scheduled sessions...',
                      minLines: 4),
                  const SizedBox(height: 28),

                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 20),

                  // Success Measurement
                  const Text('Success Measurement',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  const SizedBox(height: 16),

                  _buildLabel('How is Progress Measured?'),
                  const SizedBox(height: 8),
                  _buildMultilineField(
                      controller: controller.progressController,
                      hint:
                          'Describe the metrics or indicators you use to track client improvement...',
                      minLines: 4),
                  const SizedBox(height: 28),

                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 20),

                  // Behavioural Check
                  // const Text('Behavioural Check',
                  //     style: TextStyle(
                  //         fontFamily: 'Mulish',
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w700,
                  //         color: Colors.black)),
                  // const SizedBox(height: 16),

                  // _buildLabel('Account Ability vs. Support'),
                  // const SizedBox(height: 8),
                  // _buildMultilineField(
                  //     controller: controller.accountabilityController,
                  //     hint:
                  //         'How do you balance holding a client accountable with providing emotional support?',
                  //     minLines: 4),
                  // const SizedBox(height: 20),

                  // _buildLabel('Handling Resistance'),
                  // const SizedBox(height: 8),
                  // _buildMultilineField(
                  //     controller: controller.resistanceController,
                  //     hint:
                  //         'Describe your approach when a client shows resistance to the coaching process...',
                  //     minLines: 4),
                  // const SizedBox(height: 20),

                  // Mentor/Supervisor toggle
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Mentor/Supervisor',
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87)),
                            const SizedBox(height: 2),
                            Text('Do you have your own mentor?',
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 12,
                                    color: Colors.grey.shade500)),
                          ],
                        ),
                        Obx(() => Switch(
                              value: controller.hasMentor.value,
                              onChanged: (v) => controller.hasMentor.value = v,
                              activeColor: Colors.white,
                              activeTrackColor: const Color(0xFF0D9488),
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.grey.shade300,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildNextButton(onTap: controller.goToNext),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int step, int total) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: step / total,
        minHeight: 5,
        backgroundColor: Colors.grey.shade300,
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(text,
      style: const TextStyle(
          fontFamily: 'Mulish',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87));

  Widget _buildMultilineField({
    required TextEditingController controller,
    required String hint,
    int minLines = 3,
  }) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: null,
      style: const TextStyle(
          fontFamily: 'Mulish', fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            fontFamily: 'Mulish', fontSize: 13, color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5)),
      ),
    );
  }

  Widget _buildNextButton({required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00897B), Color(0xFF1565C0)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Next Step',
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
