import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_pos/modules/promotions/validate/base_promotion.dart';

import '../promotion_helper.dart';

// TODO : if multiple GWG promotion is enabled.
// for 100 rm ,1 item free, then for next promotion,
// previous applied 100 Rm should be removed and apart form this 100 RM , customer has to pay another 100
class QtyGiftWithPurchase with BasePromotion {
  final tag = "QtyGiftWithPurchase";

  @override
  String title() {
    return "ITEM_WISE_GIFT_WITH_PURCHASE";
  }

  @override
  String description() {
    return "Item wise gift with Purchase";
  }

  @override
  String samples() {
    return "Item wise gift with Purchase";
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

    var tier = _getTierForCartWide(cartSummary, promotions);

    if (tier == null) {
      return false;
    }

    return true;
  }

  @override
  double getDiscountAmount(CartSummary cartSummary, Promotions promotions) {
    List<CartItem> grouped = _updatedCartAfterDiscount(cartSummary, promotions);

    double discount = 0.0;

    for (var element in grouped) {
      discount = discount + (element.cartItemPrice?.automaticItemDiscount ?? 0);
    }

    return discount;
  }

  @override
  List<CartItem> applyDiscount(CartSummary cartSummary, Promotions promotions) {
    return _updatedCartAfterDiscount(cartSummary, promotions);
  }

  PromotionTiers? _getTierForCartWide(
      CartSummary cartSummary, Promotions promotions) {
    double giftItemQty = 0;

    cartSummary.cartItems?.forEach((element) {
      if (element.qty != null && _isProductInPromotion(promotions, element)) {
        giftItemQty = giftItemQty + element.qty!;
      }
    });

    if (giftItemQty == 0) {
      return null;
    }

    PromotionTiers? tier;

    double payableAmount = getPayableAmount(promotions, cartSummary);

    promotions.promotionTiers?.forEach((element) {
      if (element.minimumSpendAmount != null &&
          element.freeQuantity != null &&
          payableAmount >= element.minimumSpendAmount! &&
          giftItemQty >= element.freeQuantity!) {
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
      if (!_isProductInPromotion(promotions, element)) {
        payableAmount =
            payableAmount + getPriceToCalculateAutomaticPromotion(element);
      }
    });

    return payableAmount;
  }

  bool _isProductInPromotion(Promotions promotions, CartItem element) {
    if (element.saleReturnsItemData != null) {
      return false;
    }

    if ((element.itemWisePromotionData?.promotionId ?? 0) > 0) {
      return false;
    }

    return isItemValidForPromotion(promotions, element)
        ? (promotions.products != null &&
            element.product != null &&
            promotions.products!.contains(element.product?.id) &&
            !element.isComplementaryItem())
        : false;
  }

  List<CartItem> _updatedCartAfterDiscount(
      CartSummary cartSummary, Promotions promotions) {
    var tier = _getTierForCartWide(cartSummary, promotions);

    if (tier == null) {
      return cartSummary.cartItems ?? [];
    }

    // Split gift with purchase items as per the quantity & other items
    List<CartItem> grouped = List.empty(growable: true);
    double giftItemQty = 0;
    double maxFreeQty = getDoubleValue(tier.freeQuantity ?? 0);

    cartSummary.cartItems?.forEach((element) {
      //Check if the product is is the list
      if (element.qty != null &&
          _isProductInPromotion(promotions, element) &&
          maxFreeQty > giftItemQty) {
        double availableFreeQty = maxFreeQty - giftItemQty;

        if (element.qty != null) {
          if (availableFreeQty > element.qty!) {
            //Item qty is less than  available free item qty.
            //So add the item to grouped directly.
            giftItemQty = giftItemQty + element.qty!;
            element.makeItGiftWithPurchase = true;
            setItemWisePromotionDataToItem(element, promotions,
                element.itemWisePromotionData?.promotionGroupId, 100);
            grouped.add(element);
          } else if (element.qty! > availableFreeQty) {
            giftItemQty = maxFreeQty;
            //Item qty is more than  available free item qty.

            //So, split & make it as 2 different items.
            //Free item
            final freeItem = CartItem.fromJson(element.toJson());
            freeItem.qty = availableFreeQty;
            freeItem.makeItGiftWithPurchase = true;
            // element.promotionId = promotions.id;
            // element.discountPercent = 100;

            setItemWisePromotionDataToItem(element, promotions,
                element.itemWisePromotionData?.promotionGroupId, 100);

            grouped.add(freeItem);

            //Not free item
            final notFreeItem = CartItem.fromJson(element.toJson());
            notFreeItem.qty = element.qty! - availableFreeQty;
            notFreeItem.makeItGiftWithPurchase = false;
            grouped.add(notFreeItem);
          } else {
            // Its equal
            giftItemQty = maxFreeQty;
            element.makeItGiftWithPurchase = true;
            // element.promotionId = promotions.id;
            // element.discountPercent = 100;

            setItemWisePromotionDataToItem(element, promotions,
                element.itemWisePromotionData?.promotionGroupId, 100);
            grouped.add(element);
          }
        }
      } else {
        grouped.add(element);
      }
    });
    return grouped;
  }
}
