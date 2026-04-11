import 'package:sample/app/service/api/common_api/common_api.dart';

class Api {
  Api._();
  static final Api instance = Api._();

  final CommonApi commonApi = CommonApi.instance;
}

final Api api = Api.instance;
