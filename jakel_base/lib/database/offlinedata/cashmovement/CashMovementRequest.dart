import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// typeId : 1
/// openByPosAt : ""
/// reasonId : 1
/// reason : ""
/// authorizer : ""
/// authorizeId : 1
/// authorizerType : ""
/// amount : 10.50
/// happenedAt : ""
/// isSynced:true

CashMovementRequest cashMovementRequestFromJson(String str) =>
    CashMovementRequest.fromJson(json.decode(str));

String cashMovementRequestToJson(CashMovementRequest data) =>
    json.encode(data.toJson());

class CashMovementRequest {
  CashMovementRequest({
    this.typeId,
    this.openByPosAt,
    this.reasonId,
    this.reason,
    this.authorizer,
    this.authorizeId,
    this.authorizerType,
    this.amount,
    this.happenedAt,
    this.isSynced,
  });

  CashMovementRequest.fromJson(dynamic json) {
    typeId = json['typeId'];
    openByPosAt = json['openByPosAt'];
    reasonId = json['reasonId'];
    reason = json['reason'];
    authorizer = json['authorizer'];
    authorizeId = json['authorizeId'];
    authorizerType = json['authorizerType'];
    amount = getDoubleValue(json['amount']);
    happenedAt = json['happenedAt'];
    isSynced = json['isSynced'];
  }

  int? typeId;
  String? openByPosAt;
  int? reasonId;
  String? reason;
  String? authorizer;
  int? authorizeId;
  String? authorizerType;
  double? amount;
  String? happenedAt;
  bool? isSynced;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['typeId'] = typeId;
    map['openByPosAt'] = openByPosAt;
    map['reasonId'] = reasonId;
    map['reason'] = reason;
    map['authorizer'] = authorizer;
    map['authorizeId'] = authorizeId;
    map['authorizerType'] = authorizerType;
    map['amount'] = amount;
    map['happenedAt'] = happenedAt;
    map['isSynced'] = isSynced;
    return map;
  }
}
