import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/directors/model/DirectorsResponse.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';
import 'package:jakel_base/restapi/priceoverridetypes/model/PriceOverrideTypesResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_pos/modules/newsale/service/item_price_override_service.dart';

class ItemPriceOverrideServiceImpl with ItemPriceOverrideService {
  @override
  double getPercentageAllowed(
      List<PriceOverrideTypes> priceOverrideTypes,
      CartItem cartItem,
      CartSummary cartSummary,
      Cashier? cashier,
      StoreManagers? storeManagers,
      Directors? directors) {
    double? allowedStaffPrice;
    double? allowedStaffPercentage;

    // For employees, if allowed staff price is available, then price override should be allowed untill this price.
    if (cartSummary.employees != null) {
      return _getEmployeesThresholdPercentage(cartSummary, allowedStaffPrice,
          cartItem, allowedStaffPercentage, cashier);
    }

    if (cashier != null) {
      if (getSelectedUserPriceOverrideType(
              priceOverrideTypes, cashier, null, null) ==
          2) {
        // 2 = FLAT, 1 = PERCENTAGE
        return _getPercentageFromFlat(
            (applyAdditionalDiscountOnDiscounted(cartSummary)
                ? cartItem.cartItemPrice?.originalPrice
                : cartItem.cartItemPrice?.priceToBeUsedForManualDiscount),
            cartItem.product?.minimumPrice);
      }
      return cashier.priceOverrideLimitPercentageItem ?? 0.0;
    }

    if (storeManagers != null) {
      if (getSelectedUserPriceOverrideType(
              priceOverrideTypes, null, storeManagers, null) ==
          2) {
        // 2 = FLAT, 1 = PERCENTAGE
        return _getPercentageFromFlat(
            (applyAdditionalDiscountOnDiscounted(cartSummary)
                ? cartItem.cartItemPrice?.originalPrice
                : cartItem.cartItemPrice?.priceToBeUsedForManualDiscount),
            cartItem.product?.wholesalePrice);
      }
      return storeManagers.priceOverrideLimitPercentageItem ?? 0.0;
    }

    if (directors != null) {
      if (getSelectedUserPriceOverrideType(
              priceOverrideTypes, null, null, directors) ==
          2) {
        // 2 = FLAT, 1 = PERCENTAGE
        return _getPercentageFromFlat(
            (applyAdditionalDiscountOnDiscounted(cartSummary)
                ? cartItem.cartItemPrice?.originalPrice
                : cartItem.cartItemPrice?.priceToBeUsedForManualDiscount),
            cartItem.product?.wholesalePrice);
      }
      return directors.priceOverrideLimitPercentageItem ?? 0.0;
    }

    return 0;
  }

  double _getEmployeesThresholdPercentage(
      CartSummary cartSummary,
      double? allowedStaffPrice,
      CartItem cartItem,
      double? allowedStaffPercentage,
      Cashier? cashier) {
    if (cartSummary.employees != null) {
      allowedStaffPrice = cartItem.product?.staff_price;
      if (allowedStaffPrice != null && ((allowedStaffPrice ?? 0.0) > 0)) {
        allowedStaffPercentage = getDoubleValue(100 -
            ((allowedStaffPrice ?? 0) * 100) / (cartItem.getProductPrice()));
      }
    }

    double? priceOverrideLimitPercentage;
    // If allowed staff price is available then value
    if (allowedStaffPercentage != null) {
      priceOverrideLimitPercentage = allowedStaffPercentage;
    } else {
      priceOverrideLimitPercentage =
          cashier?.priceOverrideLimitPercentageItem ?? 0.0;
    }

    return priceOverrideLimitPercentage ?? 0;
  }

  _getPercentageFromFlat(double? originalPrice, double? allowedPrice) {
    MyLogUtils.logDebug(
        "product details original price $originalPrice, allowed price $allowedPrice");
    if ((originalPrice ?? 0) < (allowedPrice ?? 0)) {
      return 0;
    }

    double flatDiscount = ((originalPrice ?? 0) - (allowedPrice ?? 0));
    return 100 -
        (100 * ((originalPrice ?? 0) - (flatDiscount))) / (originalPrice ?? 0);
  }

  bool applyAdditionalDiscountOnDiscounted(CartSummary cartSummary) {
    if (cartSummary.companyConfiguration?.discountApplicableType?.key ==
        "ADDITIONAL_DISCOUNT_ON_ALREADY_DISCOUNTED_PRICES") {
      MyLogUtils.logDebug("ADDITIONAL_DISCOUNT_ON_ALREADY_DISCOUNTED_PRICES");
      return false;
    } else {
      MyLogUtils.logDebug("DISCOUNT_APPLIED_TO_THE_ORIGINAL_PRICE");
      return true;
    }
  }

  // Get the user configured price override type = FLAT / PERCENTAGE.
  int getSelectedUserPriceOverrideType(
      List<PriceOverrideTypes> priceOverrideTypes,
      Cashier? cashier,
      StoreManagers? storeManager,
      Directors? director) {
    int overrideType = 1;
    for (var eachOverrideType in priceOverrideTypes) {
      if (cashier != null) {
        if (eachOverrideType.id == cashier.priceOverrideType) {
          overrideType = eachOverrideType.id ?? overrideType;
          MyLogUtils.logDebug("OverrideType cashier: $overrideType");
          return overrideType;
        }
      }

      if (storeManager != null) {
        if (eachOverrideType.id == storeManager.priceOverrideType) {
          overrideType = eachOverrideType.id ?? overrideType;
          MyLogUtils.logDebug("OverrideType manager: $overrideType");
          return overrideType;
        }
      }

      if (director != null) {
        if (eachOverrideType.id == director.priceOverrideType) {
          overrideType = eachOverrideType.id ?? overrideType;
          MyLogUtils.logDebug("OverrideType director: $overrideType");
          return overrideType;
        }
      }
    }
    return overrideType;
  }
}
