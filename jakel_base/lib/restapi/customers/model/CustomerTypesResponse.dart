import 'dart:convert';

/// types : [{"id":1,"name":"Vip","key":"VIP"},{"id":2,"name":"Regular","key":"REGULAR"},{"id":3,"name":"Corporate","key":"CORPORATE"},{"id":4,"name":"Online Store","key":"ONLINE_STORE"}]

CustomerTypesResponse customerTypesResponseFromJson(String str) =>
    CustomerTypesResponse.fromJson(json.decode(str));

String customerTypesResponseToJson(CustomerTypesResponse data) =>
    json.encode(data.toJson());

class CustomerTypesResponse {
  CustomerTypesResponse({
    List<CustomerTypes>? types,
  }) {
    _types = types;
  }

  CustomerTypesResponse.fromJson(dynamic json) {
    if (json['types'] != null) {
      _types = [];
      json['types'].forEach((v) {
        _types?.add(CustomerTypes.fromJson(v));
      });
    }
  }

  List<CustomerTypes>? _types;

  CustomerTypesResponse copyWith({
    List<CustomerTypes>? types,
  }) =>
      CustomerTypesResponse(
        types: types ?? _types,
      );

  List<CustomerTypes>? get types => _types;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_types != null) {
      map['types'] = _types?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// name : "Vip"
/// key : "VIP"

CustomerTypes typesFromJson(String str) =>
    CustomerTypes.fromJson(json.decode(str));

String typesToJson(CustomerTypes data) => json.encode(data.toJson());

class CustomerTypes {
  CustomerTypes({
    int? id,
    String? name,
    String? key,
  }) {
    _id = id;
    _name = name;
    _key = key;
  }

  CustomerTypes.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _key = json['key'];
  }

  int? _id;
  String? _name;
  String? _key;

  CustomerTypes copyWith({
    int? id,
    String? name,
    String? key,
  }) =>
      CustomerTypes(
        id: id ?? _id,
        name: name ?? _name,
        key: key ?? _key,
      );

  int? get id => _id;

  String? get name => _name;

  String? get key => _key;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['key'] = _key;
    return map;
  }
}
