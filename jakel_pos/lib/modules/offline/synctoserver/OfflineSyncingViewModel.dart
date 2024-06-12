import 'package:jakel_base/constants.dart';
import 'package:jakel_base/converter/sale/CartSummaryToSaleConverter.dart';
import 'package:jakel_base/database/offlinedata/OfflineCashMovementDataApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineCloseCounterDataApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineOpenCounterDataApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineSalesDataApi.dart';
import 'package:jakel_base/database/offlinedata/cashmovement/CashMovementRequest.dart';
import 'package:jakel_base/database/sale/OfflineSaleApi.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/database/user/UserLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/cashmovement/CashMovementApi.dart';
import 'package:jakel_base/restapi/counters/CountersApi.dart';
import 'package:jakel_base/restapi/counters/model/CloseCounterRequest.dart';
import 'package:jakel_base/restapi/counters/model/OpenCounterRequest.dart';
import 'package:jakel_base/restapi/login/LoginApi.dart';
import 'package:jakel_base/restapi/login/model/LoginRequest.dart';
import 'package:jakel_base/restapi/sales/SalesApi.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SaveSaleResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_pos/modules/newsale/NewSaleViewModel.dart';

class OfflineSyncingViewModel extends NewSaleViewModel {
  final keyToDelete = "12#21#@ja!!";

  Future<bool> syncAllDataToCloud() async {
    MyLogUtils.logDebug('syncAllDataToCloud started');

    //1. Login Cashier
    MyLogUtils.logDebug('syncAllDataToCloud => 1. Login Cashier');
    var result = await loginToCashier();
    MyLogUtils.logDebug('syncAllDataToCloud => Login cashier result : $result');
    if (!result) {
      return false;
    }

    var offlineOpenCounterDataApi = locator.get<OfflineOpenCounterDataApi>();
    var counterApi = locator.get<CountersApi>();
    //1.1 Get all open counter and check the status in backend if its already closed.
    // If closed delete form local
    await deleteAlreadySyncedCounterRequest(
        offlineOpenCounterDataApi, counterApi);

    //2. List all the counter available. Check if that counter is already opened using local data.
    MyLogUtils.logDebug(
        'syncAllDataToCloud => 2. List all the counter available. Check if that counter is already opened using local data.');

    var allOfflineOpenCounters = await offlineOpenCounterDataApi.getAll();

    MyLogUtils.logDebug(
        'syncAllDataToCloud => allOfflineOpenCounters Length : ${allOfflineOpenCounters.length}');

    for (var counter in allOfflineOpenCounters) {
      MyLogUtils.logDebug(
          'syncAllDataToCloud => counter to be synced: ${counter.toJson()}');

      //3. Check if counter is synced to cloud.If not synced sync to cloud first
      MyLogUtils.logDebug(
          'syncAllDataToCloud => 3. Check if counter is synced to cloud.If not synced sync to cloud first');

      if (counter.isSyncedToCloud == null || counter.isSyncedToCloud == false) {
        result = await openCounter(counter, counterApi);
        MyLogUtils.logDebug(
            'syncAllDataToCloud=> counter sync result: $result');
        if (!result) {
          return false;
        }
      }

      /// 4. Sync sales
      result = await syncOfflineSales(counter.openedByPosAt ?? '');
      MyLogUtils.logDebug(
          'syncAllDataToCloud =>4. syncOfflineSales result: $result');
      if (!result) {
        return false;
      }

      //5 : Sync cash movement
      result = await saveOfflineCashMovements(counter.openedByPosAt ?? '');

      MyLogUtils.logDebug('syncAllDataToCloud => 5.Sync cash '
          'movement result : $result');

      if (!result) {
        MyLogUtils.logDebug(
            'syncAllDataToCloud => 6.Sync cash movement to online failed');
        return false;
      }

      //8. Get Close counter for the current counter
      MyLogUtils.logDebug('syncAllDataToCloud => 7. Close counter');
      var offlineCloseCounterDataApi =
          locator.get<OfflineCloseCounterDataApi>();

      var closeCounterRequest = await offlineCloseCounterDataApi
          .getCounterById(counter.openedByPosAt ?? '');

      MyLogUtils.logDebug(
          'syncAllDataToCloud =>closeCounterRequest : ${closeCounterRequest?.toJson()}');

      if (closeCounterRequest != null) {
        var result = await closeCounter(closeCounterRequest);
        MyLogUtils.logDebug(
            'syncAllDataToCloud =>closeCounterRequest sync result : $result');
      }

      MyLogUtils.logDebug('syncAllDataToCloud completed for the counter.');
    }

    MyLogUtils.logDebug('syncAllDataToCloud completed for the counter.');
    return Future(() => true);
  }

