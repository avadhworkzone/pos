import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/database/sale/model/PromotionData.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_pos/modules/promotions/validate/base_promotion.dart';
import 'package:jakel_pos/modules/promotions/validate/cartwide/cart_wide_flat.dart';
import 'package:jakel_pos/modules/promotions/validate/itemwise/amount_buy_for_x_get_y_percent_off.dart';
import 'package:jakel_pos/modules/promotions/validate/itemwise/amount_buy_for_x_in_price_range_get_y_flat_off.dart';
import 'package:jakel_pos/modules/promotions/validate/itemwise/amount_buy_for_x_in_price_range_get_y_percent_off.dart';
import 'package:jakel_pos/modules/promotions/validate/itemwise/limited_to_categories_flat.dart';
import 'package:jakel_pos/modules/promotions/validate/itemwise/limited_to_categories_percentage.dart';
import 'package:jakel_pos/modules/promotions/validate/itemwise/limited_to_products_flat.dart';
import 'package:jakel_pos/modules/promotions/validate/itemwise/limited_to_products_percentage.dart';
import 'package:jakel_pos/modules/promotions/validate/itemwise/limited_to_tags_flat.dart';
import 'package:jakel_pos/modules/promotions/validate/itemwise/limited_to_tags_percentage.dart';
import 'package:jakel_pos/modules/promotions/validate/itemwise/qty_bundle_buy.dart';
import 'package:jakel_pos/modules/promotions/validate/itemwise/qty_buy_x_get_n.dart';
import 'package:jakel_pos/modules/promotions/validate/itemwise/qty_buy_x_get_y_at_z_price.dart';
import 'package:jakel_pos/modules/promotions/validate/itemwise/qty_buy_x_get_y_percent.dart';
import 'package:jakel_pos/modules/promotions/validate/itemwise/qty_buy_x_get_y_percent_on_others.dart';
import 'package:jakel_pos/modules/promotions/validate/itemwise/qty_get_cheapest_free.dart';
import 'package:jakel_pos/modules/promotions/validate/itemwise/qty_gift_with_purchase.dart';
import 'package:jakel_pos/modules/promotions/validate/promotions_service.dart';

import 'cartwide/cart_wide_percentage.dart';
import 'itemwise/amount_buy_for_x_get_y_flat_off.dart';
import 'itemwise/amount_buy_for_x_in_brand_get_y_flat_off.dart';
import 'itemwise/amount_buy_for_x_in_brand_get_y_percent_off.dart';
import 'itemwise/limited_to_brands_flat.dart';
import 'itemwise/limited_to_brands_percentage.dart';
import 'itemwise/qty_buy_x_get_y_price_off.dart';
import 'itemwise/qty_buy_x_get_y_price_off_on_others.dart';

const String limitNoLimit = "NO_LIMIT";
const String limitByDates = "LIMITED_BY_DATES";
const String limitByDayOfMonth = "LIMIT_BY_DAY_OF_THE_MONTH";
const String limitHourOfTheDay = "LIMIT_BY_HOUR_OF_THE_DAY";
const String limitByDayOfTheWeek = "LIMIT_BY_DAY_OF_THE_WEEK";

class PromotionsServiceImpl with PromotionsService {
  final cartWidgetPercentage = "CART_WIDE_AUTOMATIC_PERCENTAGE"; //1

  final cartWideFlat = "CART_WIDE_AUTOMATIC_FLAT"; //2

  // Similar with percentage & flat
  final itemWiseLimitedToProductsPercentage =
      "ITEM_WISE_LIMITED_TO_PRODUCTS_PERCENTAGE"; //3
  final itemWiseLimitedToProductsFlat =
      "ITEM_WISE_LIMITED_TO_PRODUCTS_FLAT"; //4

  // Similar with percentage & flat
  final itemWiseLimitedToCategoriesPercentage =
      "ITEM_WISE_LIMITED_TO_CATEGORIES_PERCENTAGE"; //5
  final itemWiseLimitedToCategoriesFlat =
      "ITEM_WISE_LIMITED_TO_CATEGORIES_FLAT"; //6

