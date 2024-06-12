import 'package:jakel_base/constants.dart';
import 'package:jakel_base/database/counter/CounterLocalApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineCloseCounterDataApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineOpenCounterDataApi.dart';
import 'package:jakel_base/database/user/UserLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/configurationkey/ConfigurationApi.dart';
import 'package:jakel_base/restapi/counters/model/OpenCounterRequest.dart';
import 'package:jakel_base/restapi/me/MeApi.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_pos/routing/route_names.dart';
import 'package:rxdart/rxdart.dart';

class SplashViewModel extends BaseViewModel {
  var responseSubject = PublishSubject<bool>();

  Stream<bool?> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  Future<int?> getOpenedCounter() async {
    var counterLocalApi = locator.get<CounterLocalApi>();
    var counter = await counterLocalApi.getCounter();
    if (counter != null) {
      return counter.id;
    }
    return null;
  }

  void autoLogin() async {
    MyLogUtils.logDebug("autoLogin");
    try {
      var localUserApi = locator.get<UserLocalApi>();

      var localCounterApi = locator.get<CounterLocalApi>();

      var token = await localUserApi.getToken();

      MyLogUtils.logDebug("autoLogin token : $token");

      //To Show Splash screen, added delay of 2 seconds
      responseSubject.delay(const Duration(seconds: 2));

      if (token == null) {
        responseSubject.sink.add(false);
      } else {
        var meApi = locator.get<MeApi>();
        try {
          late CurrentUserResponse response;

          // Handle Offline
          if (token == offlineToken) {
            var localResponse = await localUserApi.getCurrentUser();
            if (localResponse == null) {
              responseSubject.sink.add(false);
              return;
            }
            response = localResponse;
          } else {
            response = await meApi.currentUser();
          }

          MyLogUtils.logDebug("autoLogin response : ${response.toJson()}");
          //If response has store info, it means counter is already opened
          await localUserApi.saveCurrentUser(response);

          // If response has cashier info
          if (response.cashier != null) {
            if (response.store != null) {
              await localCounterApi.saveStore(response.store!);
            }

            //If response has counter info, it means counter is already opened
            if (response.counter != null && token != offlineToken) {
              //Save current counter in local
              await localCounterApi.saveCounter(response.counter!);
              // Save counter details to local db for offline support
              await _saveOpenCounterForOffline(response, token != offlineToken);
            }
            responseSubject.sink.add(true);
          }
        } catch (e) {
          MyLogUtils.logDebug("autoLogin  error : $e");
          responseSubject.sink.addError(e);
        }
      }
    } catch (e) {
      MyLogUtils.logDebug("autoLogin  autoLogin error : $e");
    }
  }

  Future<void> _saveOpenCounterForOffline(
      CurrentUserResponse response, bool isSyncedToCloud) async {
    var offlineOpenCounterApi = locator.get<OfflineOpenCounterDataApi>();

    var request = OpenCounterRequest(
        counterId: response.counter!.id,
        isSyncedToCloud: isSyncedToCloud,
        openingBalance: response.counter?.openingBalance,
        openedByPosAt: response.counter!.openedAt ?? '');

    await offlineOpenCounterApi.setOpenCounterRequest(request);
  }

  void downloadConfiguration() async {
    MyLogUtils.logDebug("downloadConfiguration ");
    var configApi = locator.get<ConfigurationApi>();
    var localUserApi = locator.get<UserLocalApi>();

    try {
      //To Show Splash screen, added delay of 2 seconds
      responseSubject.delay(const Duration(seconds: 2));

      var configurationKey = await localUserApi.getConfigKey();

      MyLogUtils.logDebug(
          "downloadConfiguration configurationKey : $configurationKey");

      if (configurationKey == null) {
        responseSubject.sink.add(false);
        return;
      }

      //Download Configuration API.
      var config = await configApi.getConfigurations(configurationKey);

      MyLogUtils.logDebug("downloadConfiguration config : $config");

      //If there is an error to give configured url, get from local stored.
      if (config.url == null) {
        var localConfig = await localUserApi.getConfiguration();
        if (localConfig != null && localConfig.url != null) {
          responseSubject.sink.add(true);
          return;
        } else {
          responseSubject.sink.add(false);
          return;
        }
      }
      // Updated downloaded config to local
      var result = await localUserApi.saveConfiguration(config);

      MyLogUtils.logDebug(
          "downloadConfiguration saveConfiguration result : $result");

      if (result == null) {
        responseSubject.sink.add(false);
      } else {
        responseSubject.sink.add(true);
      }
    } catch (e) {
      MyLogUtils.logDebug(
          "downloadConfiguration splashviewmodel error exception to string : ${e.toString()}");
      MyLogUtils.logDebug(
          "downloadConfiguration splashviewmodel error exception : $e");

      var localConfig = await localUserApi.getConfiguration();

      MyLogUtils.logDebug(
          "downloadConfiguration  error localConfig : ${localConfig?.toJson()}");
      if (localConfig != null && localConfig.url != null) {
        responseSubject.sink.add(true);
        return;
      } else {
        responseSubject.sink.add(false);
        return;
      }
    }
  }

  Future<String> getNextRoute() async {
    var route = HomeRoute;
    var result = await showOpenCounterScreen();

    MyLogUtils.logDebug("showOpenCounterScreen result : $result");
    if (result) {
      route = OpenCounterRoute;
    }
    var offlineOpenCounterApi = locator.get<OfflineOpenCounterDataApi>();
    var offlineCloseCounterApi = locator.get<OfflineCloseCounterDataApi>();

    var currentOpenCounter =
        await offlineOpenCounterApi.getCurrentOpenedCounter();

    if (currentOpenCounter != null && !result) {
      route = HomeRoute;
      return route;
    }

    var allOpenCounters = await offlineOpenCounterApi.getAll();

    MyLogUtils.logDebug(
        "showOpenCounterScreen allOpenCounters  $allOpenCounters");

    for (var value in allOpenCounters) {
      MyLogUtils.logDebug("showOpenCounterScreen counter  ${value.toJson()}");

      // There is no open counter available.
      // And check if any close counter is not synced to cloud yet for
      // this opened counter which is closed locally.
      var closeCounter = await offlineCloseCounterApi
          .getCounterById(value.openedByPosAt ?? '');
      MyLogUtils.logDebug(
          "showOpenCounterScreen closeCounter  ${closeCounter?.toJson()}");

      if (closeCounter != null) {
        route = LocalCountersInfoRoute;
      }

      MyLogUtils.logDebug("getNextRoute  $route");
    }

    return route;
  }
}