  Future<void> deleteAlreadySyncedCounterRequest(
      OfflineOpenCounterDataApi offlineOpenCounterDataApi,
      CountersApi counterApi) async {
    var allOfflineOpenCountersToCheck =
        await offlineOpenCounterDataApi.getAll();

    allOfflineOpenCountersToCheck.forEach((element) async {
      MyLogUtils.logDebug(
          "allOfflineOpenCountersToCheck element : ${element.toJson()}");
      if (element.counterId != null && element.openedByPosAt != null) {
        var response = await counterApi.getCounterOpenStatus(
            element.counterId ?? 0,
            element.openedByPosAt ?? '',
            element.counterUpdateId);

        MyLogUtils.logDebug(
            "allOfflineOpenCountersToCheck response : ${response}");
        if (response.isCounterClosed == true &&
            response.isCounterOpened == true) {
          //
          offlineOpenCounterDataApi
              .clearOpenCounterRequest(element.openedByPosAt ?? '');
        }
      }
    });
  }

  Future<bool> syncOfflineSales(String openedByPosAt) async {
    try {
      // Get All offline sales for this counter
      List<CartSummary> salesToBeSynced =
          await getNotSyncedSales(openedByPosAt);

      //To make sure , same sale is not sent twice.
      List<String> salesOfflineIds = List.empty(growable: true);

      /// Sync sales
      for (var value in salesToBeSynced) {
        if (!salesOfflineIds.contains(value.offlineSaleId ?? '')) {
          salesOfflineIds.add(value.offlineSaleId ?? '');
          await syncOfflineCartSummaryToCloud(value);
        }
      }

      /// Recheck for offline sales
      salesToBeSynced = await getNotSyncedSales(openedByPosAt);

      return salesToBeSynced.isEmpty;
    } catch (e) {
      MyLogUtils.logDebug(
          'syncAllDataToCloud =>syncOfflineSales exception $e ');
    }

    return false;
  }

  Future<List<CartSummary>> getNotSyncedSales(String openByPosAt) async {
    MyLogUtils.logDebug('syncAllDataToCloud => getNotSyncedSales');

    MyLogUtils.logDebug(
        'syncAllDataToCloud => 1. Fetch all sales for this counter.');
    var offlineSalesDataApi = locator.get<OfflineSalesDataApi>();

    var salesForThisCounter = await offlineSalesDataApi.getSales(openByPosAt);

    MyLogUtils.logDebug(
        'syncAllDataToCloud =>salesForThisCounter length : ${salesForThisCounter.length}');

    //5. Fetch all not synced sales.
    MyLogUtils.logDebug('syncAllDataToCloud => 2. Fetch all not synced sales.');
    var offlineSaleApi = locator.get<OfflineSaleApi>();
    List<CartSummary> allOfflineSales = await offlineSaleApi.getAll();
    MyLogUtils.logDebug(
        'syncAllDataToCloud =>allOfflineSales length : ${allOfflineSales.length}');

    //6. Filter offline sales with sales that are made only for this counter;
    MyLogUtils.logDebug(
        'syncAllDataToCloud => 3. Filter offline sales with sales that are made only for this counter;');
    List<CartSummary> salesToBeSyncedNow = List.empty(growable: true);
    for (var element in allOfflineSales) {
      if (checkIfSaleExists(salesForThisCounter, element.offlineSaleId ?? '')) {
        salesToBeSyncedNow.add(element);
      }
    }

    MyLogUtils.logDebug(
        'syncAllDataToCloud => salesToBeSyncedNow length : ${salesToBeSyncedNow.length}');

    return salesToBeSyncedNow;
  }

  bool checkIfSaleExists(List<Sales> allSales, String offlineId) {
    for (var value in allSales) {
      if (value.offlineSaleId == offlineId) {
        return true;
      }
    }
    return false;
  }

  Future<bool> loginToCashier() async {
    var userLocalApi = locator.get<UserLocalApi>();
    var loginApi = locator.get<LoginApi>();
    var token = await userLocalApi.getToken();
    MyLogUtils.logDebug(
        'syncAllDataToCloud => loginToCashier old token : $token');

    //to avoid frequent login call to server
    if (token == offlineToken) {
      LoginRequest request = LoginRequest(
          username: await userLocalApi.getUserName(),
          pin: await userLocalApi.getPassword());
      var response = await loginApi.login(request);
      if (response.token != null && response.token != offlineToken) {
        await userLocalApi.saveToken(response.token!);
        await userLocalApi.savePassword(request.pin!);
        await userLocalApi.saveUserName(request.username!);
        return true;
      } else {
        MyLogUtils.logDebug('syncAllDataToCloud => Login cashier failed');
        return false;
      }
    }
    return true;
  }

