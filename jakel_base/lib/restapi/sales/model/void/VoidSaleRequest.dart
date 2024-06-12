import 'dart:convert';
/// voided_by_store_manager_id : 1
/// passcode : ""
/// void_sale_reason_id : 1

VoidSaleRequest voidSaleRequestFromJson(String str) => VoidSaleRequest.fromJson(json.decode(str));
String voidSaleRequestToJson(VoidSaleRequest data) => json.encode(data.toJson());
class VoidSaleRequest {
  VoidSaleRequest({
      int? voidedByStoreManagerId, 
      String? passcode, 
      int? voidSaleReasonId,}){
    _voidedByStoreManagerId = voidedByStoreManagerId;
    _passcode = passcode;
    _voidSaleReasonId = voidSaleReasonId;
}

  VoidSaleRequest.fromJson(dynamic json) {
    _voidedByStoreManagerId = json['voided_by_store_manager_id'];
    _passcode = json['passcode'];
    _voidSaleReasonId = json['void_sale_reason_id'];
  }
  int? _voidedByStoreManagerId;
  String? _passcode;
  int? _voidSaleReasonId;
VoidSaleRequest copyWith({  int? voidedByStoreManagerId,
  String? passcode,
  int? voidSaleReasonId,
}) => VoidSaleRequest(  voidedByStoreManagerId: voidedByStoreManagerId ?? _voidedByStoreManagerId,
  passcode: passcode ?? _passcode,
  voidSaleReasonId: voidSaleReasonId ?? _voidSaleReasonId,
);
  int? get voidedByStoreManagerId => _voidedByStoreManagerId;
  String? get passcode => _passcode;
  int? get voidSaleReasonId => _voidSaleReasonId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['voided_by_store_manager_id'] = _voidedByStoreManagerId;
    map['passcode'] = _passcode;
    map['void_sale_reason_id'] = _voidSaleReasonId;
    return map;
  }

}