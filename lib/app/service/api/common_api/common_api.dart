import 'package:sample/app/service/api/common_api/authentication_api/authentication_api.dart';
import 'package:sample/app/service/api/common_api/doctor_consult_api/doctor_consult_api.dart';

class CommonApi {
  CommonApi._();
  static final CommonApi instance = CommonApi._();
  final AuthenticationApi authenticationApi = AuthenticationApi();
  final DoctorConsultApi doctorConsultApi = DoctorConsultApi();

  
}
