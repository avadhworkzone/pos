import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';
import 'package:jakel_base/restapi/dreamprice/model/DreamPriceResponse.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'package:jakel_pos/modules/newsale/service/cart_service.dart';

import '../../app_locator.dart';
import '../../cashbacks/validate/cashback_service.dart';
import '../../dreamprices/dream_price_service.dart';
import '../../promotions/validate/promotions_service.dart';
import '../../vouchers/validate/voucher_config_service.dart';
import '../../vouchers/validate/voucher_service.dart';
import '../jobs/CartItemSubTotalJob.dart';
import '../jobs/CartItemSummaryUpdateJob.dart';
import '../jobs/CartManualCartDiscountJob.dart';
import '../jobs/CartManualItemDiscountJob.dart';
import '../jobs/CartResetAppliedPromotionsJob.dart';
import '../jobs/CartSummaryUpdateJob.dart';
import '../jobs/GetCartCalculationOrderJob.dart';
import '../model/NewSaleConfiguration.dart';

class CartServiceImpl with CartService {
  @override
  CartSummary getUpdatedCart(
      NewSaleConfiguration configuration,
      CartSummary cartSummary,
      List<DreamPrices> dreamPrices,
      List<Promotions> allPromotions,
      List<VoucherConfiguration> allVoucherConfigs,
      List<Cashbacks> allCashBacks) {
    var promotionService = appLocator.get<PromotionsService>();
    var voucherConfigService = appLocator.get<VoucherConfigService>();
    var voucherService = appLocator.get<VoucherService>();
    var cashBackService = appLocator.get<CashBackService>();
    var dreamPriceService = appLocator.get<DreamPriceService>();

    /// Step 1: Get the Cart Calculation Steps Configuration
    int index = 0;
    List<NewSaleCartCalculationSteps> steps =
        configuration.newSaleCartCalculationSteps ?? [];

    /// Step 2:  Iterate in while loop until all the steps are completed
    while (index < steps.length) {
      var step = steps[index];

      // Sub total Calculation
      if (_canStepProceed(cartConfigSubTotal, step, cartSummary)) {
        cartSummary = cartItemSubTotalJob(cartSummary);
      }

      // Reset Promotions Data
      if (_canStepProceed(cartConfigResetPromotionData, step, cartSummary)) {
        cartSummary.promotionData = null;
      }

      // Reset applied promotions
      if (_canStepProceed(cartConfigResetPromotions, step, cartSummary)) {
        cartSummary = cartResetAppliedPromotionsJob(cartSummary);
      }

      // Reset dream price
      if (_canStepProceed(cartConfigResetDreamPrice, step, cartSummary)) {
        cartSummary = dreamPriceService.resetAppliedDreamPrice(cartSummary);
      }

      // Apply dream price
      if (_canStepProceed(cartConfigUseDreamPrice, step, cartSummary)) {
        cartSummary =
            dreamPriceService.applyDreamPrice(dreamPrices, cartSummary);
      }

      // Apply Manual Item Discount
      if (_canStepProceed(cartConfigUseManualItemDiscount, step, cartSummary)) {
        cartSummary = cartIManualItemDiscountJob(cartSummary);
      }

      // Pick Up Automatic Item Wise Promotions.
      if (_canStepProceed(
          cartConfigAutomaticPickItemPromotion, step, cartSummary)) {
        cartSummary = promotionService.pickBestItemWisePromotions(
            cartSummary, allPromotions);
      }

      // Pick Up Automatic Cart Promotions.
      if (_canStepProceed(
          cartConfigAutomaticPickCartPromotion, step, cartSummary)) {
        if (cartSummary.autoPickPromotions) {
          cartSummary = promotionService.pickBestCartWidePromotions(
              cartSummary, allPromotions);
        }
      }

      /// Apply automatic item promotion
      if (_canStepProceed(
          cartConfigAutomaticApplyItemPromotion, step, cartSummary)) {
        cartSummary.promotionData?.appliedItemDiscounts?.forEach((element) {
          cartSummary.cartItems =
              promotionService.applyDiscount(cartSummary, element);
        });
      }

      /// Apply automatic cart promotion
      if (_canStepProceed(
          cartConfigAutomaticApplyCartPromotion, step, cartSummary)) {
        if (cartSummary.promotionData?.cartWideDiscount != null) {
          cartSummary.cartItems = promotionService.applyDiscount(
              cartSummary, cartSummary.promotionData!.cartWideDiscount!);
        }
      }

      /// Apply Manual cart discount or price override in cart level
      if (_canStepProceed(cartConfigUseManualCartDiscount, step, cartSummary)) {
        // Set the previous step calculated total taxable amount as price
        // to be used for manual cart discount
        cartSummary.cartPrice?.priceToBeUsedForManualDiscount =
            cartSummary.cartPrice?.totalTaxableAmount;
        cartSummary = cartManualCartDiscountJob(cartSummary);
      }

      /// Apply Voucher
      if (_canStepProceed(cartConfigApplyVoucher, step, cartSummary)) {
        if (cartSummary.vouchers != null) {
          cartSummary = voucherService.applyVouchers(cartSummary);
        }
      }

      /// Apply Cashback
      if (_canStepProceed(cartConfigApplyCashback, step, cartSummary)) {
        cashBackService.applyCashbackForThisCart(cartSummary, allCashBacks);
      }

      /// Generate New Vouchers based on total paid amount
      if (_canStepProceed(cartConfigGenerateNewVouchers, step, cartSummary)) {
        List<VoucherConfiguration> selectedVoucherConfigs = voucherConfigService
            .selectAllVoucherConfiguration(cartSummary, allVoucherConfigs);
        cartSummary.selectedVoucherConfigs = selectedVoucherConfigs;
      }

      index = index + 1;
      // Update the cart details after every loop
      cartSummary = updateCartSummary(cartSummary);
    }

    cartSummary = updateCartSummary(cartSummary);

    return cartSummary;
  }

// Update tax, taxable amount & total amount
  CartSummary updateCartSummary(CartSummary cartSummary) {
    // Calculate the cart items summary.
    cartSummary = cartItemSummaryUpdateJob(cartSummary);
    // Calculate the cart summary.
    cartSummary = cartSummaryUpdateJob(cartSummary);

    return cartSummary;
  }

  bool _isStepAllowedToProceedWith(
      bool? isCartExchangeOrReturn, bool? allowInExchangeOrReturn) {
    if (isCartExchangeOrReturn == null || isCartExchangeOrReturn == false) {
      return true;
    }

    if (isCartExchangeOrReturn == true && allowInExchangeOrReturn == true) {
      return true;
    }

    return false;
  }

  bool _canStepProceed(String expected, NewSaleCartCalculationSteps step,
      CartSummary cartSummary) {
    return expected == step.key &&
        _isStepAllowedToProceedWith(
            cartSummary.isExchange, step.allowedInExchange) &&
        _isStepAllowedToProceedWith(
            cartSummary.isReturns, step.allowedInReturns);
  }
}