  final itemWiseBuyXGetN = "ITEM_WISE_BUY_3_GET_1"; //7
  final itemWiseCheapestFree = "ITEM_WISE_CHEAPEST_FREE"; //8
  final itemWiseBundleBuy = "ITEM_WISE_BUNDLE_BUY"; //9

  final itemWiseGiftWithPurchase = "ITEM_WISE_GIFT_WITH_PURCHASE"; //10
  final itemWiseBuyXGetNAtZPrice =
      "ITEM_WISE_BUY_2_AND_GET_1_QUANTITY_AT_RM1"; //11

  //Similar with discount & flat off
  final itemWiseBuyXGetYPercentageOff =
      "ITEM_WISE_BUY_ANY_3_OR_MORE_AND_GET_30_OFF"; //12

  final itemWiseBuyXGetYAmountOff =
      "ITEM_WISE_BUY_ANY_3_OR_MORE_AND_GET_RM_30_OFF"; //13

  //Similar with discount & flat off
  final itemWiseBuyXGetYPercentOnOthers =
      "ITEM_WISE_BUY_2_GET_50_OFF_ON_OTHERS"; //14
  final itemWiseBuyXGetYPriceOffOnOthers =
      "ITEM_WISE_BUY_2_GET_RM_50_OFF_ON_OTHERS"; //15

  final itemWiseAsPerAmountGetPercentOffOnOthers =
      "ITEM_WISE_AS_PER_AMOUNT_GET_OFF_ON_OTHERS_PERCENTAGE"; //16

  final itemWiseAsPerAmountGetFlatOffOnOthers =
      "ITEM_WISE_AS_PER_AMOUNT_GET_OFF_ON_OTHERS_FLAT"; // 17

  final itemWiseLimitedToBrandsPercentage =
      "ITEM_WISE_LIMITED_TO_BRANDS_PERCENTAGE"; // 18

  final itemWiseLimitedToBrandsFlat = "ITEM_WISE_LIMITED_TO_BRANDS_FLAT"; // 19

  final itemWiseAsPerAmountLimitedToBrandPercentage =
      "ITEM_WISE_AS_PER_AMOUNT_LIMITED_TO_BRANDS_PERCENTAGE"; // 20

  final itemWiseAsPerAmountLimitedToBrandFlatAmount =
      "ITEM_WISE_AS_PER_AMOUNT_LIMITED_TO_BRANDS_FLAT"; // 21

  final itemWiseAsPerAmountLimitedToPricePercentage =
      "ITEM_WISE_AS_PER_AMOUNT_LIMITED_TO_PRICE_PERCENTAGE"; // 22

  final itemWiseAsPerAmountLimitedToPriceFlatAmount =
      "ITEM_WISE_AS_PER_AMOUNT_LIMITED_TO_PRICE_FLAT"; // 23

  final itemWiseAsPerSKULimitedToTagsFlatAmount =
      "ITEM_WISE_LIMITED_TO_TAGS_FLAT"; // 24

  final itemWiseAsPerSKULimitedToTagsPercentage =
      "ITEM_WISE_LIMITED_TO_TAGS_PERCENTAGE"; // 25

  @override
  List<CartItem> applyDiscount(CartSummary cartSummary, Promotions promotions) {
    return _getPromotionFactory(promotions)
            ?.applyDiscount(cartSummary, promotions) ??
        [];
  }

