import 'dart:convert';

/// sale_return_reasons : [{"id":1,"reason":"DEFECTIVE"}]

SaleReturnsResponse saleReturnsResponseFromJson(String str) =>
    SaleReturnsResponse.fromJson(json.decode(str));

String saleReturnsResponseToJson(SaleReturnsResponse data) =>
    json.encode(data.toJson());

class SaleReturnsResponse {
  SaleReturnsResponse({
    List<SaleReturnReasons>? saleReturnReasons,
  }) {
    _saleReturnReasons = saleReturnReasons;
  }

  SaleReturnsResponse.fromJson(dynamic json) {
    if (json['sale_return_reasons'] != null) {
      _saleReturnReasons = [];
      json['sale_return_reasons'].forEach((v) {
        _saleReturnReasons?.add(SaleReturnReasons.fromJson(v));
      });
    }
  }

  List<SaleReturnReasons>? _saleReturnReasons;

  SaleReturnsResponse copyWith({
    List<SaleReturnReasons>? saleReturnReasons,
  }) =>
      SaleReturnsResponse(
        saleReturnReasons: saleReturnReasons ?? _saleReturnReasons,
      );

  List<SaleReturnReasons>? get saleReturnReasons => _saleReturnReasons;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_saleReturnReasons != null) {
      map['sale_return_reasons'] =
          _saleReturnReasons?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// reason : "DEFECTIVE"

SaleReturnReasons saleReturnReasonsFromJson(String str) =>
    SaleReturnReasons.fromJson(json.decode(str));

String saleReturnReasonsToJson(SaleReturnReasons data) =>
    json.encode(data.toJson());

class SaleReturnReasons {
  SaleReturnReasons({
    int? id,
    String? reason,
  }) {
    _id = id;
    _reason = reason;
  }

  SaleReturnReasons.fromJson(dynamic json) {
    _id = json['id'];
    _reason = json['reason'];
  }

  int? _id;
  String? _reason;

  SaleReturnReasons copyWith({
    int? id,
    String? reason,
  }) =>
      SaleReturnReasons(
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
