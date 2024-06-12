/// races : [{"id":1,"name":"Malay","key":"MALAY"},{"id":2,"name":"Chinese","key":"CHINESE"},{"id":3,"name":"Indian","key":"INDIAN"},{"id":8,"name":"Others","key":"OTHERS"}]

class GetRacesResponse {
  GetRacesResponse({
    this.races,});

  GetRacesResponse.fromJson(dynamic json) {
    if (json['races'] != null) {
      races = [];
      json['races'].forEach((v) {
        races?.add(Races.fromJson(v));
      });
    }
  }
  List<Races>? races;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (races != null) {
      map['races'] = races?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// name : "Malay"
/// key : "MALAY"

class Races {
  Races({
    this.id,
    this.name,
    this.key,});

  Races.fromJson(dynamic json) {
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