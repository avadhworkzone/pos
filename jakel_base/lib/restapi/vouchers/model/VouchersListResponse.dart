import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// vouchers : [{"id":1,"customer_id":3,"discount_type":"Percentage","number":"1XMPC1664085237","minimum_spend_amount":150.00,"percentage":3.00,"flat_amount":1.00,"expiry_date":"2022-10-25"}]
/// total_records : 9
/// last_page : 1
/// current_page : 1
/// per_page : 100

VouchersListResponse vouchersListResponseFromJson(String str) =>
    VouchersListResponse.fromJson(json.decode(str));

String vouchersListResponseToJson(VouchersListResponse data) =>
    json.encode(data.toJson());

class VouchersListResponse {
  VouchersListResponse({
    this.vouchers,
    this.totalRecords,
    this.lastPage,
    this.currentPage,
    this.perPage,
  });

  VouchersListResponse.fromJson(dynamic json) {
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

  VouchersListResponse copyWith({
    List<Vouchers>? vouchers,
    int? totalRecords,
    int? lastPage,
    int? currentPage,
    int? perPage,
  }) =>
      VouchersListResponse(
        vouchers: vouchers ?? this.vouchers,
        totalRecords: totalRecords ?? this.totalRecords,
        lastPage: lastPage ?? this.lastPage,
        currentPage: currentPage ?? this.currentPage,
        perPage: perPage ?? this.perPage,
      );

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

/// id : 1
/// customer_id : 3
/// discount_type : "Percentage"
/// number : "1XMPC1664085237"
/// minimum_spend_amount : 150.00
/// percentage : 3.00
/// flat_amount : 1.00
/// expiry_date : "2022-10-25"

Vouchers vouchersFromJson(String str) => Vouchers.fromJson(json.decode(str));

String vouchersToJson(Vouchers data) => json.encode(data.toJson());

class Vouchers {
  Vouchers({
    this.id,
    this.customerId,
    this.discountType,
    this.number,
    this.minimumSpendAmount,
    this.voucherType,
    this.percentage,
    this.flatAmount,
    this.expiryDate,
    this.mismatches,
    this.dreamPriceApplicable,
    this.itemWisePromotionApplicable,
    this.cartWidePromotionApplicable,
  });

  Vouchers.fromJson(dynamic json) {
    id = json['id'];
    customerId = json['member_id'];
    discountType = json['discount_type'];
    number = json['number'];
    voucherType = json['voucher_type'];
    minimumSpendAmount = getDoubleValue(json['minimum_spend_amount']);
    percentage = getDoubleValue(json['percentage']);
    flatAmount = getDoubleValue(json['flat_amount']);
    expiryDate = json['expiry_date'];
    mismatches =
        json['mismatches'] != null ? json['mismatches'].cast<String>() : [];
    dreamPriceApplicable = json['dream_price_applicable'];
    itemWisePromotionApplicable = json['item_wise_promotion_applicable'];
    cartWidePromotionApplicable = json['cart_wide_promotion_applicable'];
  }

  int? id;
  int? customerId;
  String? discountType;
  String? number;
  String? voucherType;
  double? minimumSpendAmount;
  double? percentage;
  double? flatAmount;
  String? expiryDate;
  List<String>? mismatches;
  bool? dreamPriceApplicable;
  bool? itemWisePromotionApplicable;
  bool? cartWidePromotionApplicable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['member_id'] = customerId;
    map['discount_type'] = discountType;
    map['voucher_type'] = voucherType;
    map['number'] = number;
    map['minimum_spend_amount'] = minimumSpendAmount;
    map['percentage'] = percentage;
    map['flat_amount'] = flatAmount;
    map['expiry_date'] = expiryDate;
    map['mismatches'] = mismatches;
    map['dream_price_applicable'] = dreamPriceApplicable;
    map['item_wise_promotion_applicable'] = itemWisePromotionApplicable;
    map['cart_wide_promotion_applicable'] = cartWidePromotionApplicable;
    return map;
  }
}
