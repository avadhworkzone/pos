import 'dart:convert';

/// types : [{"id":1,"name":"Regular Sale","key":"REGULAR_SALE"},{"id":2,"name":"Layaway Sale","key":"LAYAWAY_SALE"},{"id":3,"name":"Booking Payment","key":"BOOKING_PAYMENT"}]

HoldSaleTypesResponse holdSaleTypesResponseFromJson(String str) =>
    HoldSaleTypesResponse.fromJson(json.decode(str));

String holdSaleTypesResponseToJson(HoldSaleTypesResponse data) =>
    json.encode(data.toJson());


class HoldSaleTypesResponse {
  HoldSaleTypesResponse({
    List<Types>? types,
  }) {
    _types = types;
  }

  HoldSaleTypesResponse.fromJson(dynamic json) {
    if (json['types'] != null) {
      _types = [];
      json['types'].forEach((v) {
        _types?.add(Types.fromJson(v));
      });
    }
  }

  List<Types>? _types;

  HoldSaleTypesResponse copyWith({
    List<Types>? types,
  }) =>
      HoldSaleTypesResponse(
        types: types ?? _types,
      );

  List<Types>? get types => _types;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_types != null) {
      map['types'] =
          _types?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}


/// id : 1
/// name : "Regular Sale"
/// key : "REGULAR_SALE"

Types typesFromJson(String str) => Types.fromJson(json.decode(str));

String typesToJson(Types data) => json.encode(data.toJson());

class Types {
  Types({
    int? id,
    String? name,
    String? key,
  }) {
    _id = id;
    _name = name;
    _key = key;
  }

  Types.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _key = json['key'];
  }

  int? _id;
  String? _name;
  String? _key;

  Types copyWith({
    int? id,
    String? name,
    String? key,
  }) =>
      Types(
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
