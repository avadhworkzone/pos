import 'dart:convert';

/// void_sale_reasons : [{"id":1,"reason":"Test 1"},{"id":2,"reason":"Test 2"},{"id":3,"reason":"Test 3"}]

VoidSaleReasonResponse voidSaleReasonResponseFromJson(String str) =>
    VoidSaleReasonResponse.fromJson(json.decode(str));

String voidSaleReasonResponseToJson(VoidSaleReasonResponse data) =>
    json.encode(data.toJson());

class VoidSaleReasonResponse {
  VoidSaleReasonResponse({
    List<VoidSaleReasons>? voidSaleReasons,
  }) {
    _voidSaleReasons = voidSaleReasons;
  }

  VoidSaleReasonResponse.fromJson(dynamic json) {
    if (json['void_sale_reasons'] != null) {
      _voidSaleReasons = [];
      json['void_sale_reasons'].forEach((v) {
        _voidSaleReasons?.add(VoidSaleReasons.fromJson(v));
      });
    }
  }

  List<VoidSaleReasons>? _voidSaleReasons;

  VoidSaleReasonResponse copyWith({
    List<VoidSaleReasons>? voidSaleReasons,
  }) =>
      VoidSaleReasonResponse(
        voidSaleReasons: voidSaleReasons ?? _voidSaleReasons,
      );

  List<VoidSaleReasons>? get voidSaleReasons => _voidSaleReasons;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_voidSaleReasons != null) {
      map['void_sale_reasons'] =
          _voidSaleReasons?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// reason : "Test 1"

VoidSaleReasons voidSaleReasonsFromJson(String str) =>
    VoidSaleReasons.fromJson(json.decode(str));

String voidSaleReasonsToJson(VoidSaleReasons data) =>
    json.encode(data.toJson());

class VoidSaleReasons {
  VoidSaleReasons({
    int? id,
    String? reason,
  }) {
    _id = id;
    _reason = reason;
  }

  VoidSaleReasons.fromJson(dynamic json) {
    _id = json['id'];
    _reason = json['reason'];
  }

  int? _id;
  String? _reason;

  VoidSaleReasons copyWith({
    int? id,
    String? reason,
  }) =>
      VoidSaleReasons(
        id: id ?? _id,
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
