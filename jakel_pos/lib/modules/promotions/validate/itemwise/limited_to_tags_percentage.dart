import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';

import '../base_promotion.dart';
import '../promotion_helper.dart';

class LimitedToTagsPercentage with BasePromotion {
  final tag = "LimitedToTagsPercentage";

  @override
  String samples() {
    return "Item Wise limited to tags & percentage";
  }

  @override
  String title() {
    return "ITEM_WISE_LIMITED_TO_TAGS_PERCENTAGE";
  }

  @override
  String description() {
    return "Item Wise limited to tags & percentage";
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
      if (_isProductInPromotionTag(promotions, element)) {
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
        if (_isProductInPromotionTag(promotions, element)) {
          Promotions? selectedPromotion = _getTagPromotion(element, promotions);
          if (selectedPromotion != null) {
            setItemWisePromotionDataToItem(
                element, promotions, null, selectedPromotion.percentage ?? 0);
          }
        }
      });
    }
    return cartSummary.cartItems ?? [];
  }

  double _totalDiscountAmount(CartSummary cartSummary, Promotions promotions) {
    double discount = 0.0;

    cartSummary.cartItems?.forEach((element) {
      var temp = CartItem.fromJson(element.toJson());
      if (_isProductInPromotionTag(promotions, temp)) {
        Promotions? selectedPromotion = _getTagPromotion(element, promotions);
        if (selectedPromotion != null) {
          discount = discount +
              (getPriceToCalculateAutomaticPromotion(temp) *
                  (selectedPromotion.percentage ?? 0) /
                  100);
        }
      }
    });

    return discount;
  }

  bool _isProductInPromotionTag(Promotions promotions, CartItem cartItem) {
    bool isTagAvailable = false;

    // Already item wise promotion is applied
    if ((cartItem.itemWisePromotionData?.promotionId ?? 0) > 0) {
      return false;
    }

    if (cartItem.saleReturnsItemData != null) {
      return false;
    }

    Promotions? selectedPromotion = _getTagPromotion(cartItem, promotions);
    if (selectedPromotion != null && !cartItem.isComplementaryItem()) {
      isTagAvailable = true;
    }
    return isItemValidForPromotion(promotions, cartItem)
        ? isTagAvailable
        : false;
  }

  // Get product applicable promotion
  Promotions? _getTagPromotion(CartItem cartItem, Promotions promotions) {
    Promotions? promotion;
    for (var productTag in cartItem.product?.tags ?? []) {
      for (PromotionTags element in promotions.tags ?? []) {
        if (promotion == null) {
          if (element.id != null &&
              productTag.id != null &&
              (element.id == productTag.id)) {
            promotion = promotions;
          }
        }
      }
    }
    return promotion;
  }

  bool _notValidForThisCart(CartSummary cartSummary, Promotions promotions) {
    return notValidForThisCart(tag, cartSummary, promotions);
  }
}
