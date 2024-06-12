import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartItemFocData.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';
import 'package:jakel_base/restapi/dreamprice/model/DreamPriceResponse.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'package:jakel_base/serialportdevices/service/extended_display_service.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_pos/modules/newsale/service/cart_service.dart';
import 'package:jakel_pos/modules/newsale/service/new_sale_config_service.dart';
import 'package:jakel_pos/modules/promotions/validate/promotions_group.dart';

import '../app_locator.dart';

class CartViewModel extends BaseViewModel {
  CartSummary getCartSummary(
      CartSummary cartSummary,
      List<DreamPrices> dreamPrices,
      List<Promotions> allPromotions,
      List<VoucherConfiguration> allVoucherConfigs,
      List<Cashbacks> allCashBacks) {
    var cartService = appLocator.get<CartService>();
    var newSaleConfigService = appLocator.get<NewSaleConfigService>();

    cartSummary = cartService.getUpdatedCart(
        newSaleConfigService.getConfig(),
        cartSummary,
        dreamPrices,
        allPromotions,
        allVoucherConfigs,
        allCashBacks);

    return cartSummary;

    // var promotionService = appLocator.get<PromotionsService>();
    // var voucherConfigService = appLocator.get<VoucherConfigService>();
    // var voucherService = appLocator.get<VoucherService>();
    // var cashBackService = appLocator.get<CashBackService>();
    //
    // /// Get Cart summary without discount
    // cartSummary = _getCartSummary(cartSummary);
    //
    // /// Reset group id &  cart items before selecting promotions
    // cartSummary.promotionData = null;
    // cartSummary = _resetPromotions(cartSummary);
    //
    // /// Pick up best cartWide & itemWise promotions
    // ///if we perform exchange then promotions will not apply
    // if (cartSummary.isExchange != true) {
    //   if (cartSummary.autoPickPromotions) {
    //     cartSummary =
    //         promotionService.pickBestPromotions(cartSummary, allPromotions);
    //   }
    //
    //   /// Reset group id &  cart items before applying promotions
    //   _resetPromotions(cartSummary);
    //
    //   /// Apply the item wise promotion
    //   cartSummary.promotionData?.appliedItemDiscounts?.forEach((element) {
    //     cartSummary.cartItems =
    //         promotionService.applyDiscount(cartSummary, element);
    //   });
    //
    //   /// Apply the cart wide promotion
    //   if (cartSummary.promotionData?.cartWideDiscount != null) {
    //     cartSummary.cartItems = promotionService.applyDiscount(
    //         cartSummary, cartSummary.promotionData!.cartWideDiscount!);
    //   }
    //
    //   //Apply Voucher Code;
    //   if (cartSummary.vouchers != null) {
    //     cartSummary = voucherService.applyVouchers(cartSummary);
    //   }
    //
    //   /// Calculate discounts
    //   cartSummary.discount = _getDiscount(cartSummary.cartItems);
    //
    //   MyLogUtils.logDebug(" cartSummary.discount : ${cartSummary.discount}");
    //
    //   // Apply Custom cart leve manual discount.
    //   cartSummary = applyCustomCartDiscount(cartSummary);
    //
    //   //Apply cashback
    //   cashBackService.applyCashbackForThisCart(cartSummary, allCashBacks);
    //
    //   //Select applicable voucher configuration
    //   List<VoucherConfiguration> selectedVoucherConfigs = voucherConfigService
    //       .selectAllVoucherConfiguration(cartSummary, allVoucherConfigs);
    //
    //   cartSummary.selectedVoucherConfigs = selectedVoucherConfigs;
    // }
    // onCartUpdated(cartSummary);
    //
    // return cartSummary;
  }

