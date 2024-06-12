///warehouse_Id:10

class GetWarehouseManagerHomeRequest {
  GetWarehouseManagerHomeRequest({
    String? warehouseId,
  }) {
    _warehouseId = warehouseId;
  }

  GetWarehouseManagerHomeRequest.fromJson(dynamic json) {
    _warehouseId = json['warehouse_id'];
  }

  String? _warehouseId;

  String? get warehouseId => _warehouseId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['warehouse_id'] = _warehouseId;
    return map;
  }
}
