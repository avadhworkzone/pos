import 'package:jakel_base/database/offlinedata/OfflineCashMovementDataApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineCloseCounterDataApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineOpenCounterDataApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineSalesDataApi.dart';
import 'package:jakel_base/database/offlinedata/cashmovement/CashMovementRequest.dart';
import 'package:jakel_base/database/sale/OfflineSaleApi.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/counters/model/CloseCounterRequest.dart';
import 'package:jakel_base/restapi/counters/model/OpenCounterRequest.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';

class LocalCountersViewModel extends BaseViewModel {
  Future<List<OpenCounterRequest>> getLocalCounters() async {
    var offlineOpenCounterApi = locator.get<OfflineOpenCounterDataApi>();
    return offlineOpenCounterApi.getAll();
  }

  Future<CloseCounterRequest?> getClosedCounter(String getOpenedAt) async {
    try {
      MyLogUtils.logDebug("getClosedCounter for getOpenedAt :$getOpenedAt");
      var api = locator.get<OfflineCloseCounterDataApi>();
      var requestData = await api.getCounterById(getOpenedAt);
      MyLogUtils.logDebug(
          "getClosedCounter requestData :${requestData?.toJson()}");
      if (requestData == null) {
        return CloseCounterRequest();
      }
      return requestData;
    } catch (e) {
      MyLogUtils.logDebug("getClosedCounter exception :$e");
      return null;
    }
  }

  Future<List<Sales>> getNotSyncedSalesForThisShift(String openedAt) async {
    var allSales = await getSalesData(openedAt);

    List<Sales> notSynced = List.empty(growable: true);

    var offlineSaleApi = locator.get<OfflineSaleApi>();
    var offlineSales = await offlineSaleApi.getAll();

    for (var element in allSales) {
      if (isSaleAvailableInOffline(element.offlineSaleId, offlineSales)) {
        notSynced.add(element);
      }
    }

    return notSynced;
  }

  bool isSaleAvailableInOffline(
      String? offlineSaleId, List<CartSummary> offlineSales) {
    for (var element in offlineSales) {
      if (element.offlineSaleId == offlineSaleId) {
        return true;
      }
    }
    return false;
  }

  Future<List<Sales>> getSalesData(String openedAt) async {
    try {
      MyLogUtils.logDebug("getSalesData for getOpenedAt :$openedAt");
      var api = locator.get<OfflineSalesDataApi>();
      var requestData = await api.getSales(openedAt);
      return requestData;
    } catch (e) {
      MyLogUtils.logDebug("getClosedCounter exception :$e");
      return [];
    }
  }

  Future<List<CashMovementRequest>> getNotSyncedCashMovements(
      String openedAt) async {
    try {
      MyLogUtils.logDebug("getCashMovements for getOpenedAt :$openedAt");
      var api = locator.get<OfflineCashMovementDataApi>();
      var requestData = await api.getNotSynced(openedAt);
      return requestData;
    } catch (e) {
      MyLogUtils.logDebug("getCashMovements exception :$e");
      return [];
    }
  }
}
