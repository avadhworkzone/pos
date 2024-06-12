import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';

import '../base_promotion.dart';
import '../promotion_helper.dart';

class LimitedToCategoriesPercentage with BasePromotion {
  final tag = "LimitedToCategoriesPercentage";

  @override
  String samples() {
    return "Item Wise limited to categories & percentage";
  }

  @override
  String title() {
    return "ITEM_WISE_LIMITED_TO_CATEGORIES_PERCENTAGE";
  }

  @override
  String description() {
    return "Item Wise limited to categories & percentage";
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
      if (_isProductInPromotionCategory(promotions, element)) {
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
        if (_isProductInPromotionCategory(promotions, element)) {
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
      if (_isProductInPromotionCategory(promotions, temp)) {
        discount = discount +
            (getPriceToCalculateAutomaticPromotion(temp) *
                discountPercentage /
                100);
      }
    });

    return discount;
  }

  bool _isProductInPromotionCategory(Promotions promotions, CartItem cartItem) {
    bool isCategoryAvailable = false;

    // Already item wise promotion is applied
    if ((cartItem.itemWisePromotionData?.promotionId ?? 0) > 0) {
      return false;
    }

    if (cartItem.saleReturnsItemData != null) {
      return false;
    }

    cartItem.product?.categories?.forEach((element) {
      if (promotions.categories != null &&
          promotions.categories!.contains(element.id) &&
          !cartItem.isComplementaryItem()) {
        isCategoryAvailable = true;
      }
    });
    return isItemValidForPromotion(promotions, cartItem)
        ? isCategoryAvailable
        : false;
  }

  bool _notValidForThisCart(CartSummary cartSummary, Promotions promotions) {
    return notValidForThisCart(tag, cartSummary, promotions);
  }
}
