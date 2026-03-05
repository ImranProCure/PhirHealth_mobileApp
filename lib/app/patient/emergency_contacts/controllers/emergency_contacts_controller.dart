import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactsController extends GetxController {
  final List<Map<String, dynamic>> contacts = [
    {
      'name': 'Kamlesh Singh',
      'relation': 'Son',
      'phone': '98765 32140',
      'iconBg': 0xFFEFF6FF,
      'iconColor': 0xFF3B82F6,
      'icon': Icons.group_outlined,
    },
    {
      'name': 'Dr. Smith',
      'relation': 'Cardiologist',
      'phone': '98765 32140',
      'iconBg': 0xFFF5F3FF,
      'iconColor': 0xFF8B5CF6,
      'icon': Icons.medical_services_outlined,
    },
    {
      'name': 'Kamlesh Singh',
      'relation': 'Spouse',
      'phone': '98765 32140',
      'iconBg': 0xFFFFF7ED,
      'iconColor': 0xFFF97316,
      'icon': Icons.face_outlined,
    },
  ];

  void callAmbulance() async {
    final Uri uri = Uri(scheme: 'tel', path: '108');
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  void callContact(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone.replaceAll(' ', ''));
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  void addNewContact() {}
}
