import 'dart:convert';
/// genders : [{"id":1,"name":"Male","key":"MALE"},{"id":2,"name":"Female","key":"FEMALE"}]

GenderResponse genderResponseFromJson(String str) => GenderResponse.fromJson(json.decode(str));
String genderResponseToJson(GenderResponse data) => json.encode(data.toJson());
class GenderResponse {
  GenderResponse({
      List<Genders>? genders,}){
    _genders = genders;
}

  GenderResponse.fromJson(dynamic json) {
    if (json['genders'] != null) {
      _genders = [];
      json['genders'].forEach((v) {
        _genders?.add(Genders.fromJson(v));
      });
    }
  }
  List<Genders>? _genders;
GenderResponse copyWith({  List<Genders>? genders,
}) => GenderResponse(  genders: genders ?? _genders,
);
  List<Genders>? get genders => _genders;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_genders != null) {
      map['genders'] = _genders?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// name : "Male"
/// key : "MALE"

Genders gendersFromJson(String str) => Genders.fromJson(json.decode(str));
String gendersToJson(Genders data) => json.encode(data.toJson());
class Genders {
  Genders({
      int? id, 
      String? name, 
      String? key,}){
    _id = id;
    _name = name;
    _key = key;
}

  Genders.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _key = json['key'];
  }
  int? _id;
  String? _name;
  String? _key;
Genders copyWith({  int? id,
  String? name,
  String? key,
}) => Genders(  id: id ?? _id,
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