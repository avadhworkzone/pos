import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_pos/modules/promotions/validate/base_promotion.dart';

import '../promotion_helper.dart';

class CartWidePercentage with BasePromotion {
  final tag = "CartWidePercentage";

  @override
  String description() {
    return "Cart Wide Automatic Percentage";
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
  String samples() {
    return "Cart Wide Automatic Percentage";
  }

  @override
  String title() {
    return "Cart Wide Automatic Percentage";
  }

  @override
  bool isValidDiscountForSale(CartSummary cartSummary, Promotions promotions) {
    if (_notValidForThisCart(cartSummary, promotions)) {
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
    if (_notValidForThisCart(cartSummary, promotions)) {
      return 0.0;
    }

    double totalPayableAmount = getPayableAmount(promotions, cartSummary);

    var tier = _getTierForCartWide(totalPayableAmount, promotions);

    if (tier != null) {
      return _totalDiscountAmount(cartSummary, promotions, tier);
    }

    return 0.0;
  }

  @override
  List<CartItem> applyDiscount(CartSummary cartSummary, Promotions promotions) {
    if (_notValidForThisCart(cartSummary, promotions)) {
      return cartSummary.cartItems ?? [];
    }

    double totalPayableAmount = getPayableAmount(promotions, cartSummary);

    var tier = _getTierForCartWide(totalPayableAmount, promotions);

    if (getDiscountAmount(cartSummary, promotions) > 0) {
      double tierDiscountPercentage = tier?.percentage ?? 0;

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

  double _totalDiscountAmount(
      CartSummary cartSummary, Promotions promotions, PromotionTiers tier) {
    double discount = 0.0;
    double tierDiscountPercentage = tier.percentage ?? 0;

    cartSummary.cartItems?.forEach((element) {
      if (isItemValidForPromotion(promotions, element)) {
        double totalItemPrice =
            getPriceToCalculateAutomaticPromotion(element) * (element.qty ?? 1);
        double totalDiscountAmount =
            totalItemPrice * tierDiscountPercentage / 100;
        discount = discount + totalDiscountAmount;
      }
    });

    return discount;
  }

  PromotionTiers? _getTierForCartWide(
      double payableAmount, Promotions promotions) {
    PromotionTiers? tier;
    promotions.promotionTiers?.forEach((element) {
      if (element.minimumSpendAmount != null &&
          payableAmount >= element.minimumSpendAmount!) {
        tier = element;
      }
    });
    return tier;
  }

  bool _notValidForThisCart(CartSummary cartSummary, Promotions promotions) {
    return notValidForThisCart(tag, cartSummary, promotions);
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
