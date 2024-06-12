///store_id:10

class GetPromoterCommissionDetailsRequest {
  GetPromoterCommissionDetailsRequest({
    String? commissionId,
    String? status,
  }) {
    _commissionId = commissionId;
    _status = status;
  }

  GetPromoterCommissionDetailsRequest.fromJson(dynamic json) {
    _commissionId = json['commission_id'];
    _status = json['status'];
  }

  String? _commissionId;
  String? _status;

  String? get commissionId => _commissionId;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['commission_id'] = _commissionId;
    map['status'] = _status;
    return map;
  }
}
