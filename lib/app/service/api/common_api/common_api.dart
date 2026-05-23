import 'package:sample/app/service/api/common_api/authentication_api/authentication_api.dart';
import 'package:sample/app/service/api/common_api/counsaller_api/counsaller_consult_api.dart';
import 'package:sample/app/service/api/common_api/doctor_consult_api/doctor_consult_api.dart';
import 'package:sample/app/service/api/common_api/doctor_visit_api/doctor_visit_api.dart';
import 'package:sample/app/service/api/common_api/payment_api/phone_pay_api.dart';

class CommonApi {
  CommonApi._();
  static final CommonApi instance = CommonApi._();
  final AuthenticationApi authenticationApi = AuthenticationApi();
  final DoctorConsultApi doctorConsultApi = DoctorConsultApi();
  final CounsallerConsultApi counsallerConsultApi = CounsallerConsultApi();
  final DoctorVisitApi doctorVisitApi = DoctorVisitApi();
  final PhonePayApi phonePayApi = PhonePayApi();
}
