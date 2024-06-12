import 'dart:collection';

import 'package:jakel_base/database/counter/CounterLocalApi.dart';
import 'package:jakel_base/database/denominations/DenominationsLocalApi.dart';
import 'package:jakel_base/database/user/UserLocalApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineCloseCounterDataApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/printer/service/my_printer_service.dart';
import 'package:jakel_base/restapi/counters/CountersApi.dart';
import 'package:jakel_base/restapi/counters/model/CloseCounterRequest.dart';
import 'package:jakel_base/restapi/counters/model/PaymentDeclarationRequest.dart';
import 'package:jakel_base/restapi/counters/model/ShiftDetailsResponse.dart';
import 'package:jakel_base/restapi/denominations/model/DenominationsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/utils/my_unique_id.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:rxdart/rxdart.dart';

class ShiftCloseViewModel extends BaseViewModel {
  var responseSubject = PublishSubject<ShiftDetailsResponse>();

  Stream<ShiftDetailsResponse> get responseStream => responseSubject.stream;

  var boolResponseSubject = PublishSubject<bool>();

  Stream<bool> get boolResponseStream => boolResponseSubject.stream;

  void closeObservable() {
    responseSubject.close();
    boolResponseSubject.close();
  }

  void getShiftClosingDetails() async {
    var api = locator.get<CountersApi>();

    try {
      var response = await api.getShiftClosingDetails();

      MyLogUtils.logDebug(
          "getShiftClosingDetails view model response :  ${response.toJson()}");

      // If payment type in shift close does not contain cash & still opening balance is added,
      // then it should be declared as well
      if (response.counterClosingDetails != null) {
        addOpeningBalanceToCashPayment(response);
      }
      responseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("getShiftClosingDetails exception $e");
      responseSubject.sink.addError(e);
    }
  }

  void addOpeningBalanceToCashPayment(ShiftDetailsResponse response) {
    List<ShiftClosingPayments>? payments =
        response.counterClosingDetails?.payments;

    MyLogUtils.logDebug(
        "getShiftClosingDetails addOpeningBalanceToCashPayment ${payments?.length}");
    payments ??= [];
    bool isCashPaymentAvailable = false;
    for (var value in payments) {
      if (value.paymentTypeId == cashPaymentId) {
        isCashPaymentAvailable = true;
      }

      MyLogUtils.logDebug(
          "getShiftClosingDetails addOpeningBalanceToCashPayment "
          "value.paymentTypeId : ${value.paymentTypeId}"
          "value.total : ${value.total}");
    }
    if (!isCashPaymentAvailable) {
      payments.add(ShiftClosingPayments(
          paymentTypeId: cashPaymentId, paymentType: "Cash"));
    }
    response.counterClosingDetails?.setPayments(payments);
  }

  void closeCounter(CloseCounterRequest request) async {
    var api = locator.get<CountersApi>();

    try {
      MyLogUtils.logDebug("closeCounter request : ${request.toJson()}");
      var response = await api.closeCounter(request);
      MyLogUtils.logDebug("closeCounter response : $response");
      responseSubject.delay(const Duration(seconds: 2));
      boolResponseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("closeCounter exception $e");
      boolResponseSubject.sink.addError(e);
    }
  }

  Future<bool> checkCounterDataIsNotSynced() async {
    var api = locator.get<OfflineCloseCounterDataApi>();
    var closeCounter = await api.getAll();
    return closeCounter.isNotEmpty;
  }

