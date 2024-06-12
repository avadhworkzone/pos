import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartItemPromotionItemData.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import '../base_promotion.dart';
import '../promotion_helper.dart';
import '../promotions_group.dart';

class QtyBuyXGetYPriceOff with BasePromotion {
  final tag = "QtyBuyXGetYPriceOff";

  @override
  String samples() {
    return "ITEM_WISE_BUY_ANY_3_OR_MORE_AND_GET_RM_30_OFF";
  }

  @override
  String title() {
    return "Item Wise Buy Any 3 Or More And Get Rm 30 Off";
  }

  @override
  String description() {
    return "Item Wise Buy Any 3 Or More And Get Rm 30 Off";
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

    MyLogUtils.logDebug("$tag discount : $discount");

    return discount;
  }

  @override
  bool isValidDiscountForSale(CartSummary cartSummary, Promotions promotions) {
    MyLogUtils.logDebug("$tag isValidDiscountForSale ======>");

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
    //       "$tag itemsAsSingleQty element id : ${element.product?.id} && name : ${element.product?.name} && qty:"
    //       " ${element.qty}");
    // }

    // Find the list of applicable tiers.
    List<PromotionTiers> tiers = _getTiers(itemsAsSingleQty, promotions);
    return tiers.isNotEmpty;
  }

  @override
  List<CartItem> applyDiscount(CartSummary cartSummary, Promotions promotions) {
    MyLogUtils.logDebug("$tag applyDiscount ======>");

    if (_notValidForThisCart(cartSummary, promotions)) {
      return cartSummary.cartItems ?? [];
    }

    if (promotions.products == null) {
      return cartSummary.cartItems!;
    }

    /// Split item as items with single qty.
    MyLogUtils.logDebug("$tag applyDiscount _splitItemsAsSingleQty ======>");

    List<CartItem> itemsAsSingleQty =
        _splitItemsAsSingleQty(cartSummary, promotions);

    // Find the list of applicable tiers.
    MyLogUtils.logDebug("$tag applyDiscount _getTiers ======>");
    List<PromotionTiers> selectedTiers =
        _getTiers(itemsAsSingleQty, promotions);

    /// Apply the discount & group the cart items

    List<CartItem> groupedCartItems =
        _applyAndGetDiscountAmount(selectedTiers, itemsAsSingleQty, promotions);

    return groupedCartItems;
  }

  bool _notValidForThisCart(CartSummary cartSummary, Promotions promotions) {
    return notValidForThisCart(tag, cartSummary, promotions);
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

    MyLogUtils.logDebug("$tag totalProductsQty :$totalProductsQty ");

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

    MyLogUtils.logDebug("$tag Selected tiers count ${tiers.length} ");

    return tiers;
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

      MyLogUtils.logDebug("$tag _getTier tier buyQuantity  "
          " getQuantity :${tier.getQuantity} "
          " totalProductsQtyInCart :$totalProductsQtyInCart "
          " totalTierQty:$totalTierQty");

      if (totalProductsQtyInCart >= totalTierQty) {
        promotionTier = tier;
        MyLogUtils.logDebug("$tag _getTier selected");
      }
    }

    MyLogUtils.logDebug("$tag _getTier selected tier buyQuantity:"
        "${promotionTier?.buyQuantity} && getQuantity: ${promotionTier?.getQuantity}");

    return promotionTier;
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

    //Iterate all the selected tiers.
    for (var tier in selectedTiers) {
      int groupId = PromotionsGroup().getNewGroupId();
      int totalBuyQty = _getTotalQtyNeededInCart(tier);
      int countedBuyQty = 0;
      MyLogUtils.logDebug(
          "$tag tier with totalBuyQty:$totalBuyQty & groupId: $groupId");

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

      //Calculate this group total amount
      var totalPriceOfThisGroup = 0.0;
      for (var element in thisGroupItems) {
        totalPriceOfThisGroup =
            totalPriceOfThisGroup + element.getProductSubTotal();
      }

      for (var element in thisGroupItems) {
        //Apply discount for these items
        double itemPrice = element.getProductSubTotal();

        // Using totalAmount of this bundle & this item price, get percentage
        double percentageInThisBundle =
            (itemPrice * 100) / totalPriceOfThisGroup;

        // Calculate discount amount for this item.
        double payableAmountOfThisElementInThisBundle =
            (tier.flatAmount ?? 0.0) * percentageInThisBundle / 100;

        double discountPercent =
            (payableAmountOfThisElementInThisBundle * 100) / itemPrice;

        setItemWisePromotionDataToItem(element, promotions,
            element.itemWisePromotionData?.promotionGroupId, discountPercent);

        MyLogUtils.logDebug(
            "$tag , element: ${element.product?.name} , itemPrice:$itemPrice ,"
            "discountPercent:$discountPercent, "
            "tier.flatAmount:${tier.flatAmount}");
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

    List<CartItem> groupedCartItems = List.empty(growable: true);

    for (var value in itemsAfterDiscountApplied) {
      int index = _isAlreadyAddedInList(groupedCartItems, value, promotions);
      if (index < 0) {
        groupedCartItems.add(value);
      } else {
        int groupedItemIndex = 0;
        // Check the grouped cart item & increment the qty
        for (var value in groupedCartItems) {
          if (groupedItemIndex == index) {
            value.qty = value.qty! + 1;
            break;
          }
          groupedItemIndex += 1;
        }
      }
    }

    return groupedCartItems;
  }

  int _isAlreadyAddedInList(
      List<CartItem> existingItems, CartItem newItem, Promotions promotions) {
    if (existingItems.isEmpty) {
      return -1;
    }

    int index = 0;
    for (var value in existingItems) {
      //For this item promotion is not available
      if (newItem.itemWisePromotionData?.promotionId == null &&
          (value.getUniqueIdOfProduct() == newItem.getUniqueIdOfProduct())) {
        return index;
      }

      // promotion id matches & its buy product & its same group
      if (newItem.itemWisePromotionData?.promotionId == promotions.id &&
          newItem.itemWisePromotionData?.promotionGroupId ==
              value.itemWisePromotionData?.promotionGroupId &&
          (value.getUniqueIdOfProduct() == newItem.getUniqueIdOfProduct())) {
        return index;
      }

      index = index + 1;
    }

    return -1;
  }
}
