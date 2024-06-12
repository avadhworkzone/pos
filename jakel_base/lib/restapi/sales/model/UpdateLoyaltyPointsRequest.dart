import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// loyalty_points : [{"loyalty_campaign_id":1,"minimum_spend_amount":1.0, "points":1,"expired_at":"2022-04-30"}]

UpdateLoyaltyPointsRequest updateLoyaltyPointsRequestFromJson(String str) =>
    UpdateLoyaltyPointsRequest.fromJson(json.decode(str));

String updateLoyaltyPointsRequestToJson(UpdateLoyaltyPointsRequest data) =>
    json.encode(data.toJson());

class UpdateLoyaltyPointsRequest {
  UpdateLoyaltyPointsRequest({
    this.loyaltyPoints,
  });

  UpdateLoyaltyPointsRequest.fromJson(dynamic json) {
    if (json['loyalty_points'] != null) {
      loyaltyPoints = [];
      json['loyalty_points'].forEach((v) {
        loyaltyPoints?.add(LoyaltyPoints.fromJson(v));
      });
    }
  }

  List<LoyaltyPoints>? loyaltyPoints;

  UpdateLoyaltyPointsRequest copyWith({
    List<LoyaltyPoints>? loyaltyPoints,
  }) =>
      UpdateLoyaltyPointsRequest(
        loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (loyaltyPoints != null) {
      map['loyalty_points'] = loyaltyPoints?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// loyalty_campaign_id : 1
/// minimum_spend_amount : 1.0
/// points : 1
/// expired_at : "2022-04-30"

LoyaltyPoints loyaltyPointsFromJson(String str) =>
    LoyaltyPoints.fromJson(json.decode(str));

String loyaltyPointsToJson(LoyaltyPoints data) => json.encode(data.toJson());

class LoyaltyPoints {
  LoyaltyPoints({
    this.loyaltyCampaignID,
    this.minSpendAmount,
    this.points,
    this.expiredAt,
  });

  LoyaltyPoints.fromJson(dynamic json) {
    loyaltyCampaignID = json['loyalty_campaign_id'];
    minSpendAmount = getDoubleValue(json['minimum_spend_amount']);
    points = json['points'];
    expiredAt = json['expired_at'];
  }

  int? loyaltyCampaignID;
  double? minSpendAmount;
  int? points;
  String? expiredAt;

  LoyaltyPoints copyWith({
    int? loyaltyCampaignID,
    double? minSpendAmount,
    int? points,
    String? expiredAt,
  }) =>
      LoyaltyPoints(
        loyaltyCampaignID: loyaltyCampaignID ?? this.loyaltyCampaignID,
        minSpendAmount: minSpendAmount ?? this.minSpendAmount,
        points: points ?? this.points,
        expiredAt: expiredAt ?? this.expiredAt,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['loyalty_campaign_id'] = loyaltyCampaignID;
    map['minimum_spend_amount'] = minSpendAmount;
    map['points'] = points;
    map['expired_at'] = expiredAt;
    return map;
  }
}
