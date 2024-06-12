/// titles : [{"id":1,"name":"Datin","key":"DATIN"},{"id":2,"name":"Datin Seri","key":"DATIN_SERI"},{"id":3,"name":"Dato Sri","key":"DATO_SRI"},{"id":4,"name":"Datuk","key":"DATUK"},{"id":5,"name":"Dr","key":"DR"},{"id":6,"name":"Dato","key":"DATO"},{"id":7,"name":"Madam","key":"MADAM"},{"id":8,"name":"Mr","key":"MR"},{"id":9,"name":"Mrs","key":"MRS"},{"id":10,"name":"Ms","key":"MS"},{"id":11,"name":"Puan","key":"PUAN"},{"id":12,"name":"Tan Sri","key":"TAN_SRI"},{"id":13,"name":"Puan Sri","key":"PUAN_SRI"}]

class GetTitlesResponse {
  GetTitlesResponse({
    this.titles,});

  GetTitlesResponse.fromJson(dynamic json) {
    if (json['titles'] != null) {
      titles = [];
      json['titles'].forEach((v) {
        titles?.add(Titles.fromJson(v));
      });
    }
  }
  List<Titles>? titles;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (titles != null) {
      map['titles'] = titles?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// name : "Datin"
/// key : "DATIN"

class Titles {
  Titles({
    this.id,
    this.name,
    this.key,});

  Titles.fromJson(dynamic json) {
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