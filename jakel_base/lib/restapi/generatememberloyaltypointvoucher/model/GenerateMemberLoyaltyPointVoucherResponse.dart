import 'package:jakel_base/utils/num_utils.dart';

/// voucher : {"id":23523,"member_id":85,"discount_type":"PERCENTAGE","voucher_type":"LOYALTY_POINT_RESTRICTED_BY_MEMBER_PERCENTAGE_VOUCHER","number":"9VECO1692172492","minimum_spend_amount":"200.00","percentage":10,"flat_amount":1,"expiry_date":"2023-08-21","dream_price_applicable":true,"item_wise_promotion_applicable":true,"cart_wide_promotion_applicable":true}

class GenerateMemberLoyaltyPointVoucherResponse {
  GenerateMemberLoyaltyPointVoucherResponse({
    this.voucher,});

  GenerateMemberLoyaltyPointVoucherResponse.fromJson(dynamic json) {
    voucher = json['voucher'] != null ? Voucher.fromJson(json['voucher']) : null;
  }
  Voucher? voucher;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (voucher != null) {
      map['voucher'] = voucher?.toJson();
    }
    return map;
  }

}

/// id : 23523
/// member_id : 85
/// discount_type : "PERCENTAGE"
/// voucher_type : "LOYALTY_POINT_RESTRICTED_BY_MEMBER_PERCENTAGE_VOUCHER"
/// number : "9VECO1692172492"
/// minimum_spend_amount : "200.00"
/// percentage : 10
/// flat_amount : 1
/// expiry_date : "2023-08-21"
/// dream_price_applicable : true
/// item_wise_promotion_applicable : true
/// cart_wide_promotion_applicable : true

class Voucher {
  Voucher({
    this.id,
    this.memberId,
    this.discountType,
    this.voucherType,
    this.number,
    this.minimumSpendAmount,
    this.percentage,
    this.flatAmount,
    this.expiryDate,
    this.dreamPriceApplicable,
    this.itemWisePromotionApplicable,
    this.cartWidePromotionApplicable,});

  Voucher.fromJson(dynamic json) {
    id = json['id'];
    memberId = json['member_id'];
    discountType = json['discount_type'];
    voucherType = json['voucher_type'];
    number = json['number'];
    minimumSpendAmount = getDoubleValue(json['minimum_spend_amount']);
    percentage = getDoubleValue(json['percentage']);
    flatAmount = getDoubleValue(json['flat_amount']);
    expiryDate = json['expiry_date'];
    dreamPriceApplicable = json['dream_price_applicable'];
    itemWisePromotionApplicable = json['item_wise_promotion_applicable'];
    cartWidePromotionApplicable = json['cart_wide_promotion_applicable'];
  }
  int? id;
  int? memberId;
  String? discountType;
  String? voucherType;
  String? number;
  double? minimumSpendAmount;
  double? percentage;
  double? flatAmount;
  String? expiryDate;
  bool? dreamPriceApplicable;
  bool? itemWisePromotionApplicable;
  bool? cartWidePromotionApplicable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['member_id'] = memberId;
    map['discount_type'] = discountType;
    map['voucher_type'] = voucherType;
    map['number'] = number;
    map['minimum_spend_amount'] = minimumSpendAmount;
    map['percentage'] = percentage;
    map['flat_amount'] = flatAmount;
    map['expiry_date'] = expiryDate;
    map['dream_price_applicable'] = dreamPriceApplicable;
    map['item_wise_promotion_applicable'] = itemWisePromotionApplicable;
    map['cart_wide_promotion_applicable'] = cartWidePromotionApplicable;
    return map;
  }

}