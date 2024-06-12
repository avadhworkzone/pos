import 'dart:convert';
/// id : 1
/// name : "Sale"
/// key : "SALE"

CashierPermissionResponse cashierPermissionResponseFromJson(String str) => CashierPermissionResponse.fromJson(json.decode(str));
String cashierPermissionResponseToJson(CashierPermissionResponse data) => json.encode(data.toJson());
class CashierPermissionResponse {
  CashierPermissionResponse({
      int? id, 
      String? name, 
      String? key,}){
    _id = id;
    _name = name;
    _key = key;
}

  CashierPermissionResponse.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _key = json['key'];
  }
  int? _id;
  String? _name;
  String? _key;
CashierPermissionResponse copyWith({  int? id,
  String? name,
  String? key,
}) => CashierPermissionResponse(  id: id ?? _id,
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