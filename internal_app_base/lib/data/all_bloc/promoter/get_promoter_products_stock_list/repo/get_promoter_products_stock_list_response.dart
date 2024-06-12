/// store_stock : [{"store_id":36,"store_name":"ARIANI GALLERY SUNGAI PETANI","stock":"-1.00"},{"store_id":20,"store_name":"ARIANI READY TO WEAR SHAH ALAM","stock":"-7.00"},{"store_id":55,"store_name":"HOUSE OF ARIANI","stock":"-27.00"},{"store_id":16,"store_name":"ARIANI GALLERY IPOH","stock":"-281.00"},{"store_id":11,"store_name":"ARIANI GALLERY BANGI","stock":"-2185.00"},{"store_id":38,"store_name":"ARIANI GALLERY WANGSA WALK","stock":"-519.00"},{"store_id":9,"store_name":"ARIANI GALLERY BANDAR TUN HUSSEIN ONN (BTHO)","stock":"50.00"},{"store_id":37,"store_name":"ARIANI GALLERY TANAH MERAH","stock":"806.00"},{"store_id":17,"store_name":"ARIANI GALLERY JOHOR BAHRU","stock":"961.00"},{"store_id":6,"store_name":"ARIANI GALLERY ALOR SETAR","stock":"-71.00"}]
/// total_records : 21
/// last_page : 3
/// current_page : 1
/// per_page : 10

class GetPromoterProductsStockListResponse {
  GetPromoterProductsStockListResponse({
    this.storeStock,
    this.totalRecords,
    this.lastPage,
    this.currentPage,
    this.perPage,});

  GetPromoterProductsStockListResponse.fromJson(dynamic json) {
    if (json['store_stock'] != null) {
      storeStock = [];
      json['store_stock'].forEach((v) {
        storeStock?.add(StoreStock.fromJson(v));
      });
    }
    totalRecords = json['total_records'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }
  List<StoreStock>? storeStock;
  int? totalRecords;
  int? lastPage;
  int? currentPage;
  int? perPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (storeStock != null) {
      map['store_stock'] = storeStock?.map((v) => v.toJson()).toList();
    }
    map['total_records'] = totalRecords;
    map['last_page'] = lastPage;
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    return map;
  }

}

/// store_id : 36
/// store_name : "ARIANI GALLERY SUNGAI PETANI"
/// stock : "-1.00"

class StoreStock {
  StoreStock({
    this.storeId,
    this.storeName,
    this.stock,});

  StoreStock.fromJson(dynamic json) {
    storeId = json['store_id'];
    storeName = json['store_name'];
    stock = json['stock'];
  }
  int? storeId;
  String? storeName;
  String? stock;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['store_id'] = storeId;
    map['store_name'] = storeName;
    map['stock'] = stock;
    return map;
  }

}