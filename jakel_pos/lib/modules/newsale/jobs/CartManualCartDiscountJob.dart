import 'package:jakel_base/database/sale/model/CartSummary.dart';

cartManualCartDiscountJob(CartSummary cartSummary) {
  double discountPercentage =
      cartSummary.cartCustomDiscount?.discountPercentage ?? 0;
  if (discountPercentage > 0) {
    cartSummary.cartItems?.forEach((element) {
      // Get Current Step Total Price Per Unit
      double totalItemPricePerUnit =
          (element.cartItemPrice?.nextCalculationPrice ?? 0);

      // Get Total Discount Amount Per Unit
      double totalDiscountAmountPerUnit =
          totalItemPricePerUnit * discountPercentage / 100;

      // Get New Price after discount is applied
      double newPricePerUnit =
          totalItemPricePerUnit - totalDiscountAmountPerUnit;

      // Set the cart discount amount
      element.cartItemPrice?.setManualCartDiscount(
          totalDiscountAmountPerUnit * (element.qty ?? 1));
      // Set the next calculation price
      element.cartItemPrice?.setNextCalculationPrice(newPricePerUnit);
    });
  }
  return cartSummary;
}
