/// data : [{"receipt_id":"1723261686813806662","sales_amount":100},{"receipt_id":"0723261686805589873","sales_amount":95}]
/// total_records : 2
/// last_page : 1
/// current_page : 1
/// per_page : 10

class GetStoreManagerSalesListResponse {
  GetStoreManagerSalesListResponse({
    this.data,
    this.totalRecords,
    this.lastPage,
    this.currentPage,
    this.perPage,});

  GetStoreManagerSalesListResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(SalesListData.fromJson(v));
      });
    }
    totalRecords = json['total_records'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }
  List<SalesListData>? data;
  int? totalRecords;
  int? lastPage;
  int? currentPage;
  int? perPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['total_records'] = totalRecords;
    map['last_page'] = lastPage;
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    return map;
  }

}

/// receipt_id : "1723261686813806662"
/// sales_amount : 100

class SalesListData {
  SalesListData({
    this.receiptId,
    this.salesAmount,});

  SalesListData.fromJson(dynamic json) {
    receiptId = json['receipt_id'].toString();
    salesAmount = json['sales_amount'].toString();
  }
  String? receiptId;
  String? salesAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['receipt_id'] = receiptId;
    map['sales_amount'] = salesAmount;
    return map;
  }

}