import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartPrice.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';

import 'CartRoundOffJob.dart';

cartSummaryUpdateJob(CartSummary cartSummary) {
  //Retain only the variable that is created before in the calculation and not all
  var cartPrice = CartPrice(
      priceToBeUsedForManualDiscount:
          cartSummary.cartPrice?.priceToBeUsedForManualDiscount);

  /// Step 1. Calculate Sub Total: including price override & dream price & except discount
  cartPrice.subTotal = _getSubTotal(cartSummary.cartItems);

  /// Step 2. Calculate tax
  cartPrice.tax = _getTotalSaleTax(cartSummary.cartItems);

  /// Step 3. Calculate return Total payable amount
  cartPrice.returnTotal = _getReturnPayableAmount(cartSummary.cartItems);

  MyLogUtils.logDebug(
      "cartPrice newSaleTotal returnTotal : ${cartPrice.returnTotal}");

  /// Step 4. Calculate Round Off
  cartPrice.returnRoundOff =
      cartRoundOffJob(cartSummary, cartPrice.returnTotal);
  MyLogUtils.logDebug(
      "cartPrice newSaleTotal returnRoundOff : ${cartPrice.returnRoundOff}");

  /// Step 3. Calculate return Total payable amount
  cartPrice.returnTotal =
      (cartPrice.returnTotal ?? 0) + (cartPrice.returnRoundOff ?? 0);
  MyLogUtils.logDebug(
      "cartPrice newSaleTotal returnTotal with round off : ${cartPrice.returnTotal}");

  /// Step 5. Calculate total payable amount
  cartPrice.totalTaxableAmount = _getTotalTaxableAmount(cartSummary.cartItems);

  /// Step 6. Calculate total payable amount for newly added items for the sale
  cartPrice.newSaleTotal = _getTotalNewSalePayable(cartSummary.cartItems);

  MyLogUtils.logDebug("cartPrice newSaleTotal: ${cartPrice.newSaleTotal}");

  /// Step 7. Round off of new sale item
  cartPrice.newSaleRoundOff =
      cartRoundOffJob(cartSummary, cartPrice.newSaleTotal);

  MyLogUtils.logDebug(
      "cartPrice newSaleRoundOff: ${cartPrice.newSaleRoundOff}");

  /// Step 7. Round off of new sale item
  cartPrice.newSaleTotal =
      (cartPrice.newSaleTotal ?? 0) + (cartPrice.newSaleRoundOff ?? 0);

  MyLogUtils.logDebug(
      "cartPrice newSaleTotal with roundOff: ${cartPrice.newSaleTotal}");

  /// Step 8. Calculate total payable amount
  // cartPrice.total = (cartPrice.newSaleTotal ?? 0) +
  //     (cartPrice.returnTotal ??
  //         0); //_getTotalPayableAmount(cartSummary, cartPrice);

  /// Step 10. Update total Accordingly
  cartPrice.total =
      (cartPrice.newSaleTotal ?? 0) - (cartPrice.returnTotal ?? 0);

  MyLogUtils.logDebug("cartPrice newSaleTotal total: ${cartPrice.total}");

  /// Step 9. Calculate Round Off
  cartPrice.roundOff =
      (cartPrice.newSaleRoundOff ?? 0) - (cartPrice.returnRoundOff ?? 0);

  MyLogUtils.logDebug("cartPrice newSaleTotal roundOff: ${cartPrice.roundOff}");

  /// Step 11. Calculate the total cart wide discount amount(This can be done any time)
  cartPrice.totalCartDiscountAmount =
      _getTotalCartWideDiscountAmount(cartSummary.cartItems);

  /// Step 12. Calculate the total discount amount(This can be done any time)
  cartPrice.discount = _getTotalDiscountAmount(cartSummary.cartItems);

  MyLogUtils.logDebug("cartPrice info: ${cartPrice.toJson()}");

  cartSummary.cartPrice = cartPrice;
  return cartSummary;
}