  // CartSummary applyCustomCartDiscount(CartSummary cartSummary) {
  //   double priceOverrideDiscountPercentage =
  //       cartSummary.cartCustomDiscount?.discountPercentage ?? 0;
  //
  //   MyLogUtils.logDebug(
  //       "applyCustomCartDiscount priceOverrideDiscountPercentage :$priceOverrideDiscountPercentage ");
  //
  //   //1. We need to apply for all the items in cart level
  //   if (cartSummary.cartCustomDiscount != null &&
  //       cartSummary.cartCustomDiscount?.discountPercentage != null) {
  //     cartSummary.cartItems?.forEach((element) {
  //       //2. Check if this item is not having 100 % discount.
  //       if (element.getIsSelectItem()) {
  //         if (element.discountPercent == null ||
  //             element.discountPercent! < 100) {
  //           //3.Get original price to update discount percentage
  //           double originalPriceWithoutAnyDiscount =
  //               element.getProductSubTotal();
  //           //4. get taxable price
  //           double taxablePrice = element.getTaxableAmount();
  //           //5. Calculate new taxable price after applying discount
  //           double newTaxablePrice = taxablePrice -
  //               taxablePrice * (priceOverrideDiscountPercentage / 100);
  //
  //           MyLogUtils.logDebug(
  //               "applyCustomCartDiscount newTaxablePrice :$newTaxablePrice ");
  //
  //           //6. Calculate the discount percentage
  //           double totalDiscountPercentage =
  //               100 - newTaxablePrice * 100 / originalPriceWithoutAnyDiscount;
  //
  //           MyLogUtils.logDebug(
  //               "applyCustomCartDiscount totalDiscountPercentage :$totalDiscountPercentage ");
  //
  //           //7. Apply the discount percent to the items.
  //           if (totalDiscountPercentage < 100) {
  //             element.discountPercent = totalDiscountPercentage;
  //           }
  //         }
  //       }
  //     });
  //
  //     // if (priceOverrideDiscountPercentage > 0) {
  //     //   cartSummary.cartCustomDiscount!.priceOverrideAmount =
  //     //       _getPayableOverrideAmount(cartSummary);
  //     // }
  //   }
  //
  //   MyLogUtils.logDebug(
  //       " applyCustomCartDiscount priceOverrideAmount : ${cartSummary.cartCustomDiscount?.priceOverrideAmount}");
  //
  //   return cartSummary;
  // }

  void onCartUpdated(CartSummary cartSummary) {
    var extendedDisplayService = appLocator.get<ExtendedDisplayService>();
    extendedDisplayService.notifyCartUpdate(cartSummary);
  }

  // CartSummary _resetPromotions(CartSummary cartSummary) {
  //   PromotionsGroup().groupId = 0;
  //   cartSummary.cartItems?.forEach((element) {
  //     element.discountPercent = 0.0;
  //     element.makeItGiftWithPurchase = false;
  //     element.promotionGroupId = null;
  //     element.promotionId = null;
  //     element.isGetProduct = null;
  //     element.isBuyProduct = null;
  //
  //     // In case of complimentary item, it should be marked as discount 100 percent
  //     if (element.makeItComplimentary != null &&
  //         (element.makeItComplimentary == true)) {
  //       element.discountPercent = 100.0;
  //     }
  //   });
  //   cartSummary.selectedVoucherConfigs = null;
  //   cartSummary.cashBackAmount = null;
  //   cartSummary.cashbackId = null;
  //   return cartSummary;
  // }

  double _getDiscount(List<CartItem>? cartItems) {
    double subTotal = 0.0;

    if (cartItems != null) {
      for (var element in cartItems) {
        if (element.getIsSelectItem()) {
          subTotal = subTotal + element.getDiscountAmount();
        }
      }
    }
    return subTotal;
  }

  ///merge item
  List<CartItem> mergeItem(CartSummary cartSummary) {
    Map<String, CartItem> mappedItems = {};

    cartSummary.cartItems?.forEach((element) {
      var existing = mappedItems[element.getUniqueIdOfProduct()];
      if (existing != null) {
        element.qty = element.qty! + existing.qty!;
      }
      mappedItems[element.getUniqueIdOfProduct()] = element;
    });

    return List.from(mappedItems.values);
  }

