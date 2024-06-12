import 'package:jakel_base/restapi/login/model/LoginRequest.dart';

import 'model/LoginResponse.dart';

abstract class LoginApi {
  Future<LoginResponse> login(LoginRequest request);
}
