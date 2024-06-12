///store_id:10

class GetPromoterHomeRequest {
  GetPromoterHomeRequest({
    String? storeId,
  }) {
    _storeId = storeId;
  }

  GetPromoterHomeRequest.fromJson(dynamic json) {
    _storeId = json['store_id'];
  }

  String? _storeId;

  String? get storeId => _storeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['store_id'] = _storeId;
    return map;
  }
}
