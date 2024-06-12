import 'dart:convert';

/// priceToBeUsedAsBase : 10.50
/// priceOverrideAmount : 10.50
/// priceOverrideAmountDiscountPercent : 1.0
/// cashierId : 1
/// storeManagerId : 1
/// directorId : 1
/// storeManagerPasscode : "passcode"
/// directorPasscode : "passcode"

CartItemPriceOverrideData cartItemPriceOverrideDataFromJson(String str) =>
    CartItemPriceOverrideData.fromJson(json.decode(str));

String cartItemPriceOverrideDataToJson(CartItemPriceOverrideData data) =>
    json.encode(data.toJson());

class CartItemPriceOverrideData {
  CartItemPriceOverrideData({
    this.priceToBeUsedAsBase,
    this.priceOverrideAmount,
    this.priceOverrideAmountDiscountPercent,
    this.cashierId,
    this.storeManagerId,
    this.directorId,
    this.storeManagerPasscode,
    this.directorPasscode,
  });

  CartItemPriceOverrideData.fromJson(dynamic json) {
    priceToBeUsedAsBase = json['priceToBeUsedAsBase'];
    priceOverrideAmount = json['priceOverrideAmount'];
    priceOverrideAmountDiscountPercent =
        json['priceOverrideAmountDiscountPercent'];
    cashierId = json['cashierId'];
    storeManagerId = json['storeManagerId'];
    directorId = json['directorId'];
    storeManagerPasscode = json['storeManagerPasscode'];
    directorPasscode = json['directorPasscode'];
  }

  double? priceToBeUsedAsBase;
  double? priceOverrideAmount;
  double? priceOverrideAmountDiscountPercent;
  int? cashierId;
  int? storeManagerId;
  int? directorId;
  String? storeManagerPasscode;
  String? directorPasscode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['priceToBeUsedAsBase'] = priceToBeUsedAsBase;
    map['priceOverrideAmount'] = priceOverrideAmount;
    map['priceOverrideAmountDiscountPercent'] =
        priceOverrideAmountDiscountPercent;
    map['cashierId'] = cashierId;
    map['storeManagerId'] = storeManagerId;
    map['directorId'] = directorId;
    map['storeManagerPasscode'] = storeManagerPasscode;
    map['directorPasscode'] = directorPasscode;
    return map;
  }
}
