import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_pos/modules/promotions/validate/base_promotion.dart';
import 'package:jakel_pos/modules/promotions/validate/promotion_helper.dart';

class CartWideFlat with BasePromotion {
  final tag = "CartWideFlat";

  @override
  String title() {
    return "Cart Wide Automatic Percentage";
  }

  @override
  String description() {
    return "Cart Wide Automatic Flat";
  }

  @override
  String samples() {
    return "Cart Wide Automatic Flat";
  }

  @override
  bool isCardWide() {
    return true;
  }

  @override
  bool isItemWise() {
    return false;
  }

  @override
  List<CartItem> applyDiscount(CartSummary cartSummary, Promotions promotions) {
    if (notValidForThisCart(tag, cartSummary, promotions)) {
      return cartSummary.cartItems ?? [];
    }

    double totalPayableAmount = getPayableAmount(promotions, cartSummary);

    var tier = _getTierForCartWide(totalPayableAmount, promotions);

    if (getDiscountAmount(cartSummary, promotions) > 0) {
      double flatAmount = tier?.flatAmount ?? 0;
      double tierDiscountPercentage = (flatAmount * 100) / totalPayableAmount;

      MyLogUtils.logDebug(
          "$tag, tierDiscountPercentage : $tierDiscountPercentage");

      applyDiscountToCartItems(promotions, cartSummary, tierDiscountPercentage);
    }
    return cartSummary.cartItems ?? [];
  }

  void applyDiscountToCartItems(Promotions promotions, CartSummary cartSummary,
      double tierDiscountPercentage) {
    cartSummary.cartItems?.forEach((element) {
      if (isItemValidForPromotion(promotions, element)) {
        double totalItemPricePerUnit =
            getPriceToCalculateAutomaticPromotion(element);

        double totalDiscountAmountPerUnit =
            totalItemPricePerUnit * tierDiscountPercentage / 100;

        double newPricePerUnit =
            totalItemPricePerUnit - totalDiscountAmountPerUnit;

        // Set the cart discount amount
        element.cartItemPrice?.setAutomaticCartDiscount(
            totalDiscountAmountPerUnit * (element.qty ?? 1));
        // Set the next calculation price
        element.cartItemPrice?.setNextCalculationPrice(newPricePerUnit);
      }
    });
  }

  @override
  bool isValidDiscountForSale(CartSummary cartSummary, Promotions promotions) {
    if (notValidForThisCart(tag, cartSummary, promotions)) {
      return false;
    }

    double totalPayableAmount = getPayableAmount(promotions, cartSummary);

    var tier = _getTierForCartWide(totalPayableAmount, promotions);

    if (tier == null) {
      return false;
    }
    return true;
  }

  @override
  double getDiscountAmount(CartSummary cartSummary, Promotions promotions) {
    if (notValidForThisCart(tag, cartSummary, promotions)) {
      return 0.0;
    }

    double totalPayableAmount = getPayableAmount(promotions, cartSummary);

    var tier = _getTierForCartWide(totalPayableAmount, promotions);

    if (tier != null) {
      return _totalDiscountAmount(cartSummary, promotions, tier);
    }

    return 0.0;
  }

  double _totalDiscountAmount(
      CartSummary cartSummary, Promotions promotions, PromotionTiers tiers) {
    double flatAmount = tiers.flatAmount ?? 0;
    return flatAmount;
  }

  PromotionTiers? _getTierForCartWide(double subTotal, Promotions promotions) {
    PromotionTiers? tier;
    promotions.promotionTiers?.forEach((element) {
      if (element.minimumSpendAmount != null &&
          subTotal >= element.minimumSpendAmount!) {
        tier = element;
      }
    });
    return tier;
  }

  double getPayableAmount(Promotions promotions, CartSummary cartSummary) {
    double payableAmount = 0.0;
    cartSummary.cartItems?.forEach((element) {
      if (isItemValidForPromotion(promotions, element)) {
        payableAmount = payableAmount +
            (getPriceToCalculateAutomaticPromotion(element) *
                (element.qty ?? 1));
      }
    });

    return payableAmount;
  }
}
