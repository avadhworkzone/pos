class GetWarehouseManagerHomeResponse {
  GetWarehouseManagerHomeResponse({
    this.skuManaged,
    this.noStock,
  });

  GetWarehouseManagerHomeResponse.fromJson(dynamic json) {
    skuManaged = json['sku_managed'].toString();
    noStock = json['no_stock'].toString();
  }
  String? skuManaged;
  String? noStock;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sku_managed'] = skuManaged;
    map['no_stock'] = noStock;
    return map;
  }
}
