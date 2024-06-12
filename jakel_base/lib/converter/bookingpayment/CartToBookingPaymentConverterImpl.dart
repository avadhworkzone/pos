import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';

import '../../restapi/sales/model/history/SalesResponse.dart';
import 'CartToBookingPaymentConverter.dart';

class CartToBookingPaymentConverterImpl extends CartToBookingPaymentConverter {
  @override
  Future<BookingPayments?> getBookingPaymentFromCart(CartSummary cartSummary) {
    List<int> promoterIds = List.empty(growable: true);

    cartSummary.promoters?.forEach((element) {
      promoterIds.add(element.id ?? 0);
    });

    BookingPayments bookingPayments = BookingPayments(
        offlineId: cartSummary.offlineSaleId,
        totalAmount: cartSummary.getPaidAmount(),
        availableAmount: cartSummary.getPaidAmount(),
        promoters: cartSummary.promoters,
        status: "ACTIVE",
        billReferenceNumber: cartSummary.billReferenceNumber,
        createdAt: cartSummary.happenedAt,
        products: _getBookingProducts(cartSummary),
        payments: _getPayments(cartSummary),
        customer: cartSummary.customers == null
            ? null
            : UserDetails.fromJson(cartSummary.customers!.toJson()));

    return Future(() => bookingPayments);
  }

  List<BookingProducts> _getBookingProducts(CartSummary cartSummary) {
    List<BookingProducts> saleItems = List.empty(growable: true);
    cartSummary.cartItems?.forEach((element) {
      if (element.product != null) {
        saleItems.add(BookingProducts(
            quantity: getInValue(element.qty ?? 0),
            productName: element.product?.name,
            promoters: element.promoters,
            articleNumber: element.product?.articleNumber,
            productId: element.product?.id));
      }
    });
    return saleItems;
  }

  List<BookingPaymentType> _getPayments(CartSummary cartSummary) {
    List<BookingPaymentType>? payments = List.empty(growable: true);

    cartSummary.payments?.forEach((element) {
      BookingPaymentType payment = BookingPaymentType(
          paymentType: element.paymentType?.name,
          amount: element.amount,
          remarks: null,
          createdAt: null);
      payments.add(payment);
    });
    return payments;
  }
}
