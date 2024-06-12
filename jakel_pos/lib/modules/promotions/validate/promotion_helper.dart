import 'package:jakel_base/database/promotions/promotion_types.dart';
import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartItemPromotionItemData.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_pos/modules/promotions/validate/promotions_service_impl.dart';
import 'package:jakel_pos/modules/vouchers/validate/voucher_helper.dart';

import '../../utils/validation_helper.dart';

bool isPromotionValidForThisCartForGivenUser(
    String tag, CartSummary cartSummary, Promotions promotions) {
  // Guests Validation
  if (allowGuestMember(cartSummary, promotions.allowWalkInMember)) {
    MyLogUtils.logDebug("$tag allowGuestMember is true");
    if (cartSummary.employees == null && cartSummary.customers == null) {
      return true;
    }
  }

  // Employees Validation
  if (allowEmployees(promotions.allowEmployee)) {
    if (cartSummary.employees != null && cartSummary.customers == null) {
      // Employee groups compatibility.
      bool result = isAvailableInUserGroup(
          promotions.employeeGroups, cartSummary.employees?.employeeGroup?.id);

      if (result) {
        MyLogUtils.logDebug("$tag allowEmployees is true");
        return true;
      }
      return false;
    }
  }

  // Members Validation
  if (allowRegisteredMember(promotions.allowRegisteredMember)) {
    if (cartSummary.customers != null && cartSummary.employees == null) {
      // Member groups compatibility.
      bool result = isAvailableInUserGroup(
          promotions.memberGroups, cartSummary.customers?.memberGroup?.id);

      if (result) {
        MyLogUtils.logDebug("$tag allowRegisteredMember is true");
        return true;
      }
      return false;
    }
  }

  return false;
}

bool notValidForThisCart(
    String tag, CartSummary cartSummary, Promotions promotions) {

  //Booking sale promotion shouldn't apply
  if (cartSummary.isBookingSale) {
    return true;
  }

  // For Cart Wide promotion , dream price check is added.
  if ((promotions.promotionType == promotionCartWidgetAutomaticFlat) ||
      (promotions.promotionType == promotionCartWidgetAutomaticPercentage) ||
      promotions.promotionType == promotionCartWidgetGiftWithPurchase) {
    // If dreamPriceApplicable is false & any one item in cart has dream price
    // then this promotion s not applicable.
    if (promotions.dreamPriceApplicable == false &&
        isDreamPriceAvailableInThisCart(cartSummary)) {
      return true;
    }
  }

  var result =
      isPromotionValidForThisCartForGivenUser(tag, cartSummary, promotions);

  //If not true for the given users condition, then its not valid for this cart
  if (!result) {
    return true;
  }

  //NO LIMIT
  if (promotions.timeframeType == limitNoLimit) {
    return false;
  }

  //LIMIT BY DATES
  if (promotions.timeframeType == limitByDates) {
    //Start & End date should be valid
    if (checkIsValidDate(promotions.startDate, promotions.endDate)) {
      return false;
    }
  }

  //LIMIT BY DAY OF MONTH
  if (promotions.timeframeType == limitByDayOfMonth &&
      promotions.monthDates != null) {
    if (promotions.monthDates!.contains(getNow().day)) {
      return false;
    }
  }

  // LIMIT BY HOUR OF THE DAY
  if (promotions.timeframeType == limitHourOfTheDay) {
    if (checkIsValidTime(
        promotions.startDate, promotions.startTime, promotions.endTime)) {
      return false;
    }
  }

  //LIMIT_BY_DAY_OF_THE_WEEK
  if (promotions.timeframeType == limitByDayOfTheWeek &&
      promotions.weekDays != null) {
    if (promotions.weekDays!.contains(getNow().weekday)) {
      return false;
    }
  }

  return true;
}

void setItemWisePromotionDataToItem(
  CartItem element,
  Promotions promotions,
  int? groupId,
  double discountPercentage,
) {
  element.itemWisePromotionData ??= CartItemPromotionItemData();
  element.itemWisePromotionData?.discountPercent = discountPercentage;
  element.itemWisePromotionData?.promotionId = promotions.id;
  element.itemWisePromotionData?.promotionGroupId = groupId;

  // Calculate the discount price based on next calculation price & discount percentage.
  var discountAmountInThisStep =
      ((element.cartItemPrice?.nextCalculationPrice ?? 0) *
          discountPercentage /
          100);

  // Calculate the price after this discount
  var nextCalculationPrice =
      (element.cartItemPrice?.nextCalculationPrice ?? 0) -
          discountAmountInThisStep;

  // Set item discount in variable
  element.cartItemPrice?.setAutomaticItemDiscount(
      getRoundedDoubleValue(discountAmountInThisStep * (element.qty ?? 1)));
  // Set the new price to be used for next calculation;
  element.cartItemPrice?.setNextCalculationPrice(nextCalculationPrice);
}

// Returns the price to be used to calculate the item wise discount
double getPriceToCalculateAutomaticPromotion(CartItem element) {
  return (element.cartItemPrice?.nextCalculationPrice ?? 0);
}

double getDiscountPercentageFromFlat(
    CartItem element, double flatDiscountAmount) {
  return 100 -
      (100 *
              (getPriceToCalculateAutomaticPromotion(element) -
                  (flatDiscountAmount))) /
          getPriceToCalculateAutomaticPromotion(element);
}
