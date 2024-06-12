import 'package:internal_base/data/utils/utils.dart';

/// today : {"net_sales":0,"total_receipts":0}
/// this_month : {"net_sales":0,"total_receipts":0}

class GetStoreManagerHomeResponse {
  GetStoreManagerHomeResponse({
    this.today,
    this.thisMonth,});

  GetStoreManagerHomeResponse.fromJson(dynamic json) {
    today = json['today'] != null ? Today.fromJson(json['today']) : null;
    thisMonth = json['this_month'] != null ? ThisMonth.fromJson(json['this_month']) : null;
  }
  Today? today;
  ThisMonth? thisMonth;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (today != null) {
      map['today'] = today?.toJson();
    }
    if (thisMonth != null) {
      map['this_month'] = thisMonth?.toJson();
    }
    return map;
  }

}

/// net_sales : 0
/// total_receipts : 0

class ThisMonth {
  ThisMonth({
    this.netSales,
    this.totalReceipts,});

  ThisMonth.fromJson(dynamic json) {
    netSales = getRoundedValueForCalculations(json['net_sales']);
    totalReceipts = json['total_receipts'];
  }
  double? netSales;
  int? totalReceipts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['net_sales'] = netSales;
    map['total_receipts'] = totalReceipts;
    return map;
  }

}

/// net_sales : 0
/// total_receipts : 0

class Today {
  Today({
    this.netSales,
    this.totalReceipts,});

  Today.fromJson(dynamic json) {
    netSales = getRoundedValueForCalculations(json['net_sales']);
    totalReceipts = json['total_receipts'];
  }
  double? netSales;
  int? totalReceipts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['net_sales'] = netSales;
    map['total_receipts'] = totalReceipts;
    return map;
  }

}