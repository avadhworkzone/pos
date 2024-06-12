/// summary : {"date":"2023-07-24","items_sold":1,"items_returned":0}
/// sales : [{"id":34289,"receipt_id":"445561690180329009","unit_sold":"1.00","amount":"RM259","status":"SALE"}]
/// total_records : 1
/// last_page : 1
/// current_page : 1
/// per_page : 10

class GetPromoterSalesReturnsListResponse {
  GetPromoterSalesReturnsListResponse({
      this.summary, 
      this.sales, 
      this.totalRecords, 
      this.lastPage, 
      this.currentPage, 
      this.perPage,});

  GetPromoterSalesReturnsListResponse.fromJson(dynamic json) {
    summary = json['summary'] != null ? Summary.fromJson(json['summary']) : null;
    if (json['sales'] != null) {
      sales = [];
      json['sales'].forEach((v) {
        sales?.add(Sales.fromJson(v));
      });
    }
    totalRecords = json['total_records'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }
  Summary? summary;
  List<Sales>? sales;
  int? totalRecords;
  int? lastPage;
  int? currentPage;
  int? perPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (summary != null) {
      map['summary'] = summary?.toJson();
    }
    if (sales != null) {
      map['sales'] = sales?.map((v) => v.toJson()).toList();
    }
    map['total_records'] = totalRecords;
    map['last_page'] = lastPage;
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    return map;
  }

}

/// id : 34289
/// receipt_id : "445561690180329009"
/// unit_sold : "1.00"
/// amount : "RM259"
/// status : "SALE"

class Sales {
  Sales({
      this.id, 
      this.receiptId, 
      this.unitSold, 
      this.amount, 
      this.status,});

  Sales.fromJson(dynamic json) {
    id = json['id'];
    receiptId = json['receipt_id'];
    unitSold = json['unit_sold'];
    amount = json['amount'];
    status = json['status'];
  }
  int? id;
  String? receiptId;
  String? unitSold;
  String? amount;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['receipt_id'] = receiptId;
    map['unit_sold'] = unitSold;
    map['amount'] = amount;
    map['status'] = status;
    return map;
  }

}

/// date : "2023-07-24"
/// items_sold : 1
/// items_returned : 0

class Summary {
  Summary({
      this.date, 
      this.itemsSold, 
      this.itemsReturned,});

  Summary.fromJson(dynamic json) {
    date = json['date'];
    itemsSold = json['items_sold'];
    itemsReturned = json['items_returned'];
  }
  String? date;
  int? itemsSold;
  int? itemsReturned;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = date;
    map['items_sold'] = itemsSold;
    map['items_returned'] = itemsReturned;
    return map;
  }

}