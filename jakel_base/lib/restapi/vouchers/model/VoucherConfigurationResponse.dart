import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// vouchers : [{"id":1,"voucher_type":"TIER_RESTRICTED_BY_CUSTOMER_PERCENTAGE_VOUCHER","exclude_by_type":"PRODUCTS","products":[10002,10002],"categories":[10002,10002],"issue_minimum_spend_amount":0.5,"use_minimum_spend_amount":150.5,"validity_days":30.5,"percentage":0.5,"flat_amount":0.5,"promotion_tiers":[{"minimum_spend_amount":200.4,"maximum_spend_amount":300.4,"percentage":5.5,"flat_amount":50.5}],"start_date":"2022-09-03","end_date":"2022-12-01"}]

VoucherConfigurationResponse voucherConfigurationResponseFromJson(String str) =>
    VoucherConfigurationResponse.fromJson(json.decode(str));

String voucherConfigurationResponseToJson(VoucherConfigurationResponse data) =>
    json.encode(data.toJson());

class VoucherConfigurationResponse {
  VoucherConfigurationResponse({
    this.voucherConfiguration,
  });

  VoucherConfigurationResponse.fromJson(dynamic json) {
    if (json['vouchers'] != null) {
      voucherConfiguration = [];
      json['vouchers'].forEach((v) {
        voucherConfiguration?.add(VoucherConfiguration.fromJson(v));
      });
    }
  }

  List<VoucherConfiguration>? voucherConfiguration;

  VoucherConfigurationResponse copyWith({
    List<VoucherConfiguration>? voucherConfiguration,
  }) =>
      VoucherConfigurationResponse(
        voucherConfiguration: voucherConfiguration ?? this.voucherConfiguration,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (voucherConfiguration != null) {
      map['vouchers'] = voucherConfiguration?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// voucher_type : "TIER_RESTRICTED_BY_CUSTOMER_PERCENTAGE_VOUCHER"
/// exclude_by_type : "PRODUCTS"
/// products : [10002,10002]
/// categories : [10002,10002]
/// issue_minimum_spend_amount : 0.5
/// use_minimum_spend_amount : 150.5
/// validity_days : 30.5
/// percentage : 0.5
/// flat_amount : 0.5
/// promotion_tiers : [{"minimum_spend_amount":200.4,"maximum_spend_amount":300.4,"percentage":5.5,"flat_amount":50.5}]
/// start_date : "2022-09-03"
/// end_date : "2022-12-01"

VoucherConfiguration voucherConfigurationFromJson(String str) =>
    VoucherConfiguration.fromJson(json.decode(str));

String voucherConfigurationToJson(VoucherConfiguration data) =>
    json.encode(data.toJson());

class VoucherConfiguration {
  VoucherConfiguration({
    this.id,
    this.voucherType,
    this.excludeByType,
    this.products,
    this.categories,
    this.issueMinimumSpendAmount,
    this.useMinimumSpendAmount,
    this.validityDays,
    this.percentage,
    this.flatAmount,
    this.promotionTiers,
    this.startDate,
    this.endDate,
    this.dreamPriceApplicable,
    this.itemWisePromotionApplicable,
    this.cartWidePromotionApplicable,
  });

  VoucherConfiguration.fromJson(dynamic json) {
    id = json['id'];
    voucherType = json['voucher_type'];
    excludeByType = json['exclude_by_type'];
    products = json['products'] != null ? json['products'].cast<int>() : [];
    categories =
        json['categories'] != null ? json['categories'].cast<int>() : [];
    issueMinimumSpendAmount =
        getDoubleValue(json['issue_minimum_spend_amount']);
    useMinimumSpendAmount = getDoubleValue(json['use_minimum_spend_amount']);
    validityDays = json['validity_days'];
    percentage = getDoubleValue(json['percentage']);
    flatAmount = getDoubleValue(json['flat_amount']);
    if (json['promotion_tiers'] != null) {
      promotionTiers = [];
      json['promotion_tiers'].forEach((v) {
        promotionTiers?.add(VoucherConfigTiers.fromJson(v));
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
  List<int>? products;
  List<int>? categories;
  double? issueMinimumSpendAmount;
  double? useMinimumSpendAmount;
  int? validityDays;
  double? percentage;
  double? flatAmount;
  List<VoucherConfigTiers>? promotionTiers;
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
    map['products'] = products;
    map['categories'] = categories;
    map['issue_minimum_spend_amount'] = issueMinimumSpendAmount;
    map['use_minimum_spend_amount'] = useMinimumSpendAmount;
    map['validity_days'] = validityDays;
    map['percentage'] = percentage;
    map['flat_amount'] = flatAmount;
    if (promotionTiers != null) {
      map['promotion_tiers'] = promotionTiers?.map((v) => v.toJson()).toList();
    }
    map['start_date'] = startDate;
    map['end_date'] = endDate;
    map['dream_price_applicable'] = dreamPriceApplicable;
    map['item_wise_promotion_applicable'] = itemWisePromotionApplicable;
    map['cart_wide_promotion_applicable'] = cartWidePromotionApplicable;

    return map;
  }
}

/// minimum_spend_amount : 200.4
/// maximum_spend_amount : 300.4
/// percentage : 5.5
/// flat_amount : 50.5

VoucherConfigTiers promotionTiersFromJson(String str) =>
    VoucherConfigTiers.fromJson(json.decode(str));

String promotionTiersToJson(VoucherConfigTiers data) =>
    json.encode(data.toJson());

class VoucherConfigTiers {
  VoucherConfigTiers({
    this.minimumSpendAmount,
    this.maximumSpendAmount,
    this.percentage,
    this.flatAmount,
  });

  VoucherConfigTiers.fromJson(dynamic json) {
    minimumSpendAmount = getDoubleValue(json['minimum_spend_amount']);
    maximumSpendAmount = getDoubleValue(json['maximum_spend_amount']);
    percentage = getDoubleValue(json['percentage']);
    flatAmount = getDoubleValue(json['flat_amount']);
  }

  double? minimumSpendAmount;
  double? maximumSpendAmount;
  double? percentage;
  double? flatAmount;

  VoucherConfigTiers copyWith({
    double? minimumSpendAmount,
    double? maximumSpendAmount,
    double? percentage,
    double? flatAmount,
  }) =>
      VoucherConfigTiers(
        minimumSpendAmount: minimumSpendAmount ?? this.minimumSpendAmount,
        maximumSpendAmount: maximumSpendAmount ?? this.maximumSpendAmount,
        percentage: percentage ?? this.percentage,
        flatAmount: flatAmount ?? this.flatAmount,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['minimum_spend_amount'] = minimumSpendAmount;
    map['maximum_spend_amount'] = maximumSpendAmount;
    map['percentage'] = percentage;
    map['flat_amount'] = flatAmount;
    return map;
  }
}
