import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// directors : [{"id":1,"first_name":"Adam","last_name":"Lim","email":"adam@test.com","passcode":"12345","price_override_limit_percentage":20.0},{"id":2,"first_name":"Rayyan","last_name":"Teh","email":"rayyan@test.com","passcode":"94564","price_override_limit_percentage":0}]

DirectorsResponse directorsResponseFromJson(String str) =>
    DirectorsResponse.fromJson(json.decode(str));

String directorsResponseToJson(DirectorsResponse data) =>
    json.encode(data.toJson());

class DirectorsResponse {
  DirectorsResponse({
    List<Directors>? directors,
  }) {
    _directors = directors;
  }

  DirectorsResponse.fromJson(dynamic json) {
    if (json['directors'] != null) {
      _directors = [];
      json['directors'].forEach((v) {
        _directors?.add(Directors.fromJson(v));
      });
    }
  }

  List<Directors>? _directors;

  DirectorsResponse copyWith({
    List<Directors>? directors,
  }) =>
      DirectorsResponse(
        directors: directors ?? _directors,
      );

  List<Directors>? get directors => _directors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_directors != null) {
      map['directors'] = _directors?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// employee_id: 1
/// first_name : "Adam"
/// last_name : "Lim"
/// email : "adam@test.com"
/// passcode : "12345"
/// price_override_limit_percentage : 20.0
/// "price_override_limit_percentage_for_item": 10,
//  "price_override_limit_percentage_for_cart": 0

Directors directorsFromJson(String str) => Directors.fromJson(json.decode(str));

String directorsToJson(Directors data) => json.encode(data.toJson());

class Directors {
  Directors(
      {int? id,
      int? employeeId,
      int? priceOverrideType,
      String? firstName,
      String? lastName,
      String? email,
      String? passcode,
        double? priceOverrideLimitPercentageItem,
        double? priceOverrideLimitPercentageCart,
      String? staffId}) {
    _id = id;
    _employeeId = employeeId;
    _priceOverrideType = priceOverrideType;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _passcode = passcode;
    _priceOverrideLimitPercentageForItem = priceOverrideLimitPercentageItem;
    _priceOverrideLimitPercentageForCart = priceOverrideLimitPercentageCart;
    _staffId = staffId;
  }

  Directors.fromJson(dynamic json) {
    _id = json['id'];
    _employeeId = json['employee_id'];
    _priceOverrideType = json['price_override_type'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _passcode = json['passcode'];
    _staffId = json['staff_id'];
    _priceOverrideLimitPercentageForItem =
        getDoubleValue(json['price_override_limit_percentage_for_item']);
    _priceOverrideLimitPercentageForCart =
        getDoubleValue(json['price_override_limit_percentage_for_cart']);
  }

  int? _id;
  int? _employeeId;
  int? _priceOverrideType;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _passcode;
  String? _staffId;
  double? _priceOverrideLimitPercentageForItem;
  double? _priceOverrideLimitPercentageForCart;



  int? get id => _id;

  int? get employeeId => _employeeId;

  int? get priceOverrideType => _priceOverrideType;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get email => _email;

  String? get passcode => _passcode;

  String? get staffId => _staffId;

  double? get priceOverrideLimitPercentageItem =>
      _priceOverrideLimitPercentageForItem;

  double? get priceOverrideLimitPercentageCart =>
      _priceOverrideLimitPercentageForCart;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['employee_id'] = _employeeId;
    map['price_override_type'] = _priceOverrideType;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['email'] = _email;
    map['passcode'] = _passcode;
    map['staff_id'] = _staffId;
    map['price_override_limit_percentage_for_item'] =
        _priceOverrideLimitPercentageForItem;
    map['price_override_limit_percentage_for_cart'] =
        _priceOverrideLimitPercentageForCart;
    return map;
  }
}
