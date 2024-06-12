import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';

import '../base_promotion.dart';
import '../promotion_helper.dart';

class LimitedToBrandsPercentage with BasePromotion {
  final tag = "LimitedToBrandsPercentage";

  @override
  String samples() {
    return "Item Wise limited to brands & percentage";
  }

  @override
  String title() {
    return "ITEM_WISE_LIMITED_TO_BRANDS_PERCENTAGE";
  }

  @override
  String description() {
    return "Item Wise limited to brands & percentage";
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
    double discountPercentage = promotions.percentage ?? 0;
    if (getDiscountAmount(cartSummary, promotions) > 0) {
      cartSummary.cartItems?.forEach((element) {
        if (_isProductInPromotionBrand(promotions, element)) {
          setItemWisePromotionDataToItem(
              element, promotions, null, discountPercentage);
        }
      });
    }
    return cartSummary.cartItems ?? [];
  }

  double _totalDiscountAmount(CartSummary cartSummary, Promotions promotions) {
    double discount = 0.0;
    double discountPercentage = promotions.percentage ?? 0;

    cartSummary.cartItems?.forEach((element) {
      var temp = CartItem.fromJson(element.toJson());
      if (_isProductInPromotionBrand(promotions, temp)) {
        discount = discount +
            (getPriceToCalculateAutomaticPromotion(temp) *
                discountPercentage /
                100);
      }
    });

    return discount;
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

  bool _notValidForThisCart(CartSummary cartSummary, Promotions promotions) {
    return notValidForThisCart(tag, cartSummary, promotions);
  }
}
