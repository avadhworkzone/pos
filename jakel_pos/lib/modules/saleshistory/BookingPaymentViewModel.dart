import 'package:jakel_base/constants.dart';
import 'package:jakel_base/database/promoters/PromotersLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/printer/types/print_refund_booking_payment.dart';
import 'package:jakel_base/printer/types/print_topup_booking_payment.dart';
import 'package:jakel_base/restapi/bookingpayment/BookingPaymentApi.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsTopUpResponse.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingTopUpRequest.dart';
import 'package:jakel_base/restapi/promoters/model/PromotersResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:rxdart/rxdart.dart';

class BookingPaymentViewModel extends BaseViewModel {
  var responseSubject = PublishSubject<BookingPaymentsResponse>();

  Stream<BookingPaymentsResponse> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void getBookingPayments(int pageNo, int perPage, int customerId,
      int employeeId, int promoterId,String searchText) async {
    var api = locator.get<BookingPaymentApi>();

    try {
      var response = await api.getBookingPayments(
          pageNo, perPage, customerId, employeeId, promoterId,searchText, null, null);
      responseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("getBookingPayments exception $e");
      responseSubject.sink.addError(e);
    }
  }

  Future<List<Promoters>> getPromoters() async {
    var api = locator.get<PromotersLocalApi>();
    return await api.getAll();
  }

  String getStatus(BookingPayments sale) {
    return sale.status ?? noData;
  }

  String getCustomerName(BookingPayments sale) {
    return sale.customer?.firstName ?? noData;
  }

  String getCashier(BookingPayments sale) {
    return sale.cashier?.firstName ?? noData;
  }

  String getCounter(BookingPayments sale) {
    return sale.counter?.name ?? noData;
  }

  String getDateTime(BookingPayments sale) {
    return sale.createdAt ?? noData;
  }

  String getTotalAmount(BookingPayments sale) {
    return getOnlyReadableAmount(sale.totalAmount ?? 0.0);
  }

  String getAvailableAmount(BookingPayments sale) {
    return getOnlyReadableAmount(sale.availableAmount ?? 0.0);
  }

  bool getIsActive(BookingPayments sale) {
    return ((sale.status??"USED")=="ACTIVE")?true:false;
  }

  bool getIsBookingPaymentProducts(BookingPayments sale) {
    return ((sale.products??[]).isNotEmpty)?true:false;
  }

  String getTotalItems(BookingPayments sale) {
    if (sale.products != null) {
      return "${sale.products?.length}";
    }
    return "0";
  }

  // String getPaymentTypes(Sales sale) {
  //   String paymentType = "";
  //   if (sale.payments != null) {
  //     for (Payments payment in sale.payments!) {
  //       if (payment.paymentType != null) {
  //         paymentType = "$paymentType ${payment.paymentType!.name!}";
  //       }
  //     }
  //   }
  //   return paymentType;
  // }

  String getSaleItemName(BookingProducts item) {
    return item.productName ?? "";
  }

  String getSaleItemQty(BookingProducts item) {
    return '${item.quantity ?? ""}';
  }


  Future<BookingPaymentsTopUpResponse> bookingPaymentsRefund(BookingTopUpRequest mBookingTopUpRequest) async {
    var api = locator.get<BookingPaymentApi>();
    BookingPaymentsTopUpResponse bookingPaymentsTopUpResponse = BookingPaymentsTopUpResponse();
    try {
      bookingPaymentsTopUpResponse = await api.postBookingTopUp(mBookingTopUpRequest);
      if(bookingPaymentsTopUpResponse.bookingPaymentTopUp!=null) {
        await printTopUpBookingPayment(
            "Booking Payment TopUp",
            bookingPaymentsTopUpResponse.bookingPaymentTopUp! , false);
      }
    } catch (e) {
      MyLogUtils.logDebug("getEmployees exception $e");
    }
    return bookingPaymentsTopUpResponse;
  }
}
