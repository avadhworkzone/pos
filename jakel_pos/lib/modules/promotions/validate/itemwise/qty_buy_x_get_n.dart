import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartItemPromotionItemData.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_pos/modules/promotions/validate/base_promotion.dart';
import 'package:jakel_pos/modules/promotions/validate/promotions_group.dart';

import '../promotion_helper.dart';

/// 1. Split items as single qty
/// 2. Arrange items in descending order.
/// 3. Arrange tiers in descending order
/// 4. Iterate all the tiers to check for condition .
/// 5. If condition satisfies, select the tier.
/// 6. Recheck again for the same tier for remaining products.
/// 7. Recursive is applied for step 5 & 6.
class QtyBuyXGetN with BasePromotion {
  final tag = "QtyBuyXGetN";

  // For while loop recovery count if there is any issue.
  final recoveryCount = 25;

  @override
  String samples() {
    return "TODO";
  }

  @override
  String title() {
    return "ITEM_WISE_BUY_3_GET_1";
  }

  @override
  String description() {
    return "Quantity Buy x items & get n items";
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
    List<CartItem> discountAppliedCartItems =
        applyDiscount(cartSummary, promotions);

    MyLogUtils.logDebug("$tag discountAppliedCartItems for ${promotions.name}");

    double discount = 0.0;

    for (var value in discountAppliedCartItems) {
      discount = discount + (value.cartItemPrice?.automaticItemDiscount ?? 0);
    }

    MyLogUtils.logDebug("$tag getDiscountAmount discount : $discount");
    return discount;
  }

  @override
  bool isValidDiscountForSale(CartSummary cartSummary, Promotions promotions) {
    return getDiscountAmount(cartSummary, promotions) > 0;
  }

  @override
  List<CartItem> applyDiscount(CartSummary cartSummary, Promotions promotions) {
    if (_notValidForThisCart(cartSummary, promotions)) {
      return cartSummary.cartItems ?? [];
    }

    if (promotions.buyProducts == null || promotions.getProducts == null) {
      return cartSummary.cartItems ?? [];
    }

    /// Split item as items with single qty.
    List<CartItem> itemsAsSingleQty =
        _splitItemsAsSingleQty(cartSummary, promotions);

    // Find the list of applicable tiers.
    List<PromotionTiers> selectedTiers =
        _getTiers(itemsAsSingleQty, promotions);

    List<CartItem> discountAppliedCartItems = _applyDiscountAndGetCartItems(
        promotions, itemsAsSingleQty, selectedTiers);

    return discountAppliedCartItems;
  }

