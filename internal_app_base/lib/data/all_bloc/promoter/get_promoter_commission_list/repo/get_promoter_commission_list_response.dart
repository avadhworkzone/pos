/// commission_history : [{"date":"2023-05-04","item_sold":40,"item_returned":0,"commission":84.79},{"date":"2023-05-03","item_sold":51,"item_returned":0,"commission":37.92},{"date":"2023-05-02","item_sold":6,"item_returned":0,"commission":5.39},{"date":"2023-05-01","item_sold":14,"item_returned":0,"commission":16.99}]
/// total_records : 4
/// last_page : 1
/// current_page : 1
/// per_page : 10

class GetPromoterCommissionListResponse {
  GetPromoterCommissionListResponse({
    this.commissionHistory,
    this.totalRecords,
    this.lastPage,
    this.currentPage,
    this.perPage,
  });

  GetPromoterCommissionListResponse.fromJson(dynamic json) {
    if (json['commission_history'] != null) {
      commissionHistory = [];
      json['commission_history'].forEach((v) {
        commissionHistory?.add(CommissionHistory.fromJson(v));
      });
    }
    totalRecords = json['total_records'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }
  List<CommissionHistory>? commissionHistory;
  int? totalRecords;
  int? lastPage;
  int? currentPage;
  int? perPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (commissionHistory != null) {
      map['commission_history'] =
          commissionHistory?.map((v) => v.toJson()).toList();
    }
    map['total_records'] = totalRecords;
    map['last_page'] = lastPage;
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    return map;
  }
}

/// date : "2023-05-04"
/// item_sold : 40
/// item_returned : 0
/// commission : 84.79

class CommissionHistory {
  CommissionHistory({
    this.date,
    this.itemSold,
    this.itemReturned,
    this.commission,
  });

  CommissionHistory.fromJson(dynamic json) {
    date = json['date'];
    itemSold = json['item_sold'];
    itemReturned = json['item_returned'];
    commission = json['commission'];
  }
  String? date;
  int? itemSold;
  int? itemReturned;
  double? commission;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = date;
    map['item_sold'] = itemSold;
    map['item_returned'] = itemReturned;
    map['commission'] = commission;
    return map;
  }
}
