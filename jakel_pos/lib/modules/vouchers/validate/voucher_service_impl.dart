import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_pos/modules/vouchers/validate/voucher_helper.dart';
import 'package:jakel_pos/modules/vouchers/validate/voucher_service.dart';

class VoucherServiceImpl with VoucherService {
  @override
  CartSummary applyVouchers(CartSummary cartSummary) {
    Vouchers vouchers = cartSummary.vouchers!;

    MyLogUtils.logDebug("applyVouchers vouchers : ${vouchers.toJson()}");

    var validationMessage = voucherValidation(cartSummary);

    MyLogUtils.logDebug(
        "applyVouchers cartSummary.cartPrice?.total : ${cartSummary.cartPrice?.total}");

    if (vouchers.minimumSpendAmount != null &&
        (cartSummary.cartPrice?.total ?? 0) <
            (vouchers.minimumSpendAmount ?? 0)) {
      validationMessage =
          "Minimum payable amount should be ${vouchers.minimumSpendAmount ?? 0}";
    }

    MyLogUtils.logDebug("applyVouchers validationMessage : $validationMessage");

    // If validation fails reset the voucher
    if (validationMessage != null) {
      cartSummary.voucherErrorMessage = validationMessage;
      cartSummary.vouchers = null;
      cartSummary.voucherCode = null;
      cartSummary.voucherDiscountAmount = null;
      return cartSummary;
    }

    MyLogUtils.logDebug("applyVouchers vouchers : ${vouchers.toJson()}");

    double totalVoucherDiscountAmount = 0.0;

    double voucherDiscountPercentage = vouchers.percentage ?? 0.0;

    MyLogUtils.logDebug(
        "applyVouchers voucherDiscountPercentage : $voucherDiscountPercentage");

    cartSummary.cartItems?.forEach((element) {
      MyLogUtils.logDebug(
          "applyVouchers getIsSelectItem : ${element.getIsSelectItem()} "
          "&& element.getTotalDiscountPercent() : ${element.getTotalDiscountPercent()}");

      if (element.getIsSelectItem()) {
        if (element.getTotalDiscountPercent() < 100) {
          //1. Get taxable amount at this stage.(After promotion is applied.)
          double taxablePrice = element.cartItemPrice?.taxableAmount ?? 0;

          MyLogUtils.logDebug("applyVouchers taxablePrice : $taxablePrice");
          MyLogUtils.logDebug(
              "applyVouchers subtotal  : ${element.cartItemPrice?.subTotal}");
          double voucherDiscountAmount = 0.0;

          if ((vouchers.flatAmount ?? 0.0) > 0) {
            // Voucher is flat amount type, calculate voucherDiscountPercentage using weight of the item in cart.
            // Ex. a of 50 , b of 25 , here a has 66.66 % & b has 33.33%
            double weightPercentageInCart =
                (element.cartItemPrice?.subTotal ?? 0) *
                    100 /
                    (cartSummary.cartPrice?.subTotal ?? 0);

            //2. Calculate voucher discount amount using flat amount & weight
            voucherDiscountAmount =
                (vouchers.flatAmount ?? 0.0) * weightPercentageInCart / 100;
          }

          if ((vouchers.percentage ?? 0.0) > 0) {
            // This voucher % is on top of payable price & not top of original price.
            // So we cannot add % directly to itemDiscount.
            //2. Calculate voucher discount amount from taxable price.
            voucherDiscountAmount =
                taxablePrice * (voucherDiscountPercentage / 100);
          }

          MyLogUtils.logDebug(
              "applyVouchers voucherDiscountAmount : $voucherDiscountAmount");

          totalVoucherDiscountAmount =
              totalVoucherDiscountAmount + voucherDiscountAmount;

          MyLogUtils.logDebug(
              "applyVouchers totalVoucherDiscountAmount : $totalVoucherDiscountAmount");

          //3. Calculate new taxable price after voucher discount is applied
          double newTaxablePrice = taxablePrice - voucherDiscountAmount;

          MyLogUtils.logDebug(
              "applyVouchers newTaxablePrice : $newTaxablePrice");

          //4. Calculate total discount percent.
          double totalDiscountPercent = 100 -
              newTaxablePrice * 100 / (element.cartItemPrice?.subTotal ?? 0);

          MyLogUtils.logDebug(
              "applyVouchers totalDiscountPercent : $totalDiscountPercent");

          if (totalDiscountPercent < 100) {
            // This is the voucher discount to be applied
            var voucherDiscountAmount =
                (element.cartItemPrice?.nextCalculationPrice ?? 0) *
                    (totalDiscountPercent / 100);

            MyLogUtils.logDebug(
                "applyVouchers voucherDiscountAmount : $voucherDiscountAmount");

            // Set this value in cart item price
            element.cartItemPrice?.voucherDiscountAmount =
                voucherDiscountAmount;

            // Set the next calculation price.
            element.cartItemPrice
                ?.setNextCalculationPrice(newTaxablePrice / (element.qty ?? 1));
          }
        }
      }
    });

    MyLogUtils.logDebug(
        "applyVouchers totalVoucherDiscountAmount : $totalVoucherDiscountAmount");
    // Set the values in cart summary.
    cartSummary.voucherDiscountAmount =
        getRoundedDoubleValue(totalVoucherDiscountAmount);
    cartSummary.voucherCode = vouchers.number;
    cartSummary.voucherType = vouchers.voucherType ?? '';
    return cartSummary;
  }

  String? voucherValidation(CartSummary cartSummary) {
    Vouchers? vouchers = cartSummary.vouchers;
    if (vouchers == null) {
      return "Voucher not exists";
    }

    // Dream price applicable is not enabled then, cart should not contain any item with dream price
    if (!(vouchers.dreamPriceApplicable == true) &&
        isDreamPriceAvailableInThisCart(cartSummary)) {
      return " Voucher cannot be used along with dream price.";
    }

    // Item wise promotion applicable is not enabled then, cart should not contain item wise promotion
    if (!(vouchers.itemWisePromotionApplicable == true) &&
        isAutomaticItemWisePromotionAvailableInThisCart(cartSummary)) {
      return " Voucher cannot be used along with item wise promotion.";
    }

    // Cart wide promotion applicable is not enabled then, cart should not contain cart wide promotion
    if (!(vouchers.cartWidePromotionApplicable == true) &&
        isAutomaticCartWisePromotionAvailableInThisCart(cartSummary)) {
      return " Voucher cannot be used along with cart wide promotion.";
    }
    return null;
  }
}
