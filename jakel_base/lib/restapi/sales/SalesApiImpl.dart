import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/sales/SalesApi.dart';
import 'package:jakel_base/restapi/sales/model/CancelLayawayAmountRequest.dart';
import 'package:jakel_base/restapi/sales/model/HoldSaleTypesResponse.dart';
import 'package:jakel_base/restapi/sales/model/NewOnHoldSaleRequest.dart';
import 'package:jakel_base/restapi/sales/model/UpdateLayawayAmountRequest.dart';
import 'package:jakel_base/restapi/sales/model/cancel_layaway/CancelLayawayResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/restapi/sales/model/NewSaleRequest.dart';
import 'package:jakel_base/restapi/sales/model/SaleReturnsResponse.dart';
import 'package:jakel_base/restapi/sales/model/void/VoidSaleReasonResponse.dart';
import 'package:jakel_base/restapi/sales/model/void/VoidSaleRequest.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/restapi/sales/model/UpdateLayawayLoyaltyPointsRequest.dart';

import 'model/history/SaveSaleResponse.dart';

class SalesApiImpl extends BaseApi with SalesApi {
  @override
  Future<SaleReturnsResponse> getSaleReturnsReason() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + saleReturnReasonsUrl;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return SaleReturnsResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<SaveSaleResponse> saveNewSale(NewSaleRequest request) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + saveSale;

    MyLogUtils.logDebug("saveNewSale  url : $url");

    MyLogUtils.logDebug("saveNewSale  request : ${jsonEncode(request)}");

    FormData formData =
        FormData.fromMap(request.toJson(), ListFormat.multiCompatible);

    for (var element in formData.fields) {
      MyLogUtils.logDebug(
          "saveNewSale  request element : ${element.key} = ${element.value}");
    }

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug("saveNewSale response : ${response.data}");

