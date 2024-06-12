import 'dart:collection';

import 'package:jakel_base/database/counter/CounterLocalApi.dart';
import 'package:jakel_base/database/denominations/DenominationsLocalApi.dart';
import 'package:jakel_base/database/user/UserLocalApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineCloseCounterDataApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/printer/service/my_printer_service.dart';
import 'package:jakel_base/restapi/counters/CountersApi.dart';
import 'package:jakel_base/restapi/counters/model/CloseCounterRequest.dart';
import 'package:jakel_base/restapi/counters/model/PaymentDeclarationAttemptsResponse.dart';
import 'package:jakel_base/restapi/counters/model/PaymentDeclarationRequest.dart';
import 'package:jakel_base/restapi/counters/model/ShiftDetailsResponse.dart';
import 'package:jakel_base/restapi/denominations/model/DenominationsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/utils/my_unique_id.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:rxdart/rxdart.dart';

class PaymentDeclarationAttemptsViewModel extends BaseViewModel {
  var responseSubject = PublishSubject<PaymentDeclarationAttemptsResponse>();

  Stream<PaymentDeclarationAttemptsResponse> get responseStream =>
      responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void getPaymentDeclarationAttempt() async {
    var api = locator.get<CountersApi>();

    try {
      var response = await api.getPaymentDeclarationAttempt();
      MyLogUtils.logDebug(
          "getPaymentDeclarationAttempt  response :  ${response.toJson()}");

      responseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("getPaymentDeclarationAttempt exception $e");
      responseSubject.sink.addError(e);
    }
  }
}
