import 'dart:convert';

/// races : [{"id":1,"name":"Malay","key":"MALAY"},{"id":2,"name":"Chinese","key":"CHINESE"},{"id":3,"name":"Indian","key":"INDIAN"},{"id":8,"name":"Others","key":"OTHERS"}]

CustomerRaceResponse customerRaceResponseFromJson(String str) =>
    CustomerRaceResponse.fromJson(json.decode(str));

String customerRaceResponseToJson(CustomerRaceResponse data) =>
    json.encode(data.toJson());

class CustomerRaceResponse {
  CustomerRaceResponse({
    List<CustomerRaces>? races,
  }) {
    _races = races;
  }

  CustomerRaceResponse.fromJson(dynamic json) {
    if (json['races'] != null) {
      _races = [];
      json['races'].forEach((v) {
        _races?.add(CustomerRaces.fromJson(v));
      });
    }
  }

  List<CustomerRaces>? _races;

  CustomerRaceResponse copyWith({
    List<CustomerRaces>? races,
  }) =>
      CustomerRaceResponse(
        races: races ?? _races,
      );

  List<CustomerRaces>? get races => _races;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_races != null) {
      map['races'] = _races?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// name : "Malay"
/// key : "MALAY"

CustomerRaces racesFromJson(String str) => CustomerRaces.fromJson(json.decode(str));

String racesToJson(CustomerRaces data) => json.encode(data.toJson());

class CustomerRaces {
  CustomerRaces({
    int? id,
    String? name,
    String? key,
  }) {
    _id = id;
    _name = name;
    _key = key;
  }

  CustomerRaces.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _key = json['key'];
  }

  int? _id;
  String? _name;
  String? _key;

  CustomerRaces copyWith({
    int? id,
    String? name,
    String? key,
  }) =>
      CustomerRaces(
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
