import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // Header Section
              const SizedBox(
                height: 40,
                child: Text(
                  "Select Your Role",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'Mulish',
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const SizedBox(
                height: 23,
                child: Text(
                  "Choose how you want to continue",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B7280),
                    fontFamily: 'Mulish',
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Role Cards List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.roleItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.roleItems[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom:
                            index == controller.roleItems.length - 1 ? 0 : 10,
                      ),
                      child: _buildRoleCard(
                        icon: item['icon'],
                        title: item['title'],
                        subtitle: item['subtitle'],
                        onTap: () => controller.onRoleSelected(item['role']),
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

  Widget _buildRoleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 370,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              bottom: 20,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon Container
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF0D9488), size: 28),
                ),

                const SizedBox(width: 5),

                // Text Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 11),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D9488),
                            fontFamily: 'Mulish',
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF6B7280),
                            fontFamily: 'Mulish',
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),

                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 21,
                  color: const Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
