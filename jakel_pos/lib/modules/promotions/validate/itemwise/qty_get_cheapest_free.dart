import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartItemPromotionItemData.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_pos/modules/promotions/validate/base_promotion.dart';
import 'package:jakel_pos/modules/promotions/validate/promotions_group.dart';

import '../promotion_helper.dart';

class QtyGetCheapestFree with BasePromotion {
  final tag = "QtyGetCheapestFree";

  @override
  String samples() {
    return "ITEM_WISE_CHEAPEST_FREE";
  }

  @override
  String title() {
    return "ITEM_WISE_CHEAPEST_FREE";
  }

  @override
  String description() {
    return "Quantity Get Cheapest free!";
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
    if (_notValidForThisCart(cartSummary, promotions)) {
      return 0.0;
    }

    if (promotions.products == null) {
      return 0.0;
    }

    /// Split item as items with single qty.
    List<CartItem> itemsAsSingleQty =
        _splitItemsAsSingleQty(cartSummary, promotions);

    // Find the list of applicable tiers.
    List<PromotionTiers> selectedTiers =
        _getTiers(itemsAsSingleQty, promotions);

    /// Apply the discount & group the cart items
    List<CartItem> groupedCartItem =
        _applyAndGetDiscountAmount(selectedTiers, itemsAsSingleQty, promotions);

    double discount = 0.0;
    for (var value in groupedCartItem) {
      discount = discount + (value.cartItemPrice?.automaticItemDiscount ?? 0);
    }

    MyLogUtils.logDebug(
        "Get cheapeast free getDiscountAmount discount : $discount");

    return discount;
  }

  @override
  bool isValidDiscountForSale(CartSummary cartSummary, Promotions promotions) {
    MyLogUtils.logDebug("isValidDiscountForSale ======>");

    if (_notValidForThisCart(cartSummary, promotions)) {
      return false;
    }

    if (promotions.products == null) {
      return false;
    }

    /// Split item as items with single qty.
    List<CartItem> itemsAsSingleQty =
        _splitItemsAsSingleQty(cartSummary, promotions);

    // for (var element in itemsAsSingleQty) {
    //   MyLogUtils.logDebug(
    //       "itemsAsSingleQty element id : ${element.product?.id} && name : ${element.product?.name} && qty:"
    //       " ${element.qty}");
    // }

    // Find the list of applicable tiers.
    List<PromotionTiers> tiers = _getTiers(itemsAsSingleQty, promotions);

    return tiers.isNotEmpty;
  }

  @override
  List<CartItem> applyDiscount(CartSummary cartSummary, Promotions promotions) {
    MyLogUtils.logDebug("applyDiscount ======>");

    if (_notValidForThisCart(cartSummary, promotions)) {
      return cartSummary.cartItems ?? [];
    }

    if (promotions.products == null) {
      return cartSummary.cartItems!;
    }

    /// Split item as items with single qty.
    MyLogUtils.logDebug("applyDiscount _splitItemsAsSingleQty ======>");

    List<CartItem> itemsAsSingleQty =
        _splitItemsAsSingleQty(cartSummary, promotions);

    // Find the list of applicable tiers.

    List<PromotionTiers> selectedTiers =
        _getTiers(itemsAsSingleQty, promotions);

    /// Apply the discount & group the cart items

    List<CartItem> groupedCartItems =
        _applyAndGetDiscountAmount(selectedTiers, itemsAsSingleQty, promotions);

    return groupedCartItems;
  }

  /// Split the items in cart with single quantity
  /// if an item as more then 1 qty only for
  /// products of the promotions
  List<CartItem> _splitItemsAsSingleQty(
      CartSummary cartSummary, Promotions promotions) {
    List<CartItem> itemsAsSingleQty = List.empty(growable: true);

    cartSummary.cartItems?.forEach((element) {
      if (_isAvailableInPromotion(promotions, element)) {
        for (int i = 0; i < element.qty!.toInt(); i++) {
          CartItem temp = CartItem.fromJson(element.toJson());
          temp.qty = 1;
          itemsAsSingleQty.add(temp);
        }
      } else {
        itemsAsSingleQty.add(element);
      }
    });
    return itemsAsSingleQty;
  }

  bool _isAvailableInPromotion(Promotions promotions, CartItem element) {
    if (element.saleReturnsItemData != null) {
      return false;
    }
    return isItemValidForPromotion(promotions, element)
        ? (promotions.products!.contains(element.product?.id) &&
            !element.isComplementaryItem())
        : false;
  }

  List<PromotionTiers> _getTiers(
      List<CartItem> itemsAsSingleQty, Promotions promotions) {
    List<PromotionTiers> tiers = List.empty(growable: true);

    int totalProductsQty = _getTotalProductsCount(itemsAsSingleQty, promotions);

    bool isTierAvailable = true;

    List<PromotionTiers> allTiersInSortedOrder = _getSortedTiers(promotions);

    /// Recursive iterate to get all tiers in an order.
    while (isTierAvailable) {
      var tier = _getTier(totalProductsQty, allTiersInSortedOrder);

      if (tier == null) {
        isTierAvailable = false;
        break;
      }
      tiers.add(tier);
      //tier buyQuantity & getQuantity wont be null in this line.
      //It will be checked already in _getTier.
      totalProductsQty = totalProductsQty - (_getTotalQtyNeededInCart(tier));
    }

    MyLogUtils.logDebug("Selected tiers count ${tiers.length} ");

    return tiers;
  }

