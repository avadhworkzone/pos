import 'dart:convert';

/// promoters : [{"id":1,"first_name":"Zikri","last_name":"Wong","email":"zikri@abc.com"}]

PromotersResponse promotersResponseFromJson(String str) =>
    PromotersResponse.fromJson(json.decode(str));

String promotersResponseToJson(PromotersResponse data) =>
    json.encode(data.toJson());

class PromotersResponse {
  PromotersResponse({
    List<Promoters>? promoters,
  }) {
    _promoters = promoters;
  }

  PromotersResponse.fromJson(dynamic json) {
    if (json['promoters'] != null) {
      _promoters = [];
      json['promoters'].forEach((v) {
        _promoters?.add(Promoters.fromJson(v));
      });
    }
  }

  List<Promoters>? _promoters;

  PromotersResponse copyWith({
    List<Promoters>? promoters,
  }) =>
      PromotersResponse(
        promoters: promoters ?? _promoters,
      );

  List<Promoters>? get promoters => _promoters;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_promoters != null) {
      map['promoters'] = _promoters?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// first_name : "Zikri"
/// last_name : "Wong"
/// email : "zikri@abc.com"
/// staff_id : "11"

Promoters promotersFromJson(String str) => Promoters.fromJson(json.decode(str));

String promotersToJson(Promoters data) => json.encode(data.toJson());

class Promoters {
  Promoters(
      {int? id,
      String? firstName,
      String? lastName,
      String? email,
      String? staffId}) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _staffId = staffId;
  }

  Promoters.fromJson(dynamic json) {
    _id = json['id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _staffId = json['staff_id'];
  }

  int? _id;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _staffId;

  Promoters copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? staffId,
  }) =>
      Promoters(
          id: id ?? _id,
          firstName: firstName ?? _firstName,
          lastName: lastName ?? _lastName,
          email: email ?? _email,
          staffId: staffId ?? _staffId);

  int? get id => _id;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get email => _email;

  String? get staffId => _staffId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['email'] = _email;
    map['staff_id'] = _staffId;
    return map;
  }
}
