import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartItemPromotionItemData.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import '../base_promotion.dart';
import '../promotion_helper.dart';
import '../promotions_group.dart';

class AmountBuyForXGetYPercentOff with BasePromotion {
  final tag = "AmountBuyForXGetYPercent";

  @override
  String samples() {
    return "ITEM_WISE_AS_PER_AMOUNT_GET_OFF_ON_OTHERS_PERCENTAGE";
  }

  @override
  String title() {
    return "Buy “X” amount from the Buy Products list and get “X” Percentage from the uploaded get products list.	";
  }

  @override
  String description() {
    return "Buy “X” amount from the Buy Products list and get “X” Percentage from the uploaded get products list.	";
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

    if (promotions.buyProducts == null || promotions.getProducts == null) {
      return discountAmount;
    }

    double buyProductsAmount = _getBuyProductsAmount(cartSummary, promotions);

    var selectedTier = _getPromotionTier(buyProductsAmount, promotions);

    if (selectedTier == null) {
      return discountAmount;
    }

    double discountPercentage = selectedTier.percentage ?? 0.0;

    MyLogUtils.logDebug(
        "$tag, getDiscountAmount discountPercentage : $discountPercentage ");
    if (discountPercentage > 0) {
      cartSummary.cartItems?.forEach((element) {
        if (_isAvailableInGetProducts(promotions, element)) {
          discountAmount = discountAmount +
              (getPriceToCalculateAutomaticPromotion(element) *
                  discountPercentage /
                  100);
        }
      });
    }

    MyLogUtils.logDebug(
        "$tag, getDiscountAmount discount amount : $discountAmount ");
    return discountAmount;
  }

  @override
  bool isValidDiscountForSale(CartSummary cartSummary, Promotions promotions) {
    MyLogUtils.logDebug("$tag, isValidDiscountForSale ");
    if (_notValidForThisCart(cartSummary, promotions)) {
      return false;
    }

    if (promotions.buyProducts == null || promotions.getProducts == null) {
      return false;
    }

    double buyProductsAmount = _getBuyProductsAmount(cartSummary, promotions);

    var selectedTier = _getPromotionTier(buyProductsAmount, promotions);

    return selectedTier != null;
  }

  @override
  List<CartItem> applyDiscount(CartSummary cartSummary, Promotions promotions) {
    MyLogUtils.logDebug("$tag, applyDiscount ");

    if (_notValidForThisCart(cartSummary, promotions)) {
      return cartSummary.cartItems ?? [];
    }

    if (promotions.buyProducts == null || promotions.getProducts == null) {
      return cartSummary.cartItems ?? [];
    }

    double buyProductsAmount = _getBuyProductsAmount(cartSummary, promotions);

    MyLogUtils.logDebug(
        "$tag, applyDiscount buyProductsAmount $buyProductsAmount");

    var selectedTier = _getPromotionTier(buyProductsAmount, promotions);

    MyLogUtils.logDebug(
        "$tag, applyDiscount selectedTier ${selectedTier?.toJson()}");

    if (selectedTier == null) {
      return cartSummary.cartItems ?? [];
    }

    double discountPercentage = selectedTier.percentage ?? 0.0;
    double thresholdAmount = selectedTier.minimumSpendAmount ?? 0.0;

    MyLogUtils.logDebug(
        "$tag, applyDiscount discountPercentage $discountPercentage & thresholdAmount :$thresholdAmount");

    int groupId = PromotionsGroup().getNewGroupId();
    double buyProductsTotalAmount = 0.0;

    if (discountPercentage > 0) {
      // Buy Products & get products can be same.
      // So check the maximum threshold amount in the tier.
      // Use buy products only till that amount.
      // So, even if buy & get products are same, remaining buy products can be used.

      // Iterate buy products add promotion Id & groupId until the threshold amount.
      // If threshold amount is crossed, other items in buy products can be used
      // for other promotions or in get products if same products in both

      cartSummary.cartItems?.forEach((element) {
        if (_isAvailableInBuyProducts(promotions, element) &&
            thresholdAmount > buyProductsTotalAmount) {
          buyProductsTotalAmount = buyProductsTotalAmount +
              getPriceToCalculateAutomaticPromotion(element);
          element.itemWisePromotionData ??= CartItemPromotionItemData();
          element.itemWisePromotionData?.promotionId = promotions.id;
          element.itemWisePromotionData?.promotionGroupId = groupId;
        }
      });

      //Iterate get products & add the discount percent &
      cartSummary.cartItems?.forEach((element) {
        if (_isAvailableInGetProducts(promotions, element)) {
          setItemWisePromotionDataToItem(
              element, promotions, groupId, discountPercentage);
        }
      });
    }

    return cartSummary.cartItems ?? [];
  }

  // Get total amount of buy products
  PromotionTiers? _getPromotionTier(
      double buyProductsAmount, Promotions promotions) {
    PromotionTiers? tier;
    promotions.promotionTiers?.forEach((element) {
      if ((element.minimumSpendAmount != null &&
              buyProductsAmount >= element.minimumSpendAmount!) &&
          (element.maximumSpendAmount != null &&
              buyProductsAmount <= element.maximumSpendAmount!)) {
        tier = element;
      }
    });
    return tier;
  }

  // Get total amount of buy products
  double _getBuyProductsAmount(CartSummary cartSummary, Promotions promotions) {
    double buyProductsAmount = 0.0;
    cartSummary.cartItems?.forEach((element) {
      if (_isAvailableInBuyProducts(promotions, element)) {
        buyProductsAmount =
            buyProductsAmount + getPriceToCalculateAutomaticPromotion(element);
      }
    });
    return buyProductsAmount;
  }

  bool _notValidForThisCart(CartSummary cartSummary, Promotions promotions) {
    return notValidForThisCart(tag, cartSummary, promotions);
  }

  bool _isAvailableInBuyProducts(Promotions promotions, CartItem element) {
    if (element.saleReturnsItemData != null) {
      return false;
    }

    if ((element.itemWisePromotionData?.promotionId ?? 0) > 0) {
      return false;
    }

    return promotions.buyProducts!.contains(element.product?.id) &&
        !element.isComplementaryItem();
  }

  bool _isAvailableInGetProducts(Promotions promotions, CartItem element) {
    if (element.saleReturnsItemData != null) {
      return false;
    }

    if ((element.itemWisePromotionData?.promotionId ?? 0) > 0) {
      return false;
    }

    if (element.isComplementaryItem()) {
      return false;
    }

    return isItemValidForPromotion(promotions, element)
        ? promotions.getProducts!.contains(element.product?.id)
        : false;
  }
}
