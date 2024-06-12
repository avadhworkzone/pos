import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// cashiers : [{"id":1,"first_name":"Hettie Olson","last_name":"Erik Walter","username":"cashier","pin":"1234","group_name":"Cashier Group","price_override_limit_percentage":52.09}]

CashiersResponse cashiersResponseFromJson(String str) =>
    CashiersResponse.fromJson(json.decode(str));

String cashiersResponseToJson(CashiersResponse data) =>
    json.encode(data.toJson());

class CashiersResponse {
  CashiersResponse({
    this.cashiers,
  });

  CashiersResponse.fromJson(dynamic json) {
    if (json['cashiers'] != null) {
      cashiers = [];
      json['cashiers'].forEach((v) {
        cashiers?.add(Cashiers.fromJson(v));
      });
    }
  }

  List<Cashiers>? cashiers;

  CashiersResponse copyWith({
    List<Cashiers>? cashiers,
  }) =>
      CashiersResponse(
        cashiers: cashiers ?? this.cashiers,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (cashiers != null) {
      map['cashiers'] = cashiers?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// employee_id : 1
/// first_name : "Hettie Olson"
/// last_name : "Erik Walter"
/// username : "cashier"
/// pin : "1234"
/// group_name : "Cashier Group"
/// price_override_limit_percentage : 52.09

Cashiers cashiersFromJson(String str) => Cashiers.fromJson(json.decode(str));

String cashiersToJson(Cashiers data) => json.encode(data.toJson());

class Cashiers {
  Cashiers({
    this.id,
    this.employeeId,
    this.firstName,
    this.lastName,
    this.username,
    this.pin,
    this.groupName,
    this.staffId,
    this.priceOverrideLimitPercentage,
  });

  Cashiers.fromJson(dynamic json) {
    id = json['id'];
    employeeId = json['employee_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    pin = json['pin'];
    staffId = json['staff_id'];
    groupName = json['group_name'];
    priceOverrideLimitPercentage =
        getDoubleValue(json['price_override_limit_percentage']);
  }

  int? id;
  int? employeeId;
  String? firstName;
  String? lastName;
  String? username;
  String? pin;
  String? groupName;
  String? staffId;
  double? priceOverrideLimitPercentage;

  Cashiers copyWith({
    int? id,
    int? employeeId,
    String? firstName,
    String? lastName,
    String? username,
    String? pin,
    String? staffId,
    String? groupName,
    double? priceOverrideLimitPercentage,
  }) =>
      Cashiers(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        username: username ?? this.username,
        pin: pin ?? this.pin,
        staffId: staffId ?? this.staffId,
        groupName: groupName ?? this.groupName,
        priceOverrideLimitPercentage:
            priceOverrideLimitPercentage ?? this.priceOverrideLimitPercentage,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['employee_id'] = employeeId;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['username'] = username;
    map['pin'] = pin;
    map['group_name'] = groupName;
    map['staff_id'] = staffId;

    map['price_override_limit_percentage'] = priceOverrideLimitPercentage;
    return map;
  }
}