  @override
  List<Promotions> selectAllValidItemWisePromotions(
      CartSummary cartSummary, List<Promotions> allPromotions) {
    List<Promotions> filteredPromotions = List.empty(growable: true);

    var isGiftWithPurchaseAdded = false;
    // Allow only 1 gwp discount, because there is bug for multiple discount.
    for (var element in allPromotions) {
      final promotion = _getPromotionFactory(element);

      if (promotion != null &&
          promotion.isItemWise() &&
          promotion.isValidDiscountForSale(cartSummary, element)) {
        // filteredPromotions.add(element);

        // Allow only 1 gwp discount, because there is bug for multiple discount.
        if (promotion is QtyGiftWithPurchase) {
          if (!isGiftWithPurchaseAdded) {
            isGiftWithPurchaseAdded = true;
            filteredPromotions.add(element);
          }
        } else {
          filteredPromotions.add(element);
        }
      }
    }
    return filteredPromotions;
  }

  @override
  List<Promotions> selectAllValidCartWidePromotions(
      CartSummary cartSummary, List<Promotions> allPromotions) {
    List<Promotions> filteredPromotions = List.empty(growable: true);

    var isGiftWithPurchaseAdded = false;
    // Allow only 1 gwp discount, because there is bug for multiple discount.
    for (var element in allPromotions) {
      final promotion = _getPromotionFactory(element);

      if (promotion != null &&
          promotion.isCardWide() &&
          promotion.isValidDiscountForSale(cartSummary, element)) {
        // filteredPromotions.add(element);

        // Allow only 1 gwp discount, because there is bug for multiple discount.
        if (promotion is QtyGiftWithPurchase) {
          if (!isGiftWithPurchaseAdded) {
            isGiftWithPurchaseAdded = true;
            filteredPromotions.add(element);
          }
        } else {
          filteredPromotions.add(element);
        }
      }
    }
    return filteredPromotions;
  }

  @override
  bool isCartWidePromotion(Promotions promotions) {
    return _getPromotionFactory(promotions)?.isCardWide() ?? false;
  }

  @override
  bool isItemWisePromotion(Promotions promotions) {
    return _getPromotionFactory(promotions)?.isItemWise() ?? false;
  }

  @override
  CartSummary pickBestItemWisePromotions(
      CartSummary cartSummary, List<Promotions> allPromotions) {
    List<Promotions> selectAllValidPromotionsForCart =
        selectAllValidItemWisePromotions(cartSummary, allPromotions);

    List<Promotions> itemWisePromotions = List.empty(growable: true);

    if (selectAllValidPromotionsForCart.isNotEmpty) {
      for (var value in selectAllValidPromotionsForCart) {
        var promotionType = _getPromotionFactory(value);
        if (promotionType != null) {
          /// Item Wise Promotion
          if (promotionType.isItemWise()) {
            double discountAmount =
                promotionType.getDiscountAmount(cartSummary, value);

            if (discountAmount > 0) {
              itemWisePromotions.add(value);
            }
          }
        }
      }

      cartSummary.promotionData ??= PromotionData();
      cartSummary.promotionData?.appliedItemDiscounts =
          placeGwgInLast(itemWisePromotions);
    }

    return cartSummary;
  }

  @override
  CartSummary pickBestCartWidePromotions(
      CartSummary cartSummary, List<Promotions> allPromotions) {
    List<Promotions> selectAllValidPromotionsForCart =
        selectAllValidCartWidePromotions(cartSummary, allPromotions);

    if (selectAllValidPromotionsForCart.isNotEmpty) {
      Promotions? cartWide;
      double cartWideDiscountAmount = 0.0;
      for (var value in selectAllValidPromotionsForCart) {
        var promotionType = _getPromotionFactory(value);
        if (promotionType != null) {
          /// CART WIDE PROMOTION
          if (promotionType.isCardWide()) {
            if (promotionType.getDiscountAmount(cartSummary, value) >
                cartWideDiscountAmount) {
              cartWideDiscountAmount =
                  promotionType.getDiscountAmount(cartSummary, value);
              cartWide = value;
            }
          }
        }
      }
     
      cartSummary.promotionData ??= PromotionData();
      cartSummary.promotionData?.cartWideDiscount = cartWide;
    }

    return cartSummary;
  }

