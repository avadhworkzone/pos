import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// discountPercent : 10.50
/// promotionGroupId : 1
/// promotionId : 1
/// isGetProduct : true
/// isBuyProduct : true
/// isFreeProduct : true

CartItemPromotionItemData cartItemPromotionItemDataFromJson(String str) =>
    CartItemPromotionItemData.fromJson(json.decode(str));

String cartItemPromotionItemDataToJson(CartItemPromotionItemData data) =>
    json.encode(data.toJson());

class CartItemPromotionItemData {
  CartItemPromotionItemData({
    this.discountPercent,
    this.promotionGroupId,
    this.promotionId,
    this.isGetProduct,
    this.isBuyProduct,
    this.isFreeProduct,
  });

  CartItemPromotionItemData.fromJson(dynamic json) {
    discountPercent = getDoubleValue(json['discountPercent']);
    promotionGroupId = json['promotionGroupId'];
    promotionId = json['promotionId'];
    isGetProduct = json['isGetProduct'];
    isBuyProduct = json['isBuyProduct'];
    isFreeProduct = json['isFreeProduct'];
  }

  double? discountPercent;
  int? promotionGroupId;
  int? promotionId;
  bool?
      isGetProduct; // Used item wise promotion to check if this is get product
  bool?
      isBuyProduct; // Used item wise promotion to check if this is buy product
  // Used item wise promotion to check if this is free item in cheapest
  // free discount.Mainly used to find if grouping the items .
  bool? isFreeProduct;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['discountPercent'] = discountPercent;
    map['promotionGroupId'] = promotionGroupId;
    map['promotionId'] = promotionId;
    map['isGetProduct'] = isGetProduct;
    map['isBuyProduct'] = isBuyProduct;
    map['isFreeProduct'] = isFreeProduct;
    return map;
  }
}
