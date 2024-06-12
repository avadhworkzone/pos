import 'dart:convert';

/// total_records : 3
/// member_group : [{"id":3,"name":"Group 3","code":"group3"}]

MemberGroupResponse memberGroupResponseFromJson(String str) =>
    MemberGroupResponse.fromJson(json.decode(str));

String memberGroupResponseToJson(MemberGroupResponse data) =>
    json.encode(data.toJson());

class MemberGroupResponse {
  MemberGroupResponse({
    this.totalRecords,
    this.memberGroup,
  });

  MemberGroupResponse.fromJson(dynamic json) {
    totalRecords = json['total_records'];
    if (json['data'] != null) {
      memberGroup = [];
      json['data'].forEach((v) {
        memberGroup?.add(MemberGroup.fromJson(v));
      });
    }
  }

  int? totalRecords;
  List<MemberGroup>? memberGroup;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_records'] = totalRecords;
    if (memberGroup != null) {
      map['data'] = memberGroup?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 3
/// name : "Group 3"
/// code : "group3"

MemberGroup memberGroupFromJson(String str) =>
    MemberGroup.fromJson(json.decode(str));

String memberGroupToJson(MemberGroup data) => json.encode(data.toJson());

class MemberGroup {
  MemberGroup({
    this.id,
    this.name,
    this.code,
  });

  MemberGroup.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
  }

  int? id;
  String? name;
  String? code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    return map;
  }
}
