import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/coach_step6_controller.dart';

class CoachStep6View extends GetView<CoachStep6Controller> {
  const CoachStep6View({super.key});

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
        title: const Text('Step 6 of 6',
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
                    child: Text('Client Onboarding Setup',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.black)),
                  ),
                  const SizedBox(height: 8),
                  _buildProgressBar(6, 6),
                  const SizedBox(height: 24),

                  // Client Intake Form
                  // const Text('Client Intake Form',
                  //     style: TextStyle(
                  //         fontFamily: 'Mulish',
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w700,
                  //         color: Colors.black)),
                  // const SizedBox(height: 6),
                  // Text(
                  //   'Select questions you want to ask new clients before their first session.',
                  //   style: TextStyle(
                  //       fontFamily: 'Mulish',
                  //       fontSize: 13,
                  //       color: Colors.grey.shade500),
                  // ),
                  // const SizedBox(height: 14),

                  // // Questions list
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(14),
                  //     border: Border.all(color: Colors.grey.shade200),
                  //   ),
                  //   child: Obx(() => Column(
                  //         children: controller.intakeQuestions
                  //             .asMap()
                  //             .entries
                  //             .map((entry) {
                  //           final index = entry.key;
                  //           final question = entry.value;
                  //           final isSelected =
                  //               controller.selectedQuestions.contains(index);
                  //           final isLast =
                  //               index == controller.intakeQuestions.length - 1;
                  //           return Column(
                  //             children: [
                  //               GestureDetector(
                  //                 onTap: () => controller.toggleQuestion(index),
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.symmetric(
                  //                       horizontal: 16, vertical: 14),
                  //                   child: Row(
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment.start,
                  //                     children: [
                  //                       AnimatedContainer(
                  //                         duration:
                  //                             const Duration(milliseconds: 200),
                  //                         width: 22,
                  //                         height: 22,
                  //                         decoration: BoxDecoration(
                  //                           color: isSelected
                  //                               ? const Color(0xFF0D9488)
                  //                               : Colors.white,
                  //                           borderRadius:
                  //                               BorderRadius.circular(4),
                  //                           border: Border.all(
                  //                             color: isSelected
                  //                                 ? const Color(0xFF0D9488)
                  //                                 : Colors.grey.shade400,
                  //                             width: 1.5,
                  //                           ),
                  //                         ),
                  //                         child: isSelected
                  //                             ? const Icon(Icons.check,
                  //                                 size: 14, color: Colors.white)
                  //                             : null,
                  //                       ),
                  //                       const SizedBox(width: 12),
                  //                       Expanded(
                  //                         child: Text(
                  //                           question,
                  //                           style: const TextStyle(
                  //                               fontFamily: 'Mulish',
                  //                               fontSize: 14,
                  //                               color: Colors.black87),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //               if (!isLast)
                  //                 Divider(
                  //                     height: 1,
                  //                     color: Colors.grey.shade100,
                  //                     indent: 16,
                  //                     endIndent: 16),
                  //             ],
                  //           );
                  //         }).toList(),
                  //       )),
                  // ),
                  // const SizedBox(height: 28),

                  // Success Story
                  const Text('Success Story',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  const SizedBox(height: 6),
                  Text(
                      'Share an anonymous success story for your public profile',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          color: Colors.grey.shade500)),
                  const SizedBox(height: 12),

                  TextField(
                    controller: controller.successStoryController,
                    minLines: 5,
                    maxLines: null,
                    style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        color: Colors.black87),
                    decoration: InputDecoration(
                      hintText:
                          "Briefly describe a transformation you helped a client achieve (e.g., 'Helped a senior leader navigate career burnout to finding a new role in 3 months...')",
                      hintStyle: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF0D9488), width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildSubmitButton(onTap: controller.submitApplication),
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

  Widget _buildSubmitButton({required VoidCallback onTap}) {
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
              Text('Submit Application for Review',
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              SizedBox(width: 8),
              Icon(Icons.lock_outline, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
