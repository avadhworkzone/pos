import 'dart:convert';

/// cash_movement_reasons : [{"id":1,"reason":"Tender Change","type_id":1,"type":"Cash In"},{"id":2,"reason":"Electricity Bil","type_id":2,"type":"Cash Out"}]

CashMovementReasonResponse cashMovementResponseFromJson(String str) =>
    CashMovementReasonResponse.fromJson(json.decode(str));

String cashMovementResponseToJson(CashMovementReasonResponse data) =>
    json.encode(data.toJson());

class CashMovementReasonResponse {
  CashMovementReasonResponse({
    this.cashMovementReasons,
  });

  CashMovementReasonResponse.fromJson(dynamic json) {
    if (json['cash_movement_reasons'] != null) {
      cashMovementReasons = [];
      json['cash_movement_reasons'].forEach((v) {
        cashMovementReasons?.add(CashMovementReasons.fromJson(v));
      });
    }
  }

  List<CashMovementReasons>? cashMovementReasons;

  CashMovementReasonResponse copyWith({
    List<CashMovementReasons>? cashMovementReasons,
  }) =>
      CashMovementReasonResponse(
        cashMovementReasons: cashMovementReasons ?? this.cashMovementReasons,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (cashMovementReasons != null) {
      map['cash_movement_reasons'] =
          cashMovementReasons?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// reason : "Tender Change"
/// type_id : 1
/// type : "Cash In"

CashMovementReasons cashMovementReasonsFromJson(String str) =>
    CashMovementReasons.fromJson(json.decode(str));

String cashMovementReasonsToJson(CashMovementReasons data) =>
    json.encode(data.toJson());

class CashMovementReasons {
  CashMovementReasons({
    this.id,
    this.reason,
    this.typeId,
    this.type,
  });

  CashMovementReasons.fromJson(dynamic json) {
    id = json['id'];
    reason = json['reason'];
    typeId = json['type_id'];
    type = json['type'];
  }

  int? id;
  String? reason;
  int? typeId;
  String? type;

  CashMovementReasons copyWith({
    int? id,
    String? reason,
    int? typeId,
    String? type,
  }) =>
      CashMovementReasons(
        id: id ?? this.id,
        reason: reason ?? this.reason,
        typeId: typeId ?? this.typeId,
        type: type ?? this.type,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['reason'] = reason;
    map['type_id'] = typeId;
    map['type'] = type;
    return map;
  }
}
