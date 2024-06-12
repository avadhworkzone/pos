import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';

class PromotionData {
  List<Promotions>? appliedItemDiscounts;
  Promotions? cartWideDiscount;
  bool? usingItemWiseDiscount;
  bool? usingCartWideDiscount;

  PromotionData({
    this.appliedItemDiscounts,
    this.cartWideDiscount,
    this.usingItemWiseDiscount,
    this.usingCartWideDiscount,
  });

  factory PromotionData.fromJson(dynamic json) {
    return PromotionData(
        cartWideDiscount: json['cartWideDiscount'] != null
            ? Promotions.fromJson(json['cartWideDiscount'])
            : null,
        appliedItemDiscounts: json['appliedItemDiscounts'] != null
            ? (json['appliedItemDiscounts'] as List)
                .map((i) => Promotions.fromJson(i))
                .toList()
            : [],
        usingItemWiseDiscount: json['usingItemWiseDiscount'],
        usingCartWideDiscount: json['usingCartWideDiscount']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (cartWideDiscount != null) {
      data['cartWideDiscount'] = cartWideDiscount?.toJson();
    }

    if (appliedItemDiscounts != null) {
      data['appliedItemDiscounts'] =
          appliedItemDiscounts?.map((v) => v.toJson()).toList();
    }

    data['usingItemWiseDiscount'] = usingItemWiseDiscount;
    data['usingCartWideDiscount'] = usingCartWideDiscount;

    return data;
  }
}
