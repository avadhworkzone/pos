import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

LoyaltyCampaignsResponse loyaltyCampaignsResponseFromJson(String str) =>
    LoyaltyCampaignsResponse.fromJson(json.decode(str));

String loyaltyCampaignsResponseToJson(LoyaltyCampaignsResponse data) =>
    json.encode(data.toJson());

/// loyalty_campaigns : [{"id":1,"name":"NORMAL MEMBER","minimum_spend_amount":"1.00","loyalty_points":1,"start_date":"2023-02-07","end_date":"2070-02-28","excluded_brands":[{"id":2,"name":"ARIANI RTW","code":"ARR"}]}]

class LoyaltyCampaignsResponse {
  LoyaltyCampaignsResponse({
    this.loyaltyCampaigns,
  });

  LoyaltyCampaignsResponse.fromJson(dynamic json) {
    if (json['loyalty_campaigns'] != null) {
      loyaltyCampaigns = [];
      json['loyalty_campaigns'].forEach((v) {
        loyaltyCampaigns?.add(LoyaltyCampaigns.fromJson(v));
      });
    }
  }

  List<LoyaltyCampaigns>? loyaltyCampaigns;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (loyaltyCampaigns != null) {
      map['loyalty_campaigns'] =
          loyaltyCampaigns?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// name : "NORMAL MEMBER"
/// minimum_spend_amount : "1.00"
/// loyalty_points : 1
/// start_date : "2023-02-07"
/// end_date : "2070-02-28"
/// excluded_brands : [{"id":2,"name":"ARIANI RTW","code":"ARR"}]
///
LoyaltyCampaigns loyaltyCampaignsFromJson(String str) =>
    LoyaltyCampaigns.fromJson(json.decode(str));

String loyaltyCampaignsToJson(LoyaltyCampaigns data) =>
    json.encode(data.toJson());

class LoyaltyCampaigns {
  LoyaltyCampaigns({
    this.id,
    this.name,
    this.minimumSpendAmount,
    this.loyaltyPoints,
    this.startDate,
    this.endDate,
    this.excludedBrands,
  });

  LoyaltyCampaigns.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    minimumSpendAmount = getDoubleValue(json['minimum_spend_amount']);
    loyaltyPoints = json['loyalty_points'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    if (json['excluded_brands'] != null) {
      excludedBrands = [];
      json['excluded_brands'].forEach((v) {
        excludedBrands?.add(ExcludedBrands.fromJson(v));
      });
    }
  }

  int? id;
  String? name;
  double? minimumSpendAmount;
  int? loyaltyPoints;
  String? startDate;
  String? endDate;
  List<ExcludedBrands>? excludedBrands;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['minimum_spend_amount'] = minimumSpendAmount;
    map['loyalty_points'] = loyaltyPoints;
    map['start_date'] = startDate;
    map['end_date'] = endDate;
    if (excludedBrands != null) {
      map['excluded_brands'] = excludedBrands?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 2
/// name : "ARIANI RTW"
/// code : "ARR"

class ExcludedBrands {
  ExcludedBrands({
    this.id,
    this.name,
    this.code,
  });

  ExcludedBrands.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
  }

  int? id;
  String? name;
  String? code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    return map;
  }
}
