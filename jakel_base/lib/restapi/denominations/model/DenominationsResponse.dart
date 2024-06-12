import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// denominationKey : [{"id":1,"denomination":"100.00"}]

DenominationsResponse denominationsResponseFromJson(String str) =>
    DenominationsResponse.fromJson(json.decode(str));

String denominationsResponseToJson(DenominationsResponse data) =>
    json.encode(data.toJson());

class DenominationsResponse {
  DenominationsResponse({
    this.denominationKey,
  });

  DenominationsResponse.fromJson(dynamic json) {
    if (json['denominations'] != null) {
      denominationKey = [];
      json['denominations'].forEach((v) {
        denominationKey?.add(DenominationKey.fromJson(v));
      });
    }
  }

  List<DenominationKey>? denominationKey;

  DenominationsResponse copyWith({
    List<DenominationKey>? denominationKey,
  }) =>
      DenominationsResponse(
        denominationKey: denominationKey ?? this.denominationKey,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (denominationKey != null) {
      map['denominations'] = denominationKey?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// denomination : "100.00"

DenominationKey denominationKeyFromJson(String str) =>
    DenominationKey.fromJson(json.decode(str));

String denominationKeyToJson(DenominationKey data) =>
    json.encode(data.toJson());

class DenominationKey {
  DenominationKey({
    this.id,
    this.denomination,
  });

  DenominationKey.fromJson(dynamic json) {
    id = json['id'];
    denomination = getDoubleValue(json['denomination']);
  }

  int? id;
  double? denomination;

  DenominationKey copyWith({
    int? id,
    double? denomination,
  }) =>
      DenominationKey(
        id: id ?? this.id,
        denomination: denomination ?? this.denomination,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['denomination'] = denomination;
    return map;
  }
}