  /// Removes all the discount in cart items.
  /// If items are split, it will be grouped as per the items with qty
  List<CartItem> removeAllDiscountsAndGroupItCorrectly(
      CartSummary cartSummary) {
    PromotionsGroup().groupId = 0;
    Map<String, CartItem> mappedItems = {};

    cartSummary.cartItems?.forEach((element) {
      element.itemWisePromotionData?.discountPercent = 0.0;
      element.makeItGiftWithPurchase = false;
      element.itemWisePromotionData?.promotionGroupId = null;
      element.itemWisePromotionData?.isGetProduct = null;
      element.itemWisePromotionData?.isBuyProduct = null;
      var existing = mappedItems[element.getUniqueIdOfProduct()];
      if (existing != null) {
        element.qty = element.qty! + existing.qty!;
      }
      mappedItems[element.getUniqueIdOfProduct()] = element;
    });

    return List.from(mappedItems.values);
  }

  double getTotalQuantity(CartSummary cartSummary) {
    double totalQty = 0;
    cartSummary.cartItems?.forEach((element) {
      totalQty = totalQty + (element.qty ?? 0);
    });
    return totalQty;
  }

  double getTotalItems(CartSummary cartSummary) {
    double totalItems = 0;
    List<String> alreadyAddedUpc = List.empty(growable: true);
    cartSummary.cartItems?.forEach((element) {
      if (!alreadyAddedUpc.contains(element.product?.upc)) {
        totalItems = totalItems + 1;
        alreadyAddedUpc.add(element.product?.upc ?? "");
      }
    });
    return totalItems;
  }

  bool isExchangeItemsValid(CartSummary cartSummary) {
    if (cartSummary.isExchange == null || cartSummary.isExchange == false) {
      return true;
    }

    bool isValid = true;

    //TODO : If needed we add additional validation
    return isValid;
  }

  CartItem? getNewItemFromCart(int productId, CartSummary cartSummary) {
    CartItem? selected;
    cartSummary.cartItems?.forEach((element) {
      // This is sale returns or exchange
      if (element.saleReturnsItemData == null &&
          element.product?.id == productId) {
        selected = element;
      }
    });
    return selected;
  }

  double getDiscountPercent(CartItem cartItem) {
    return cartItem.getTotalDiscountPercent();
  }

  double getSingleItemPrice(CartItem cartItem) {
    if (cartItem.getProductPrice() != cartItem.getOriginalProductPrice() &&
        cartItem.saleReturnsItemData == null) {
      return getRoundedDoubleValue(cartItem.getOriginalProductPrice());
    }

    return getRoundedDoubleValue(cartItem.getPerUnitPrice());
  }