    if (response.statusCode == 200) {
      var saveSaleResponse = SaveSaleResponse.fromJson(response.data);
      if (saveSaleResponse.sale?.hasMismatch != null &&
          saveSaleResponse.sale?.hasMismatch == true) {
        MyLogUtils.logDebug("-----------------------------------------------");
        MyLogUtils.logSaleMismatch(
            "saleMismatches for receipt ${saveSaleResponse.sale?.offlineSaleId} is : ${saveSaleResponse.sale?.saleMismatches}");
        MyLogUtils.logDebug("-----------------------------------------------");
      }
      MyLogUtils.logDebug("saveNewSale response : ${response.data}");

      return saveSaleResponse;
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<SalesResponse> getSalesHistory(
      int pageNo,
      int perPage,
      int customerId,
      int employeeId,
      String? fromDate,
      String? toDate,
      String? searchText,
      int? counterId) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url = "$masterUrl$getRegularAndCompletedLayawaySales?";

    if (pageNo > 0) {
      url = "${url}page=$pageNo";
    }

    if (perPage > 0) {
      url = "$url&per_page=$perPage";
    }

    if (customerId > 0) {
      url = "$url&customer_id=$customerId";
    }

    if (employeeId > 0) {
      url = "$url&employee_id=$employeeId";
    }

    if (fromDate != null) {
      url = "$url&from_date=$fromDate";
    }

    if (toDate != null) {
      url = "$url&to_date=$toDate";
    }

    if (searchText != null) {
      url = "$url&search_text=$searchText";
    }

    if (counterId != null) {
      url = "$url&counter_id=$counterId";
    }

    MyLogUtils.logDebug("getSalesHistory Url : $url");
    Response response = await dio.get(url);

    MyLogUtils.logDebug("getSalesHistory statusCode : ${response.statusCode}");

    MyLogUtils.logDebug("getSalesHistory data : ${response.data}");

    if (response.statusCode == 200) {
      return SalesResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<SalesResponse> getSaleById(String saleId) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url = "$masterUrl$getSaleDetails";

    url = "$url$saleId";

    MyLogUtils.logDebug("getSaleById Url : $url");

    Response response = await dio.get(url);

    MyLogUtils.logDebug("getSaleById statusCode : ${response.statusCode}");

    if (response.statusCode == 200) {
      var salesResponse = SalesResponse.fromJson(response.data);

      if (salesResponse.sale != null) {
        List<Sales>? salesList = List.empty(growable: true);
        salesList.add(salesResponse.sale!);

        return SalesResponse(
            currentPage: 1,
            totalRecords: 1,
            lastPage: 1,
            perPage: 1,
            sales: salesList);
      }
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<SalesResponse> getLayawaySales(int pageNo, int perPage, int customerId,
      int employeeId, String? fromDate, String? toDate) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url = "$masterUrl$getPendingLayawaySales?";

    // if (pageNo > 0) {
    //   url = "${url}page=$pageNo";
    // }
    //
    // if (perPage > 0) {
    //   url = "${url}&per_page=$perPage";
    // }

    if (customerId > 0) {
      url = "$url&customer_id=$customerId";
    }

    if (employeeId > 0) {
      url = "$url&employee_id=$employeeId";
    }

    if (fromDate != null) {
      url = "$url&from_date=$fromDate";
    }

    if (toDate != null) {
      url = "$url&to_date=$toDate";
    }

    MyLogUtils.logDebug("getLayawaySales Url : $url");
    Response response = await dio.get(url);

    MyLogUtils.logDebug("getLayawaySales statusCode : ${response.statusCode}");

    if (response.statusCode == 200) {
      MyLogUtils.logDebug("getLayawaySales data : ${response.data}");
      return SalesResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<VoidSaleReasonResponse> getVoidSaleReason() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + voidSaleReasonsUrl;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return VoidSaleReasonResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<SaveSaleResponse> voidSale(int saleId, VoidSaleRequest request) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = "$masterUrl$voidASaleUrl/$saleId/void";

    MyLogUtils.logDebug("voidSale  url : $url");

    MyLogUtils.logDebug("voidSale request : ${request.toJson()}");

    FormData formData = FormData.fromMap(request.toJson());

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug("void sale statusCode : ${response.statusCode}");
    MyLogUtils.logDebug("void sale response : ${response.data}");

    if (response.statusCode == 200) {
      return SaveSaleResponse.fromJson(response.data);
    }

    if (response.statusCode == 412) {
      return SaveSaleResponse.fromJson(response.data);
    }

    if (response.statusCode == 404) {
      return SaveSaleResponse(message: "Sale already voided");
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<SalesResponse> getVoidSalesHistory(int pageNo, int perPage,
      int customerId, int employeeId, String? fromDate, String? toDate) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url = "$masterUrl$getPaginatedVoidSaleList?";

    if (pageNo > 0) {
      url = "${url}page=$pageNo";
    }

    if (perPage > 0) {
      url = "$url&per_page=$perPage";
    }

    if (customerId > 0) {
      url = "$url&customer_id=$customerId";
    }

    if (employeeId > 0) {
      url = "$url&employee_id=$employeeId";
    }

    if (fromDate != null) {
      url = "$url&from_date=$fromDate";
    }

    if (toDate != null) {
      url = "$url&to_date=$toDate";
    }

    MyLogUtils.logDebug("getVoidSalesHistory Url : $url");

    Response response = await dio.get(url);

    MyLogUtils.logDebug("getVoidSalesHistory statusCode : ${response.data}");

    if (response.statusCode == 200) {
      return SalesResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<SaveSaleResponse> updateLayawayAmount(
      int saleId, UpdateLayawayAmountRequest request) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = "$masterUrl$updateLayawaySale$saleId";

    MyLogUtils.logDebug("updateLayawayAmount  url : $url");

    MyLogUtils.logDebug("updateLayawayAmount request : ${request.toJson()}");

    FormData formData = FormData.fromMap(request.toJson());

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug("updateLayawayAmount sale response : ${response.data}");

    if (response.statusCode == 200) {
      return SaveSaleResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }


  @override
  Future<CancelLayawayResponse> cancelLayawayAmount(
      int saleId, CancelLayawayAmountRequest request) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = "$masterUrl$cancelLayawaySale$saleId";

    MyLogUtils.logDebug("cancelLayawayAmount  url : $url");

    MyLogUtils.logDebug("cancelLayawayAmount request : ${request.toJson()}");

    FormData formData = FormData.fromMap(request.toJson());

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug("cancelLayawayAmount sale response : ${jsonEncode(response.data)}");

    if (response.statusCode == 200) {
      return CancelLayawayResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<SaveSaleResponse> updateLayawayLoyaltyPoints(
      int saleId, UpdateLayawayLoyaltyPointsRequest request) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = "$masterUrl$updateLayawaySale$saleId";

    MyLogUtils.logDebug("updateLayawayAmount  url : $url");

    MyLogUtils.logDebug("updateLayawayAmount request : ${request.toJson()}");

    FormData formData = FormData.fromMap(request.toJson());

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug("updateLayawayAmount sale response : ${response.data}");

    if (response.statusCode == 200) {
      return SaveSaleResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<SalesResponse> getPendingLayawaySale(String saleId) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url = "$masterUrl$getPendingLayawaySaleById";

    url = "$url$saleId";

    MyLogUtils.logDebug("getPendingLayawaySale Url : $url");

    Response response = await dio.get(url);

    MyLogUtils.logDebug(
        "getPendingLayawaySale statusCode : ${response.statusCode} & message : ${response.statusMessage}");

    MyLogUtils.logDebug("getPendingLayawaySale data : ${response.data}");

    if (response.statusCode == 200) {
      return SalesResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<SalesResponse> getSaleReturnsHistory(int pageNo, int perPage,
      int customerId, int employeeId, String? fromDate, String? toDate,String? searchText) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url = "$masterUrl$getPaginatedSaleReturns?";

    if (pageNo > 0) {
      url = "${url}page=$pageNo";
    }

    if (perPage > 0) {
      url = "$url&per_page=$perPage";
    }

    if (customerId > 0) {
      url = "$url&customer_id=$customerId";
    }

    if (employeeId > 0) {
      url = "$url&employee_id=$employeeId";
    }

    if (fromDate != null) {
      url = "$url&from_date=$fromDate";
    }

    if (toDate != null) {
      url = "$url&to_date=$toDate";
    }

    if (searchText != null) {
      url = "$url&search_text=$searchText";
    }

    MyLogUtils.logDebug("getSalesHistory Url : $url");
    Response response = await dio.get(url);

    MyLogUtils.logDebug("getSalesHistory statusCode : ${response.statusCode}");

    if (response.statusCode == 200) {
      return SalesResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<bool> cancelHoldSale(NewOnHoldSaleRequest request) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + cancelHoldSaleUrl;

    MyLogUtils.logDebug("[HoldSale] cancelHoldSaleUrl  url : $url");
    MyLogUtils.logDebug("[HoldSale] cancelHoldSaleUrl  request : ${request.toJson()}");

    FormData formData =
        FormData.fromMap(request.toJson(), ListFormat.multiCompatible);

    for (var element in formData.fields) {
      MyLogUtils.logDebug(
          "[HoldSale] cancelHoldSaleUrl  request element : ${element.key} = ${element.value}");
    }

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug("[HoldSale] cancelHoldSaleUrl response : ${response.data}");

    if (response.statusCode == 200) {
      return true;
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<bool> completeHoldSale(NewOnHoldSaleRequest request) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + completeHoldSaleUrl;

    MyLogUtils.logDebug("[HoldSale] completeHoldSale  url : $url");

    MyLogUtils.logDebug("[HoldSale] completeHoldSale  request : ${request.toJson()}");

    FormData formData =
        FormData.fromMap(request.toJson(), ListFormat.multiCompatible);

    for (var element in formData.fields) {
      MyLogUtils.logDebug(
          "[HoldSale] completeHoldSale  request element : ${element.key} = ${element.value}");
    }

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug("[HoldSale] completeHoldSale response : ${response.data}");

    if (response.statusCode == 200) {
      return true;
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<bool> holdSale(NewOnHoldSaleRequest request) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + saveHoldSaleUrl;

    MyLogUtils.logDebug("[HoldSale] holdSale  url : $url");

    MyLogUtils.logDebug("[HoldSale] holdSale  request : ${request.toJson()}");

    FormData formData =
        FormData.fromMap(request.toJson(), ListFormat.multiCompatible);

    for (var element in formData.fields) {
      MyLogUtils.logDebug(
          "[HoldSale] holdSale  request element : ${element.key} = ${element.value}");
    }

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug("[HoldSale] holdSale response : ${response.data}");

    if (response.statusCode == 200) {
      return true;
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<bool> releaseHoldSale(NewOnHoldSaleRequest request) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + releasedHoldSaleUrl;

    MyLogUtils.logDebug("[HoldSale] releaseHoldSale  url : $url");

    MyLogUtils.logDebug("[HoldSale] releaseHoldSale  request : ${request.toJson()}");

    FormData formData =
        FormData.fromMap(request.toJson(), ListFormat.multiCompatible);

    for (var element in formData.fields) {
      MyLogUtils.logDebug(
          "[HoldSale] releaseHoldSale  request element : ${element.key} = ${element.value}");
    }

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug("[HoldSale] releaseHoldSale response : ${response.data}");

    if (response.statusCode == 200) {
      return true;
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<HoldSaleTypesResponse> getHoldSaleTypes() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + getHoldSaleTypesUrl;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return HoldSaleTypesResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

}