  List<PromotionTiers> _getSortedTiers(Promotions promotions) {
    List<PromotionTiers> sortedTiers = promotions.promotionTiers ?? [];
    sortedTiers.sort((a, b) {
      if (a.buyQuantity == null || b.buyQuantity == null) {
        return 0;
      }
      return a.buyQuantity!.compareTo(b.buyQuantity!);
    });
    return sortedTiers;
  }

  List<CartItem> _sortByCheapestFirst(List<CartItem> cartItems) {
    cartItems.sort((a, b) {
      return a.getProductSubTotal().compareTo(b.getProductSubTotal());
    });
    return cartItems;
  }

  PromotionTiers? _getTier(
      int totalProductsQtyInCart, List<PromotionTiers> allTiers) {
    if (totalProductsQtyInCart <= 0) {
      return null;
    }

    if (allTiers.isEmpty) {
      return null;
    }

    PromotionTiers? promotionTier;
    for (var tier in allTiers) {
      int totalTierQty = _getTotalQtyNeededInCart(tier);

      MyLogUtils.logDebug("_getTier tier buyQuantity  "
          " getQuantity :${tier.getQuantity} "
          " totalProductsQtyInCart :$totalProductsQtyInCart "
          " totalTierQty:$totalTierQty");

      if (totalProductsQtyInCart >= totalTierQty) {
        promotionTier = tier;
        MyLogUtils.logDebug("_getTier selected");
      }
    }

    MyLogUtils.logDebug("_getTier selected tier buyQuantity:"
        "${promotionTier?.buyQuantity} && getQuantity: ${promotionTier?.getQuantity}");

    return promotionTier;
  }

  /// Get total buy qty Count
  int _getTotalProductsCount(
      List<CartItem> itemsAsSingleQty, Promotions promotions) {
    int productsQtyCount = 0;

    for (var value in itemsAsSingleQty) {
      if (promotions.products != null &&
          promotions.products!.contains(value.product?.id) &&
          !value.isComplementaryItem()) {
        productsQtyCount += 1;
      }
    }

    return productsQtyCount;
  }

  // Apply discount to cart items & group the cart items
  List<CartItem> _applyAndGetDiscountAmount(List<PromotionTiers> selectedTiers,
      List<CartItem> itemsAsSingleQty, Promotions promotions) {
    List<CartItem> itemsAfterDiscountApplied = List.empty(growable: true);

    /// Add all items that are part of this promotion to this list
    List<CartItem> arrangeItemsWithCheapestFirst = List.empty(growable: true);

    //Split the items that are part of this promotion vs not part of this promotion
    for (var item in itemsAsSingleQty) {
      if (!_isAvailableInPromotion(promotions, item)) {
        itemsAfterDiscountApplied.add(item);
      } else {
        arrangeItemsWithCheapestFirst.add(item);
      }
    }

    // Arrange the items with cheapest first
    arrangeItemsWithCheapestFirst =
        _sortByCheapestFirst(arrangeItemsWithCheapestFirst);

    //Iterate all the selected tiers.
    for (var tier in selectedTiers) {
      int groupId = PromotionsGroup().getNewGroupId();
      int totalBuyQty = _getTotalQtyNeededInCart(tier);
      int countedBuyQty = 0;
      MyLogUtils.logDebug(
          "tier with totalBuyQty:$totalBuyQty & groupId: $groupId");

      List<CartItem> thisGroupItems = List.empty(growable: true);

      /// Iterate the items to get this group items
      for (var item in arrangeItemsWithCheapestFirst) {
        // Check if this item is in products list.

        if (promotions.products!.contains(item.product?.id) &&
            item.itemWisePromotionData?.promotionGroupId == null &&
            !item.isComplementaryItem()) {
          // check if the buy qty in with in threshold & apply discount id
          if (totalBuyQty > countedBuyQty) {
            item.itemWisePromotionData ??= CartItemPromotionItemData();

            item.itemWisePromotionData?.promotionGroupId = groupId;
            item.itemWisePromotionData?.promotionId = promotions.id;
            countedBuyQty += 1;
            thisGroupItems.add(item);
            MyLogUtils.logDebug("Added with discount");
          }
        }
      }

      // Arrange this group items with cheapest first to apply discount
      // as per get qty.
      thisGroupItems = _sortByCheapestFirst(thisGroupItems);
      int getQty = tier.getQuantity!;
      int countedGetQty = 0;
      for (var element in thisGroupItems) {
        //Make cheapest items free.
        if (getQty > countedGetQty) {
          countedGetQty += 1;

          setItemWisePromotionDataToItem(element, promotions,
              element.itemWisePromotionData?.promotionGroupId, 100);
          element.itemWisePromotionData?.isFreeProduct = true;
        }
        itemsAfterDiscountApplied.add(element);
      }
    }

    /// Iterate the items and check which was not applied to promotion
    /// and add them to cart
    for (var element in arrangeItemsWithCheapestFirst) {
      if (element.itemWisePromotionData?.promotionGroupId == null) {
        itemsAfterDiscountApplied.add(element);
      }
    }

    return itemsAfterDiscountApplied;
  }

  int _getTotalQtyNeededInCart(PromotionTiers promotionTiers) {
    int buyQty = 0;
    if (promotionTiers.buyQuantity != null) {
      buyQty = promotionTiers.buyQuantity!;
    }

    int getQty = 0;
    if (promotionTiers.getQuantity != null) {
      getQty = promotionTiers.getQuantity!;
    }
    return buyQty + getQty;
  }

  bool _notValidForThisCart(CartSummary cartSummary, Promotions promotions) {
    return notValidForThisCart(tag, cartSummary, promotions);
  }
}
