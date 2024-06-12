import 'dart:convert';

/// titles : [{"id":1,"name":"Datin","key":"DATIN"},{"id":2,"name":"Datin Seri","key":"DATIN_SERI"},{"id":3,"name":"Dato Sri","key":"DATO_SRI"},{"id":4,"name":"Datuk","key":"DATUK"},{"id":5,"name":"Dr","key":"DR"},{"id":6,"name":"Dato","key":"DATO"},{"id":7,"name":"Madam","key":"MADAM"},{"id":8,"name":"Mr","key":"MR"},{"id":9,"name":"Mrs","key":"MRS"},{"id":10,"name":"Ms","key":"MS"},{"id":11,"name":"Puan","key":"PUAN"},{"id":12,"name":"Tan Sri","key":"TAN_SRI"},{"id":13,"name":"Puan Sri","key":"PUAN_SRI"}]

CustomerTitlesResponse customerTitlesResponseFromJson(String str) =>
    CustomerTitlesResponse.fromJson(json.decode(str));

String customerTitlesResponseToJson(CustomerTitlesResponse data) =>
    json.encode(data.toJson());

class CustomerTitlesResponse {
  CustomerTitlesResponse({
    List<CustomerTitles>? titles,
  }) {
    _titles = titles;
  }

  CustomerTitlesResponse.fromJson(dynamic json) {
    if (json['titles'] != null) {
      _titles = [];
      json['titles'].forEach((v) {
        _titles?.add(CustomerTitles.fromJson(v));
      });
    }
  }

  List<CustomerTitles>? _titles;

  CustomerTitlesResponse copyWith({
    List<CustomerTitles>? titles,
  }) =>
      CustomerTitlesResponse(
        titles: titles ?? _titles,
      );

  List<CustomerTitles>? get titles => _titles;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_titles != null) {
      map['titles'] = _titles?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// name : "Datin"
/// key : "DATIN"

CustomerTitles titlesFromJson(String str) => CustomerTitles.fromJson(json.decode(str));

String titlesToJson(CustomerTitles data) => json.encode(data.toJson());

class CustomerTitles {
  CustomerTitles({
    int? id,
    String? name,
    String? key,
  }) {
    _id = id;
    _name = name;
    _key = key;
  }

  CustomerTitles.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _key = json['key'];
  }

  int? _id;
  String? _name;
  String? _key;

  CustomerTitles copyWith({
    int? id,
    String? name,
    String? key,
  }) =>
      CustomerTitles(
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
