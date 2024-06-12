import '../model/NewSaleConfiguration.dart';

const cartConfigSubTotal = "SUB_TOTAL";
const cartConfigResetPromotionData = "RESET_PROMOTION_DATA";
const cartConfigResetPromotions = "RESET_APPLIED_PROMOTIONS";
const cartConfigResetDreamPrice = "RESET_DREAM_PRICE";
const cartConfigUseDreamPrice = "USE_DREAM_PRICE";
const cartConfigUseManualItemDiscount = "USE_MANUAL_ITEM_DISCOUNT";
const cartConfigAutomaticPickItemPromotion = "PICK_AUTOMATIC_ITEM_PROMOTION";
const cartConfigAutomaticPickCartPromotion = "PICK_AUTOMATIC_CART_PROMOTION";
const cartConfigAutomaticApplyItemPromotion = "APPLY_AUTOMATIC_ITEM_PROMOTION";
const cartConfigAutomaticApplyCartPromotion = "APPLY_AUTOMATIC_CART_PROMOTION";
const cartConfigApplyVoucher = "APPLY_VOUCHER_CODE";
const cartConfigUseManualCartDiscount = "USE_MANUAL_CART_DISCOUNT";
const cartConfigApplyCashback = "APPLY_CASHBACK";
const cartConfigGenerateNewVouchers = "GENERATE_NEW_VOUCHERS";

getCartCalculationOrderJob() {
  final cartCalculationOrder =
      List<NewSaleCartCalculationSteps>.empty(growable: true);

  cartCalculationOrder.add(NewSaleCartCalculationSteps(
      key: cartConfigSubTotal,
      order: 1,
      allowedInExchange: true,
      allowedInReturns: true));

  cartCalculationOrder.add(NewSaleCartCalculationSteps(
      key: cartConfigResetPromotionData,
      order: 2,
      allowedInExchange: true,
      allowedInReturns: true));

  cartCalculationOrder.add(NewSaleCartCalculationSteps(
      key: cartConfigResetPromotions,
      order: 3,
      allowedInExchange: true,
      allowedInReturns: true));

  cartCalculationOrder.add(NewSaleCartCalculationSteps(
      key: cartConfigResetDreamPrice,
      order: 4,
      allowedInExchange: false,
      allowedInReturns: true));

  cartCalculationOrder.add(NewSaleCartCalculationSteps(
      key: cartConfigUseDreamPrice,
      order: 5,
      allowedInExchange: false,
      allowedInReturns: true));

  cartCalculationOrder.add(NewSaleCartCalculationSteps(
      key: cartConfigAutomaticPickItemPromotion,
      order: 6,
      allowedInExchange: false,
      allowedInReturns: true));

  cartCalculationOrder.add(NewSaleCartCalculationSteps(
      key: cartConfigAutomaticApplyItemPromotion,
      order: 7,
      allowedInExchange: false,
      allowedInReturns: true));

  cartCalculationOrder.add(NewSaleCartCalculationSteps(
      key: cartConfigUseManualItemDiscount,
      order: 8,
      allowedInExchange: false,
      allowedInReturns: true));

  cartCalculationOrder.add(NewSaleCartCalculationSteps(
      key: cartConfigAutomaticPickCartPromotion,
      order: 9,
      allowedInExchange: false,
      allowedInReturns: true));

  cartCalculationOrder.add(NewSaleCartCalculationSteps(
      key: cartConfigAutomaticApplyCartPromotion,
      order: 10,
      allowedInExchange: false,
      allowedInReturns: true));

  cartCalculationOrder.add(NewSaleCartCalculationSteps(
      key: cartConfigApplyVoucher,
      order: 11,
      allowedInExchange: false,
      allowedInReturns: true));

  cartCalculationOrder.add(NewSaleCartCalculationSteps(
      key: cartConfigUseManualCartDiscount,
      order: 12,
      allowedInExchange: false,
      allowedInReturns: true));

  cartCalculationOrder.add(NewSaleCartCalculationSteps(
      key: cartConfigApplyCashback,
      order: 13,
      allowedInExchange: false,
      allowedInReturns: true));

  cartCalculationOrder.add(NewSaleCartCalculationSteps(
      key: cartConfigGenerateNewVouchers,
      order: 14,
      allowedInExchange: false,
      allowedInReturns: true));

  return cartCalculationOrder;
}
