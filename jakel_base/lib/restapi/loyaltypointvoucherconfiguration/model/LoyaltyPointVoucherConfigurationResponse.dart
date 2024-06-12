import 'package:jakel_base/utils/num_utils.dart';

/// vouchers : [{"id":14,"voucher_type":"LOYALTY_POINT_RESTRICTED_BY_MEMBER_PERCENTAGE_VOUCHER","exclude_by_type":"NONE","issue_minimum_spend_amount":0,"use_minimum_spend_amount":200,"validity_days":5,"percentage":0,"promotion_tiers":[{"loyalty_point":100,"percentage":10}],"memberships":[{"id":2,"name":"Loyaltypoints"}],"start_date":"2023-08-15","end_date":"2031-08-10","dream_price_applicable":true,"item_wise_promotion_applicable":true,"cart_wide_promotion_applicable":true},{"id":15,"voucher_type":"LOYALTY_POINT_RESTRICTED_BY_MEMBER_FLAT_VOUCHER","exclude_by_type":"NONE","issue_minimum_spend_amount":0,"use_minimum_spend_amount":150,"validity_days":10,"flat_amount":0,"promotion_tiers":[{"loyalty_point":100,"flat_amount":10}],"memberships":[{"id":2,"name":"Loyaltypoints"}],"start_date":"2023-08-15","end_date":"2031-08-10","dream_price_applicable":true,"item_wise_promotion_applicable":true,"cart_wide_promotion_applicable":true}]

class LoyaltyPointVoucherConfigurationResponse {
  LoyaltyPointVoucherConfigurationResponse({
    this.vouchers,});

  LoyaltyPointVoucherConfigurationResponse.fromJson(dynamic json) {
    if (json['vouchers'] != null) {
      vouchers = [];
      json['vouchers'].forEach((v) {
        vouchers?.add(Vouchers.fromJson(v));
      });
    }
  }
  List<Vouchers>? vouchers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (vouchers != null) {
      map['vouchers'] = vouchers?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 14
/// voucher_type : "LOYALTY_POINT_RESTRICTED_BY_MEMBER_PERCENTAGE_VOUCHER"
/// exclude_by_type : "NONE"
/// issue_minimum_spend_amount : 0
/// use_minimum_spend_amount : 200
/// validity_days : 5
/// percentage : 0
/// flat_amount : 0
/// promotion_tiers : [{"loyalty_point":100,"percentage":10}]
/// memberships : [{"id":2,"name":"Loyaltypoints"}]
/// start_date : "2023-08-15"
/// end_date : "2031-08-10"
/// dream_price_applicable : true
/// item_wise_promotion_applicable : true
/// cart_wide_promotion_applicable : true

class Vouchers {
  Vouchers({
    this.id,
    this.voucherType,
    this.excludeByType,
    this.issueMinimumSpendAmount,
    this.useMinimumSpendAmount,
    this.validityDays,
    this.percentage,
    this.flatAmount,
    this.promotionTiers,
    this.memberships,
    this.startDate,
    this.endDate,
    this.dreamPriceApplicable,
    this.itemWisePromotionApplicable,
    this.cartWidePromotionApplicable,});

  Vouchers.fromJson(dynamic json) {
    id = json['id'];
    voucherType = json['voucher_type'];
    excludeByType = json['exclude_by_type'];
    issueMinimumSpendAmount = getDoubleValue(json['issue_minimum_spend_amount']);
    useMinimumSpendAmount = getDoubleValue(json['use_minimum_spend_amount']);
    validityDays = json['validity_days'];
    percentage = getDoubleValue(json['percentage']);
    flatAmount = getDoubleValue(json['flat_amount']);

    if (json['promotion_tiers'] != null) {
      promotionTiers = [];
      json['promotion_tiers'].forEach((v) {
        promotionTiers?.add(PromotionTiers.fromJson(v));
      });
    }
    if (json['memberships'] != null) {
      memberships = [];
      json['memberships'].forEach((v) {
        memberships?.add(Memberships.fromJson(v));
      });
    }
    startDate = json['start_date'];
    endDate = json['end_date'];
    dreamPriceApplicable = json['dream_price_applicable'];
    itemWisePromotionApplicable = json['item_wise_promotion_applicable'];
    cartWidePromotionApplicable = json['cart_wide_promotion_applicable'];
  }
  int? id;
  String? voucherType;
  String? excludeByType;
  double? issueMinimumSpendAmount;
  double? useMinimumSpendAmount;
  int? validityDays;
  double? percentage;
  double? flatAmount;
  List<PromotionTiers>? promotionTiers;
  int selectPromotionTiers = 0;
  List<Memberships>? memberships;
  String? startDate;
  String? endDate;
  bool? dreamPriceApplicable;
  bool? itemWisePromotionApplicable;
  bool? cartWidePromotionApplicable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['voucher_type'] = voucherType;
    map['exclude_by_type'] = excludeByType;
    map['issue_minimum_spend_amount'] = issueMinimumSpendAmount;
    map['use_minimum_spend_amount'] = useMinimumSpendAmount;
    map['validity_days'] = validityDays;
    map['percentage'] = percentage;
    map['flat_amount'] = flatAmount;
    if (promotionTiers != null) {
      map['promotion_tiers'] = promotionTiers?.map((v) => v.toJson()).toList();
    }
    if (memberships != null) {
      map['memberships'] = memberships?.map((v) => v.toJson()).toList();
    }
    map['start_date'] = startDate;
    map['end_date'] = endDate;
    map['dream_price_applicable'] = dreamPriceApplicable;
    map['item_wise_promotion_applicable'] = itemWisePromotionApplicable;
    map['cart_wide_promotion_applicable'] = cartWidePromotionApplicable;
    return map;
  }

}

/// id : 2
/// name : "Loyaltypoints"

class Memberships {
  Memberships({
    this.id,
    this.name,});

  Memberships.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

/// loyalty_point : 100
/// percentage : 10
/// flat_amount : 10

class PromotionTiers {
  PromotionTiers({
    this.loyaltyPoint,
    this.percentage,
    this.flatAmount,
  });

  PromotionTiers.fromJson(dynamic json) {
    loyaltyPoint = json['loyalty_point'];
    percentage = getDoubleValue(json['percentage']??0);
    flatAmount = getDoubleValue(json['flat_amount']??0);
  }
  int? loyaltyPoint;
  double? percentage;
  double? flatAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['loyalty_point'] = loyaltyPoint;
    map['percentage'] = percentage;
    map['flat_amount'] = flatAmount;
    return map;
  }

}