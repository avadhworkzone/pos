import 'package:jakel_base/database/sale/model/CartItemPriceOverrideData.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

cartIManualItemDiscountJob(CartSummary cartSummary) {
  // If already some discounts like dream price or automatic promotions is applied,
  // All them to give manual discount on top of this applied discounts.
  // If this flag is false, then only manual discount can be given on top original price;

  // DISCOUNT_APPLIED_TO_THE_ORIGINAL_PRICE -> ALl promotions will be applied to original price.

  bool useOnTopAppliedDiscountAmounts =
      cartSummary.companyConfiguration?.discountApplicableType?.key ==
          "ADDITIONAL_DISCOUNT_ON_ALREADY_DISCOUNTED_PRICES";

  cartSummary.cartItems?.forEach((element) {
    /// Manual Discount is already applied. So, set the next price to be used
    /// and other details accordingly.

    /// This null check if loops order should not be changed.
    /// Not Null Check Condition should be always in top
    if (element.cartItemPriceOverrideData != null &&
        element.cartItemPriceOverrideData?.priceOverrideAmount != null) {
      var priceToBeUsed =
          (element.cartItemPrice?.originalPrice ?? 0) / (element.qty ?? 1);
      if (useOnTopAppliedDiscountAmounts) {
        priceToBeUsed = element.cartItemPriceOverrideData!.priceOverrideAmount!;
      }
      element.cartItemPrice?.setNextCalculationPrice(priceToBeUsed);
    }

    /// Manual Discount is not applied to this product yet. So, assign the
    /// price to be used for manual discount calculation.
    if (element.cartItemPriceOverrideData == null ||
        element.cartItemPriceOverrideData?.priceOverrideAmount == null) {
      var priceToBeUsed =
          (element.cartItemPrice?.originalPrice ?? 0) / (element.qty ?? 1);

      if (useOnTopAppliedDiscountAmounts) {
        priceToBeUsed = element.cartItemPrice?.nextCalculationPrice ?? 0;
      }

      MyLogUtils.logDebug(
          "cartIManualItemDiscountJob useOnTopAppliedDiscountAmounts -> $useOnTopAppliedDiscountAmounts");
      MyLogUtils.logDebug(
          "cartIManualItemDiscountJob priceToBeUsed -> $priceToBeUsed");

      element.cartItemPrice?.setPriceToBeUsedForManualDiscount(priceToBeUsed);
      element.cartItemPriceOverrideData =
          CartItemPriceOverrideData(priceToBeUsedAsBase: priceToBeUsed);
    }
  });
  return cartSummary;
}