  Future<List<Denominations>> getDenominations() async {
    var api = locator.get<DenominationsLocalApi>();
    List<DenominationKey> denominationsKey = await api.getAll();

    List<Denominations> denominations = List.empty(growable: true);

    for (var element in denominationsKey) {
      denominations
          .add(Denominations(denomination: element.denomination, quantity: 0));
    }

    //Back up plan
    if (denominations.isEmpty) {
      denominations.add(Denominations(denomination: 100, quantity: 0));
      denominations.add(Denominations(denomination: 50, quantity: 0));
      denominations.add(Denominations(denomination: 20, quantity: 0));
      denominations.add(Denominations(denomination: 10, quantity: 0));
      denominations.add(Denominations(denomination: 5, quantity: 0));
      denominations.add(Denominations(denomination: 1, quantity: 0));
      denominations.add(Denominations(denomination: 0.50, quantity: 0));
      denominations.add(Denominations(denomination: 0.20, quantity: 0));
      denominations.add(Denominations(denomination: 0.10, quantity: 0));
      denominations.add(Denominations(denomination: 0.01, quantity: 0));
    }

    return denominations;
  }

  double getExpectedCash(CounterClosingDetails? counter) {
    if (counter == null) {
      return 0.0;
    }

    return counter.closingBalance ?? 0.0;
  }

  double getEnteredCash(List<Denominations> denominations) {
    double cash = 0.0;
    for (var element in denominations) {
      if (element.denomination != null && element.quantity != null) {
        cash = cash + element.denomination! * element.quantity!;
      }
    }
    return cash;
  }

  double getPendingCash(
      CounterClosingDetails counter, List<Denominations> denominations) {
    return getExpectedCash(counter) - getEnteredCash(denominations);
  }

  Future<void> updatePrintReceiptDeclaration(
      String? title,
      CounterClosingDetails counterClosingDetails,
      List<Denominations> denominations,
      HashMap<int, double> paymentDeclaration) async {
    var counterApi = locator.get<CountersApi>();
    var printerService = locator.get<MyPrinterService>();
    var printResult = await printerService.cashDeclarationReceipt(
        title, counterClosingDetails, denominations, paymentDeclaration);

    MyLogUtils.logDebug("Print Receipt Declaration : $printResult");
    await sendPaymentDeclaration(
        counterClosingDetails, counterApi, denominations, paymentDeclaration);
  }

  Future<void> sendPaymentDeclaration(
      CounterClosingDetails counterClosingDetails,
      CountersApi counterApi,
      List<Denominations> denominations,
      HashMap<int, double> paymentDeclaration) async {
    try {
      var userApi = locator.get<UserLocalApi>();
      var user = await userApi.getCurrentUser();

      var offlineId = getOfflineSaleUniqueId(
          user?.cashier?.id ?? 0, user?.counter?.id ?? 0, user?.store?.id ?? 0);

      List<DeclarationPayments>? payments = List.empty(growable: true);

      paymentDeclaration.forEach((key, value) {
        if (key == cashPaymentId) {
          //For Cash payment add denominations
          List<DeclarationPaymentDenominations> declared =
              List.empty(growable: true);

          for (var element in denominations) {
            declared.add(DeclarationPaymentDenominations(
                quantity: element.quantity,
                denomination: '${element.denomination}'));
          }

          payments.add(DeclarationPayments(
              paymentTypeId: key,
              declaredAmount: value,
              calculatedAmount: counterClosingDetails.closingBalance ?? 0,
              denominations: declared));
        } else {
          var calculatedAmount = 0.0;
          counterClosingDetails.payments?.forEach((element) {
            if (element.paymentTypeId == key) {
              calculatedAmount = element.total ?? 0.0;
            }
          });
          payments.add(DeclarationPayments(
              paymentTypeId: key,
              declaredAmount: value,
              calculatedAmount: calculatedAmount));
        }
      });

      var request = PaymentDeclarationRequest(
          happenedAt: dateTimeYmdHis(),
          offlineId: offlineId,
          payments: payments);
      counterApi.paymentDeclaration(request);
    } catch (e) {
      MyLogUtils.logDebug("paymentDeclaration error : $e");
    }
  }

  Future<void> printOpeningBalance(double openingBalance) async {
    var counterApi = locator.get<CounterLocalApi>();
    var store = await counterApi.getStore();
    var counter = await counterApi.getCounter();
    if (store != null && counter != null) {
      printOpenCounter("OPENING BALANCE", store, counter, openingBalance, true);
    }
  }
}
