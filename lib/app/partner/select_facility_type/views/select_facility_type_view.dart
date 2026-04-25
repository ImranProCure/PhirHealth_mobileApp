import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/select_facility_type_controller.dart';

class SelectFacilityTypeView extends GetView<SelectFacilityTypeController> {
  const SelectFacilityTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Get.back(),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, color: Colors.black, size: 22),
                    SizedBox(width: 6),
                    Text(
                      'Back',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Select Facility Type',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Choose your healthcare business\ncategory to continue.',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 15,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: controller.facilities.length,
                  itemBuilder: (context, index) {
                    final f = controller.facilities[index];

                    return GestureDetector(
                      onTap: () => controller.onFacilityTap(f['route']),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              f['iconPath'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              f['title'],
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              f['subtitle'] ?? '',
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
