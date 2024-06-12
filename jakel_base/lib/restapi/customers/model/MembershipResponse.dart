import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// memberships : [{"id":1,"name":"Product 2","minimum_lifetime_spend_amount":500.00,"loyalty_points_per_ringgit":100.50}]

MembershipResponse membershipResponseFromJson(String str) =>
    MembershipResponse.fromJson(json.decode(str));

String membershipResponseToJson(MembershipResponse data) =>
    json.encode(data.toJson());

class MembershipResponse {
  MembershipResponse({
    this.memberships,
  });

  MembershipResponse.fromJson(dynamic json) {
    if (json['memberships'] != null) {
      memberships = [];
      json['memberships'].forEach((v) {
        memberships?.add(Memberships.fromJson(v));
      });
    }
  }

  List<Memberships>? memberships;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (memberships != null) {
      map['memberships'] = memberships?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// name : "Product 2"
/// minimum_lifetime_spend_amount : 500.00
/// loyalty_points_per_ringgit : 100.50

Memberships membershipsFromJson(String str) =>
    Memberships.fromJson(json.decode(str));

String membershipsToJson(Memberships data) => json.encode(data.toJson());

class Memberships {
  Memberships({
    this.id,
    this.name,
    this.minimumLifetimeSpendAmount,
    this.loyaltyPointsPerRinggit,
  });

  Memberships.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    minimumLifetimeSpendAmount =
        getDoubleValue(json['minimum_lifetime_spend_amount']);
    loyaltyPointsPerRinggit =
        getDoubleValue(json['loyalty_points_per_ringgit']);
  }

  int? id;
  String? name;
  double? minimumLifetimeSpendAmount;
  double? loyaltyPointsPerRinggit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['minimum_lifetime_spend_amount'] = minimumLifetimeSpendAmount;
    map['loyalty_points_per_ringgit'] = loyaltyPointsPerRinggit;
    return map;
  }
}
