import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// dreamPriceId : 1
/// dreamPrice : 10.50

CartItemDreamPriceData cartItemDreamPriceDataFromJson(String str) =>
    CartItemDreamPriceData.fromJson(json.decode(str));

String cartItemDreamPriceDataToJson(CartItemDreamPriceData data) =>
    json.encode(data.toJson());

class CartItemDreamPriceData {
  CartItemDreamPriceData({
    this.dreamPriceId,
    this.dreamPrice,
  });

  CartItemDreamPriceData.fromJson(dynamic json) {
    dreamPriceId = json['dreamPriceId'];
    dreamPrice = getDoubleValue(json['dreamPrice']);
  }

  int? dreamPriceId;
  double? dreamPrice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dreamPriceId'] = dreamPriceId;
    map['dreamPrice'] = dreamPrice;
    return map;
  }
}