  List<Promotions> placeGwgInLast(List<Promotions> itemWisePromotions) {
    List<Promotions> sortedPromotions = List.empty(growable: true);

    for (var element in itemWisePromotions) {
      if (element.promotionType != itemWiseGiftWithPurchase) {
        sortedPromotions.add(element);
      }
    }

    for (var element in itemWisePromotions) {
      if (element.promotionType == itemWiseGiftWithPurchase) {
        sortedPromotions.add(element);
      }
    }

    return sortedPromotions;
  }

  BasePromotion? _getPromotionFactory(Promotions promotions) {
    if (promotions.promotionType == cartWidgetPercentage) {
      return CartWidePercentage();
    }
    if (promotions.promotionType == cartWideFlat) {
      return CartWideFlat();
    }

    if (promotions.promotionType == itemWiseLimitedToProductsPercentage) {
      return LimitedToProductsPercentage();
    }

    if (promotions.promotionType == itemWiseLimitedToProductsFlat) {
      return LimitedToProductsFlat();
    }

    if (promotions.promotionType == itemWiseLimitedToCategoriesPercentage) {
      return LimitedToCategoriesPercentage();
    }

    if (promotions.promotionType == itemWiseLimitedToCategoriesFlat) {
      return LimitedToCategoriesFlat();
    }

    if (promotions.promotionType == itemWiseBuyXGetN) {
      return QtyBuyXGetN();
    }

    if (promotions.promotionType == itemWiseBuyXGetYPercentOnOthers) {
      return QtyBuyXGetYPercentOnOthers();
    }

    if (promotions.promotionType == itemWiseBuyXGetYPriceOffOnOthers) {
      return QtyBuyXGetYPriceOffOnOthers();
    }

    if (promotions.promotionType == itemWiseCheapestFree) {
      return QtyGetCheapestFree();
    }

    if (promotions.promotionType == itemWiseBundleBuy) {
      return QtyBundleBuy();
    }

    if (promotions.promotionType == itemWiseBuyXGetYPercentageOff) {
      return QtyBuyXGetYPercent();
    }

    if (promotions.promotionType == itemWiseBuyXGetYAmountOff) {
      return QtyBuyXGetYPriceOff();
    }

    if (promotions.promotionType == itemWiseGiftWithPurchase) {
      return QtyGiftWithPurchase();
    }

    if (promotions.promotionType == itemWiseBuyXGetNAtZPrice) {
      return QtyBuyXGetYAtZPrice();
    }

    if (promotions.promotionType == itemWiseAsPerAmountGetPercentOffOnOthers) {
      return AmountBuyForXGetYPercentOff();
    }

    if (promotions.promotionType == itemWiseAsPerAmountGetFlatOffOnOthers) {
      return AmountBuyForXGetYFlatOff();
    }

    if (promotions.promotionType == itemWiseLimitedToBrandsPercentage) {
      return LimitedToBrandsPercentage();
    }

    if (promotions.promotionType == itemWiseLimitedToBrandsFlat) {
      return LimitedToBrandsFlat();
    }

    if (promotions.promotionType ==
        itemWiseAsPerAmountLimitedToBrandPercentage) {
      return AmountBuyForXInBrandGetYPercentOff();
    }

    if (promotions.promotionType ==
        itemWiseAsPerAmountLimitedToBrandFlatAmount) {
      return AmountBuyForXInBrandGetYFlatOff();
    }

    if (promotions.promotionType ==
        itemWiseAsPerAmountLimitedToPricePercentage) {
      return AmountBuyForXInPriceBetweenGetYPercentOff();
    }

    if (promotions.promotionType ==
        itemWiseAsPerAmountLimitedToPriceFlatAmount) {
      return AmountBuyForXInPriceRangeGetYFlatOff();
    }

    if (promotions.promotionType ==
        itemWiseAsPerSKULimitedToTagsFlatAmount) {
      return LimitedToTagsFlat();
    }

    if (promotions.promotionType ==
        itemWiseAsPerSKULimitedToTagsPercentage) {
      return LimitedToTagsPercentage();
    }

    return null;
  }
}