  List<CartItem> onPriceUpdated(List<CartItem> allItems, CartItem cartItem,
      int index, bool assignToAll, double percentageToBeUsed, int quantity) {
    // In case of assign to all items, qty field is ignored.
    if (assignToAll) {
      for (var element in allItems) {
        MyLogUtils.logDebug(
            "isPriceOverrideApplied : ${!element.isPriceOverrideApplied()} ");
        if (!element.isComplementaryItem() &&
            !element.isPriceOverrideApplied()) {
          element.cartItemPriceOverrideData?.priceOverrideAmount =
              getDoubleValue(percentageToBeUsed *
                  element.getProductPriceForPriceOverride() /
                  100);
          element.cartItemPriceOverrideData?.storeManagerPasscode =
              cartItem.cartItemPriceOverrideData?.storeManagerPasscode;
          element.cartItemPriceOverrideData?.directorId =
              cartItem.cartItemPriceOverrideData?.directorId;
          element.cartItemPriceOverrideData?.storeManagerId =
              cartItem.cartItemPriceOverrideData?.storeManagerId;
          element.cartItemPriceOverrideData?.directorPasscode =
              cartItem.cartItemPriceOverrideData?.directorPasscode;
          element.cartItemPriceOverrideData?.cashierId =
              cartItem.cartItemPriceOverrideData?.cashierId;
        }
      }
      return allItems;
    } else {
      List<CartItem> updatedCartItems = List.empty(growable: true);
      int position = 0;
      for (var element in allItems) {
        if (assignToAll || index == position) {
          if (percentageToBeUsed > 0) {
            CartItem tempItem = CartItem.fromJson(element.toJson());
            double qtyDifference =
                (tempItem.qty ?? 0) - getDoubleValue(quantity);

            if (qtyDifference > 0) {
              tempItem.cartItemPriceOverrideData?.priceOverrideAmount = null;
              tempItem.cartItemPriceOverrideData?.storeManagerPasscode = null;
              tempItem.cartItemPriceOverrideData?.directorId = null;
              tempItem.cartItemPriceOverrideData?.storeManagerId = null;
              tempItem.cartItemPriceOverrideData?.directorPasscode = null;
              tempItem.cartItemPriceOverrideData?.cashierId = null;
              tempItem.qty = qtyDifference;
              updatedCartItems.add(tempItem);
            }

            element.cartItemPriceOverrideData?.priceOverrideAmount =
                getDoubleValue(percentageToBeUsed *
                    element.getProductPriceForPriceOverride() /
                    100);

            element.cartItemPriceOverrideData?.storeManagerPasscode =
                cartItem.cartItemPriceOverrideData?.storeManagerPasscode;
            element.cartItemPriceOverrideData?.directorId =
                cartItem.cartItemPriceOverrideData?.directorId;
            element.cartItemPriceOverrideData?.storeManagerId =
                cartItem.cartItemPriceOverrideData?.storeManagerId;
            element.cartItemPriceOverrideData?.directorPasscode =
                cartItem.cartItemPriceOverrideData?.directorPasscode;
            element.cartItemPriceOverrideData?.cashierId =
                cartItem.cartItemPriceOverrideData?.cashierId;
            element.qty = getDoubleValue(quantity);
          } else {
            //Remove manual discount if percentage to be used is -1
            element.cartItemPriceOverrideData?.priceOverrideAmount = null;
            element.cartItemPriceOverrideData?.storeManagerPasscode = null;
            element.cartItemPriceOverrideData?.directorId = null;
            element.cartItemPriceOverrideData?.storeManagerId = null;
            element.cartItemPriceOverrideData?.directorPasscode = null;
            element.cartItemPriceOverrideData?.cashierId = null;
          }
        }

        updatedCartItems.add(element);
        position += 1;
      }
      return updatedCartItems;
    }
  }

  List<CartItem> onComplimentaryItemUpdated(List<CartItem> allItems,
      CartItem cartItem, int index, CartItemFocData focData) {
    List<CartItem> updatedCartItems = List.empty(growable: true);

    int position = 0;

    for (var element in allItems) {
      if (index == position) {
        if ((focData.complimentaryItemReasonId ?? 0) > 0) {
          CartItem tempItem = CartItem.fromJson(element.toJson());
          double qtyDifference =
              (tempItem.qty ?? 0) - getDoubleValue(focData.qty);

          // Out of some x qty, only y qty is FOC and so remaining item is being added as normal products
          if (qtyDifference > 0) {
            tempItem.itemWisePromotionData?.discountPercent = null;
            tempItem.cartItemFocData = null;
            tempItem.qty = qtyDifference;
            updatedCartItems.add(tempItem);
          }

          // Set Complimentary Item data details
          element.cartItemFocData = focData;
          element.qty = getDoubleValue(focData.qty ?? 1);
        } else {
          // Remove Complimentary Item data
          element.cartItemFocData = null;
        }
      }
      updatedCartItems.add(element);
      position += 1;
    }
    return updatedCartItems;
  }

  List<CartItem> onOpenPriceAdded(
      List<CartItem> allItems, CartItem cartItem, int index, double openPrice) {
    List<CartItem> updatedCartItems = List.empty(growable: true);
    int position = 0;
    for (var value in allItems) {
      if (index == position) {
        value.openPrice = openPrice;
      }
      updatedCartItems.add(value);
      position += 1;
    }

    return updatedCartItems;
  }
}