double _getSubTotal(List<CartItem>? cartItems) {
  double subTotal = 0.0;

  if (cartItems != null) {
    for (var element in cartItems) {
      if (element.getIsSelectItem()) {
        if (element.saleReturnsItemData == null) {
          subTotal = subTotal +
              getRoundedValueForCalculations(
                  element.cartItemPrice?.subTotal ?? 0);
        } else {
          subTotal = subTotal -
              getRoundedValueForCalculations(
                  element.cartItemPrice?.subTotal ?? 0);
        }
      }
    }
  }
  return getRoundedValueForCalculations(subTotal);
}

double _getTotalDiscountAmount(List<CartItem>? cartItems) {
  double total = 0.0;

  if (cartItems != null) {
    for (var element in cartItems) {
      if (element.getIsSelectItem()) {
        if (element.saleReturnsItemData == null) {
          total = total +
              getRoundedValueForCalculations(
                  element.cartItemPrice?.totalDiscountAmount ?? 0);
        } else {
          total = total -
              getRoundedValueForCalculations(
                  element.cartItemPrice?.totalDiscountAmount ?? 0);
        }
      }
    }
  }
  return getRoundedValueForCalculations(total);
}

double _getTotalSaleTax(List<CartItem>? cartItems) {
  double tax = 0.0;

  if (cartItems != null) {
    for (var element in cartItems) {
      ///when we sale the product tax add
      if ((element.cartItemPrice?.taxAmount ?? 0) > 0 &&
          element.getIsSelectItem()) {
        tax = tax + (element.cartItemPrice?.taxAmount ?? 0);
      }
    }
  }
  return tax;
}

double _getReturnPayableAmount(List<CartItem>? cartItems) {
  double total = 0.0;

  if (cartItems != null) {
    for (var element in cartItems) {
      ///when we return sale the product sub total add
      if (element.getIsSelectItem() && element.saleReturnsItemData != null) {
        total = total + (element.cartItemPrice?.totalAmount ?? 0);
      }
    }
  }

  MyLogUtils.logDebug("_getReturnPayableAmount total : $total");
  return total;
}

double _getTotalNewSalePayable(List<CartItem>? cartItems) {
  double total = 0.0;

  if (cartItems != null) {
    for (var element in cartItems) {
      ///when we return sale the product sub total add
      if (element.getIsSelectItem() && element.saleReturnsItemData == null) {
        total = total + (element.cartItemPrice?.totalAmount ?? 0);
      }
    }
  }

  MyLogUtils.logDebug("_getReturnPayableAmount total : $total");
  return total;
}

double _getTotalTaxableAmount(List<CartItem>? cartItems) {
  double total = 0.0;
  if (cartItems != null) {
    for (var element in cartItems) {
      if (element.getIsSelectItem()) {
        if (element.saleReturnsItemData == null) {
          total = total + (element.cartItemPrice?.taxableAmount ?? 0);
        } else {
          total = total - (element.cartItemPrice?.taxableAmount ?? 0);
        }
      }
    }
  }
  MyLogUtils.logDebug("_getTotalTaxableAmount total : $total");
  return total;
}

double _getTotalPayableAmount(CartSummary cartSummary, CartPrice cartPrice) {
  double totalPayable = 0.0;

  cartSummary.cartItems?.forEach((element) {
    if (element.getIsSelectItem()) {
      if (element.saleReturnsItemData == null) {
        totalPayable = totalPayable + (element.cartItemPrice?.totalAmount ?? 0);
      } else {
        totalPayable = totalPayable - (element.cartItemPrice?.totalAmount ?? 0);
      }
    }
  });

  MyLogUtils.logDebug("_getTotalTaxableAmount totalPayable : $totalPayable");

  return totalPayable;
}

double _getTotalCartWideDiscountAmount(List<CartItem>? cartItems) {
  double total = 0.0;

  if (cartItems != null) {
    for (var element in cartItems) {
      total = total + (element.cartItemPrice?.automaticCartDiscount ?? 0);
    }
  }
  return getRoundedDoubleValue(total);
}
