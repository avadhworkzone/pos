import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartItemPrice.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/database/sale/model/sale_returns_data.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

CartSummary addReturnItemsToCart(
    CartSummary cartSummary, SaleReturnsData? returnsData) {
  returnsData?.returnItems?.forEach((element) {
    final cartItem = CartItem();
    cartItem.product = element.product;
    cartItem.saleReturnsItemData = element;
    cartItem.qty = element.qty;
    cartSummary.cartItems!.add(cartItem);
  });

  if (returnsData?.isExchange == null || returnsData?.isExchange == false) {
    cartSummary.isExchange = false;
    cartSummary.isReturns = true;
  } else {
    cartSummary.isExchange = returnsData?.isExchange;
    cartSummary.isReturns = false;
  }

  cartSummary.customers = returnsData?.customers;

  if (returnsData?.employees != null) {
    cartSummary.employees = returnsData?.employees;
  }
  return cartSummary;
}

CartItemPrice getCartItemPriceForGivenQtyInReturnsOrExchange(
    CartItemPrice? price, double qtyForGivenPrice, double expectedQty) {
  MyLogUtils.logDebug(
      "getCartItemPriceForGivenQtyInReturnsOrExchange price:  ${price?.toJson()}");
  MyLogUtils.logDebug(
      "getCartItemPriceForGivenQtyInReturnsOrExchange qtyForGivenPrice:  $qtyForGivenPrice");
  MyLogUtils.logDebug(
      "getCartItemPriceForGivenQtyInReturnsOrExchange expectedQty:  $expectedQty");

  double nextCalculationPrice = price?.nextCalculationPrice ?? 0;
  double subTotal = (price?.subTotal ?? 0) / qtyForGivenPrice;
  double taxableAmount = (price?.taxableAmount ?? 0) / qtyForGivenPrice;
  double totalDiscountAmount =
      (price?.totalDiscountAmount ?? 0) / qtyForGivenPrice;
  double originalPrice = (price?.originalPrice ?? 0) / qtyForGivenPrice;
  double totalAmount = (price?.totalAmount ?? 0) / qtyForGivenPrice;
  double taxAmount = (price?.taxAmount ?? 0) / qtyForGivenPrice;

  return CartItemPrice(
      nextCalculationPrice: nextCalculationPrice,
      subTotal: subTotal * expectedQty,
      taxableAmount: taxableAmount * expectedQty,
      totalDiscountAmount: totalDiscountAmount * expectedQty,
      originalPrice: originalPrice * expectedQty,
      totalAmount: totalAmount * expectedQty,
      taxAmount: taxAmount * expectedQty,
      priceForThisQty: expectedQty);
}
