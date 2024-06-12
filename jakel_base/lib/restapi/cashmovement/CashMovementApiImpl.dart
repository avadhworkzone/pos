import 'package:dio/dio.dart';
import 'package:jakel_base/database/offlinedata/OfflineCashMovementDataApi.dart';
import 'package:jakel_base/database/offlinedata/OfflineOpenCounterDataApi.dart';
import 'package:jakel_base/database/offlinedata/cashmovement/CashMovementRequest.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/cashmovement/model/CashMovementResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import '../../locator.dart';
import '../../utils/my_network_helper.dart';
import 'CashMovementApi.dart';
import 'model/CashMovementReasonResponse.dart';

class CashMovementApiImpl extends BaseApi with CashMovementApi {
  @override
  Future<CashMovementReasonResponse> getCashMovementReasons() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + cashMovementReasons;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return CashMovementReasonResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<CashMovementResponse> saveCashMovement(
      CashMovementRequest request) async {
    MyLogUtils.logDebug("saveCashMovement request : ${request.toJson()}");

    if (!await checkIsInternetConnected()) {
      return await saveOffline(request, false);
    }

    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + saveCashMovements;

    FormData formData = FormData.fromMap({
      "cash_movement_reason_id": request.reasonId,
      "cash_movement_type_id": request.typeId,
      "authorizer_id": request.authorizeId,
      "authorizer_type": request.authorizerType,
      "amount": request.amount,
      "happened_at": request.happenedAt,
    });

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug("saveCashMovement response : ${response.data}");

    if (response.statusCode == 200) {
      await saveOffline(request, true);
      return CashMovementResponse.fromJson(response.data);
    }

    if (response.statusCode == 412) {
      //return response.data['message'] ?? "Error";
      return CashMovementResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);

    return await saveOffline(request, false);
  }

  @override
  Future<CashMovementResponse> getAllCashMovements(
      int typeId, int pageNo, int perPage, bool onlyThisCounter) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url = "$masterUrl$cashMovements?";

    if (pageNo > 0) {
      url = "${url}page=$pageNo";
    }

    if (perPage > 0) {
      url = "$url&per_page=$perPage";
    }

    if (onlyThisCounter) {
      url = "$url&only_current_counter=1";
    } else {
      url = "$url&only_current_counter=0";
    }

    url = "$url&movement_type_id=$typeId";

    MyLogUtils.logDebug("getAllCashMovements Url : $url");

    Response response = await dio.get(url);

    MyLogUtils.logDebug(
        "getAllCashMovements statusCode : ${response.statusCode}");

    if (response.statusCode == 200) {
      return CashMovementResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  Future<CashMovementResponse> saveOffline(
      CashMovementRequest request, bool isSynced) async {
    MyLogUtils.logDebug(
        "Save CashMovement Offline isSynced $isSynced  & request : ${request.toJson()}");

    // Set open counter time using current opened counter in close counter request
    var api = locator.get<OfflineCashMovementDataApi>();
    var openDataCounterApi = locator.get<OfflineOpenCounterDataApi>();
    var openedCounter = await openDataCounterApi.getCurrentOpenedCounter();

    MyLogUtils.logDebug(
        "Save cash movement offline openedCounter : $isSynced && request : ${openedCounter?.toJson()}");

    request.openByPosAt = openedCounter?.openedByPosAt ?? '';

    if (isSynced) {
      request.isSynced = true;
    } else {
      request.isSynced = false;
    }

    MyLogUtils.logDebug(
        "Save CashMovement Offline isSynced $isSynced  & request : ${request.toJson()}");

    await api.save(request);

    return CashMovementResponse(
        cashMovement: CashMovements(
            amount: request.amount,
            authorizer: request.authorizer,
            cashMovementReason: request.reason,
            createdAt: request.happenedAt,
            type: ""));
  }
}
