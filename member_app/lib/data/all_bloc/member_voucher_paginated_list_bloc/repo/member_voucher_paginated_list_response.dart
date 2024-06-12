/// vouchers : [{"id":11408,"discount_type":"FLAT","number":"216779749742392054364286","minimum_spend_amount":"200.00","percentage":"","flat_amount":"10.00","used_at":"","expiry_date":"2023-04-04"}]
/// total_records : 1
/// last_page : 1
/// current_page : 1
/// per_page : 10

class MemberVoucherPaginatedListResponse {
  MemberVoucherPaginatedListResponse({
    this.vouchers,
    this.totalRecords,
    this.lastPage,
    this.currentPage,
    this.perPage,});

  MemberVoucherPaginatedListResponse.fromJson(dynamic json) {
    if (json['vouchers'] != null) {
      vouchers = [];
      json['vouchers'].forEach((v) {
        vouchers?.add(Vouchers.fromJson(v));
      });
    }
    totalRecords = json['total_records'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }
  List<Vouchers>? vouchers;
  int? totalRecords;
  int? lastPage;
  int? currentPage;
  int? perPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (vouchers != null) {
      map['vouchers'] = vouchers?.map((v) => v.toJson()).toList();
    }
    map['total_records'] = totalRecords;
    map['last_page'] = lastPage;
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    return map;
  }

}

/// id : 11408
/// discount_type : "FLAT"
/// number : "216779749742392054364286"
/// minimum_spend_amount : "200.00"
/// percentage : ""
/// flat_amount : "10.00"
/// used_at : ""
/// expiry_date : "2023-04-04"

class Vouchers {
  Vouchers({
    this.id,
    this.discountType,
    this.number,
    this.minimumSpendAmount,
    this.percentage,
    this.flatAmount,
    this.usedAt,
    this.expiryDate,});

  Vouchers.fromJson(dynamic json) {
    id = json['id'];
    discountType = json['discount_type'];
    number = json['number'];
    minimumSpendAmount = json['minimum_spend_amount'];
    percentage = json['percentage'];
    flatAmount = json['flat_amount'];
    usedAt = json['used_at'];
    expiryDate = json['expiry_date'];
  }
  int? id;
  String? discountType;
  String? number;
  String? minimumSpendAmount;
  String? percentage;
  String? flatAmount;
  String? usedAt;
  String? expiryDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['discount_type'] = discountType;
    map['number'] = number;
    map['minimum_spend_amount'] = minimumSpendAmount;
    map['percentage'] = percentage;
    map['flat_amount'] = flatAmount;
    map['used_at'] = usedAt;
    map['expiry_date'] = expiryDate;
    return map;
  }

}