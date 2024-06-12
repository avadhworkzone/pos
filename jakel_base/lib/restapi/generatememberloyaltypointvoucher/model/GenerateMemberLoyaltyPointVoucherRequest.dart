import 'dart:convert';

/// voucher_configuration_id:1
/// member_id:1
/// loyalty_points:100

GenerateMemberLoyaltyPointVoucherRequest generateMemberLoyaltyPointVoucherRequestFromJson(String str) =>
    GenerateMemberLoyaltyPointVoucherRequest.fromJson(json.decode(str));

String generateMemberLoyaltyPointVoucherRequestToJson(GenerateMemberLoyaltyPointVoucherRequest data) =>
    json.encode(data.toJson());

class GenerateMemberLoyaltyPointVoucherRequest {
  GenerateMemberLoyaltyPointVoucherRequest({
    int? voucherConfigurationId,
    int? memberId,
    int? loyaltyPoints,
  }) {
    _voucherConfigurationId = voucherConfigurationId;
    _memberId = memberId;
    _loyaltyPoints = loyaltyPoints;
  }

  GenerateMemberLoyaltyPointVoucherRequest.fromJson(dynamic json) {
    _voucherConfigurationId = json['voucher_configuration_id'];
    _memberId = json['member_id'];
    _loyaltyPoints = json['loyalty_points'];
  }

  int? _voucherConfigurationId;
  int? _memberId;
  int? _loyaltyPoints;

  int? get voucherConfigurationId => _voucherConfigurationId;

  int? get memberId => _memberId;

  int? get loyaltyPoints => _loyaltyPoints;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['voucher_configuration_id'] = _voucherConfigurationId;
    map['member_id'] = _memberId;
    map['loyalty_points'] = _loyaltyPoints;
    return map;
  }
}