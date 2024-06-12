import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import '../base_promotion.dart';
import '../promotion_helper.dart';
import '../promotions_group.dart';

class AmountBuyForXInPriceRangeGetYFlatOff with BasePromotion {
  final tag = "AmountBuyForXInPriceRangeGetYFlatOff";

  @override
  String samples() {
    return "ITEM_WISE_AS_PER_AMOUNT_LIMITED_TO_PRICE_FLAT";
  }

  @override
  String title() {
    return "Buy “X” amount between the price range and get “Y” flat amount.";
  }

  @override
  String description() {
    return "Buy “X” amount between the price range and get “Y” flat amount.";
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
  double getDiscountAmount(CartSummary cartSummary, Promotions promotions) {
    MyLogUtils.logDebug("$tag, getDiscountAmount ");

    double discountAmount = 0.0;

    if (_notValidForThisCart(cartSummary, promotions)) {
      return discountAmount;
    }

    if (promotions.promotionTiers == null) {
      return discountAmount;
    }

    cartSummary.cartItems?.forEach((element) {
      var selectedTier = _getPromotionTier(element, promotions);
      if ((selectedTier != null) &&
          _isAvailableInPromotion(promotions, element)) {
        discountAmount = discountAmount +
            (getPriceToCalculateAutomaticPromotion(element) *
                (selectedTier.flatAmount ?? 0.0) /
                100);
      }
    });

    MyLogUtils.logDebug("$tag, getDiscountAmount : $discountAmount ");
    return discountAmount;
  }

  @override
  bool isValidDiscountForSale(CartSummary cartSummary, Promotions promotions) {
    MyLogUtils.logDebug("$tag, isValidDiscountForSale ");
    if (_notValidForThisCart(cartSummary, promotions)) {
      return false;
    }

    if (promotions.promotionTiers == null) {
      return false;
    }

    PromotionTiers? selectedTier;
    cartSummary.cartItems?.forEach((element) {
      if (_isAvailableInPromotion(promotions, element)) {
        selectedTier ??= _getPromotionTier(element, promotions);
      }
    });
    return (selectedTier != null);
  }

  @override
  List<CartItem> applyDiscount(CartSummary cartSummary, Promotions promotions) {
    MyLogUtils.logDebug("$tag, applyDiscount ");

    if (_notValidForThisCart(cartSummary, promotions)) {
      return cartSummary.cartItems ?? [];
    }

    if (promotions.promotionTiers == null) {
      return cartSummary.cartItems ?? [];
    }

    int groupId = PromotionsGroup().getNewGroupId();

    //Iterate get products & add the discount flat amount
    cartSummary.cartItems?.forEach((element) {
      var selectedTier = _getPromotionTier(element, promotions);

      if ((selectedTier != null) &&
          _isAvailableInPromotion(promotions, element)) {
        double flatDiscountAmount = selectedTier.flatAmount ?? 0.0;
        double discountPercentage =
            getDiscountPercentageFromFlat(element, flatDiscountAmount);

        setItemWisePromotionDataToItem(
            element, promotions, groupId, discountPercentage);
      }
    });

    return cartSummary.cartItems ?? [];
  }

  // Get product promotion tier
  PromotionTiers? _getPromotionTier(CartItem cartItem, Promotions promotions) {
    PromotionTiers? tier;
    for (var element in promotions.promotionTiers ?? []) {
      if (tier == null) {
        if (element.minimumProductPrice != null &&
            (cartItem.cartItemPrice?.nextCalculationPrice ?? 0.0) >=
                element.minimumProductPrice! &&
            element.maximumProductPrice != null &&
            (cartItem.cartItemPrice?.nextCalculationPrice ?? 0.0) <=
                element.maximumProductPrice!) {
          tier = element;
        }
      }
    }
    return tier;
  }

  bool _notValidForThisCart(CartSummary cartSummary, Promotions promotions) {
    return notValidForThisCart(tag, cartSummary, promotions);
  }

  /// Check if item is available in promotion products
  bool _isAvailableInPromotion(Promotions promotions, CartItem element) {
    // Already item wise promotion is applied
    if ((element.itemWisePromotionData?.promotionId ?? 0) > 0) {
      return false;
    }

    if (element.saleReturnsItemData != null) {
      return false;
    }

    return isItemValidForPromotion(promotions, element) ? true : false;
  }
}
