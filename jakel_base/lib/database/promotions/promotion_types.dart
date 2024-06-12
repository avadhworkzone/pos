import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';

/// Cart wide promotions type
const String promotionCartWidgetAutomaticPercentage =
    "CART_WIDE_AUTOMATIC_PERCENTAGE";
const String promotionCartWidgetAutomaticFlat = "CART_WIDE_AUTOMATIC_FLAT";
const String promotionCartWidgetGiftWithPurchase =
    "CART_WIDE_GIFT_WITH_PURCHASE";

/// Item wise promotions type
const String promotionItemWiseLimitedToProductsPercentage =
    "ITEM_WISE_LIMITED_TO_PRODUCTS_PERCENTAGE";
const String promotionItemWiseLimitedToProductsFlat =
    "ITEM_WISE_LIMITED_TO_PRODUCTS_FLAT";
const String promotionItemWiseLimitedToCategoriesPercentage =
    "ITEM_WISE_LIMITED_TO_CATEGORIES_PERCENTAGE";
const String promotionItemWiseLimitedToCategoriesFlat =
    "ITEM_WISE_LIMITED_TO_CATEGORIES_FLAT";
const String promotionItemWiseBuy3Get1 = "ITEM_WISE_BUY_3_GET_1";
const String promotionItemWiseBuy2Get50OffOnOthers =
    "ITEM_WISE_BUY_2_GET_50_OFF_ON_OTHERS";
const String promotionItemWiseBuyAny3OrMoreAndGet30Off =
    "ITEM_WISE_BUY_ANY_3_OR_MORE_AND_GET_30_OFF";
const String promotionItemWiseCheapestFree = "ITEM_WISE_CHEAPEST_FREE";
const String promotionItemWiseBundleBuy = "ITEM_WISE_BUNDLE_BUY";

/// Promotion time limit
const String promotionTimeFrameNoLimit = "NO_LIMIT";
const String promotionTimeFrameLimitByDates = "LIMITED_BY_DATES";
const String promotionTimeFrameLimitByDayOfWeek = "LIMIT_BY_DAY_OF_THE_WEEK";
const String promotionTimeFrameLimitByDayOfMonth = "LIMIT_BY_DAY_OF_THE_MONTH";
const String promotionTimeLimitByHourOfTheDay = "LIMIT_BY_HOUR_OF_THE_DAY";

bool isCartWideDiscount(Promotions promotions) {
  if (promotions.promotionType != null &&
      (promotions.promotionType == promotionCartWidgetAutomaticPercentage ||
          promotions.promotionType == promotionCartWidgetGiftWithPurchase ||
          promotions.promotionType == promotionCartWidgetAutomaticFlat)) {
    return true;
  }
  return false;
}

bool isItemWiseDiscount(Promotions promotions) {
  if (promotions.promotionType != null &&
      (promotions.promotionType == promotionItemWiseLimitedToProductsPercentage ||
          promotions.promotionType == promotionItemWiseLimitedToProductsFlat ||
          promotions.promotionType ==
              promotionItemWiseLimitedToCategoriesPercentage ||
          promotions.promotionType ==
              promotionItemWiseLimitedToCategoriesFlat ||
          promotions.promotionType == promotionItemWiseBuy3Get1 ||
          promotions.promotionType == promotionItemWiseBuy2Get50OffOnOthers ||
          promotions.promotionType ==
              promotionItemWiseBuyAny3OrMoreAndGet30Off ||
          promotions.promotionType == promotionItemWiseCheapestFree ||
          promotions.promotionType == promotionItemWiseBundleBuy)) {
    return true;
  }
  return false;
}
