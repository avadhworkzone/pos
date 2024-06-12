import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import '../helper/new_sale_returns_helper.dart';

cartItemSummaryUpdateJob(CartSummary cartSummary) {
  cartSummary.cartItems?.forEach((element) {
    // In Case New Item added for exchange, the price is retained from the exchanged item
    // in new_sale_widget _onProductSelected.

    if (element.isNewItemForExchange != true) {
      // FOC remove dream price
      if (element.isComplementaryItem()) {
        element.cartItemDreamPriceData = null;
      }

      // ===================================================================
      // Set Taxable Amount
      // ===================================================================
      var taxableAmount = ((element.cartItemPrice?.nextCalculationPrice ?? 0) *
          (element.qty ?? 1));

      // In Case Of return Use data from sale returns object
      if (element.saleReturnsItemData != null) {
        taxableAmount =
            getTaxableAmountForReturnsPerUnit(element) * (element.qty ?? 1);
      }

      //FOC
      if (element.isComplementaryItem()) {
        taxableAmount = 0;
      }

      element.cartItemPrice?.setTaxableAmount(taxableAmount);

      // ===================================================================
      // Set Total Discount
      // ===================================================================
      var totalDiscountAmount =
          (element.cartItemPrice?.subTotal ?? 0) - taxableAmount;

      // In Case Returns Get the data from the Sale Returns Item Data
      if (element.saleReturnsItemData != null) {
        double discountAmountPerUnit =
            (element.saleReturnsItemData?.saleItem?.totalDiscountAmount ?? 0) /
                (element.saleReturnsItemData?.saleItem?.quantity ?? 1);

        totalDiscountAmount = (discountAmountPerUnit * (element.qty ?? 1));
      }
      MyLogUtils.logDebug(
          "totalDiscountAmount in Cartssadf : $totalDiscountAmount");

      // FOC
      if (element.isComplementaryItem()) {
        totalDiscountAmount = element.cartItemPrice?.originalPrice ?? 0;
      }
      // Set Total Discount Amount
      element.cartItemPrice?.setTotalDiscountAmount(totalDiscountAmount);

      // ===================================================================
      // Set Tax Amount
      // ===================================================================

      var tax = taxableAmount * (element.taxPercentage) / 100;

      // In Case Returns Get the data from the Sale Returns Item Data
      if (element.saleReturnsItemData != null) {
        double taxPerUnit =
            (element.saleReturnsItemData?.saleItem?.totalTaxAmount ?? 0) /
                (element.saleReturnsItemData?.saleItem?.quantity ?? 1);
        tax = (taxPerUnit * (element.qty ?? 1));
      }
      // FOC
      if (element.isComplementaryItem()) {
        tax = 0;
      }
      // Set Total Discount Amount
      element.cartItemPrice?.setTaxAmount(tax);

      // ===================================================================
      // Set Total Amount
      // ===================================================================

      var totalAmount = taxableAmount + tax;

      // In Case Returns Get the data from the Sale Returns Item Data
      if (element.saleReturnsItemData != null) {
        totalAmount =
            (element.saleReturnsItemData?.saleItem?.pricePaidPerUnit ?? 0) *
                (element.qty ?? 1);
      }
      MyLogUtils.logDebug("totalAmount in Cartssadf : $totalAmount");
      // Set Total Amount
      element.cartItemPrice?.setTotalAmount(totalAmount);

      // Set The qty. Not useful in new sale but in exchange its useful.
      element.cartItemPrice?.setPriceForThisQty(element.qty ?? 1);
    } else {
      // In Case New Item added for exchange, the price is retained from the exchanged item
      // and negative values are converted into positive values

      MyLogUtils.logDebug(
          "Cart Item for isNewItemForExchange :${element.toJson()}");

      var existingCartItemPrice = element.cartItemPrice;
      MyLogUtils.logDebug(
          "existingCartItemPrice in exchange new item:   ${existingCartItemPrice?.toJson()}");

      element.cartItemPrice = getCartItemPriceForGivenQtyInReturnsOrExchange(
          existingCartItemPrice,
          existingCartItemPrice?.priceForThisQty ?? 1,
          element.qty ?? 1);

      MyLogUtils.logDebug(
          "totalAmount in Cartssadf element updated : ${element.cartItemPrice?.toJson()}");
    }
  });

  MyLogUtils.logDebug(
      "cartItemSummaryUpdateJob cartSummary : ${cartSummary.toJson()}");

  return cartSummary;
}

double getTaxableAmountForReturnsPerUnit(CartItem element) {
  double totalPaidPerUnit =
      element.saleReturnsItemData?.saleItem?.pricePaidPerUnit ?? 0;

  double taxAmountPerUnit =
      (element.saleReturnsItemData?.saleItem?.totalTaxAmount ?? 0) /
          (element.saleReturnsItemData?.saleItem?.quantity ?? 1);
  return (totalPaidPerUnit - taxAmountPerUnit);
}
