import 'dart:convert';

/// payments : [{"loyalty_campaign_id":1,"expired_at":1.0}]

UpdateLayawayLoyaltyPointsRequest updateLayawayLoyaltyPointsRequestFromJson(String str) =>
    UpdateLayawayLoyaltyPointsRequest.fromJson(json.decode(str));

String updateLayawayLoyaltyPointsRequestToJson(UpdateLayawayLoyaltyPointsRequest data) =>
    json.encode(data.toJson());

class UpdateLayawayLoyaltyPointsRequest {
  UpdateLayawayLoyaltyPointsRequest({
    this.payments,});

  UpdateLayawayLoyaltyPointsRequest.fromJson(dynamic json) {
    if (json['loyalty_points'] != null) {
      payments = [];
      json['loyalty_points'].forEach((v) {
        payments?.add(LoyaltyPoints.fromJson(v));
      });
    }
  }

  List<LoyaltyPoints>? payments;

  UpdateLayawayLoyaltyPointsRequest copyWith({ List<LoyaltyPoints>? payments,
  }) =>
      UpdateLayawayLoyaltyPointsRequest(payments: payments ?? this.payments,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (payments != null) {
      map['loyalty_points'] = payments?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// loyalty_campaign_id : 1
/// expired_at : 1.0
/// minimum_spend_amount : 1.0

LoyaltyPoints paymentsFromJson(String str) =>
    LoyaltyPoints.fromJson(json.decode(str));

String paymentsToJson(LoyaltyPoints data) => json.encode(data.toJson());

class LoyaltyPoints {
  LoyaltyPoints({
    this.loyaltyCampaignId,
    this.expiredAt,
    this.minimumSpendAmount,
    this.points,
  });

  LoyaltyPoints.fromJson(dynamic json) {
    loyaltyCampaignId = json['loyalty_campaign_id'];
    expiredAt = json['expired_at'];
    minimumSpendAmount = json['minimum_spend_amount'];
    points = json['points'];
  }

  int? loyaltyCampaignId;
  String? expiredAt;
  String? minimumSpendAmount;
  String? points;

  LoyaltyPoints copyWith({ int? loyaltyCampaignId,
    String? expiredAt,
    String? minimumSpendAmount,
    String? points,
  }) =>
      LoyaltyPoints(
        loyaltyCampaignId: loyaltyCampaignId ?? this.loyaltyCampaignId,
        expiredAt: expiredAt ?? this.expiredAt,
        minimumSpendAmount: minimumSpendAmount ?? this.minimumSpendAmount,
        points: points ?? this.points,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['loyalty_campaign_id'] = loyaltyCampaignId;
    map['expired_at'] = expiredAt;
    map['minimum_spend_amount'] = minimumSpendAmount;
    map['points'] = points;
    return map;
  }

}