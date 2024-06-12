import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// cashMovements : [{"id":18,"cash_movement_reason":"Tender Change","authorizer":"STORE_MANAGER: Prof. Bridget Rath Ms. Brionna Hoeger DVM","other_reason":"N/A","type":"CASH_IN","amount":12.50,"mismatches":[""]}]
/// total_records : 4
/// last_page : 1
/// current_page : 1
/// per_page : 10

CashMovementResponse cashMovementResponseFromJson(String str) =>
    CashMovementResponse.fromJson(json.decode(str));

String cashMovementResponseToJson(CashMovementResponse data) =>
    json.encode(data.toJson());

class CashMovementResponse {
  CashMovementResponse({
    this.cashMovements,
    this.cashMovement,
    this.totalRecords,
    this.message,
    this.lastPage,
    this.currentPage,
    this.perPage,
  });

  CashMovementResponse.fromJson(dynamic json) {
    if (json['cash_movements'] != null) {
      cashMovements = [];
      json['cash_movements'].forEach((v) {
        cashMovements?.add(CashMovements.fromJson(v));
      });
    }
    cashMovement = json['cash_movement'] != null
        ? CashMovements.fromJson(json['cash_movement'])
        : null;
    totalRecords = json['total_records'];
    message = json['message'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }

  List<CashMovements>? cashMovements;
  CashMovements? cashMovement;
  int? totalRecords;
  String? message;
  int? lastPage;
  int? currentPage;
  int? perPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (cashMovements != null) {
      map['cash_movements'] = cashMovements?.map((v) => v.toJson()).toList();
    }

    if (cashMovement != null) {
      map['cash_movement'] = cashMovement?.toJson();
    }

    map['total_records'] = totalRecords;
    map['last_page'] = lastPage;
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    map['message'] = message;
    return map;
  }
}

/// id : 18
/// cash_movement_reason : "Tender Change"
/// authorizer : "STORE_MANAGER: Prof. Bridget Rath Ms. Brionna Hoeger DVM"
/// other_reason : "N/A"
/// type : "CASH_IN"
/// amount : 12.50
/// mismatches : [""]

CashMovements cashMovementsFromJson(String str) =>
    CashMovements.fromJson(json.decode(str));

String cashMovementsToJson(CashMovements data) => json.encode(data.toJson());

class CashMovements {
  CashMovements({
    this.id,
    this.cashMovementReason,
    this.authorizer,
    this.otherReason,
    this.type,
    this.amount,
    this.createdAt,
    this.mismatches,
  });

  CashMovements.fromJson(dynamic json) {
    id = json['id'];
    cashMovementReason = json['cash_movement_reason'];
    authorizer = json['authorizer'];
    otherReason = json['other_reason'];
    type = json['type'];
    amount = getDoubleValue(json['amount']);
    createdAt = json['created_at'];
    mismatches =
        json['mismatches'] != null ? json['mismatches'].cast<String>() : [];
  }

  int? id;
  String? cashMovementReason;
  String? authorizer;
  String? otherReason;
  String? type;
  double? amount;
  String? createdAt;
  List<String>? mismatches;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['cash_movement_reason'] = cashMovementReason;
    map['authorizer'] = authorizer;
    map['other_reason'] = otherReason;
    map['type'] = type;
    map['amount'] = amount;
    map['mismatches'] = mismatches;
    map['created_at'] = createdAt;

    return map;
  }
}
