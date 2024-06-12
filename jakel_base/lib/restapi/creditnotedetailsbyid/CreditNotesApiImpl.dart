import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/counters/model/CreditNotesRefundRequest.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesApiResponse.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesListApiResponse.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesRefundResponce.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import 'CreditNotesApi.dart';

class CreditNotesApiImpl extends BaseApi with CreditNotesApi {
  @override
  Future<CreditNotesListApiResponse> getCreditNotesList(int pageNo, int perPage,
      int customerId, int employeeId) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url = "$masterUrl$getCreditNoteList?";

    if (pageNo > 0) {
      url = "${url}page=$pageNo";
    }

    if (perPage > 0) {
      url = "$url&per_page=$perPage";
    }

    if (customerId > 0) {
      url = "$url&member_id=$customerId";
    }

    if (employeeId > 0) {
      url = "$url&employee_id=$employeeId";
    }

    MyLogUtils.logDebug("getCreditNotesListById Url : $url");

    Response response = await dio.get(url);

    MyLogUtils.logDebug("getCreditNotesListById statusCode : ${response.statusCode}");
    MyLogUtils.logDebug("getCreditNotesListById data : ${response.data}");

    if (response.statusCode == 200) {
        return CreditNotesListApiResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<CreditNotesApiResponse> getCreditNotesDetails(
      String creditNotesDetailsByIdId) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url = "$masterUrl$getCreditNoteDetails$creditNotesDetailsByIdId";

    MyLogUtils.logDebug("getCreditNotesDetailsById Url : $url");

    Response response = await dio.get(url);

    MyLogUtils.logDebug(
        "getCreditNotesDetailsById statusCode : ${response.statusCode}");

    if (response.statusCode == 200) {
      MyLogUtils.logDebug(
          "getCreditNotesDetailsById response : ${response.data}");
      var creditNotesApiResponse =
      CreditNotesApiResponse.fromJson(response.data);
      return creditNotesApiResponse;
    } else {
      return CreditNotesApiResponse();
    }
  }

  @override
  Future<CreditNotesRefundResponse> getCreditNotesRefund(CreditNotesRefundRequest mCreditNotesRefundRequest) async{
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url = "$masterUrl$creditNoteRefund${mCreditNotesRefundRequest.paymentTypeId}/refund/";

    MyLogUtils.logDebug("CreditNotesRefundResponse Url : $url");

    FormData formData = FormData.fromMap({
      "payment_type_id": mCreditNotesRefundRequest.refundPaymentTypeId,
      "amount": mCreditNotesRefundRequest.amount,
      "store_manager_id": mCreditNotesRefundRequest.storeManagerId,
      "passcode": mCreditNotesRefundRequest.passcode,
    });

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug(
        "CreditNotesRefundResponse statusCode : ${response.statusCode}");

    if (response.statusCode == 200) {
      MyLogUtils.logDebug(
          "CreditNotesRefundResponse response : ${response.data}");
      CreditNotesRefundResponse creditNotesRefundApiResponse = CreditNotesRefundResponse.fromJson(response.data);
      return creditNotesRefundApiResponse;
    } else {
      return CreditNotesRefundResponse();
    }
  }

}
