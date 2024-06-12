import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';

import '../../database/sale/model/CartSummary.dart';

abstract class CartToBookingPaymentConverter {
  Future<BookingPayments?> getBookingPaymentFromCart(CartSummary cartSummary);
}
