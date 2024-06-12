import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import '../base_promotion.dart';
import '../promotion_helper.dart';
import '../promotions_group.dart';

class AmountBuyForXInBrandGetYFlatOff with BasePromotion {
  final tag = "AmountBuyForXInBrandGetYFlatOff";

  @override
  String samples() {
    return "ITEM_WISE_AS_PER_AMOUNT_LIMITED_TO_BRANDS_FLAT";
  }

  @override
  String title() {
    return "Buy “X” amount from the a brand list and get “Y” flat amount from the products in brand.";
  }

  @override
  String description() {
    return "Buy “X” amount from the a brand list and get “Y” flat amount from the products in brand.";
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

    if (promotions.brands == null) {
      return discountAmount;
    }

    double buyProductsAmount =
        _getTotalAmountOfProductsInSpecifiedBrand(cartSummary, promotions);

    var selectedTier = _getPromotionTier(buyProductsAmount, promotions);

    if (selectedTier == null) {
      return discountAmount;
    }

    double flatDiscountAmount = selectedTier.flatAmount ?? 0.0;

    MyLogUtils.logDebug(
        "$tag, getDiscountAmount flatDiscountAmount : $flatDiscountAmount ");

    if (flatDiscountAmount > 0) {
      cartSummary.cartItems?.forEach((element) {
        if (_isProductInPromotionBrand(promotions, element)) {
          discountAmount = discountAmount + flatDiscountAmount;
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

    if (promotions.brands == null) {
      return false;
    }

    double buyProductsAmount =
        _getTotalAmountOfProductsInSpecifiedBrand(cartSummary, promotions);

    var selectedTier = _getPromotionTier(buyProductsAmount, promotions);

    return selectedTier != null;
  }

  @override
  List<CartItem> applyDiscount(CartSummary cartSummary, Promotions promotions) {
    MyLogUtils.logDebug("$tag, applyDiscount ");

    if (_notValidForThisCart(cartSummary, promotions)) {
      return cartSummary.cartItems ?? [];
    }

    if (promotions.brands == null) {
      return cartSummary.cartItems ?? [];
    }

    int groupId = PromotionsGroup().getNewGroupId();

    //Get total brand amount and use it to get the tier
    double totalBrandAmount = getTotalBrandAmount(cartSummary, promotions);
    var selectedTier = _getPromotionTier(totalBrandAmount, promotions);

    //Iterate get products & add the discount percent &
    cartSummary.cartItems?.forEach((element) {
      if (_isProductInPromotionBrand(promotions, element)) {
        //In case of brands, it should be total brand amount and not per product amount
        // double buyProductAmount =
        //     _getTotalAmountOfEachProductInSpecifiedBrand(element, promotions);
        // var selectedTier = _getPromotionTier(buyProductAmount, promotions);

        // Flat discount is for per qty. if 3 qty of ite, then flatDiscountAMount*3.
        double flatDiscountAmount = selectedTier?.flatAmount ?? 0.0;
        double discountPercentage =
            getDiscountPercentageFromFlat(element, flatDiscountAmount);
        MyLogUtils.logDebug("$tag discountPercentage is : $discountPercentage");

        setItemWisePromotionDataToItem(
            element, promotions, groupId, discountPercentage);
      }
    });
    return cartSummary.cartItems ?? [];
  }

  // Get total amount of buy products
  PromotionTiers? _getPromotionTier(
      double buyProductsAmount, Promotions promotions) {
    PromotionTiers? tier;
    promotions.promotionTiers?.forEach((element) {
      if (element.minimumSpendAmount != null &&
          buyProductsAmount >= element.minimumSpendAmount!) {
        tier = element;
      }
    });
    return tier;
  }

  // Get total amount of each buy product with qty
  double _getTotalAmountOfEachProductInSpecifiedBrand(
      CartItem cartItem, Promotions promotions) {
    double buyProductsAmount = 0.0;
    if (_isProductInPromotionBrand(promotions, cartItem)) {
      buyProductsAmount = (cartItem.cartItemPrice?.nextCalculationPrice ?? 0) *
          (cartItem.qty ?? 0);
    }
    return buyProductsAmount;
  }

  // Get total amount of buy products
  double _getTotalAmountOfProductsInSpecifiedBrand(
      CartSummary cartSummary, Promotions promotions) {
    double buyProductsAmount = 0.0;
    cartSummary.cartItems?.forEach((element) {
      if (_isProductInPromotionBrand(promotions, element)) {
        buyProductsAmount = buyProductsAmount +
            (element.cartItemPrice?.nextCalculationPrice ?? 0);
      }
    });
    return buyProductsAmount;
  }

  bool _notValidForThisCart(CartSummary cartSummary, Promotions promotions) {
    return notValidForThisCart(tag, cartSummary, promotions);
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

  double getTotalBrandAmount(CartSummary cartSummary, Promotions promotions) {
    double totalBrandAmount = 0.0;
    cartSummary.cartItems?.forEach((element) {
      if (_isProductInPromotionBrand(promotions, element)) {
        double buyProductAmount =
            _getTotalAmountOfEachProductInSpecifiedBrand(element, promotions);

        totalBrandAmount = buyProductAmount + totalBrandAmount;
      }
    });
    return totalBrandAmount;
  }
}
