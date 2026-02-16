import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/experience_controller.dart';

class ExperienceView extends GetView<ExperienceController> {
  const ExperienceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Step 2 of 4",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              const Center(
                child: Text(
                  "Experience & Expertise",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const LinearProgressIndicator(
                  value: 2 / 4,
                  minHeight: 6,
                  backgroundColor: Color(0xFFE5E7EB),
                  valueColor: AlwaysStoppedAnimation(Color(0xFF0D9488)),
                ),
              ),

              const SizedBox(height: 32),

              /// ================= EXPERIENCE =================
              const Text(
                "Experience Section",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              const Text("Total Experience"),

              const SizedBox(height: 12),

              Obx(() => Column(
                    children: [
                      Slider(
                        value: controller.totalExperience.value,
                        min: 0,
                        max: 40,
                        divisions: 40,
                        activeColor: const Color(0xFF0D9488),
                        onChanged: (value) {
                          controller.totalExperience.value = value;
                        },
                      ),
                      Text(
                        "${controller.totalExperience.value.toInt()} Years",
                        style: const TextStyle(
                          color: Color(0xFF0D9488),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )),

              const SizedBox(height: 24),

              /// ================= PRIMARY SPECIALTY =================
              const Text(
                "Primary Specialty",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 10),

              _inputField(
                controller.specialtyController,
                "General Physician",
              ),

              const SizedBox(height: 30),

              const Divider(),

              const SizedBox(height: 24),

              /// ================= PRACTICE DETAILS =================
              const Text(
                "Practice Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              const Text("Current Practice Place"),

              const SizedBox(height: 12),

              Obx(() => Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _pill("Hospital", controller.selectedPracticePlaces),
                      _pill(
                          "Private Clinic", controller.selectedPracticePlaces),
                      _pill("Telemedicine", controller.selectedPracticePlaces),
                    ],
                  )),

              const SizedBox(height: 24),

              const Text("Care Experience"),

              const SizedBox(height: 12),

              Obx(() => Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _pill("OPD", controller.selectedCareExperience),
                      _pill("IPD", controller.selectedCareExperience),
                      _pill("Emergency", controller.selectedCareExperience),
                    ],
                  )),

              const SizedBox(height: 24),

              const Text("Gynecological History"),

              const SizedBox(height: 10),

              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TextField(
                  controller: controller.historyController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Briefly describe your experience...",
                  ),
                ),
              ),

              const SizedBox(height: 40),

              _buildNextButton(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController controller, String hint) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }

  Widget _pill(String text, RxList list) {
    final isSelected = list.contains(text);

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          list.remove(text);
        } else {
          list.add(text);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE6F5F3) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF0D9488) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF00786F),
              Color(0xFF009689),
              Color(0xFF1447E6),
            ],
          ),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: controller.goToNextStep,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Next Step",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
