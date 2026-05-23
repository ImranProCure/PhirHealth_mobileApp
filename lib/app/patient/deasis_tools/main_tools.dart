import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HealthToolsView extends StatelessWidget {
  HealthToolsView({super.key});

  final List<Map<String, dynamic>> healthTools = [
    {
      'title': 'ASCVD\nHeart Disease',
      'icon': 'assets/Group 177.png',
      'route': '/ascvd-info',
    },
    {
      'title': 'QRISK3\nHeart Risk',
      'icon': 'assets/Group 177.png',
      'route': '/qrisk-info',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Tools'),
        centerTitle: true,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: healthTools.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final tool = healthTools[index];

            return GestureDetector(
              onTap: () {
                Get.toNamed(tool['route']);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      tool['icon'],
                      height: 70,
                      width: 70,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tool['title'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: const Color(0xFFF5F7FA),
    );
  }
}
