import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// counters : [{"id":1,"name":"Counter 1","store_id":1,"is_locked":false}]

GetCountersResponse getCountersResponseFromJson(String str) =>
    GetCountersResponse.fromJson(json.decode(str));

String getCountersResponseToJson(GetCountersResponse data) =>
    json.encode(data.toJson());

class GetCountersResponse {
  GetCountersResponse({
    List<Counters>? counters,
  }) {
    _counters = counters;
  }

  GetCountersResponse.fromJson(dynamic json) {
    if (json['counters'] != null) {
      _counters = [];
      json['counters'].forEach((v) {
        _counters?.add(Counters.fromJson(v));
      });
    }
  }

  List<Counters>? _counters;

  GetCountersResponse copyWith({
    List<Counters>? counters,
  }) =>
      GetCountersResponse(
        counters: counters ?? _counters,
      );

  List<Counters>? get counters => _counters;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_counters != null) {
      map['counters'] = _counters?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// name : "Counter 1"
/// store_id : 1
/// is_locked : false
/// is_opened: true

Counters countersFromJson(String str) => Counters.fromJson(json.decode(str));

String countersToJson(Counters data) => json.encode(data.toJson());

class Counters {
  Counters(
      {int? id,
      double? openingBalance,
      String? name,
      int? storeId,
      int? counterUpdateId,
      bool? isLocked,
      bool? isOpened,
      String? openedAt}) {
    _id = id;
    _name = name;
    _storeId = storeId;
    _counterUpdateId = counterUpdateId;
    _openingBalance = openingBalance;
    _isLocked = isLocked;
    _isOpened = isOpened;
    _openedAt = openedAt;
  }

  Counters.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _storeId = json['store_id'];
    _counterUpdateId = json['counter_update_id'];
    _isLocked = json['is_locked'];
    _openingBalance = getDoubleValue(json['opening_balance']);
    _isOpened = json['is_opened'];
    _openedAt = json['opened_at'];
  }

  int? _id;
  String? _name;
  int? _storeId;
  int? _counterUpdateId;
  bool? _isLocked;
  bool? _isOpened;
  String? _openedAt;
  double? _openingBalance;

  int? get id => _id;

  int? get counterUpdateId => _counterUpdateId;

  String? get name => _name;

  int? get storeId => _storeId;

  bool? get isLocked => _isLocked;

  bool? get isOpened => _isOpened;

  String? get openedAt => _openedAt;

  double? get openingBalance => _openingBalance;

  setOpenedAt(String openingTime) {
    _openedAt = openingTime;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['store_id'] = _storeId;
    map['counter_update_id'] = _counterUpdateId;
    map['is_locked'] = _isLocked;
    map['is_opened'] = _isOpened;
    map['opened_at'] = _openedAt;
    map['opening_balance'] = _openingBalance;

    return map;
  }
}
