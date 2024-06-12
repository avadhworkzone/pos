import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartItemPrice.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/database/sale/model/sale_booking_returns_data.dart';
import 'package:jakel_base/database/sale/model/sale_returns_data.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';

CartSummary addResetBookingItemsToCart(
    CartSummary cartSummary, BookingItemsResetData? bookingSaleReturnsData) {

  bookingSaleReturnsData?.returnItems?.forEach((element) {
    final cartItem = CartItem();
    cartItem.product = element.returnItems;
    cartItem.qty = getDoubleValue(element.quantity);
    cartItem.promoters = element.promoters;
    cartSummary.cartItems!.add(cartItem);
  });

  cartSummary.returnBookingSaleId =
      bookingSaleReturnsData?.returnId ?? 0;
  cartSummary.promoters = bookingSaleReturnsData?.returnPromoters;
  cartSummary.promoters = bookingSaleReturnsData?.returnPromoters;
  cartSummary.customers = bookingSaleReturnsData?.customers;
  cartSummary.isBookingSale = true;
  cartSummary.isBookingItemReset = true;
  return cartSummary;
}
