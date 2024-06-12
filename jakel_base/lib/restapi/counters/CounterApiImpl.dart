import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jakel_base/database/offlinedata/OfflineCashMovementDataApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineCloseCounterDataApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineOpenCounterDataApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineSalesDataApi.dart';
import 'package:jakel_base/database/paymenttypes/PaymentTypesLocalApi.dart';
import 'package:jakel_base/database/user/UserLocalApi.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/counters/CountersApi.dart';
import 'package:jakel_base/restapi/counters/model/CloseCounterRequest.dart';
import 'package:jakel_base/restapi/counters/model/ClosedCountesrHistoryResponse.dart';
import 'package:jakel_base/restapi/counters/model/CurrentOpenedCounterResponse.dart';
import 'package:jakel_base/restapi/counters/model/GetCountersResponse.dart';
import 'package:jakel_base/restapi/counters/model/OpenCounterRequest.dart';
import 'package:jakel_base/restapi/counters/model/PaymentDeclarationAttemptsResponse.dart';
import 'package:jakel_base/restapi/counters/model/PaymentDeclarationRequest.dart';
import 'package:jakel_base/restapi/counters/model/ShiftDetailsResponse.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/utils/my_network_helper.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';

import '../../locator.dart';
import '../../utils/MyLogUtils.dart';
import '../sales/model/history/SalesResponse.dart';
import 'model/CounterOpenStatusResponse.dart';
import 'model/GetStoresResponse.dart';

class CountersApiImpl extends BaseApi with CountersApi {
  @override
  Future<CounterOpenStatusResponse> getCounterOpenStatus(
      int counterId, String openedByPosAt, int? counterUpdateId) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();

    var url = '$masterUrl$getCounterOpenStatusUrl?counter_id=$counterId'
        '&opened_by_pos_at=$openedByPosAt';

    if (counterUpdateId != null && counterUpdateId > 0) {
      url = "$url&counter_update_id=$counterUpdateId";
    }

    MyLogUtils.logDebug("getCounterOpenStatus url : $url");

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      MyLogUtils.logDebug("getCounterOpenStatus response : ${response.data}");
      return CounterOpenStatusResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<GetCountersResponse> getCounters(int storeId) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = '$masterUrl$countersUrl$storeId';

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return GetCountersResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<String> openCounter(OpenCounterRequest request) async {
    var offlineOpenCounterDataApi = locator.get<OfflineOpenCounterDataApi>();
    MyLogUtils.logDebug("openCounter request : ${request.toJson()}");

    if (!await checkIsInternetConnected()) {
      return await saveOpenCounterOffline(
          offlineOpenCounterDataApi, request, false);
    }

    var masterUrl = await getMasterUrl();
    final url = '$masterUrl$openCounterUrl';

    try {
      var dio = await getDioInstance();
      FormData formData = FormData.fromMap({
        "counter_id": request.counterId,
        "opening_balance": request.openingBalance,
        "opened_by_pos_at": request.openedByPosAt,
      });

      Response response = await dio.post(url, data: formData);

      MyLogUtils.logDebug("openCounter response.data : ${response.data}");

      MyLogUtils.logDebug(
          "openCounter response statusMessage : ${response.statusMessage}");

      MyLogUtils.logDebug(
          "openCounter response statusCode : ${response.statusCode}");

      if (response.statusCode == 200) {
        try {
          CurrentOpenedCounterResponse openedCounterResponse =
              await getCurrentOpenedCounter();

          MyLogUtils.logDebug(
              "CurrentOpenedCounterResponse  : ${openedCounterResponse.toJson()}");

          request.setCounterUpdateId(
              openedCounterResponse.counter?.counterUpdateId);
        } catch (e) {
          MyLogUtils.logDebug("CurrentOpenedCounterResponse exception : $e");
        }

        return await saveOpenCounterOffline(
            offlineOpenCounterDataApi, request, true);
      }

      if (response.statusCode == 412) {
        return response.data['message'];
      }

      //Log Error
      logError(url, response.statusCode, response.statusMessage);

      return await saveOpenCounterOffline(
          offlineOpenCounterDataApi, request, false);
    } on DioError catch (ex) {
      //Log Error
      logError(url, -1, "Dio Error, Type:${ex.type}, Message:${ex.message}");
      return await saveOpenCounterOffline(
          offlineOpenCounterDataApi, request, false);
    }
  }

