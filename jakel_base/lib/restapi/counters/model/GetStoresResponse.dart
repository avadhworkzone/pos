import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// stores : [{"id":1,"name":"Nestle Malaysia","code":"NESMYR","email":"abc@test.my","phone":"606549873100","mobile":"603564798","address_line_1":"Stadium Park","address_line_2":"45B-block street","city":"Kuala Lumpur","area_code":"420001","sales_tax_percentage":5.05,"sales_return_days_limit":7,"receipt_footer":"Nestle Malaysia","disclaimer":"disclaimer"}]

GetStoresResponse getStoresResponseFromJson(String str) =>
    GetStoresResponse.fromJson(json.decode(str));

String getStoresResponseToJson(GetStoresResponse data) =>
    json.encode(data.toJson());

class GetStoresResponse {
  GetStoresResponse({
    List<Stores>? stores,
  }) {
    _stores = stores;
  }

  GetStoresResponse.fromJson(dynamic json) {
    if (json['stores'] != null) {
      _stores = [];
      json['stores'].forEach((v) {
        _stores?.add(Stores.fromJson(v));
      });
    }
  }

  List<Stores>? _stores;

  GetStoresResponse copyWith({
    List<Stores>? stores,
  }) =>
      GetStoresResponse(
        stores: stores ?? _stores,
      );

  List<Stores>? get stores => _stores;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_stores != null) {
      map['stores'] = _stores?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// name : "Nestle Malaysia"
/// code : "NESMYR"
/// email : "abc@test.my"
/// phone : "606549873100"
/// mobile : "603564798"
/// address_line_1 : "Stadium Park"
/// address_line_2 : "45B-block street"
/// city : "Kuala Lumpur"
/// area_code : "420001"
/// sales_tax_percentage : 5.05
/// sales_return_days_limit : 7
/// receipt_footer : "Nestle Malaysia"
/// disclaimer : "disclaimer"

Stores storesFromJson(String str) => Stores.fromJson(json.decode(str));

String storesToJson(Stores data) => json.encode(data.toJson());

class Stores {
  Stores({
    int? id,
    String? name,
    String? code,
    String? email,
    String? phone,
    String? mobile,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? areaCode,
    double? salesTaxPercentage,
    int? salesReturnDaysLimit,
    String? receiptFooter,
    String? disclaimer,
  }) {
    _id = id;
    _name = name;
    _code = code;
    _email = email;
    _phone = phone;
    _mobile = mobile;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _city = city;
    _areaCode = areaCode;
    _salesTaxPercentage = salesTaxPercentage;
    _salesReturnDaysLimit = salesReturnDaysLimit;
    _receiptFooter = receiptFooter;
    _disclaimer = disclaimer;
  }

  Stores.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _email = json['email'];
    _phone = json['phone'];
    _mobile = json['mobile'];
    _addressLine1 = json['address_line_1'];
    _addressLine2 = json['address_line_2'];
    _city = json['city'];
    _areaCode = json['area_code'];
    _salesTaxPercentage = getDoubleValue(json['sales_tax_percentage']);
    _salesReturnDaysLimit = json['sales_return_days_limit'];
    _receiptFooter = json['receipt_footer'];
    _disclaimer = json['disclaimer'];
  }

  int? _id;
  String? _name;
  String? _code;
  String? _email;
  String? _phone;
  String? _mobile;
  String? _addressLine1;
  String? _addressLine2;
  String? _city;
  String? _areaCode;
  double? _salesTaxPercentage;
  int? _salesReturnDaysLimit;
  String? _receiptFooter;
  String? _disclaimer;

  Stores copyWith({
    int? id,
    String? name,
    String? code,
    String? email,
    String? phone,
    String? mobile,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? areaCode,
    double? salesTaxPercentage,
    int? salesReturnDaysLimit,
    String? receiptFooter,
    String? disclaimer,
  }) =>
      Stores(
        id: id ?? _id,
        name: name ?? _name,
        code: code ?? _code,
        email: email ?? _email,
        phone: phone ?? _phone,
        mobile: mobile ?? _mobile,
        addressLine1: addressLine1 ?? _addressLine1,
        addressLine2: addressLine2 ?? _addressLine2,
        city: city ?? _city,
        areaCode: areaCode ?? _areaCode,
        salesTaxPercentage: salesTaxPercentage ?? _salesTaxPercentage,
        salesReturnDaysLimit: salesReturnDaysLimit ?? _salesReturnDaysLimit,
        receiptFooter: receiptFooter ?? _receiptFooter,
        disclaimer: disclaimer ?? _disclaimer,
      );

  int? get id => _id;

  String? get name => _name;

  String? get code => _code;

  String? get email => _email;

  String? get phone => _phone;

  String? get mobile => _mobile;

  String? get addressLine1 => _addressLine1;

  String? get addressLine2 => _addressLine2;

  String? get city => _city;

  String? get areaCode => _areaCode;

  double? get salesTaxPercentage => _salesTaxPercentage;

  int? get salesReturnDaysLimit => _salesReturnDaysLimit;

  String? get receiptFooter => _receiptFooter;

  String? get disclaimer => _disclaimer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    map['email'] = _email;
    map['phone'] = _phone;
    map['mobile'] = _mobile;
    map['address_line_1'] = _addressLine1;
    map['address_line_2'] = _addressLine2;
    map['city'] = _city;
    map['area_code'] = _areaCode;
    map['sales_tax_percentage'] = _salesTaxPercentage;
    map['sales_return_days_limit'] = _salesReturnDaysLimit;
    map['receipt_footer'] = _receiptFooter;
    map['disclaimer'] = _disclaimer;
    return map;
  }
}
