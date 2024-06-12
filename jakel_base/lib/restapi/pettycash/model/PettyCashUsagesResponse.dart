import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// petty_cash_usages : [{"id":32,"created_at":"04-10-2022 03:06:15 AM","reason":"Test","amount":10.00}]
/// total_records : 5
/// last_page : 1
/// current_page : 1
/// per_page : 10

PettyCashUsagesResponse pettyCashUsagesResponseFromJson(String str) =>
    PettyCashUsagesResponse.fromJson(json.decode(str));

String pettyCashUsagesResponseToJson(PettyCashUsagesResponse data) =>
    json.encode(data.toJson());

class PettyCashUsagesResponse {
  PettyCashUsagesResponse({
    this.pettyCashUsages,
    this.totalRecords,
    this.lastPage,
    this.currentPage,
    this.perPage,
  });

  PettyCashUsagesResponse.fromJson(dynamic json) {
    if (json['petty_cash_usages'] != null) {
      pettyCashUsages = [];
      json['petty_cash_usages'].forEach((v) {
        pettyCashUsages?.add(PettyCashUsages.fromJson(v));
      });
    }
    totalRecords = json['total_records'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }

  List<PettyCashUsages>? pettyCashUsages;
  int? totalRecords;
  int? lastPage;
  int? currentPage;
  int? perPage;

  PettyCashUsagesResponse copyWith({
    List<PettyCashUsages>? pettyCashUsages,
    int? totalRecords,
    int? lastPage,
    int? currentPage,
    int? perPage,
  }) =>
      PettyCashUsagesResponse(
        pettyCashUsages: pettyCashUsages ?? this.pettyCashUsages,
        totalRecords: totalRecords ?? this.totalRecords,
        lastPage: lastPage ?? this.lastPage,
        currentPage: currentPage ?? this.currentPage,
        perPage: perPage ?? this.perPage,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (pettyCashUsages != null) {
      map['petty_cash_usages'] =
          pettyCashUsages?.map((v) => v.toJson()).toList();
    }
    map['total_records'] = totalRecords;
    map['last_page'] = lastPage;
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    return map;
  }
}

/// id : 32
/// created_at : "04-10-2022 03:06:15 AM"
/// reason : "Test"
/// amount : 10.00

PettyCashUsages pettyCashUsagesFromJson(String str) =>
    PettyCashUsages.fromJson(json.decode(str));

String pettyCashUsagesToJson(PettyCashUsages data) =>
    json.encode(data.toJson());

class PettyCashUsages {
  PettyCashUsages({
    this.id,
    this.createdAt,
    this.reason,
    this.amount,
  });

  PettyCashUsages.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['created_at'];
    reason = json['reason'];
    amount = getDoubleValue(json['amount']);
  }

  int? id;
  String? createdAt;
  String? reason;
  double? amount;

  PettyCashUsages copyWith({
    int? id,
    String? createdAt,
    String? reason,
    double? amount,
  }) =>
      PettyCashUsages(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        reason: reason ?? this.reason,
        amount: amount ?? this.amount,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['created_at'] = createdAt;
    map['reason'] = reason;
    map['amount'] = amount;
    return map;
  }
}
