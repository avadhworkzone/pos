import 'dart:convert';

import 'package:jakel_base/restapi/counters/model/GetCountersResponse.dart';
import 'package:jakel_base/restapi/counters/model/GetStoresResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';

/// cashier : {"id":1,"username":"cashier","last_login_at":"2022-05-28 12:58:55","first_name":"Rayyan","last_name":"Teh","email":"rayyan@test.com","mobile_number":"60-4455667711","address_line_1":"2003A- building park","address_line_2":"west street","city":"Kuching","area_code":"5657896","date_of_joining":"2022-05-01","permissions":[1,3,6,10,7]}
/// round_off_configuration : [{"decimal_place":".01","value":"-0.01"},{"decimal_place":".02","value":"-0.02"},{"decimal_place":".03","value":"0.02"},{"decimal_place":".04","value":"0.01"},{"decimal_place":".05","value":"0.00"},{"decimal_place":".06","value":"-0.01"},{"decimal_place":".07","value":"-0.02"},{"decimal_place":".08","value":"0.02"},{"decimal_place":".09","value":"0.01"},{"decimal_place":".00","value":"0.00"}]
/// store : Store same as GetStoresResponse. Null if counter is not opened
/// counter : Same as in GetCountersResponse. Null if counter is not opened

CurrentUserResponse currentUserResponseFromJson(String str) =>
    CurrentUserResponse.fromJson(json.decode(str));

String currentUserResponseToJson(CurrentUserResponse data) =>
    json.encode(data.toJson());

class CurrentUserResponse {
  CurrentUserResponse(
      {Cashier? cashier,
      Company? company,
      List<RoundOffConfiguration>? roundOffConfiguration,
      Stores? store,
      Counters? counter}) {
    _cashier = cashier;
    _roundOffConfiguration = roundOffConfiguration;
  }

  CurrentUserResponse.fromJson(dynamic json) {
    _cashier =
        json['cashier'] != null ? Cashier.fromJson(json['cashier']) : null;

    _company =
        json['company'] != null ? Company.fromJson(json['company']) : null;

    if (json['round_off_configuration'] != null) {
      _roundOffConfiguration = [];
      json['round_off_configuration'].forEach((v) {
        _roundOffConfiguration?.add(RoundOffConfiguration.fromJson(v));
      });
    }
    _store = json['store'] != null ? Stores.fromJson(json['store']) : null;

    _counter =
        json['counter'] != null ? Counters.fromJson(json['counter']) : null;
  }

  Stores? _store;
  Counters? _counter;
  Company? _company;
  Cashier? _cashier;
  List<RoundOffConfiguration>? _roundOffConfiguration;

  Cashier? get cashier => _cashier;

  Company? get company => _company;

  List<RoundOffConfiguration>? get roundOffConfiguration =>
      _roundOffConfiguration;

  Stores? get store => _store;

  Counters? get counter => _counter;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (_cashier != null) {
      map['cashier'] = _cashier?.toJson();
    }

    if (_company != null) {
      map['company'] = _company?.toJson();
    }

    if (_store != null) {
      map['store'] = _store?.toJson();
    }

    if (_counter != null) {
      map['counter'] = _counter?.toJson();
    }

    if (_roundOffConfiguration != null) {
      map['round_off_configuration'] =
          _roundOffConfiguration?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// decimal_place : ".01"
/// value : "-0.01"

RoundOffConfiguration roundOffConfigurationFromJson(String str) =>
    RoundOffConfiguration.fromJson(json.decode(str));

String roundOffConfigurationToJson(RoundOffConfiguration data) =>
    json.encode(data.toJson());

class RoundOffConfiguration {
  RoundOffConfiguration({
    String? decimalPlace,
    String? value,
  }) {
    _decimalPlace = decimalPlace;
    _value = value;
  }

  RoundOffConfiguration.fromJson(dynamic json) {
    _decimalPlace = json['decimal_place'];
    _value = json['value'];
  }

  String? _decimalPlace;
  String? _value;

  RoundOffConfiguration copyWith({
    String? decimalPlace,
    String? value,
  }) =>
      RoundOffConfiguration(
        decimalPlace: decimalPlace ?? _decimalPlace,
        value: value ?? _value,
      );

  String? get decimalPlace => _decimalPlace;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['decimal_place'] = _decimalPlace;
    map['value'] = _value;
    return map;
  }
}

/// id : 1
/// username : "cashier"
/// last_login_at : "2022-05-28 12:58:55"
/// first_name : "Rayyan"
/// last_name : "Teh"
/// email : "rayyan@test.com"
/// mobile_number : "60-4455667711"
/// address_line_1 : "2003A- building park"
/// address_line_2 : "west street"
/// city : "Kuching"
/// area_code : "5657896"
/// date_of_joining : "2022-05-01"
/// permissions : [1,3,6,10,7]

Cashier cashierFromJson(String str) => Cashier.fromJson(json.decode(str));

String cashierToJson(Cashier data) => json.encode(data.toJson());

class Cashier {
  Cashier({
    int? id,
    int? priceOverrideType,
    String? username,
    String? lastLoginAt,
    String? firstName,
    String? lastName,
    String? email,
    String? mobileNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? areaCode,
    String? dateOfJoining,
    String? staffId,
    List<int>? permissions,
    double? priceOverrideLimitPercentageItem,
    double? priceOverrideLimitPercentageCart,
  }) {
    _id = id;
    _priceOverrideType = priceOverrideType;
    _username = username;
    _lastLoginAt = lastLoginAt;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _mobileNumber = mobileNumber;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _city = city;
    _areaCode = areaCode;
    _dateOfJoining = dateOfJoining;
    _permissions = permissions;
    _staffId = staffId;
    _priceOverrideLimitPercentageForItem = priceOverrideLimitPercentageItem;
    _priceOverrideLimitPercentageForCart = priceOverrideLimitPercentageCart;
  }

