import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';

import '../base_promotion.dart';
import '../promotion_helper.dart';

class LimitedToBrandsFlat with BasePromotion {
  final tag = "LimitedToBrandsFlat";

  @override
  String samples() {
    return "Item Wise limited to brand & flat";
  }

  @override
  String title() {
    return "LimitedToBrandsFlat";
  }

  @override
  String description() {
    return "Item Wise limited to brand & flat";
  }

  @override
  double getDiscountAmount(CartSummary cartSummary, Promotions promotions) {
    if (_notValidForThisCart(cartSummary, promotions)) {
      return 0.0;
    }
    return _totalDiscountAmount(cartSummary, promotions);
  }

  @override
  bool isCardWide() {
    return false;
  }

  @override
  bool isItemWise() {
    return true;
  }

  @override
  bool isValidDiscountForSale(CartSummary cartSummary, Promotions promotions) {
    if (_notValidForThisCart(cartSummary, promotions)) {
      return false;
    }
    bool isValid = false;
    cartSummary.cartItems?.forEach((element) {
      if (_isProductInPromotionBrand(promotions, element)) {
        isValid = true;
      }
    });
    return isValid;
  }

  @override
  List<CartItem> applyDiscount(CartSummary cartSummary, Promotions promotions) {
    if (_notValidForThisCart(cartSummary, promotions)) {
      return cartSummary.cartItems ?? [];
    }
    double flatAmount = promotions.flatAmount ?? 0.0;
    if (getDiscountAmount(cartSummary, promotions) > 0) {
      cartSummary.cartItems?.forEach((element) {
        if (_isProductInPromotionBrand(promotions, element)) {
          double discountPercentage = (flatAmount * (element.qty ?? 0) * 100) /
              getPriceToCalculateAutomaticPromotion(element);

          setItemWisePromotionDataToItem(
              element, promotions, null, discountPercentage);
        }
      });
    }
    return cartSummary.cartItems ?? [];
  }

  bool _isProductInPromotionBrand(Promotions promotions, CartItem cartItem) {
    bool isBrandAvailable = false;

    // Already item wise promotion is applied
    if ((cartItem.itemWisePromotionData?.promotionId ?? 0) > 0) {
      return false;
    }

    if (cartItem.saleReturnsItemData != null) {
      return false;
    }

    if (cartItem.isComplementaryItem()) {
      return false;
    }

    if (cartItem.product?.brand != null &&
        promotions.brands != null &&
        promotions.brands!.contains(cartItem.product?.brand?.id)) {
      isBrandAvailable = true;
    }

    return isItemValidForPromotion(promotions, cartItem)
        ? isBrandAvailable
        : false;
  }

  double _totalDiscountAmount(CartSummary cartSummary, Promotions promotions) {
    double discount = 0.0;
    double flatAmount = promotions.flatAmount ?? 0.0;

    cartSummary.cartItems?.forEach((element) {
      var temp = CartItem.fromJson(element.toJson());
      if (_isProductInPromotionBrand(promotions, temp)) {
        double discountPercentage =
            getDiscountPercentageFromFlat(element, flatAmount);
        discount = discount +
            (getPriceToCalculateAutomaticPromotion(temp) *
                discountPercentage /
                100);
      }
    });

    return discount;
  }

  bool _notValidForThisCart(CartSummary cartSummary, Promotions promotions) {
    return notValidForThisCart(tag, cartSummary, promotions);
  }
}