  /// Split the items in cart with single quantity
  /// if an item as more then 1 qty only for buy
  /// & get products of the promotions
  List<CartItem> _splitItemsAsSingleQty(
      CartSummary cartSummary, Promotions promotions) {
    List<CartItem> itemsAsSingleQty = List.empty(growable: true);

    cartSummary.cartItems?.forEach((element) {
      if (_isAvailableInBuyProducts(promotions, element)) {
        for (int i = 0; i < element.qty!.toInt(); i++) {
          CartItem temp = CartItem.fromJson(element.toJson());
          temp.qty = 1;
          itemsAsSingleQty.add(temp);
        }
      } else if (_isAvailableInGetProducts(promotions, element)) {
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

  bool _isAvailableInBuyProducts(Promotions promotions, CartItem element) {
    if (element.saleReturnsItemData != null) {
      return false;
    }

    // Already item wise promotion is applied
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

    // Already item wise promotion is applied
    if ((element.itemWisePromotionData?.promotionId ?? 0) > 0) {
      return false;
    }

    return promotions.getProducts!.contains(element.product?.id) &&
        !element.isComplementaryItem();
  }

  List<PromotionTiers> _getTiers(
      List<CartItem> itemsAsSingleQty, Promotions promotions) {
    //1. Arrange in descending order as per the price.
    List<CartItem> itemsAsSingleQtyInPriceDesc =
        _sortByCostliestFirst(itemsAsSingleQty);

    //2. Add items to temporary list
    List<CartItem> tempItemsList = List.empty(growable: true);
    for (var element in itemsAsSingleQtyInPriceDesc) {
      tempItemsList.add(CartItem.fromJson(element.toJson()));
    }

    MyLogUtils.logDebug(
        "$tag _getTiers tempItemsList.length : ${tempItemsList.length}");

    List<PromotionTiers> selectedTiers = List.empty(growable: true);

    //3. Sort the tiers in descending order.
    List<PromotionTiers> allTiersInSortedOrder =
        _getSortedTiersInDesc(promotions);

    // Iterate all the tiers
    for (var value in allTiersInSortedOrder) {
      int buyQty = value.buyQuantity ?? 0;
      int getQty = value.getQuantity ?? 0;

      int availableBuyQty = 0;
      int availableGetQty = 0;

      // Check if tier condition is satisfied.
      bool isTierConditionSatisfied =
          _isTierConditionSatisfied(tempItemsList, promotions, value);

      // Iterate using while, as recursive is needed here because of tiers.
      int whileLoopCount = 0;
      while (isTierConditionSatisfied) {
        bool isBuyQtyThresholdReached = false;

        whileLoopCount = whileLoopCount + 1;

        for (var cartItem in tempItemsList) {
          //Since the items are in descending order, keep counting for buy qty.

          if (!isBuyQtyThresholdReached &&
              _isBuyProduct(cartItem, promotions)) {
            MyLogUtils.logDebug(
                "$tag [APPLY] as buy product here for : ${cartItem.getProductName()}");
            availableBuyQty = availableBuyQty + 1;
            cartItem.itemWisePromotionData ??= CartItemPromotionItemData();
            cartItem.itemWisePromotionData?.isBuyProduct = true;
          }

          // Once the buy qty count reaches the required buy qty count

          MyLogUtils.logDebug(
              "$tag [APPLY] isBuyQtyThresholdReached: $isBuyQtyThresholdReached  and availableBuyQty : $availableBuyQty"
              "& cartItem : ${cartItem.getProductName()}");
          if (availableBuyQty == buyQty) {
            isBuyQtyThresholdReached = true;
            // Sort the list in cheapest & get its count.
            tempItemsList = _sortByCheapestFirst(tempItemsList);
            for (var cheapestItem in tempItemsList) {
              //Check for get Production & increment the count
              if (_isGetProduct(cheapestItem, promotions)) {
                availableGetQty = availableGetQty + 1;

                cartItem.itemWisePromotionData ??= CartItemPromotionItemData();
                cartItem.itemWisePromotionData?.isGetProduct = true;
                MyLogUtils.logDebug("$tag [APPLY] this is get product");
              }

              MyLogUtils.logDebug(
                  "$tag [APPLY] isBuyQtyThresholdReached: $isBuyQtyThresholdReached  and availableGetQty : $availableGetQty"
                  "& cheapestItem : ${cheapestItem.getProductName()}");

              // Once the count is reached, select the tier & reset the count;
              if (availableGetQty == getQty) {
                // this tier is selected
                selectedTiers.add(value);
                // Reset the counter
                availableBuyQty = 0;
                availableGetQty = 0;
                break;
              }
            }
          }
        }
        // Recheck the the tier condition for remaining products list
        isTierConditionSatisfied =
            _isTierConditionSatisfied(tempItemsList, promotions, value);

        MyLogUtils.logDebug(
            "$tag _getTiers isTierConditionSatisfied inside while: $isTierConditionSatisfied for : ${value.toJson()}");

        if (whileLoopCount > recoveryCount) {
          MyLogUtils.logDebug("$tag Forcefully close the while loop");
          isTierConditionSatisfied = false;
        }
      }
    }

    return selectedTiers;
  }

  // Before applying, all conditions are checked &
  // only selected promotions are applied to cart items without any checking.
  List<CartItem> _applyDiscountAndGetCartItems(Promotions promotions,
      List<CartItem> itemsAsSingleQty, List<PromotionTiers> promotionsTiers) {
    MyLogUtils.logDebug(
        "$tag _applyDiscountAndGetCartItems itemsAsSingleQty length : ${itemsAsSingleQty.length}, ");

    for (var cartItem in itemsAsSingleQty) {
      MyLogUtils.logDebug(
          "$tag _applyDiscountAndGetCartItems itemsAsSingleQty id : ${cartItem.product?.id}, name : ${cartItem.product?.name}");
    }
    //1. Arrange in cheapest item at first
    List<CartItem> cheapestItems = _sortByCheapestFirst(itemsAsSingleQty);
    MyLogUtils.logDebug(
        "$tag _applyDiscountAndGetCartItems cheapestItems length : ${cheapestItems.length}, ");

    for (var cartItem in cheapestItems) {
      MyLogUtils.logDebug(
          "$tag _applyDiscountAndGetCartItems cheapestItem id : ${cartItem.product?.id}, name : ${cartItem.product?.name}");
    }

    //2.Iterate all the tiers
    for (var value in promotionsTiers) {
      MyLogUtils.logDebug("$tag apply discount for tier : ${value.toJson()}");

      int buyQty = value.buyQuantity ?? 0;
      int getQty = value.getQuantity ?? 0;

      int groupId = PromotionsGroup().getNewGroupId();
      int availableBuyQty = 0;
      int availableGetQty = 0;

      bool isBuyQtyThresholdReached = false;
      bool isGetQtyThresholdReached = false;

      //3. Iterate all items & apply discount for the items that are part of this discount

      MyLogUtils.logDebug(
          "$tag _applyDiscountAndGetCartItems  inside tier cheapestItems length : ${cheapestItems.length}, ");

      for (var cartItem in cheapestItems) {
        MyLogUtils.logDebug(
            "$tag _applyDiscountAndGetCartItems inside tier cheapestItem id : ${cartItem.product?.id}, name : ${cartItem.product?.name}");

        if (!isGetQtyThresholdReached && _isGetProduct(cartItem, promotions)) {
          setItemWisePromotionDataToItem(cartItem, promotions, groupId, 100);
          cartItem.itemWisePromotionData?.isGetProduct = true;
          cartItem.itemWisePromotionData?.isFreeProduct = true;
          availableGetQty = availableGetQty + 1;
        }

        if (!isBuyQtyThresholdReached && _isBuyProduct(cartItem, promotions)) {
          cartItem.itemWisePromotionData ??= CartItemPromotionItemData();
          cartItem.itemWisePromotionData?.isBuyProduct = true;
          cartItem.itemWisePromotionData?.promotionGroupId = groupId;
          cartItem.itemWisePromotionData?.promotionId = promotions.id;
          availableBuyQty = availableBuyQty + 1;
        }

        if (availableGetQty > 0 && availableGetQty == getQty) {
          isGetQtyThresholdReached = true;
        }

        if (availableBuyQty > 0 && availableBuyQty == buyQty) {
          isBuyQtyThresholdReached = true;
          //break;
        }

        if (isBuyQtyThresholdReached && isGetQtyThresholdReached) {
          break;
        }
      }
    }

    return cheapestItems;
  }

  /// Check if tier condition is satisfied
  bool _isTierConditionSatisfied(
      List<CartItem> items, Promotions promotions, PromotionTiers tier) {
    MyLogUtils.logDebug(
        "$tag _isTierConditionSatisfied  for : ${tier.toJson()}");

    int buyQty = tier.buyQuantity ?? 0;
    int getQty = tier.getQuantity ?? 0;

    int availableBuyQty = 0;
    int availableGetQty = 0;

    /// Add items
    List<CartItem> tempItemsList = List.empty(growable: true);
    for (var value1 in items) {
      tempItemsList.add(CartItem.fromJson(value1.toJson()));
    }
    bool isBuyQtyThresholdReached = false;
    for (var cartItem in tempItemsList) {
      MyLogUtils.logDebug(
          "$tag isBuyQtyThresholdReached: $isBuyQtyThresholdReached "
          "& cartItem : ${cartItem.getProductName()}");
      //Since the items are in descending order, keep counting for buy qty.
      if (!isBuyQtyThresholdReached && _isBuyProduct(cartItem, promotions)) {
        MyLogUtils.logDebug("$tag this is buy product");
        availableBuyQty = availableBuyQty + 1;
        cartItem.itemWisePromotionData ??= CartItemPromotionItemData();
        cartItem.itemWisePromotionData?.isBuyProduct = true;
      }

      MyLogUtils.logDebug(
          "$tag isBuyQtyThresholdReached: $isBuyQtyThresholdReached  and availableBuyQty : $availableBuyQty"
          "& cartItem : ${cartItem.getProductName()}");
      // Once the buy qty count reaches the required buy qty count
      if (availableBuyQty == buyQty) {
        isBuyQtyThresholdReached = true;
        // Sort the list in cheapest & get its count.
        tempItemsList = _sortByCheapestFirst(tempItemsList);

        for (var cheapestItem in tempItemsList) {
          //Check for get product & increment the count
          if (_isGetProduct(cheapestItem, promotions)) {
            availableGetQty = availableGetQty + 1;
            cartItem.itemWisePromotionData ??= CartItemPromotionItemData();
            cheapestItem.itemWisePromotionData?.isGetProduct = true;
            MyLogUtils.logDebug("$tag this is get product");
          }

          MyLogUtils.logDebug(
              "$tag isBuyQtyThresholdReached: $isBuyQtyThresholdReached  and availableGetQty : $availableGetQty"
              "& cheapestItem : ${cheapestItem.getProductName()}");

          // Once the count is reached, select the tier & reset the count;
          if (availableGetQty == getQty) {
            // this tier is selected
            MyLogUtils.logDebug("$tag Buy & get qty is reached");
            return true;
          }
        }
      }
    }

    return false;
  }

  List<PromotionTiers> _getSortedTiersInDesc(Promotions promotions) {
    List<PromotionTiers> sortedTiers = promotions.promotionTiers ?? [];
    sortedTiers.sort((a, b) {
      if (a.buyQuantity == null || b.buyQuantity == null) {
        return 0;
      }
      return b.buyQuantity!.compareTo(a.buyQuantity!);
    });
    return sortedTiers;
  }

  /// Check is given item is buy product
  /// This checks if this item is already part of get item or buy item as well
  bool _isBuyProduct(CartItem item, Promotions promotions) {
    if ((item.itemWisePromotionData?.promotionId ?? 0) > 0) {
      return false;
    }

    return !(item.itemWisePromotionData?.isBuyProduct ?? false) &&
        !(item.itemWisePromotionData?.isGetProduct ?? false) &&
        promotions.buyProducts != null &&
        promotions.buyProducts!.contains(item.product?.id) &&
        !item.isComplementaryItem();
  }

  /// Check is given item is get product.
  /// This checks if this item is already part of get item or buy item as well
  bool _isGetProduct(CartItem item, Promotions promotions) {
    if ((item.itemWisePromotionData?.promotionId ?? 0) > 0) {
      return false;
    }
    return isItemValidForPromotion(promotions, item)
        ? (!(item.itemWisePromotionData?.isBuyProduct ?? false) &&
            !(item.itemWisePromotionData?.isGetProduct ?? false) &&
            promotions.getProducts != null &&
            promotions.getProducts!.contains(item.product?.id) &&
            !item.isComplementaryItem())
        : false;
  }

  bool _notValidForThisCart(CartSummary cartSummary, Promotions promotions) {
    return notValidForThisCart(tag, cartSummary, promotions);
  }

  List<CartItem> _sortByCostliestFirst(List<CartItem> cartItems) {
    cartItems.sort((a, b) {
      return b.getProductSubTotal().compareTo(a.getProductSubTotal());
    });
    return cartItems;
  }

  List<CartItem> _sortByCheapestFirst(List<CartItem> cartItems) {
    cartItems.sort((a, b) {
      return a.getProductSubTotal().compareTo(b.getProductSubTotal());
    });
    return cartItems;
  }
}
