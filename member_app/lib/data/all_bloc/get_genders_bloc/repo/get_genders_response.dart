/// genders : [{"id":1,"name":"Male","key":"MALE"},{"id":2,"name":"Female","key":"FEMALE"}]

class GetGendersResponse {
  GetGendersResponse({
    this.genders,});

  GetGendersResponse.fromJson(dynamic json) {
    if (json['genders'] != null) {
      genders = [];
      json['genders'].forEach((v) {
        genders?.add(Genders.fromJson(v));
      });
    }
  }
  List<Genders>? genders;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (genders != null) {
      map['genders'] = genders?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// name : "Male"
/// key : "MALE"

class Genders {
  Genders({
    this.id,
    this.name,
    this.key,});

  Genders.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    key = json['key'];
  }
  int? id;
  String? name;
  String? key;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['key'] = key;
    return map;
  }

}