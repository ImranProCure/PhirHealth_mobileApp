import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/routes/app_routes.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:intl/intl.dart';

enum Gender { male, female, other }

class IdentityVitalsEditController extends GetxController {
  // ---------------- TEXT INPUT ----------------

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final dobController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  // ---------------- SELECTION STATES ----------------
  final profileImageUrl = RxString('');

  final gender = Gender.male.obs;
  Api api = Api.instance;
  final RxBool isLoading = false.obs;

  final heightInInches = 69.obs;
  final weightKg = 72.5.obs;
  final bloodGroup = 'A+'.obs;
  final bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-'];

  // ---------------- PROFILE IMAGE ----------------

  final Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  // ---------------- PRE-FILL FROM API ----------------

  /// Call this after fetching the profile. Parses the response map from:
  /// response.data['message']['data']
  void loadProfile(Map<String, dynamic> data) {
    nameController.text = data['patient_name'] ?? '';
    emailController.text = data['email'] ?? '';
    mobileController.text = data['mobile'] ?? '';

    // Parse "yyyy-MM-dd" from API → display as "MM / dd / yyyy"
    final rawDob = data['dob'] as String?;
    if (rawDob != null && rawDob.isNotEmpty) {
      try {
        final parsed = DateFormat('dd-MM-yyyy').parse(rawDob);
        dobController.text = "${parsed.month.toString().padLeft(2, '0')} / "
            "${parsed.day.toString().padLeft(2, '0')} / "
            "${parsed.year}";
      } catch (_) {}
    }

    // Height & weight
    final h = data['height'];
    final w = data['weight'];
    if (h != null) heightController.text = h.toString();
    if (w != null) weightController.text = w.toString();

    // Gender
    final sex = (data['sex'] as String?)?.toLowerCase();
    if (sex == 'male') {
      gender.value = Gender.male;
    } else if (sex == 'female') {
      gender.value = Gender.female;
    } else if (sex != null) {
      gender.value = Gender.other;
    }

    // Blood group: API sends full name ("A Positive") → convert to short form
    final bg = data['blood_group'] as String?;
    if (bg != null) {
      bloodGroup.value = getBloodGroupShortName(bg);
    }

    final image = data['image'] as String?;
    if (image != null && image.isNotEmpty) {
      profileImageUrl.value = '${ApiConstants.baseUrl}$image';
    }
  }

  // ---------------- IMAGE PICKER ----------------

  Future<void> pickProfileImage(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (image != null) {
      profileImage.value = File(image.path);
      profileImageUrl.value =
          ''; // clear network url, local file takes priority
    }
  }

  void removeProfileImage() => profileImage.value = null;

  // ---------------- DATE PICKER ----------------

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0D9488),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0D9488),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      dobController.text = "${pickedDate.month.toString().padLeft(2, '0')} / "
          "${pickedDate.day.toString().padLeft(2, '0')} / "
          "${pickedDate.year}";
    }
  }

  // ---------------- DERIVED VALUES ----------------

  int get heightFeet => heightInInches.value ~/ 12;
  int get heightRemainingInches => heightInInches.value % 12;

  bool get isFormValid =>
      nameController.text.isNotEmpty &&
      dobController.text.isNotEmpty &&
      bloodGroup.value.isNotEmpty;

  // ---------------- NAVIGATION ----------------
  void goToNextStep() {
    // ---- Profile image: allow if either local file or network url exists ----
    if (profileImage.value == null && profileImageUrl.value.isEmpty) {
      showError("Please upload profile image");
      return;
    }
    if (nameController.text.trim().isEmpty) {
      showError("Please enter your name");
      return;
    }
    if (emailController.text.trim().isEmpty) {
      showError("Please enter your email");
      return;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      showError("Please enter valid email");
      return;
    }
    if (mobileController.text.trim().isEmpty) {
      showError("Please enter mobile number");
      return;
    }
    if (mobileController.text.trim().length != 10) {
      showError("Please enter valid mobile number");
      return;
    }
    if (dobController.text.trim().isEmpty) {
      showError("Please select date of birth");
      return;
    }
    if (heightController.text.trim().isEmpty) {
      showError("Please enter height");
      return;
    }
    if (weightController.text.trim().isEmpty) {
      showError("Please enter weight");
      return;
    }
    if (bloodGroup.value.isEmpty) {
      showError("Please select blood group");
      return;
    }

    // All validations passed → call API
    _basicEditApi();
  }
  // ---------------- HELPERS ----------------

  /// Converts display format "MM / dd / yyyy" → API format "yyyy-MM-dd"
  String formatDob(String dob) {
    // FIX: was "dd / MM / yyyy" — swapped month and day
    DateTime date = DateFormat("MM / dd / yyyy").parse(dob);
    return DateFormat("yyyy-MM-dd").format(date);
  }

  String getBloodGroupFullName(String group) {
    const map = {
      'A+': 'A Positive',
      'A-': 'A Negative',
      'B+': 'B Positive',
      'B-': 'B Negative',
      'O+': 'O Positive',
      'O-': 'O Negative',
    };
    return map[group] ?? group;
  }

  /// Reverse of getBloodGroupFullName — used when loading from API
  String getBloodGroupShortName(String fullName) {
    const map = {
      'A Positive': 'A+',
      'A Negative': 'A-',
      'B Positive': 'B+',
      'B Negative': 'B-',
      'O Positive': 'O+',
      'O Negative': 'O-',
    };
    return map[fullName] ?? fullName;
  }

  // ---------------- API CALL ----------------

  Future<void> fetchProfileApi() async {
    isLoading.value = true;

    ApiResponse response =
        await api.commonApi.authenticationApi.getProfileDetail();
    isLoading.value = false;

    final messageData = response.data['message'];

    if (messageData["status"] == true) {
      final data = messageData["data"] as Map<String, dynamic>;
      loadProfile(data);
    } else {
      showError(messageData["message"]);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfileApi();
  }

  Future<void> _basicEditApi() async {
    isLoading.value = true;

    final data = {
      "full_name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "mobile_no": mobileController.text.trim(),
      "date_of_birth": formatDob(dobController.text),
      "gender": gender.value.name,
      "height": heightController.text.trim(),
      "weight": weightController.text.trim(),
      "blood_group": getBloodGroupFullName(bloodGroup.value),
    };

    if (profileImage.value == null) {
      ApiResponse response = await api.commonApi.authenticationApi
          .patientEditProfile(fields: data);
      isLoading.value = false;

      final messageData = response.data['message'];

      if (messageData["status"] == true) {
        //Get.toNamed(Routes.PATIENT_MEDICAL_HISTORY);
      } else {
        showError(messageData["message"]);
      }
    } else {
      ApiResponse response = await api.commonApi.authenticationApi
          .patientEditProfile(fields: data, filePath: profileImage.value!.path);

      isLoading.value = false;

      final messageData = response.data['message'];

      if (messageData["status"] == true) {
        //Get.toNamed(Routes.PATIENT_MEDICAL_HISTORY);
      } else {
        showError(messageData["message"]);
      }
    }
  }
  // ---------------- CLEANUP ----------------

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    dobController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.onClose();
  }
}
