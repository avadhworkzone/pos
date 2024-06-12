import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// ============================== ///
/// Everything is price for total quantity.
/// If per unit price is needed, it should be calculated separately
/// ============================== ///

/// originalPrice : 10.0
/// subTotal : 111.0
/// openPrice : 10.0
/// dreamPrice : 10.0
/// automaticItemDiscount : 10.0
/// automaticCartDiscount : 10.0
/// manualItemDiscount : 19.0
/// manualCartDiscount : 10.0
/// vouchDiscountAmount : 10.0
/// taxableAmount : 10.0
/// taxAmount : 10.0
/// totalAmount : 10.0

CartItemPrice cartPriceFromJson(String str) =>
    CartItemPrice.fromJson(json.decode(str));

String cartPriceToJson(CartItemPrice data) => json.encode(data.toJson());

class CartItemPrice {
  CartItemPrice(
      {this.priceForThisQty, // The price given in this object is for this qty. Usefull mainly in the returns& exchange
        this.priceToBeUsedForManualDiscount,
        this.nextCalculationPrice,
        this.originalPrice,
        this.originalUomPrice, // This is the UOM price and not the derivative price in case of UOM products
        this.subTotal,
        this.openPrice,
        this.dreamPrice,
        this.automaticItemDiscount,
        this.automaticCartDiscount,
        this.manualItemDiscount,
        this.manualCartDiscount,
        this.voucherDiscountAmount,
        this.taxableAmount,
        this.taxAmount,
        this.totalAmount,
        this.totalDiscountAmount});

  CartItemPrice.fromJson(dynamic json) {
    priceForThisQty = getDoubleValue(json['priceForThisQty']);
    originalUomPrice = getDoubleValue(json['originalUomPrice']);
    priceToBeUsedForManualDiscount =
        getDoubleValue(json['priceToBeUsedForManualDiscount']);
    nextCalculationPrice = getDoubleValue(json['nextCalculationPrice']);
    originalPrice = getDoubleValue(json['originalPrice']);
    subTotal = getDoubleValue(json['subTotal']);
    openPrice = getDoubleValue(json['openPrice']);
    dreamPrice = getDoubleValue(json['dreamPrice']);
    automaticItemDiscount = getDoubleValue(json['automaticItemDiscount']);
    automaticCartDiscount = getDoubleValue(json['automaticCartDiscount']);
    manualItemDiscount = getDoubleValue(json['manualItemDiscount']);
    manualCartDiscount = getDoubleValue(json['manualCartDiscount']);
    voucherDiscountAmount = getDoubleValue(json['vouchDiscountAmount']);
    taxableAmount = getDoubleValue(json['taxableAmount']);
    taxAmount = getDoubleValue(json['taxAmount']);
    totalAmount = getDoubleValue(json['totalAmount']);
    totalDiscountAmount = getDoubleValue(json['totalDiscountAmount']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['originalUomPrice'] = originalUomPrice;
    map['priceForThisQty'] = priceForThisQty;
    map['priceToBeUsedForManualDiscount'] = priceToBeUsedForManualDiscount;
    map['nextCalculationPrice'] = nextCalculationPrice;
    map['originalPrice'] = originalPrice;
    map['subTotal'] = subTotal;
    map['openPrice'] = openPrice;
    map['dreamPrice'] = dreamPrice;
    map['automaticItemDiscount'] = automaticItemDiscount;
    map['automaticCartDiscount'] = automaticCartDiscount;
    map['manualItemDiscount'] = manualItemDiscount;
    map['manualCartDiscount'] = manualCartDiscount;
    map['vouchDiscountAmount'] = voucherDiscountAmount;
    map['taxableAmount'] = taxableAmount;
    map['taxAmount'] = taxAmount;
    map['totalAmount'] = totalAmount;
    map['totalDiscountAmount'] = totalDiscountAmount;
    return map;
  }

  // This is price per unit
  double? originalUomPrice; // Should be used when sending to backend.

  // Backend accepts only the UOM price of the product.
  double? priceForThisQty;
  double? priceToBeUsedForManualDiscount;
  double? nextCalculationPrice; // This is price per unit
  double? originalPrice;
  double? subTotal;
  double? openPrice;
  double? dreamPrice;
  double? automaticItemDiscount;
  double? automaticCartDiscount;
  double? manualItemDiscount;
  double? manualCartDiscount;
  double? voucherDiscountAmount;
  double? taxableAmount;
  double? taxAmount;
  double? totalAmount;
  double? totalDiscountAmount;

  setOriginalUomPrice(double value) {
    originalUomPrice = value;
  }

  setPriceForThisQty(double value) {
    priceForThisQty = value;
  }

  setTotalDiscountAmount(double value) {
    totalDiscountAmount = value;
  }

  setPriceToBeUsedForManualDiscount(double value) {
    priceToBeUsedForManualDiscount = value;
  }

  setNextCalculationPrice(double value) {
    nextCalculationPrice = value;
  }

  setSubTotal(double value) {
    subTotal = value;
  }

  setOriginalPrice(double value) {
    originalPrice = value;
  }

  setOpenPrice(double value) {
    openPrice = value;
  }

  setDreamPrice(double value) {
    dreamPrice = value;
  }

  setAutomaticItemDiscount(double value) {
    automaticItemDiscount = value;
  }

  setAutomaticCartDiscount(double value) {
    automaticCartDiscount = value;
  }

  setManualItemDiscount(double value) {
    manualItemDiscount = value;
  }

  setManualCartDiscount(double value) {
    manualCartDiscount = value;
  }

  setVoucherDiscountAmount(double value) {
    voucherDiscountAmount = value;
  }

  setTaxableAmount(double value) {
    taxableAmount = value;
  }

  setTaxAmount(double value) {
    taxAmount = value;
  }

  setTotalAmount(double value) {
    totalAmount = getRoundedDoubleValue(value);
  }
}
