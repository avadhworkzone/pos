import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsRefundResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsTopUpResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingTopUpRequest.dart';
import 'package:jakel_base/restapi/bookingpayment/model/ResetBookingRequest.dart';
import 'package:jakel_base/restapi/bookingpayment/model/ResetBookingResponse.dart';

import 'model/BookingRefundRequest.dart';
import 'model/NewBookingRequest.dart';

abstract class BookingPaymentApi {
  Future<BookingPaymentsResponse> getBookingPayments(
      int pageNo,
      int perPage,
      int customerId,
      int employeeId,
      int promoterId,
      String? searchText,
      String? fromDate,
      String? toDate);

  Future<BookingPaymentsResponse> storeNewBooking(NewBookingRequest request);

  Future<BookingPaymentsRefundResponse> getBookingRefund(
      BookingRefundRequest mBookingRefundRequest);

  Future<BookingPaymentsTopUpResponse> postBookingTopUp(BookingTopUpRequest mBookingTopUpRequest);

  Future<ResetBookingResponse> resetBookingsProducts(
      int bookingPaymentsId,ResetBookingRequest mResetBookingRequest);
}
