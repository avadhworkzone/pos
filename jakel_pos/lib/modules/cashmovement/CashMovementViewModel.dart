import 'package:jakel_base/database/cashmovement/CashMovementLocalApi.dart';
import 'package:jakel_base/database/offlinedata/cashmovement/CashMovementRequest.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/printer/types/cash_movement_in_out_print.dart';
import 'package:jakel_base/restapi/cashmovement/CashMovementApi.dart';
import 'package:jakel_base/restapi/cashmovement/model/CashMovementReasonResponse.dart';
import 'package:jakel_base/restapi/cashmovement/model/CashMovementResponse.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';

import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

class CashMovementViewModel extends BaseViewModel {
  // Use this object to prevent concurrent access to data
  var lock = Lock();
  var responseSubject = PublishSubject<String>();

  Stream<String> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  var dataResponseSubject = PublishSubject<CashMovementResponse>();

  Stream<CashMovementResponse> get dataResponseStream =>
      dataResponseSubject.stream;

  void getCashMovementsData(int typeId, int pageNo, int perPage) async {
    await lock.synchronized(() async {
      // Only this block can run (once) until done
      var api = locator.get<CashMovementApi>();

      try {
        var response =
            await api.getAllCashMovements(typeId, pageNo, perPage, true);
        dataResponseSubject.sink.add(response);
      } catch (e) {
        MyLogUtils.logDebug("getCashMovementsData exception $e");
        dataResponseSubject.sink.addError(e);
      }
    });
  }

  Future saveCashIn(String reason, int reasonId, double amount,
      StoreManagers storeManagers) async {
    await lock.synchronized(() async {
      MyLogUtils.logDebug("saveCashIn requested for $amount");

      //To Fix UI issues in windows
      responseSubject.delay(const Duration(seconds: 2));

      var api = locator.get<CashMovementApi>();

      try {
        var request = CashMovementRequest(
            reasonId: reasonId,
            reason: reason,
            typeId: cashInTypeId,
            authorizeId: storeManagers.id!,
            authorizer: storeManagers.firstName,
            authorizerType: "Store Manager",
            amount: amount,
            happenedAt: dateTimeYmdHis24Hour());

        var response = await api.saveCashMovement(request);

        MyLogUtils.logDebug("saveCashIn response ${response.toJson()}");

        if (response.cashMovement == null) {
          responseSubject.sink.add(response.message ?? "Error");
        } else {
          printCashMovement("Cash In", response.cashMovement!, false);
          responseSubject.sink.add("true");
        }
      } catch (e) {
        MyLogUtils.logDebug("savePettyCashUsage exception $e");
        responseSubject.sink.addError(e);
      }
    });
  }

  void saveCashOut(String? reason, int reasonId, double amount,
      StoreManagers storeManagers) async {
    await lock.synchronized(() async {
      MyLogUtils.logDebug("saveCashOut ==>");
      var api = locator.get<CashMovementApi>();

      //To Fix UI issues in windows
      responseSubject.delay(const Duration(seconds: 2));

      try {
        var request = CashMovementRequest(
            reasonId: reasonId,
            reason: reason,
            typeId: cashOutTypeId,
            authorizeId: storeManagers.id!,
            authorizer: storeManagers.firstName,
            authorizerType: "Store Manager",
            amount: amount,
            happenedAt: dateTimeYmdHis24Hour());

        var response = await api.saveCashMovement(request);

        if (response.message != null && response.cashMovement == null) {
          responseSubject.sink.add(response.message ?? "Error");
        } else {
          printCashMovement("Cash Out", response.cashMovement!, false);
          responseSubject.sink.add("true");
        }
      } catch (e) {
        MyLogUtils.logDebug("savePettyCashUsage exception $e");
        responseSubject.sink.addError(e);
      }
    });
  }

  Future<List<CashMovementReasons>> getCashIn() async {
    var api = locator.get<CashMovementLocalApi>();
    var response = await api.getAll();
    List<CashMovementReasons> cashIn = List.empty(growable: true);
    for (var value in response) {
      if (value.typeId == 1) {
        cashIn.add(value);
      }
    }

    return cashIn;
  }

  Future<List<CashMovementReasons>> getCashOut() async {
    var api = locator.get<CashMovementLocalApi>();
    var response = await api.getAll();
    List<CashMovementReasons> cashOut = List.empty(growable: true);
    for (var value in response) {
      if (value.typeId == 2) {
        cashOut.add(value);
      }
    }

    return cashOut;
  }
}
