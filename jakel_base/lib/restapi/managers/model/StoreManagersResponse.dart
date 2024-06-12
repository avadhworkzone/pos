import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// store_managers : [{"id":1,"first_name":"Alya","last_name":"Loh","email":"alya@abc.com","price_override_limit_percentage":0,"passcode":"$2y$10$L8CBbPN91EHSum4zUvEWl.6vVoFp7D/mylf/qQhFWbjw4ZsI9a4ru"}]

StoreManagersResponse storeManagersResponseFromJson(String str) =>
    StoreManagersResponse.fromJson(json.decode(str));

String storeManagersResponseToJson(StoreManagersResponse data) =>
    json.encode(data.toJson());

class StoreManagersResponse {
  StoreManagersResponse({
    List<StoreManagers>? storeManagers,
  }) {
    _storeManagers = storeManagers;
  }

  StoreManagersResponse.fromJson(dynamic json) {
    if (json['store_managers'] != null) {
      _storeManagers = [];
      json['store_managers'].forEach((v) {
        _storeManagers?.add(StoreManagers.fromJson(v));
      });
    }
  }

  List<StoreManagers>? _storeManagers;

  StoreManagersResponse copyWith({
    List<StoreManagers>? storeManagers,
  }) =>
      StoreManagersResponse(
        storeManagers: storeManagers ?? _storeManagers,
      );

  List<StoreManagers>? get storeManagers => _storeManagers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_storeManagers != null) {
      map['store_managers'] = _storeManagers?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// employee_id: 1
/// first_name : "Alya"
/// last_name : "Loh"
/// email : "alya@abc.com"
/// price_override_limit_percentage : 0
/// passcode : "$2y$10$L8CBbPN91EHSum4zUvEWl.6vVoFp7D/mylf/qQhFWbjw4ZsI9a4ru"

StoreManagers storeManagersFromJson(String str) =>
    StoreManagers.fromJson(json.decode(str));

String storeManagersToJson(StoreManagers data) => json.encode(data.toJson());

class StoreManagers {
  StoreManagers(
      {int? id,
      int? employeeId,
      int? priceOverrideType,
      String? firstName,
      String? lastName,
      String? email,
      double? priceOverrideLimitPercentageItem,
      double? priceOverrideLimitPercentageCart,
      String? passcode,
      String? staffId}) {
    _id = id;
    _employeeId = employeeId;
    _priceOverrideType = priceOverrideType;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _priceOverrideLimitPercentageForItem = priceOverrideLimitPercentageItem;
    _priceOverrideLimitPercentageForCart = priceOverrideLimitPercentageCart;
    _passcode = passcode;
    _staffId = staffId;
  }

  StoreManagers.fromJson(dynamic json) {
    _id = json['id'];
    _employeeId = json['employee_id'];
    _priceOverrideType = json['price_override_type'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _priceOverrideLimitPercentageForItem =
        getDoubleValue(json['price_override_limit_percentage_for_item']);
    _priceOverrideLimitPercentageForCart =
        getDoubleValue(json['price_override_limit_percentage_for_cart']);
    _passcode = json['passcode'];
    _staffId = json['staff_id'];
  }

  int? _id;
  int? _employeeId;
  int? _priceOverrideType;
  String? _firstName;
  String? _lastName;
  String? _email;
  double? _priceOverrideLimitPercentageForItem;
  double? _priceOverrideLimitPercentageForCart;
  String? _passcode;
  String? _staffId;

  int? get id => _id;

  int? get employeeId => _employeeId;

  int? get priceOverrideType => _priceOverrideType;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get email => _email;

  double? get priceOverrideLimitPercentageItem =>
      _priceOverrideLimitPercentageForItem;

  double? get priceOverrideLimitPercentageCart =>
      _priceOverrideLimitPercentageForCart;

  String? get passcode => _passcode;

  String? get staffId => _staffId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['employee_id'] = _employeeId;
    map['price_override_type'] = _priceOverrideType;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['staff_id'] = _staffId;
    map['email'] = _email;
    map['price_override_limit_percentage_for_item'] =
        _priceOverrideLimitPercentageForItem;
    map['price_override_limit_percentage_for_cart'] =
        _priceOverrideLimitPercentageForCart;
    map['passcode'] = _passcode;
    return map;
  }
}
