import 'package:sample/app/service/api/api_client/common_constants.dart';

class ApiConstants {
  ApiConstants._();

  static const String baseUrl = "https://devcal.phirhealth.com";

  // ✅ Yeh add karo
  static String imageUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '$baseUrl$path';
  }

  static const CommonApiConstants commonApiConstants = CommonApiConstants();
}
