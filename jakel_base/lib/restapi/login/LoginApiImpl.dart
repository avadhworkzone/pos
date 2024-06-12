import 'package:dio/dio.dart';
import 'package:jakel_base/database/user/UserLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/login/LoginApi.dart';
import 'package:jakel_base/restapi/login/model/LoginRequest.dart';
import 'package:jakel_base/restapi/login/model/LoginResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import '../../utils/my_network_helper.dart';

class LoginApiImpl extends BaseApi with LoginApi {
  @override
  Future<LoginResponse> login(LoginRequest request) async {
    var userLocalApi = locator.get<UserLocalApi>();

    if (!await checkIsInternetConnected()) {
      // Handle offline login
      return await handleOfflineLogin(userLocalApi, request);
    }

    var masterUrl = await getMasterUrl();
    MyLogUtils.logDebug("login masterUrl: $masterUrl");

    var dio = await getDioInstance();
    final url = masterUrl + loginUrl;

    try {
      MyLogUtils.logDebug("login url: $url");

      FormData formData = FormData.fromMap({
        "username": request.username,
        "pin": request.pin,
        "device_type": 'mobile',
      });
      Response response = await dio.post(url, data: formData);

      MyLogUtils.logDebug("login response : ${response.data}");
      MyLogUtils.logDebug(
          "login response statusMessage : ${response.statusMessage}");
      MyLogUtils.logDebug("login response statusCode : ${response.statusCode}");

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      }

      if (response.statusCode == 412) {
        try {
          logError(url, response.statusCode, response.data);
        } catch (e) {}

        return LoginResponse.fromJson(response.data);
      }

      //Log Error
      logError(url, response.statusCode, response.statusMessage);

      // Handle offline login
      return await handleOfflineLogin(userLocalApi, request);
    } on DioError catch (ex) {
      //Log Error
      logError(url, -1, "Dio Error, Type:${ex.type}, Message:${ex.message}");
      // Handle offline login
      return await handleOfflineLogin(userLocalApi, request);
    }
  }

  Future<LoginResponse> handleOfflineLogin(
      UserLocalApi userLocalApi, LoginRequest request) async {
    var userName = await userLocalApi.getUserName();
    var pin = await userLocalApi.getPassword();

    MyLogUtils.logDebug(
        "Handle offline login userName : $userName & password : $pin");

    if (request.username == userName && request.pin == pin) {
      var cashier = await userLocalApi.getCurrentUser();
      var loginResponse = LoginResponse(
          message: "",
          cashier: Cashier.fromJson(cashier?.cashier?.toJson()),
          token: "OFFLINE_TOKEN");
      return loginResponse;
    } else {
      var loginResponse =
          LoginResponse(message: "Invalid user name or password");
      return loginResponse;
    }
  }
}
