import 'package:flutter/widgets.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/database/counter/CounterLocalApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineOpenCounterDataApi.dart';
import 'package:jakel_base/database/user/UserLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/logs/MyLogs.dart';
import 'package:jakel_base/restapi/counters/CountersApi.dart';
import 'package:jakel_base/restapi/counters/model/GetCountersResponse.dart';
import 'package:jakel_base/restapi/counters/model/GetStoresResponse.dart';
import 'package:jakel_base/restapi/counters/model/OpenCounterRequest.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_pos/modules/offline/synctoserver/OfflineSyncingViewModel.dart';
import 'package:rxdart/rxdart.dart';

import '../ui/open_counter_in_herited_widget.dart';

class CountersViewModel extends BaseViewModel {
  var responseSubject = PublishSubject<List<Counters>>();

  Stream<List<Counters>> get responseStream => responseSubject.stream;

  var boolResponseSubject = PublishSubject<String>();

  Stream<String> get boolResponseStream => boolResponseSubject.stream;

  void closeObservable() {
    responseSubject.close();
    boolResponseSubject.close();
  }

  void openCounter(int counterId, double openingBalance,
      OpenCounterModel openCounterModel) async {
    var logsApi = locator.get<MyLogs>();
    var api = locator.get<CountersApi>();

    await deletePreviousOpenedCounters();

    try {
      OpenCounterRequest request = OpenCounterRequest(
          counterId: counterId,
          openingBalance: openingBalance,
          openedByPosAt: dateTimeYmdHis24Hour());

      MyLogUtils.logDebug("openCounter request : ${request.toJson()}");

      var response = await api.openCounter(request);

      MyLogUtils.logDebug("openCounter response : $response");

      responseSubject.delay(const Duration(seconds: 2));

      if (response != "true") {
        logsApi.error(
            "Open counter: $counterId with opening balance $openingBalance Error: ",
            response);
      }

      openCounterModel.counters?.setOpenedAt(request.openedByPosAt ?? '');
      printOpenCounter("OPENING BALANCE", openCounterModel.store,
          openCounterModel.counters, openingBalance, false);
      boolResponseSubject.sink.add(response);
    } catch (e) {
      boolResponseSubject.sink.addError(e);
      logsApi.error("Open counter Error: ", e.toString());
    }
  }

  Future<void> deletePreviousOpenedCounters() async {
    MyLogUtils.logDebug("deletePreviousOpenedCounters ");
    try {
      var offlineOpenCounterDataApi = locator.get<OfflineOpenCounterDataApi>();
      var counterApi = locator.get<CountersApi>();
      await OfflineSyncingViewModel().deleteAlreadySyncedCounterRequest(
          offlineOpenCounterDataApi, counterApi);
    } catch (e) {
      MyLogUtils.logDebug("deletePreviousOpenedCounters exception :${e}");
    }
  }

  Future<List<Counters>> getCountersForCurrentStore() async {
    var localUserApi = locator.get<UserLocalApi>();
    var user = await localUserApi.getCurrentUser();

    var api = locator.get<CountersApi>();

    try {
      var response = await api.getCounters(user?.store?.id ?? 0);
      return response.counters ?? [];
    } catch (e) {
      return [];
    }
  }

  void getCounters(int storeId) async {
    var logsApi = locator.get<MyLogs>();
    var api = locator.get<CountersApi>();

    try {
      var response = await api.getCounters(storeId);
      if (response.counters != null) {
        responseSubject.sink.add(response.counters!);
      }
    } catch (e) {
      responseSubject.sink.addError(e);
      logsApi.error("Get Counters Api Error: ", e.toString());
    }
  }

  String getOpeningBalance(BuildContext context) {
    double? openingBalance =
        OpenCounterInHeritedWidget.of(context).object.openingBalance;
    if (openingBalance == null) {
      return "";
    }
    return getReadableAmount(currency, openingBalance);
  }

  String getOpeningBalanceNoCurrency(BuildContext context) {
    double? openingBalance =
        OpenCounterInHeritedWidget.of(context).object.openingBalance;
    if (openingBalance == null) {
      return "";
    }
    return getOnlyReadableAmount(openingBalance);
  }

  bool isOpeningBalancedAdded(BuildContext context) {
    double? openingBalance =
        OpenCounterInHeritedWidget.of(context).object.openingBalance;
    if (openingBalance == null) {
      return false;
    }
    return true;
  }

  bool isStoreSelected(BuildContext context, Stores store) {
    return (OpenCounterInHeritedWidget.of(context).object.store != null &&
        store.id == OpenCounterInHeritedWidget.of(context).object.store!.id);
  }

  bool isCounterSelected(BuildContext context, Counters? counters) {
    if (counters == null) {
      return false;
    }
    return (OpenCounterInHeritedWidget.of(context).object.counters != null &&
        counters.id ==
            OpenCounterInHeritedWidget.of(context).object.counters!.id);
  }

  Future<Stores?> getLastSelectedStores() async {
    var api = locator.get<CounterLocalApi>();
    var result = await api.getStore();
    MyLogUtils.logDebug("getLastSelectedStores result : ${result?.toJson()}");
    return result;
  }

  Future<Counters?> getLastSelectedCounter() async {
    var api = locator.get<CounterLocalApi>();
    var result = await api.getCounter();
    MyLogUtils.logDebug("getLastSelectedCounter  : ${result?.toJson()}");
    return result;
  }
}
