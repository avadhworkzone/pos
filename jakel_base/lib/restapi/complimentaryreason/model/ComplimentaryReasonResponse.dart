import 'dart:convert';

/// complimentary_item_reasons : [{"id":1,"reason":"VIP"}]

ComplimentaryReasonResponse complimentaryReasonResponseFromJson(String str) =>
    ComplimentaryReasonResponse.fromJson(json.decode(str));

String complimentaryReasonResponseToJson(ComplimentaryReasonResponse data) =>
    json.encode(data.toJson());

class ComplimentaryReasonResponse {
  ComplimentaryReasonResponse({
    List<ComplimentaryItemReasons>? complimentaryItemReasons,
  }) {
    _complimentaryItemReasons = complimentaryItemReasons;
  }

  ComplimentaryReasonResponse.fromJson(dynamic json) {
    if (json['complimentary_item_reasons'] != null) {
      _complimentaryItemReasons = [];
      json['complimentary_item_reasons'].forEach((v) {
        _complimentaryItemReasons?.add(ComplimentaryItemReasons.fromJson(v));
      });
    }
  }

  List<ComplimentaryItemReasons>? _complimentaryItemReasons;

  ComplimentaryReasonResponse copyWith({
    List<ComplimentaryItemReasons>? complimentaryItemReasons,
  }) =>
      ComplimentaryReasonResponse(
        complimentaryItemReasons:
            complimentaryItemReasons ?? _complimentaryItemReasons,
      );

  List<ComplimentaryItemReasons>? get complimentaryItemReasons =>
      _complimentaryItemReasons;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_complimentaryItemReasons != null) {
      map['complimentary_item_reasons'] =
          _complimentaryItemReasons?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// reason : "VIP"

ComplimentaryItemReasons complimentaryItemReasonsFromJson(String str) =>
    ComplimentaryItemReasons.fromJson(json.decode(str));

String complimentaryItemReasonsToJson(ComplimentaryItemReasons data) =>
    json.encode(data.toJson());

class ComplimentaryItemReasons {
  ComplimentaryItemReasons({
    int? id,
    String? reason,
  }) {
    _id = id;
    _reason = reason;
  }

  ComplimentaryItemReasons.fromJson(dynamic json) {
    _id = json['id'];
    _reason = json['reason'];
  }

  int? _id;
  String? _reason;

  ComplimentaryItemReasons copyWith({
    int? id,
    String? reason,
  }) =>
      ComplimentaryItemReasons(
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
