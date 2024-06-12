import 'package:jakel_base/constants.dart';
import 'package:jakel_base/database/user/UserLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/login/LoginApi.dart';
import 'package:jakel_base/restapi/login/model/LoginRequest.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:rxdart/rxdart.dart';

class LoginViewModel extends BaseViewModel {
  var responseSubject = PublishSubject<String>();

  Stream<String?> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  Future<String?> getPasswordForSleepValidation() async {
    var localApi = locator.get<UserLocalApi>();
    var password = await localApi.getPassword();
    return password;
  }

  void login(String userName, String pin) async {
    try {
      var localApi = locator.get<UserLocalApi>();
      var api = locator.get<LoginApi>();
      LoginRequest request = LoginRequest(username: userName, pin: pin);

      responseSubject.delay(const Duration(seconds: 2));
      var response = await api.login(request);

      MyLogUtils.logDebug(
          "login response in view model : ${response.toJson()}");

      if (response.token != null) {
        MyLogUtils.logDebug("login response response.token not null");

        await localApi.saveToken(response.token!);

        if (response.token != offlineToken) {
          await localApi.savePassword(pin);
          await localApi.saveUserName(userName);
        }

        responseSubject.sink.add("true");
      } else if (response.message != null && response.message!.isNotEmpty) {
        MyLogUtils.logDebug("login response response.message ");
        responseSubject.sink.add(response.message!);
      } else {
        MyLogUtils.logDebug("login response Login Error");
        addError(responseSubject, "Login Error");
      }
    } catch (e) {
      MyLogUtils.logDebug("Login local exception : ${e}");
      responseSubject.sink.addError(e);
    }
  }
}
