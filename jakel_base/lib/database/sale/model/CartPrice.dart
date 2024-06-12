import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// subTotal : 10.50
/// discount : 10.50
/// total : 10.50
/// saleTotal : 10.50
/// returnTotal : 10.50
/// roundOff : 10.50
/// returnRoundOff : 10.50
/// tax : 10.50

CartPrice cartPriceFromJson(String str) => CartPrice.fromJson(json.decode(str));

String cartPriceToJson(CartPrice data) => json.encode(data.toJson());

class CartPrice {
  CartPrice({
    this.subTotal,
    this.discount,
    this.totalTaxableAmount,
    this.returnTotal,
    this.returnRoundOff,
    this.newSaleTotal,
    this.newSaleRoundOff,
    this.total,
    this.roundOff,
    this.tax,
    this.totalCartDiscountAmount,
    this.priceToBeUsedForManualDiscount,
  });

  CartPrice.fromJson(dynamic json) {
    newSaleTotal = getDoubleValue(json['newSaleTotal']);
    newSaleRoundOff = getDoubleValue(json['newSaleRoundOff']);
    subTotal = getDoubleValue(json['subTotal']);
    discount = getDoubleValue(json['discount']);
    total = getDoubleValue(json['total']);
    totalTaxableAmount = getDoubleValue(json['totalTaxableAmount']);
    returnTotal = getDoubleValue(json['returnTotal']);
    roundOff = getDoubleValue(json['roundOff']);
    returnRoundOff = getDoubleValue(json['returnRoundOff']);
    tax = getDoubleValue(json['tax']);
    totalCartDiscountAmount = getDoubleValue(json['totalCartDiscountAmount']);
    priceToBeUsedForManualDiscount =
        getDoubleValue(json['priceToBeUsedForManualDiscount']);
  }

  double? subTotal;
  double? discount;
  double? total;
  double? totalTaxableAmount;
  double? returnTotal;
  double? roundOff;
  double? returnRoundOff;
  double? tax;
  double? totalCartDiscountAmount;
  double? priceToBeUsedForManualDiscount;
  double? newSaleTotal;
  double? newSaleRoundOff;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['newSaleTotal'] = newSaleTotal;
    map['newSaleRoundOff'] = newSaleRoundOff;
    map['subTotal'] = subTotal;
    map['discount'] = discount;
    map['total'] = total;
    map['totalTaxableAmount'] = totalTaxableAmount;
    map['returnTotal'] = returnTotal;
    map['roundOff'] = roundOff;
    map['returnRoundOff'] = returnRoundOff;
    map['tax'] = tax;
    map['totalCartDiscountAmount'] = totalCartDiscountAmount;
    map['priceToBeUsedForManualDiscount'] = priceToBeUsedForManualDiscount;
    return map;
  }
}
