import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartItemPromotionItemData.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import '../base_promotion.dart';
import '../promotion_helper.dart';
import '../promotions_group.dart';

class QtyBundleBuy with BasePromotion {
  final tag = "QtyBundleBuy";

  @override
  String samples() {
    return "Item Wise discount bundle buy";
  }

  @override
  String title() {
    return "ITEM_WISE_BUNDLE_BUY";
  }

  @override
  String description() {
    return "Item Wise discount bundle buy";
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
        "Get Bundle Buy getDiscountAmount discount : $discount");

    return discount;
  }

  @override
  bool isValidDiscountForSale(CartSummary cartSummary, Promotions promotions) {
    if (_notValidForThisCart(cartSummary, promotions)) {
      return false;
    }

    if (promotions.products == null) {
      return false;
    }

    /// Split item as items with single qty.
    List<CartItem> itemsAsSingleQty =
        _splitItemsAsSingleQty(cartSummary, promotions);

    // Find the list of applicable tiers.
    List<PromotionTiers> tiers = _getTiers(itemsAsSingleQty, promotions);

    return tiers.isNotEmpty;
  }

  @override
  List<CartItem> applyDiscount(CartSummary cartSummary, Promotions promotions) {
    MyLogUtils.logDebug("$tag, applyDiscount ==>");

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
    MyLogUtils.logDebug("applyDiscount _getTiers ======>");
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
  /// if an item has more then 1 qty only for
  /// products of the promotions
  List<CartItem> _splitItemsAsSingleQty(
      CartSummary cartSummary, Promotions promotions) {
    List<CartItem> itemsAsSingleQty = List.empty(growable: true);

    cartSummary.cartItems?.forEach((element) {
      if (_isAvailableInPromotion(promotions, element)) {
        MyLogUtils.logDebug("itemsAsSingleQty element.qty : ${element.qty}");
        for (int i = 0; i < element.qty!.toInt(); i++) {
          CartItem temp = CartItem.fromJson(element.toJson());
          temp.qty = 1;
          itemsAsSingleQty.add(temp);
        }
      } else {
        itemsAsSingleQty.add(element);
      }
    });

    MyLogUtils.logDebug("itemsAsSingleQty length : ${itemsAsSingleQty.length}");
    return itemsAsSingleQty;
  }

  /// Check if item is available in promotion products
  bool _isAvailableInPromotion(Promotions promotions, CartItem element) {
    // Already item wise promotion is applied
    // Already item wise promotion is applied
    if ((element.itemWisePromotionData?.promotionId ?? 0) > 0) {
      return false;
    }

    if (element.saleReturnsItemData != null) {
      return false;
    }

    return isItemValidForPromotion(promotions, element)
        ? (promotions.products!.contains(element.product?.id))
        : false;
  }

  // Get all availabel tiers by running in while loop
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
    return tiers;
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
      if (_isAvailableInPromotion(promotions, value)) {
        productsQtyCount += 1;
      }
    }

    return productsQtyCount;
  }

  List<CartItem> _applyAndGetDiscountAmount(List<PromotionTiers> selectedTiers,
      List<CartItem> itemsAsSingleQty, Promotions promotions) {
    MyLogUtils.logDebug(
        "$tag _applyAndGetDiscountAmount itemsAsSingleQty: ${itemsAsSingleQty.length} && selectedTiers : ${selectedTiers.length}");

    List<CartItem> itemsAfterDiscountApplied = List.empty(growable: true);

    /// Add all items that are part of this promotion to this list
    List<CartItem> arrangeItemsWithCheapestFirst = List.empty(growable: true);

    //Split the items that are part of this promotion vs not part of this promotion
    for (var item in itemsAsSingleQty) {
      if (_isAvailableInPromotion(promotions, item)) {
        arrangeItemsWithCheapestFirst.add(item);
      } else {
        itemsAfterDiscountApplied.add(item);
      }
    }

    MyLogUtils.logDebug(
        "$tag _applyAndGetDiscountAmount arrangeItemsWithCheapestFirst: ${arrangeItemsWithCheapestFirst.length}");

    // Arrange the items with cheapest first
    arrangeItemsWithCheapestFirst =
        _sortByCheapestFirst(arrangeItemsWithCheapestFirst);

    for (var tier in selectedTiers) {
      int groupId = PromotionsGroup().getNewGroupId();
      int totalBuyQty = _getTotalQtyNeededInCart(tier);
      int countedBuyQty = 0;

      List<CartItem> thisGroupItems = List.empty(growable: true);

      MyLogUtils.logDebug(
          "arrangeItemsWithCheapestFirst length-> ${arrangeItemsWithCheapestFirst.length}");

      /// Iterate the items to get this group items
      for (var item in arrangeItemsWithCheapestFirst) {
        // Check if this item is in products list.

        MyLogUtils.logDebug(
            "arrangeItemsWithCheapestFirst -> ${item.product?.name} & ${item.qty} "
            "& totalBuyQty : $totalBuyQty ,countedBuyQty: $countedBuyQty");

        if (_isAvailableInPromotion(promotions, item) &&
            item.itemWisePromotionData?.promotionGroupId == null) {
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

      // Calculate total amount of this 3 items to calculate the percentage.
      double totalPriceOfThisGroup = 0.0;
      for (var element in thisGroupItems) {
        totalPriceOfThisGroup =
            totalPriceOfThisGroup + (element.cartItemPrice?.nextCalculationPrice??0);
      }

      MyLogUtils.logDebug("totalPriceOfThisGroup  : $totalPriceOfThisGroup");

      double totalBundleBuyPrice = tier.amount ?? 0.0;

      MyLogUtils.logDebug("totalBundleBuyPrice : $totalBundleBuyPrice");

      // Add discount amount as percentage to these grouped Items.
      for (var element in thisGroupItems) {
        // Item price
        double itemPrice = (element.cartItemPrice?.nextCalculationPrice??0);

        MyLogUtils.logDebug("itemPrice : $itemPrice");

        // Using totalAmount of this bundle & this item price, get percentage
        double percentageInThisBundle =
            (itemPrice * 100) / totalPriceOfThisGroup;

        MyLogUtils.logDebug("percentageInThisBundle : $percentageInThisBundle");
        // Calculate discount amount for this item.
        double payableAmountOfThisElementInThisBundle =
            totalBundleBuyPrice * percentageInThisBundle / 100;

        MyLogUtils.logDebug(
            "payableAmountOfThisElementInThisBundle : $payableAmountOfThisElementInThisBundle");

        // Convert amount into percentage & subtract from 100 to get the
        // payable amount percentage of this item
        var discountPercentage =
            100 - (payableAmountOfThisElementInThisBundle * 100) / itemPrice;

        MyLogUtils.logDebug("discountPercentage : $discountPercentage");

        setItemWisePromotionDataToItem(
            element,
            promotions,
            element.itemWisePromotionData?.promotionGroupId,
            discountPercentage);

        itemsAfterDiscountApplied.add(element);
      }
    }

    MyLogUtils.logDebug(
        "$tag, arrangeItemsWithCheapestFirst length after all calc : ${arrangeItemsWithCheapestFirst.length}");

    /// Iterate the items and check which was not applied to promotion
    /// and add them to cart
    for (var element in arrangeItemsWithCheapestFirst) {
      if (element.itemWisePromotionData?.promotionGroupId == null) {
        itemsAfterDiscountApplied.add(element);
      }
    }

    MyLogUtils.logDebug(
        "$tag, itemsAfterDiscountApplied length after all calc : ${itemsAfterDiscountApplied.length}");

    //Grouping of items is not working fine. So commented this code.
    // List<CartItem> groupedCartItems = List.empty(growable: true);
    // for (var value in itemsAfterDiscountApplied) {
    //   int index = _isAlreadyAddedInList(groupedCartItems, value, promotions);
    //   if (index < 0) {
    //     groupedCartItems.add(value);
    //   } else {
    //     // Check the grouped cart item & increment the qty
    //     var value = groupedCartItems[index];
    //     value.qty = value.qty! + 1;
    //   }
    // }

    return itemsAfterDiscountApplied;
  }

  int _isAlreadyAddedInList(
      List<CartItem> existingItems, CartItem newItem, Promotions promotions) {
    if (existingItems.isEmpty) {
      return -1;
    }

    int index = 0;
    for (var i = 0; i < existingItems.length; i++) {
      //For this item promotion is not available
      if (newItem.itemWisePromotionData?.promotionId == null &&
          (existingItems[i].getUniqueIdOfProduct() ==
              newItem.getUniqueIdOfProduct())) {
        index = -1;
      } else if (existingItems[i].getUniqueIdOfProduct() !=
          newItem.getUniqueIdOfProduct()) {
        index = -1;
      } else {
        index = i;
      }
    }

    return index;
  }
}
