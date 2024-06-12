import 'dart:convert';

/// petty_cash_usage_reasons : [{"id":1,"reason":"Office Items"}]

PettyCashUsageResponse pettyCashUsageResponseFromJson(String str) =>
    PettyCashUsageResponse.fromJson(json.decode(str));

String pettyCashUsageResponseToJson(PettyCashUsageResponse data) =>
    json.encode(data.toJson());

class PettyCashUsageResponse {
  PettyCashUsageResponse({
    List<PettyCashUsageReasons>? pettyCashUsageReasons,}) {
    _pettyCashUsageReasons = pettyCashUsageReasons;
  }

  PettyCashUsageResponse.fromJson(dynamic json) {
    if (json['petty_cash_usage_reasons'] != null) {
      _pettyCashUsageReasons = [];
      json['petty_cash_usage_reasons'].forEach((v) {
        _pettyCashUsageReasons?.add(PettyCashUsageReasons.fromJson(v));
      });
    }
  }

  List<PettyCashUsageReasons>? _pettyCashUsageReasons;

  PettyCashUsageResponse copyWith(
      { List<PettyCashUsageReasons>? pettyCashUsageReasons,
      }) =>
      PettyCashUsageResponse(
        pettyCashUsageReasons: pettyCashUsageReasons ?? _pettyCashUsageReasons,
      );

  List<PettyCashUsageReasons>? get pettyCashUsageReasons =>
      _pettyCashUsageReasons;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_pettyCashUsageReasons != null) {
      map['petty_cash_usage_reasons'] =
          _pettyCashUsageReasons?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// reason : "Office Items"

PettyCashUsageReasons pettyCashUsageReasonsFromJson(String str) =>
    PettyCashUsageReasons.fromJson(json.decode(str));

String pettyCashUsageReasonsToJson(PettyCashUsageReasons data) =>
    json.encode(data.toJson());

class PettyCashUsageReasons {
  PettyCashUsageReasons({
    int? id,
    String? reason,}) {
    _id = id;
    _reason = reason;
  }

  PettyCashUsageReasons.fromJson(dynamic json) {
    _id = json['id'];
    _reason = json['reason'];
  }

  int? _id;
  String? _reason;

  PettyCashUsageReasons copyWith({ int? id,
    String? reason,
  }) =>
      PettyCashUsageReasons(id: id ?? _id,
        reason: reason ?? _reason,
      );

  int? get id => _id;

  String? get reason => _reason;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['reason'] = _reason;
    return map;
  }

}