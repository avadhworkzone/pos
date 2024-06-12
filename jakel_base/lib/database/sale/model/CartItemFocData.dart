import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// complimentaryItemReasonId : 1
/// makeItComplimentary : false
/// storeManagerId : 1
/// storeManagerPasscode : ""
/// qty : 1.0

CartItemFocData cartItemFocDataFromJson(String str) =>
    CartItemFocData.fromJson(json.decode(str));

String cartItemFocDataToJson(CartItemFocData data) =>
    json.encode(data.toJson());

class CartItemFocData {
  CartItemFocData({
    this.complimentaryItemReasonId,
    this.makeItComplimentary,
    this.storeManagerId,
    this.storeManagerPasscode,
    this.qty,
  });

  CartItemFocData.fromJson(dynamic json) {
    complimentaryItemReasonId = json['complimentaryItemReasonId'];
    makeItComplimentary = json['makeItComplimentary'];
    storeManagerId = json['storeManagerId'];
    storeManagerPasscode = json['storeManagerPasscode'];
    qty = getDoubleValue(json['qty']);
  }

  int? complimentaryItemReasonId;
  bool? makeItComplimentary;
  int? storeManagerId;
  String? storeManagerPasscode;
  double? qty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['complimentaryItemReasonId'] = complimentaryItemReasonId;
    map['makeItComplimentary'] = makeItComplimentary;
    map['storeManagerId'] = storeManagerId;
    map['storeManagerPasscode'] = storeManagerPasscode;
    map['qty'] = qty;
    return map;
  }
}