  @override
  Future<GetStoresResponse> getStores() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + storesUrl;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return GetStoresResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<bool> closeCounter(CloseCounterRequest request) async {
    MyLogUtils.logDebug("closeCounter request => ${request.toJson()}");

    var offlineCloseCounterDataApi = locator.get<OfflineCloseCounterDataApi>();

    if (!await checkIsInternetConnected()) {
      return await saveCloseCounterOffline(
          offlineCloseCounterDataApi, request, false);
    }

    var masterUrl = await getMasterUrl();
    final url = '$masterUrl$closeCounterUrl';

    try {
      var dio = await getDioInstance();

      FormData formData = FormData.fromMap(request.toJson());

      Response response = await dio.post(url, data: formData);

      MyLogUtils.logDebug("closeCounter response ${response.data}");

      if (response.statusCode == 200) {
        await saveCloseCounterOffline(
            offlineCloseCounterDataApi, request, true);
        return true;
      }

      //Log Error
      logError(url, response.statusCode, response.statusMessage);

      return await saveCloseCounterOffline(
          offlineCloseCounterDataApi, request, false);
    } on DioError catch (ex) {
      //Log Error
      logError(url, -1, "Dio Error, Type:${ex.type}, Message:${ex.message}");
      return await saveCloseCounterOffline(
          offlineCloseCounterDataApi, request, false);
    }
  }

  @override
  Future<ShiftDetailsResponse> getShiftClosingDetails() async {
    if (!await checkIsInternetConnected()) {
      return await getShiftCloseDetailsLocal();
    }
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + getCurrentCounterDetails;
    MyLogUtils.logDebug("getShiftClosingDetails url $url");

    try {
      Response response = await dio.get(url);

      MyLogUtils.logDebug(
          "getShiftClosingDetails response ${jsonEncode(response.data)}");

      if (response.statusCode == 200) {
        return ShiftDetailsResponse.fromJson(response.data);
      }
      //Log Error
      logError(url, response.statusCode, response.statusMessage);
      throw Exception(
          "${response.statusCode} & ${response.statusMessage} for $url endpoint");
    } on DioError catch (ex) {
      //Log Error
      logError(url, -1, "Dio Error, Type:${ex.type}, Message:${ex.message}");
      return await getShiftCloseDetailsLocal();
    }
  }

  @override
  Future<bool> paymentDeclaration(PaymentDeclarationRequest request) async {
    MyLogUtils.logDebug("paymentDeclaration  request : ${request.toJson()}");
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = "$masterUrl$updatePaymentDeclaration";

    MyLogUtils.logDebug("paymentDeclaration  url : $url");

    FormData formData =
        FormData.fromMap(request.toJson(), ListFormat.multiCompatible);

    for (var element in formData.fields) {
      MyLogUtils.logDebug(
          "paymentDeclaration  request element : ${element.key} = ${element.value}");
    }

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug(
        "paymentDeclaration response statusCode: ${response.statusCode}");

    if (response.statusCode == 200) {
      return true;
    }

    // if (response.statusCode == 412) {
    //   return BookingPaymentsResponse.fromJson(response.data);
    // }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<ClosedCountersHistoryResponse> getLastThirtyDaysClosedCounters(
      int pageNo, int perPage) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url = "$masterUrl$getLastThirtyDaysClosedCountersUrl?";

    if (pageNo > 0) {
      url = "${url}page=$pageNo";
    }

    if (perPage > 0) {
      url = "$url&per_page=$perPage";
    }

