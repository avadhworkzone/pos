import 'package:jakel_base/database/user/UserLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/configurationkey/ConfigurationApi.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:rxdart/rxdart.dart';

class ConfigurationViewModel extends BaseViewModel {
  var responseSubject = PublishSubject<bool>();

  Stream<bool?> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void downloadConfiguration(String key) async {
    MyLogUtils.logDebug("downloadConfiguration in view model");
    try {
      var localApi = locator.get<UserLocalApi>();
      var api = locator.get<ConfigurationApi>();
      MyLogUtils.logDebug("downloadConfiguration api created ");
      var response = await api.getConfigurations(key);
      MyLogUtils.logDebug(
          "downloadConfiguration api response : ${response.toJson()} ");

      if (response.url != null) {
        await localApi.deleteConfiguration();
        await localApi.saveConfigKey(key);
        await localApi.saveConfiguration(response);
        responseSubject.sink.add(true);
      } else {
        addError(responseSubject, "downloadConfiguration Error");
      }
    } catch (e) {
      MyLogUtils.logDebug(
          "downloadConfiguration from config screen exception to string -> ${e.toString()}");

      MyLogUtils.logDebug(
          "downloadConfiguration from config screen exception -> ${e}");
      responseSubject.sink.addError(e);
    }
  }
}