  Cashier.fromJson(dynamic json) {
    _id = json['id'];
    _priceOverrideType = json['price_override_type'];
    _username = json['username'];
    _lastLoginAt = json['last_login_at'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _mobileNumber = json['mobile_number'];
    _addressLine1 = json['address_line_1'];
    _addressLine2 = json['address_line_2'];
    _city = json['city'];
    _areaCode = json['area_code'];
    _dateOfJoining = json['date_of_joining'];
    _staffId = json['staff_id'];
    _priceOverrideLimitPercentageForItem =
        getDoubleValue(json['price_override_limit_percentage_for_item']);
    _priceOverrideLimitPercentageForCart =
        getDoubleValue(json['price_override_limit_percentage_for_cart']);
    _permissions =
        json['permissions'] != null ? json['permissions'].cast<int>() : [];
  }

  int? _id;
  int? _priceOverrideType;
  String? _username;
  String? _lastLoginAt;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _mobileNumber;
  String? _addressLine1;
  String? _addressLine2;
  String? _city;
  String? _areaCode;
  String? _dateOfJoining;
  List<int>? _permissions;
  String? _staffId;
  double? _priceOverrideLimitPercentageForItem;
  double? _priceOverrideLimitPercentageForCart;

  int? get id => _id;

  int? get priceOverrideType => _priceOverrideType;

  String? get username => _username;

  String? get lastLoginAt => _lastLoginAt;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get email => _email;

  String? get mobileNumber => _mobileNumber;

  String? get addressLine1 => _addressLine1;

  String? get addressLine2 => _addressLine2;

  String? get city => _city;

  String? get areaCode => _areaCode;

  String? get staffId => _staffId;

  String? get dateOfJoining => _dateOfJoining;

  List<int>? get permissions => _permissions;

  double? get priceOverrideLimitPercentageItem =>
      _priceOverrideLimitPercentageForItem;

  double? get priceOverrideLimitPercentageCart =>
      _priceOverrideLimitPercentageForCart;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['price_override_type'] = _priceOverrideType;
    map['username'] = _username;
    map['last_login_at'] = _lastLoginAt;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['email'] = _email;
    map['mobile_number'] = _mobileNumber;
    map['address_line_1'] = _addressLine1;
    map['address_line_2'] = _addressLine2;
    map['city'] = _city;
    map['area_code'] = _areaCode;
    map['date_of_joining'] = _dateOfJoining;
    map['permissions'] = _permissions;
    map['staff_id'] = _staffId;
    map['price_override_limit_percentage_for_item'] =
        _priceOverrideLimitPercentageForItem;
    map['price_override_limit_percentage_for_cart'] =
        _priceOverrideLimitPercentageForCart;

    return map;
  }
}

// "company": {
// "name": "ARIANI TEXTILES & MANUFACTURING (M) SDN. BHD.",
// "email": "galerialorsetar@ariani.my",
// "employer_identification_number": null,
// "social_security_number": null
// }
Company companyFromJson(String str) => Company.fromJson(json.decode(str));

String companyToJson(Counters data) => json.encode(data.toJson());

class Company {
  Company({
    String? name,
    String? email,
  }) {
    _name = name;
    _email = email;
  }

  Company.fromJson(dynamic json) {
    _email = json['email'];
    _name = json['name'];
  }

  String? _email;
  String? _name;

  String? get id => _email;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['name'] = _name;
    return map;
  }
}
