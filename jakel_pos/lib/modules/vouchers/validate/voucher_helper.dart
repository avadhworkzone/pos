// This is used for voucher generation validation.
import 'package:jakel_base/database/sale/model/CartSummary.dart';

double getTotalForVoucherGenerationValidation(CartSummary cartSummary) {
  return cartSummary.cartPrice?.total ?? 0;
}

bool isDreamPriceAvailableInThisCart(CartSummary cartSummary) {
  var result = false;
  cartSummary.cartItems?.forEach((element) {
    if (!result && (element.cartItemDreamPriceData?.dreamPriceId ?? 0) > 0) {
      result = true;
    }
  });
  return result;
}

bool isAutomaticItemWisePromotionAvailableInThisCart(CartSummary cartSummary) {
  var result = false;
  cartSummary.cartItems?.forEach((element) {
    if (!result && (element.cartItemPrice?.automaticItemDiscount ?? 0) > 0) {
      result = true;
    }
  });
  return result;
}

bool isAutomaticCartWisePromotionAvailableInThisCart(CartSummary cartSummary) {
  var result = false;
  cartSummary.cartItems?.forEach((element) {
    if (!result && (element.cartItemPrice?.automaticCartDiscount ?? 0) > 0) {
      result = true;
    }
  });
  return result;
}
