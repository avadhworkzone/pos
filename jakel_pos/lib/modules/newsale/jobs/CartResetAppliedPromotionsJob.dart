import 'package:jakel_base/database/sale/model/CartSummary.dart';

import '../../promotions/validate/promotions_group.dart';

CartSummary cartResetAppliedPromotionsJob(CartSummary cartSummary) {
  PromotionsGroup().groupId = 0;
  cartSummary.cartItems?.forEach((element) {
    element.itemWisePromotionData?.discountPercent = 0.0;
    element.makeItGiftWithPurchase = false;
    element.itemWisePromotionData?.promotionGroupId = null;
    element.itemWisePromotionData?.promotionId = null;
    element.itemWisePromotionData?.isGetProduct = null;
    element.itemWisePromotionData?.isBuyProduct = null;
  });
  cartSummary.selectedVoucherConfigs = null;
  cartSummary.cashBackAmount = null;
  cartSummary.cashbackId = null;
  return cartSummary;
}
