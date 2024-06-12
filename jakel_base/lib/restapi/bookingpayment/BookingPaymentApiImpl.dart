import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/bookingpayment/BookingPaymentApi.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsRefundResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsTopUpResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingRefundRequest.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingTopUpRequest.dart';
import 'package:jakel_base/restapi/bookingpayment/model/ResetBookingRequest.dart';
import 'package:jakel_base/restapi/bookingpayment/model/ResetBookingResponse.dart';

import 'package:jakel_base/utils/MyLogUtils.dart';

import 'model/NewBookingRequest.dart';

class BookingPaymentApiImpl extends BaseApi with BookingPaymentApi {

  @override
  Future<ResetBookingResponse> resetBookingsProducts(
      int bookingPaymentsId,ResetBookingRequest mResetBookingRequest) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url = "$masterUrl$resetBookingPaymentsList$bookingPaymentsId";

    MyLogUtils.logDebug("postResetBookingPayments Url : $url");

    MyLogUtils.logDebug("postResetBookingPayments toJson : ${mResetBookingRequest.toJson()}");

    FormData formData = FormData.fromMap(mResetBookingRequest.toJson(), ListFormat.multiCompatible);
    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug("postResetBookingPayments statusCode : ${response.statusCode}");

    MyLogUtils.logDebug("postResetBookingPayments data : ${response.data}");

    if (response.statusCode == 200) {
      return ResetBookingResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<BookingPaymentsResponse> storeNewBooking(
      NewBookingRequest request) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = "$masterUrl$newBookingPayment";

    MyLogUtils.logDebug("storeNewBooking  url : $url");

    FormData formData =
        FormData.fromMap(request.toJson(), ListFormat.multiCompatible);

    for (var element in formData.fields) {
      MyLogUtils.logDebug(
          "storeNewBooking  request element : ${element.key} = ${element.value}");
    }

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug("storeNewBooking response : ${response.data}");

    if (response.statusCode == 200) {
      return BookingPaymentsResponse.fromJson(response.data);
    }

    if (response.statusCode == 412) {
      return BookingPaymentsResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<BookingPaymentsResponse> getBookingPayments(
      int pageNo,
      int perPage,
      int customerId,
      int employeeId,
      int promoterId,
      String? searchText,
      String? fromDate,
      String? toDate) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url = "$masterUrl$bookingPaymentsList?";

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

    if (fromDate != null) {
      url = "$url&from_date=$fromDate";
    }

    if (toDate != null) {
      url = "$url&to_date=$toDate";
    }

    if (promoterId > 0) {
      url = "$url&promoter_id=$promoterId";
    }
    if ((searchText??"").isNotEmpty) {
      url = "$url&search_text=$searchText";
    }

    MyLogUtils.logDebug("getBookingPayments Url : $url");

    Response response = await dio.get(url);

    MyLogUtils.logDebug("getBookingPayments statusCode : ${response.data}");

    if (response.statusCode == 200) {
      return BookingPaymentsResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<BookingPaymentsRefundResponse> getBookingRefund(
      BookingRefundRequest mBookingRefundRequest) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url =
        "$masterUrl$bookingPaymentsRefund${mBookingRefundRequest.paymentTypeId}/refund/";

    MyLogUtils.logDebug("getBookingRefund Url : $url");

    FormData formData = FormData.fromMap({
      "payment_type_id": mBookingRefundRequest.refundPaymentTypeId,
      "amount": mBookingRefundRequest.amount,
    });

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug("getBookingRefund statusCode : ${response.statusCode}");

    if (response.statusCode == 200) {
      MyLogUtils.logDebug("getBookingRefund response : ${response.data}");
      var bookingRefundApiResponse =
          BookingPaymentsRefundResponse.fromJson(response.data);
      return bookingRefundApiResponse;
    } else {
      return BookingPaymentsRefundResponse();
    }
  }

  @override
  Future<BookingPaymentsTopUpResponse> postBookingTopUp(
      BookingTopUpRequest mBookingTopUpRequest) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url =
        "$masterUrl$bookingPaymentsRefund${mBookingTopUpRequest.selectedBookingPaymentId}/top-up/";

    MyLogUtils.logDebug("postBookingTopUp Url : $url");

    FormData formData = FormData.fromMap({
      "payment_type_id": mBookingTopUpRequest.paymentTypeId,
      "amount": mBookingTopUpRequest.amount,
    });

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug("postBookingTopUp statusCode : ${response.statusCode}");

    if (response.statusCode == 200) {
      MyLogUtils.logDebug("postBookingTopUp response : ${jsonEncode(response.data)}");
      var bookingPaymentsTopUpResponse =
      BookingPaymentsTopUpResponse.fromJson(response.data);
      return bookingPaymentsTopUpResponse;
    } else {
      return BookingPaymentsTopUpResponse();
    }
  }
}
