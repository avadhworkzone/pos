import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import '../base_promotion.dart';
import '../promotion_helper.dart';

class LimitedToProductsPercentage with BasePromotion {
  final tag = "LimitedToProductsPercentage";

  @override
  String samples() {
    return "Item Wise limited to products & percentage";
  }

  @override
  String title() {
    return "ITEM_WISE_LIMITED_TO_PRODUCTS_PERCENTAGE";
  }

  @override
  String description() {
    return "Item Wise limited to products & percentage";
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
      if (_isProductInPromotion(promotions, element)) {
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

    MyLogUtils.logDebug(
        "LimitedToProductsPercentage apply discount discountPercentage: $discountPercentage");

    if (getDiscountAmount(cartSummary, promotions) > 0) {
      cartSummary.cartItems?.forEach((element) {
        if (_isProductInPromotion(promotions, element)) {
          setItemWisePromotionDataToItem(
              element, promotions, null, discountPercentage);
        }
      });
    }
    return cartSummary.cartItems ?? [];
  }

  bool _isProductInPromotion(Promotions promotions, CartItem element) {
    // Already item wise promotion is applied
    if ((element.itemWisePromotionData?.promotionId ?? 0) > 0) {
      return false;
    }

    if (element.saleReturnsItemData != null) {
      return false;
    }

    return isItemValidForPromotion(promotions, element)
        ? (promotions.products != null &&
            element.product != null &&
            promotions.products!.contains(element.product?.id) &&
            !element.isComplementaryItem())
        : false;
  }

  double _totalDiscountAmount(CartSummary cartSummary, Promotions promotions) {
    double discount = 0.0;
    double discountPercentage = promotions.percentage ?? 0;

    cartSummary.cartItems?.forEach((element) {
      var temp = CartItem.fromJson(element.toJson());
      if (_isProductInPromotion(promotions, temp)) {
        discount = discount +
            (getPriceToCalculateAutomaticPromotion(temp) *
                discountPercentage /
                100);
      }
    });

    MyLogUtils.logDebug(
        "LimitedToProductsPercentage _totalDiscountAmount : $discount");
    return discount;
  }

  bool _notValidForThisCart(CartSummary cartSummary, Promotions promotions) {
    return notValidForThisCart(tag, cartSummary, promotions);
  }
}
