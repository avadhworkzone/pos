import 'package:flutter/cupertino.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/bookingpayment/BookingPaymentApi.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsRefundResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingRefundRequest.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';

class RefundBookingPaymentViewModel extends BaseViewModel {
  /// Booking Payments Refund
  bool isActiveBookingPayments(BookingPayments selectedBookingPayments) {
    return selectedBookingPayments.status.toString().toUpperCase() == "ACTIVE";
  }

  Future<BookingPaymentsRefundResponse> bookingPaymentsRefund(
      BookingRefundRequest mBookingRefundRequest, BuildContext context) async {
    var api = locator.get<BookingPaymentApi>();

    try {
      var response = await api.getBookingRefund(mBookingRefundRequest);
      return response;
    } catch (e) {
      MyLogUtils.logDebug("getEmployees exception $e");
    }
    return BookingPaymentsRefundResponse();
  }
}
