import 'package:jakel_base/restapi/counters/model/CloseCounterRequest.dart';
import 'package:jakel_base/restapi/counters/model/ClosedCountesrHistoryResponse.dart';
import 'package:jakel_base/restapi/counters/model/CounterOpenStatusResponse.dart';
import 'package:jakel_base/restapi/counters/model/CurrentOpenedCounterResponse.dart';
import 'package:jakel_base/restapi/counters/model/GetCountersResponse.dart';
import 'package:jakel_base/restapi/counters/model/OpenCounterRequest.dart';
import 'package:jakel_base/restapi/counters/model/PaymentDeclarationAttemptsResponse.dart';
import 'package:jakel_base/restapi/counters/model/PaymentDeclarationRequest.dart';
import 'package:jakel_base/restapi/counters/model/ShiftDetailsResponse.dart';

import 'model/GetStoresResponse.dart';

abstract class CountersApi {
  Future<GetStoresResponse> getStores();

  Future<PaymentDeclarationAttemptsResponse> getPaymentDeclarationAttempt();

  Future<GetCountersResponse> getCounters(int storeId);

  Future<String> openCounter(OpenCounterRequest request);

  Future<ShiftDetailsResponse> getShiftClosingDetails();

  Future<bool> closeCounter(CloseCounterRequest request);

  Future<bool> paymentDeclaration(PaymentDeclarationRequest request);

  Future<ClosedCountersHistoryResponse> getLastThirtyDaysClosedCounters(
      int pageNo, int perPage);

  Future<CurrentOpenedCounterResponse> getCurrentOpenedCounter();

  Future<CounterOpenStatusResponse> getCounterOpenStatus(
      int counterId, String openedByPosAt, int? counterUpdateId);
}
