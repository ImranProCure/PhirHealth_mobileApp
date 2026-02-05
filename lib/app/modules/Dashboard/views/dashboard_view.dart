import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      bottomNavigationBar: const _BottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _Header(),
              SizedBox(height: 16),
              _DoctorActionsSection(),
              SizedBox(height: 24),
              _InsuranceSection(),
              SizedBox(height: 24),
              _AiMedicineFitnessSection(),
              SizedBox(height: 24),
              _PromoBanner(),
              SizedBox(height: 24),
              _SmartHealthToolsSection(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= HEADER =================
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              _ProfileAvatar(),
              SizedBox(width: 12),
              _GreetingText(),
            ],
          ),
          const _HeaderActions(),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 24,
      backgroundImage: AssetImage('assets/profile.png'),
    );
  }
}

class _GreetingText extends StatelessWidget {
  const _GreetingText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Hey, John',
      style: TextStyle(
        fontFamily: 'Mulish',
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _HeaderActions extends StatelessWidget {
  const _HeaderActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.search, size: 24),
        SizedBox(width: 12),
        Icon(Icons.notifications_none, size: 24),
      ],
    );
  }
}

// ================= DOCTOR & QUICK ACTIONS =================
class _DoctorActionsSection extends StatelessWidget {
  const _DoctorActionsSection();

  static const List<Map<String, String>> _actions = [
    {'icon': 'assets/icons/stethoscope.png', 'label': 'Doctor\nConsult'},
    {
      'icon': 'assets/icons/ar_on_you.png',
      'label': 'Face Scan /\nHealth Vitals'
    },
    {'icon': 'assets/icons/health_cross.png', 'label': 'Network\nLocator'},
    {
      'icon': 'assets/icons/published_with_changes.png',
      'label': 'Policy\nRenew'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Doctor & Quick Actions'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _actions
                .map((action) => _DoctorActionItem(
                      imagePath: action['icon']!,
                      label: action['label']!,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _DoctorActionItem extends StatelessWidget {
  final String imagePath;
  final String label;

  const _DoctorActionItem({
    required this.imagePath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF0D9488), Color(0xFF2563EB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Image.asset(
              imagePath,
              width: 30,
              height: 30,
              color: Colors.white,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.local_hospital,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 75,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

// ================= INSURANCE & PROTECTION =================
class _InsuranceSection extends StatelessWidget {
  const _InsuranceSection();

  static const List<Map<String, String>> _insuranceItems = [
    {
      'icon': 'assets/icons/health_and_safety.png',
      'label': 'Health\nInsurance'
    },
    {'icon': 'assets/icons/diversity_1.png', 'label': 'Family\nHealth'},
    {'icon': 'assets/icons/flight_takeoff.png', 'label': 'Travel\nInsurance'},
    {'icon': 'assets/icons/add_moderator.png', 'label': 'Super\nTop-up'},
    {'icon': 'assets/icons/cast_for_education.png', 'label': 'Student\nTravel'},
    {'icon': 'assets/icons/workspace_premium.png', 'label': 'Ultimate\nCare'},
    {'icon': 'assets/icons/assist_walker.png', 'label': 'Senior\nCitizen'},
    {'icon': 'assets/icons/arrow_circle_right.png', 'label': 'View\nAll'},
  ];

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Insurance & Protection'),
          const SizedBox(height: 20),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _insuranceItems.length,
            itemBuilder: (context, index) {
              final item = _insuranceItems[index];
              return _InsuranceItem(
                imagePath: item['icon']!,
                label: item['label']!,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InsuranceItem extends StatelessWidget {
  final String imagePath;
  final String label;

  const _InsuranceItem({
    required this.imagePath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: 32,
          height: 32,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.shield,
            size: 32,
            color: Color(0xFF0D9488),
          ),
        ),
        const SizedBox(height: 8),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ================= AI + MEDICINE + FITNESS =================
class _AiMedicineFitnessSection extends StatelessWidget {
  const _AiMedicineFitnessSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Expanded(child: _CancerAiCard()),
          SizedBox(width: 12),
          Expanded(child: _MedicineFitnessCards()),
        ],
      ),
    );
  }
}

class _CancerAiCard extends StatelessWidget {
  const _CancerAiCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Cancer Risk AI Scan',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Early detection saves lives.\nCheck your risk now.',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/icons/cancer-cell 1.png',
              width: 80,
              height: 80,
              errorBuilder: (_, __, ___) => const SizedBox(
                width: 80,
                height: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicineFitnessCards extends StatelessWidget {
  const _MedicineFitnessCards();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _SmallInfoCard(
          title: 'Medicines &\nLab Discounts',
          imagePath: 'assets/icons/best-offer 1.png',
        ),
        SizedBox(height: 10),
        _SmallInfoCard(
          title: 'Track Steps\n& Fitness',
          imagePath: 'assets/icons/footprint 1.png',
        ),
      ],
    );
  }
}

class _SmallInfoCard extends StatelessWidget {
  final String title;
  final String imagePath;

  const _SmallInfoCard({
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ),
          Image.asset(
            imagePath,
            width: 40,
            height: 40,
            errorBuilder: (_, __, ___) => const SizedBox(
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}

// ================= PROMO BANNER =================
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/Gemini_Generated_Image_rb2batrb2batrb2b.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFFE5E7EB),
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 50,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= SMART HEALTH TOOLS =================
class _SmartHealthToolsSection extends StatelessWidget {
  const _SmartHealthToolsSection();

  static const List<Map<String, dynamic>> _tools = [
    {
      'title': 'Check\nYour BMI',
      'icon': 'assets/icons/bmi 1.png',
      'color': Color(0xFFE6F5F3),
    },
    {
      'title': 'Diet &\nNutrition',
      'icon': 'assets/icons/salad 1.png',
      'color': Color(0xFFFFECEC),
    },
    {
      'title': 'Medicine\nReminder',
      'icon': 'assets/icons/time 1.png',
      'color': Color(0xFFFFF6E5),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Smart Health Tools'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _tools
                .map((tool) => _SmartToolCard(
                      title: tool['title'] as String,
                      imagePath: tool['icon'] as String,
                      bgColor: tool['color'] as Color,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SmartToolCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color bgColor;

  const _SmartToolCard({
    required this.title,
    required this.imagePath,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 103,
      height: 146,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Image.asset(
              imagePath,
              height: 70,
              width: 70,
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 70,
                width: 70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= REUSABLE COMPONENTS =================
class _WhiteCard extends StatelessWidget {
  final Widget child;

  const _WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Mulish',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1F2937),
      ),
    );
  }
}

// ================= BOTTOM NAVIGATION =================
class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D9488), Color(0xFF2563EB)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D9488).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavItem(icon: Icons.home, label: 'Home', isActive: true),
          _NavItem(icon: Icons.medical_services_outlined, label: 'Doctor'),
          _NavItem(icon: Icons.receipt_long_outlined, label: 'Policy'),
          _NavItem(icon: Icons.menu, label: 'Menu'),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: isActive ? 26 : 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