    MyLogUtils.logDebug("getLastThirtyDaysClosedCounters Url : $url");

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return ClosedCountersHistoryResponse.fromJson(response.data);
    }

    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<PaymentDeclarationAttemptsResponse>
      getPaymentDeclarationAttempt() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = '$masterUrl$getCounterPaymentDeclarationAttempts';

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return PaymentDeclarationAttemptsResponse.fromJson(response.data);
    }

    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<CurrentOpenedCounterResponse> getCurrentOpenedCounter() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + getCurrentlyOpenedCounterStatus;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return CurrentOpenedCounterResponse.fromJson(response.data);
    }

    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  // Save the opening counter details offline until system is online
  Future<String> saveOpenCounterOffline(
      OfflineOpenCounterDataApi offlineOpenCounterDataApi,
      OpenCounterRequest request,
      bool isSynced) async {
    request.setIsSyncedToCloud(isSynced);

    MyLogUtils.logDebug("saveOpenCounterOffline request : ${request.toJson()}");
    await offlineOpenCounterDataApi.setOpenCounterRequest(request);

    MyLogUtils.logDebug(
        "saveOpenCounterOffline currentOpened : ${(await offlineOpenCounterDataApi.getCurrentOpenedCounter())?.toJson()}");
    return "true";
  }

  Future<bool> saveCloseCounterOffline(
      OfflineCloseCounterDataApi offlineCloseCounterDataApi,
      CloseCounterRequest request,
      bool isSynced) async {
    MyLogUtils.logDebug(
        "saveCloseCounterOffline isSynced $isSynced  & request : ${request.toJson()}");

    // Set open counter time using current opened counter in close counter request
    var openDataCounterApi = locator.get<OfflineOpenCounterDataApi>();
    var openedCounter = await openDataCounterApi.getCurrentOpenedCounter();

    MyLogUtils.logDebug(
        "saveCloseCounterOffline openedCounter : $isSynced && request : ${openedCounter?.toJson()}");

    // Becuase , if 1 open counter is not synced & 1 more  is opened during offline mode,
    // We will get get current open counter data only. It should the
    if (request.openedByPostAt == null) {
      request.setOpenedByPost(openedCounter?.openedByPosAt ?? '');
    }

    MyLogUtils.logDebug(
        "saveCloseCounterOffline isSynced : $isSynced && request : ${request.toJson()}");

    await offlineCloseCounterDataApi.setCloseCounterRequest(request);

    if (isSynced) {
      // Clear all offline data in close counter & open counter
      await clearOfflineCloseAndOpenCounterData(request.openedByPostAt);
    } else {
      var openCounterRequest =
          await openDataCounterApi.getCounterById(request.openedByPostAt ?? '');

      if (openCounterRequest != null) {
        var userLocalApi = locator.get<UserLocalApi>();
        var currentUserResponse = await userLocalApi.getCurrentUser();
        if (currentUserResponse != null) {}
        openCounterRequest.setClosedAt(request.closedByPosAt ?? '');
        MyLogUtils.logDebug(
            "saveCloseCounterOffline openCounterRequest : ${openCounterRequest.toJson()}");
        await openDataCounterApi.setOpenCounterRequest(openCounterRequest);
      }
    }
    return true;
  }

  //Deletes all open & close counter data in app
  Future<void> clearOfflineCloseAndOpenCounterData(
      String? openedByPosAt) async {
    var openDataCounterApi = locator.get<OfflineOpenCounterDataApi>();
    var offlineCloseCounterDataApi = locator.get<OfflineCloseCounterDataApi>();

    MyLogUtils.logDebug(
        "clearOfflineCloseAndOpenCounterData isSynced clearOpenCounterRequest "
        "openedByPostAt : $openedByPosAt");

    await openDataCounterApi.clearOpenCounterRequest(openedByPosAt ?? '');

    MyLogUtils.logDebug(
        "clearOfflineCloseAndOpenCounterData isSynced clearCloseCounterRequest "
        "openedByPostAt : $openedByPosAt");

    await offlineCloseCounterDataApi
        .clearCloseCounterRequest(openedByPosAt ?? '');

    // Clear all sales stored for this counter opened at
    var offlineSalesDataApi = locator.get<OfflineSalesDataApi>();

    MyLogUtils.logDebug(
        "saveCloseCounterOffline isSynced delete sales ForCounterOpenedAt "
        "openedByPostAt : $openedByPosAt");

    await offlineSalesDataApi.deleteForCounterOpenedAt(openedByPosAt ?? '');
  }

  Future<ShiftDetailsResponse> getShiftCloseDetailsLocal() async {
    var offlineOpenCounterDataApi = locator.get<OfflineOpenCounterDataApi>();
    var userLocalApi = locator.get<UserLocalApi>();
    var salesOfflineData = locator.get<OfflineSalesDataApi>();

    var cashier = await userLocalApi.getCurrentUser();
    var openCounterRequest =
        await offlineOpenCounterDataApi.getCurrentOpenedCounter();

    MyLogUtils.logDebug(
        "getShiftCloseDetailsLocal openCounterRequest : ${openCounterRequest?.toJson()}");

    List<Sales> allSales = await salesOfflineData
        .getSales(openCounterRequest?.openedByPosAt ?? '');

    MyLogUtils.logDebug(
        "getShiftCloseDetailsLocal allSales : ${allSales.length}");

    double closingBalance = openCounterRequest?.openingBalance ?? 0.0;

    closingBalance =
        closingBalance + await getCashMovementAmount(openCounterRequest);

    MyLogUtils.logDebug(
        "getShiftCloseDetailsLocal openingBalance : $closingBalance && allSales count : ${allSales.length}");

    Map<int, double> paymentTypeGrouping = {};
    for (var value in allSales) {
      value.payments?.forEach((element) {
        MyLogUtils.logDebug(
            "getShiftCloseDetailsLocal payment id : ${element.paymentType?.id} "
            "& amount : ${element.amount}");

        if (element.paymentType?.id == cashPaymentId) {
          closingBalance = closingBalance + (element.amount ?? 0.0);
        }

        double existingAmount =
            (paymentTypeGrouping[element.paymentType?.id] ?? 0.0) +
                (element.amount ?? 0.0);
        paymentTypeGrouping[element.paymentType?.id ?? 0] = existingAmount;
      });
    }

    MyLogUtils.logDebug(
        "getShiftCloseDetailsLocal paymentTypeGrouping : $paymentTypeGrouping");

    List<ShiftClosingPayments> payments = List.empty(growable: true);

    List<int> paymentIds = List.from(paymentTypeGrouping.keys);

    for (var element in paymentIds) {
      var paymentTypesLocalApi = locator.get<PaymentTypesLocalApi>();
      var payment = await paymentTypesLocalApi.getById(element);

      var shiftPayment = ShiftClosingPayments(
          paymentTypeId: element,
          total: paymentTypeGrouping[element],
          paymentType: payment.name);

      MyLogUtils.logDebug(
          "getShiftCloseDetailsLocal shiftPayment : ${shiftPayment.toJson()} ");
      payments.add(shiftPayment);
    }

    MyLogUtils.logDebug(
        "getShiftCloseDetailsLocal payments length : ${payments.length}");

    var counterClosingDetails = CounterClosingDetails(
        cashierName: cashier?.cashier?.firstName,
        counterName: cashier?.counter?.name,
        openingDateTime: openCounterRequest?.openedByPosAt ?? dateTimeYmdHis(),
        openingBalance: openCounterRequest?.openingBalance ?? 0.0,
        closingBalance: closingBalance,
        totalSales: allSales.length,
        payments: payments);

    MyLogUtils.logDebug(
        "counterClosingDetails : ${counterClosingDetails.toJson()}");

    var response =
        ShiftDetailsResponse(counterClosingDetails: counterClosingDetails);
    return response;
  }

  Future<double> getCashMovementAmount(OpenCounterRequest? request) async {
    var salesOfflineData = locator.get<OfflineCashMovementDataApi>();
    var cashMovements =
        await salesOfflineData.get(request?.openedByPosAt ?? '');

    double amount = 0.0;
    for (var element in cashMovements) {
      if (element.typeId == cashOutTypeId) {
        amount = amount - (element.amount ?? 0);
      }
      if (element.typeId == cashInTypeId) {
        amount = amount + (element.amount ?? 0);
      }
    }

    return amount;
  }
}
