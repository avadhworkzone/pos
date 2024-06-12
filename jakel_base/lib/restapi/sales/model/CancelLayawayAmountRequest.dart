import 'dart:convert';

import 'package:jakel_base/restapi/sales/model/UpdateLoyaltyPointsRequest.dart';
import 'package:jakel_base/utils/num_utils.dart';


/// happened_at : ""
/// store_manager_id : ""
/// passcode : ""
/// reason : ""


CancelLayawayAmountRequest cancelLayawayAmountRequest(String str) =>
    CancelLayawayAmountRequest.fromJson(json.decode(str));

String newSaleRequestToJson(CancelLayawayAmountRequest data) => json.encode(data.toJson());

class CancelLayawayAmountRequest {
  CancelLayawayAmountRequest({
    String? happenedAt,
    int? storeManagerId,
    String? passcode,
    String? reason,
  }) {
    _happenedAt = happenedAt;
    _storeManagerId = storeManagerId;
    _passcode = passcode;
    _reason = reason;
 
  }

  CancelLayawayAmountRequest.fromJson(dynamic json) {
    _happenedAt = json['happened_at'];
    _storeManagerId = json['store_manager_id'];
    _passcode = json['passcode'];
    _reason = json['reason'];
  }
  
  String? _happenedAt;
  int? _storeManagerId;
  String? _passcode;
  String? _reason;

  String? get happenedAt => _happenedAt;
  String? get reason => _reason;
  int? get storeManagerId => _storeManagerId;
  String? get passcode => _passcode;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['happened_at'] = _happenedAt;
    map['store_manager_id'] = _storeManagerId;
    map['passcode'] = _passcode;
    map['reason'] = _reason;
    return map;
  }
}
