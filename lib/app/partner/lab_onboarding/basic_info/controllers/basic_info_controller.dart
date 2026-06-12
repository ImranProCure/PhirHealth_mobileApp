import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sample/app/common_function.dart';
import 'package:image_picker/image_picker.dart';

class BasicInfoController extends GetxController {
  final labNameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final cityStateController = TextEditingController();
  final RxString latitude = ''.obs;
  final RxString longitude = ''.obs;
  final RxBool isFetchingLocation = false.obs;

  final List<String> interestAreas = [
    'Pathology',
    'Radiology',
    'Diagnostic Centre',
    'Others',
  ];

  final RxSet<String> selectedInterests = <String>{}.obs;
  final RxString logoPath = ''.obs;

  final ImagePicker _picker = ImagePicker();

  void toggleInterest(String area) {
    if (selectedInterests.contains(area)) {
      selectedInterests.remove(area);
    } else {
      selectedInterests.add(area);
    }
  }

  Future<void> pickLogo() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) {
      logoPath.value = file.path;
    }
  }

  void goToNext() {
    if (labNameController.text.trim().isEmpty) {
      showError('Please enter lab name');
      return;
    }
    if (contactController.text.trim().length != 10) {
      showError('Please enter valid 10-digit mobile number');
      return;
    }
    if (emailController.text.trim().isEmpty) {
      showError('Please enter email address');
      return;
    }
    if (addressController.text.trim().isEmpty) {
      showError('Please enter lab address');
      return;
    }
    if (latitude.value.isEmpty || longitude.value.isEmpty) {
      showError('Please fetch your current location');
      return;
    }
    if (cityStateController.text.trim().isEmpty) {
      showError('Please enter city & state');
      return;
    }
    Get.toNamed('/capabilities');
  }

  @override
  void onClose() {
    labNameController.dispose();
    contactController.dispose();
    emailController.dispose();
    addressController.dispose();
    cityStateController.dispose();
    super.onClose();
  }

  Future<void> fetchLocation() async {
    try {
      isFetchingLocation.value = true;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        showError('Location permission denied');
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude.toString();
      longitude.value = position.longitude.toString();
      showMessage('Location fetched successfully ✅');
    } catch (e) {
      showError(e.toString());
    } finally {
      isFetchingLocation.value = false;
    }
  }
}