  Future<bool> openCounter(
      OpenCounterRequest request, CountersApi counterApi) async {
    //Check if counter open is already success using status api.
    if (request.counterId != null && request.openedByPosAt != null) {
      var counterStatusResponse = await counterApi.getCounterOpenStatus(
          request.counterId ?? 0,
          request.openedByPosAt ?? '',
          request.counterUpdateId);

      MyLogUtils.logDebug(
          "openCounter check status before calling open : $counterStatusResponse");
      if (counterStatusResponse.isCounterOpened == true &&
          counterStatusResponse.isCounterClosed == false) {
        // Open counter request is already synced to backend
        return true;
      }
    }

    // OPen the counter
    if (request.isSyncedToCloud == null || request.isSyncedToCloud == false) {
      var openCounterApi = locator.get<CountersApi>();
      var response = await openCounterApi.openCounter(request);
      if (response != "true") {
        return false;
      }
    }
    return true;
  }

  Future<bool> closeCounter(CloseCounterRequest request) async {
    var openCounterApi = locator.get<CountersApi>();
    var response = await openCounterApi.closeCounter(request);
    return response;
  }

  Future<bool> syncOfflineCartSummaryToCloud(CartSummary cartSummary) async {
    MyLogUtils.logDebug(
        "syncOfflineCartSummaryToCloud saleTye : ${cartSummary.saleTye}");

    if (cartSummary.saleTye == SaleTye.BOOKING) {
      return saveNewOfflineBookings(cartSummary);
    }

    return saveNewOfflineSale(cartSummary);
  }

  Future<bool> saveNewOfflineSale(CartSummary cartSummary) async {
    try {
      MyLogUtils.logDebug(
          "saveNewOfflineSale cartSummary  : ${cartSummary.toJson()}");

      var offlineSaleApi = locator.get<OfflineSaleApi>();
      var saleRestApi = locator.get<SalesApi>();

      // Check if sale exists
      try {
        var sale =
            await saleRestApi.getSaleById(cartSummary.offlineSaleId ?? noData);
        if (sale.sales != null && sale.sales!.isNotEmpty) {
          await deleteOnHoldSale(cartSummary, null);
          MyLogUtils.logDebug(
              "syncOfflineCartSummaryToCloud getSaleById trye for  : ${cartSummary.offlineSaleId ?? noData}");
          await offlineSaleApi.delete(cartSummary.offlineSaleId ?? noData);
        } else {
          var response =
              await saveNewSaleAndGetResult(cartSummary, false, false, null);
          await deleteOnHoldSale(cartSummary, null);
          await offlineSaleApi.delete(response?.sale!.offlineSaleId ?? noData);
        }
      } catch (e) {
        var response =
            await saveNewSaleAndGetResult(cartSummary, false, false, null);
        await deleteOnHoldSale(cartSummary, null);
        await offlineSaleApi.delete(response?.sale!.offlineSaleId ?? noData);
      }

      return true;
    } catch (e) {
      MyLogUtils.logDebug("saveNewOfflineSale exception : ${e}");
    }

    return false;
  }

  Future<bool> saveNewOfflineBookings(CartSummary cartSummary) async {
    try {
      MyLogUtils.logDebug(
          "saveNewOfflineBookings cartSummary : ${cartSummary.payments}");

      var response =
          await saveNewBookingsAndGetResult(cartSummary, false, false, null);

      MyLogUtils.logDebug("saveNewBookingsAndGetResult response : $response");

      return true;
    } catch (e) {
      MyLogUtils.logDebug("saveNewOfflineBookings exception : $e");
    }

    return false;
  }

  //Save all offline cash movements to cloud for the current opened counter
  Future<bool> saveOfflineCashMovements(String posOpenedAt) async {
    try {
      var offlineSaleApi = locator.get<OfflineCashMovementDataApi>();
      var cashMovementApi = locator.get<CashMovementApi>();

      List<CashMovementRequest> cashMovements =
          await offlineSaleApi.getNotSynced(posOpenedAt);

      for (var value in cashMovements) {
        var response = await cashMovementApi.saveCashMovement(value);
      }

      //Check for offline cash movements.
      cashMovements = await offlineSaleApi.getNotSynced(posOpenedAt);
      return cashMovements.isEmpty;
    } catch (e) {
      MyLogUtils.logDebug("saveNewOfflineSale exception : ${e}");
    }

    return false;
  }

  Future<List<CartSummary>> getAllOfflineSales() async {
    var offlineSaleApi = locator.get<OfflineSaleApi>();
    return offlineSaleApi.getAll();
  }

  Future<List<Sales>> getOfflineSalesAsSale() async {
    var converterApi = locator.get<CartSummaryToSaleConverter>();
    List<CartSummary> cartSummary = await getAllOfflineSales();
    List<Sales> sales = List.empty(growable: true);
    cartSummary.forEach((element) async {
      if (element.saleTye == SaleTye.REGULAR) {
        Sale? sale = await converterApi.getSaleFromCartSummary(element);
        if (sale != null) {
          sales.add(Sales.fromJson(sale.toJson()));
        }
      }
    });
    return sales;
  }

  Future<bool> deleteOfflineSale(String offlineSaleId) async {
    var offlineSaleApi = locator.get<OfflineSaleApi>();
    await offlineSaleApi.delete(offlineSaleId);
    return true;
  }
}
