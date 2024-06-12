import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// closed_counter : [{"id":678,"counter":{"id":72,"name":"ARAPWT01","store_id":32},"cashier_id":113,"opening_balance":12.50,"closing_balance":13285.50,"mismatch_amount":-587.2,"reason":"asddg","opening_date_time":"2023-03-05 14:00:50","opened_at":"2023-03-05 14:00:50","closed_at":"03-03-2023 07:26:35 PM","total_sales":50,"total_sales_amount":20643.55,"total_layaway_sales":4,"total_layaway_sales_amount":2254.9,"total_voided_sales":9,"total_voided_sales_amount":2059.1,"total_item_wise_discount_amount":242.62,"total_cart_wide_discount_amount":25.41,"total_tax_amount":0,"total_sales_round_off":-0.02,"total_sale_returns":8,"total_sale_returns_amount":0,"total_credit_notes_used_amount":795.6,"total_credit_notes_refunded_amount":0.40,"total_sale_returns_round_off":0.40,"total_cashback_amount":0.40,"total_vouchers_used":1,"total_voucher_discount_amount":10.40,"total_vouchers_generated":9,"total_sale_promotion_used":0,"total_sale_promotion_discount_amount":0.50,"total_sale_item_promotion_used":4,"total_sale_item_promotion_discount_amount":18.11,"total_dream_price_used":0,"total_dream_price_discount_amount":0.50,"total_complimentary_item_discount_used":0.50,"total_complimentary_item_discount_amount":0.50,"total_price_override_used":12,"total_price_override_discount_amount":224.51,"total_booking_payment_amount":1100.50,"total_booking_payment_refunded_amount":0.50,"total_booking_payment_used_amount":1000.50,"total_cash_ins_amount":0.50,"total_cash_outs_amount":0.50,"sale_payments":[{"payment_type_id":1,"payment_type":"Cash","total":13860.2}]}]
/// total_records : 28
/// last_page : 28
/// current_page : 1
/// per_page : 1

ClosedCountersHistoryResponse closedCountersHistoryResponseFromJson(
        String str) =>
    ClosedCountersHistoryResponse.fromJson(json.decode(str));

String closedCountersHistoryResponseToJson(
        ClosedCountersHistoryResponse data) =>
    json.encode(data.toJson());

class ClosedCountersHistoryResponse {
  ClosedCountersHistoryResponse({
    this.closedCounter,
    this.totalRecords,
    this.lastPage,
    this.currentPage,
    this.perPage,
  });

  ClosedCountersHistoryResponse.fromJson(dynamic json) {
    if (json['closed_counter'] != null) {
      closedCounter = [];
      json['closed_counter'].forEach((v) {
        closedCounter?.add(ClosedCounter.fromJson(v));
      });
    }
    totalRecords = json['total_records'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }

  List<ClosedCounter>? closedCounter;
  int? totalRecords;
  int? lastPage;
  int? currentPage;
  int? perPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (closedCounter != null) {
      map['closed_counter'] = closedCounter?.map((v) => v.toJson()).toList();
    }
    map['total_records'] = totalRecords;
    map['last_page'] = lastPage;
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    return map;
  }
}

/// id : 678
/// counter : {"id":72,"name":"ARAPWT01","store_id":32}
/// cashier_id : 113
/// opening_balance : 12.50
/// closing_balance : 13285.50
/// mismatch_amount : -587.2
/// reason : "asddg"
/// opening_date_time : "2023-03-05 14:00:50"
/// opened_at : "2023-03-05 14:00:50"
/// closed_at : "03-03-2023 07:26:35 PM"
/// total_sales : 50
/// total_sales_amount : 20643.55
/// total_layaway_sales : 4
/// total_layaway_sales_amount : 2254.9
/// total_voided_sales : 9
/// total_voided_sales_amount : 2059.1
/// total_item_wise_discount_amount : 242.62
/// total_cart_wide_discount_amount : 25.41
/// total_tax_amount : 0
/// total_sales_round_off : -0.02
/// total_sale_returns : 8
/// total_sale_returns_amount : 0
/// total_credit_notes_used_amount : 795.6
/// total_credit_notes_refunded_amount : 0.40
/// total_sale_returns_round_off : 0.40
/// total_cashback_amount : 0.40
/// total_vouchers_used : 1
/// total_voucher_discount_amount : 10.40
/// total_vouchers_generated : 9
/// total_sale_promotion_used : 0
/// total_sale_promotion_discount_amount : 0.50
/// total_sale_item_promotion_used : 4
/// total_sale_item_promotion_discount_amount : 18.11
/// total_dream_price_used : 0
/// total_dream_price_discount_amount : 0.50
/// total_complimentary_item_discount_used : 0.50
/// total_complimentary_item_discount_amount : 0.50
/// total_price_override_used : 12
/// total_price_override_discount_amount : 224.51
/// total_booking_payment_amount : 1100.50
/// total_booking_payment_refunded_amount : 0.50
/// total_booking_payment_used_amount : 1000.50
/// total_cash_ins_amount : 0.50
/// total_cash_outs_amount : 0.50
/// sale_payments : [{"payment_type_id":1,"payment_type":"Cash","total":13860.2}]

ClosedCounter closedCounterFromJson(String str) =>
    ClosedCounter.fromJson(json.decode(str));

String closedCounterToJson(ClosedCounter data) => json.encode(data.toJson());

class ClosedCounter {
  ClosedCounter({
    this.id,
    this.counter,
    this.cashierId,
    this.openingBalance,
    this.closingBalance,
    this.mismatchAmount,
    this.reason,
    this.openingDateTime,
    this.openedAt,
    this.closedAt,
    this.totalSales,
    this.totalSalesAmount,
    this.totalLayawaySales,
    this.totalLayawaySalesAmount,
    this.totalVoidedSales,
    this.totalVoidedSalesAmount,
    this.totalItemWiseDiscountAmount,
    this.totalCartWideDiscountAmount,
    this.totalTaxAmount,
    this.totalSalesRoundOff,
    this.totalSaleReturns,
    this.totalSaleReturnsAmount,
    this.totalCreditNotesUsedAmount,
    this.totalCreditNotesRefundedAmount,
    this.totalSaleReturnsRoundOff,
    this.totalCashbackAmount,
    this.totalVouchersUsed,
    this.totalVoucherDiscountAmount,
    this.totalVouchersGenerated,
    this.totalSalePromotionUsed,
    this.totalSalePromotionDiscountAmount,
    this.totalSaleItemPromotionUsed,
    this.totalSaleItemPromotionDiscountAmount,
    this.totalDreamPriceUsed,
    this.totalDreamPriceDiscountAmount,
    this.totalComplimentaryItemDiscountUsed,
    this.totalComplimentaryItemDiscountAmount,
    this.totalPriceOverrideUsed,
    this.totalPriceOverrideDiscountAmount,
    this.totalBookingPaymentAmount,
    this.totalBookingPaymentRefundedAmount,
    this.totalBookingPaymentUsedAmount,
    this.totalCashInsAmount,
    this.totalCashOutsAmount,
    this.salePayments,
  });

  ClosedCounter.fromJson(dynamic json) {
    id = json['id'];
    counter =
        json['counter'] != null ? Counter.fromJson(json['counter']) : null;
    cashierId = json['cashier_id'];
    openingBalance = getDoubleValue(json['opening_balance']);
    closingBalance = getDoubleValue(json['closing_balance']);
    mismatchAmount = getDoubleValue(json['mismatch_amount']);
    reason = json['reason'];
    openingDateTime = json['opening_date_time'];
    openedAt = json['opened_at'];
    closedAt = json['closed_at'];
    totalSales = json['total_sales'];
    totalSalesAmount = getDoubleValue(json['total_sales_amount']);
    totalLayawaySales = json['total_layaway_sales'];
    totalLayawaySalesAmount =
        getDoubleValue(json['total_layaway_sales_amount']);
    totalVoidedSales = json['total_voided_sales'];
    totalVoidedSalesAmount = getDoubleValue(json['total_voided_sales_amount']);
    totalItemWiseDiscountAmount =
        getDoubleValue(json['total_item_wise_discount_amount']);
    totalCartWideDiscountAmount =
        getDoubleValue(json['total_cart_wide_discount_amount']);
    totalTaxAmount = getDoubleValue(json['total_tax_amount']);
    totalSalesRoundOff = getDoubleValue(json['total_sales_round_off']);
    totalSaleReturns = json['total_sale_returns'];
    totalSaleReturnsAmount = getDoubleValue(json['total_sale_returns_amount']);
    totalCreditNotesUsedAmount =
        getDoubleValue(json['total_credit_notes_used_amount']);
    totalCreditNotesRefundedAmount =
        getDoubleValue(json['total_credit_notes_refunded_amount']);
    totalSaleReturnsRoundOff =
        getDoubleValue(json['total_sale_returns_round_off']);
    totalCashbackAmount = getDoubleValue(json['total_cashback_amount']);
    totalVouchersUsed = json['total_vouchers_used'];
    totalVoucherDiscountAmount =
        getDoubleValue(json['total_voucher_discount_amount']);
    totalVouchersGenerated = json['total_vouchers_generated'];
    totalSalePromotionUsed = json['total_sale_promotion_used'];
    totalSalePromotionDiscountAmount =
        getDoubleValue(json['total_sale_promotion_discount_amount']);
    totalSaleItemPromotionUsed = json['total_sale_item_promotion_used'];
    totalSaleItemPromotionDiscountAmount =
        getDoubleValue(json['total_sale_item_promotion_discount_amount']);
    totalDreamPriceUsed = getDoubleValue(json['total_dream_price_used']);
    totalDreamPriceDiscountAmount =
        getDoubleValue(json['total_dream_price_discount_amount']);
    totalComplimentaryItemDiscountUsed =
        getDoubleValue(json['total_complimentary_item_discount_used']);
    totalComplimentaryItemDiscountAmount =
        getDoubleValue(json['total_complimentary_item_discount_amount']);
    totalPriceOverrideUsed = getDoubleValue(json['total_price_override_used']);
    totalPriceOverrideDiscountAmount =
        getDoubleValue(json['total_price_override_discount_amount']);
    totalBookingPaymentAmount =
        getDoubleValue(json['total_booking_payment_amount']);
    totalBookingPaymentRefundedAmount =
        getDoubleValue(json['total_booking_payment_refunded_amount']);
    totalBookingPaymentUsedAmount =
        getDoubleValue(json['total_booking_payment_used_amount']);
    totalCashInsAmount = getDoubleValue(json['total_cash_ins_amount']);
    totalCashOutsAmount = getDoubleValue(json['total_cash_outs_amount']);
    if (json['sale_payments'] != null) {
      salePayments = [];
      json['sale_payments'].forEach((v) {
        salePayments?.add(SalePayments.fromJson(v));
      });
    }
  }

  int? id;
  Counter? counter;
  int? cashierId;
  double? openingBalance;
  double? closingBalance;
  double? mismatchAmount;
  String? reason;
  String? openingDateTime;
  String? openedAt;
  String? closedAt;
  int? totalSales;
  double? totalSalesAmount;
  int? totalLayawaySales;
  double? totalLayawaySalesAmount;
  int? totalVoidedSales;
  double? totalVoidedSalesAmount;
  double? totalItemWiseDiscountAmount;
  double? totalCartWideDiscountAmount;
  double? totalTaxAmount;
  double? totalSalesRoundOff;
  int? totalSaleReturns;
  double? totalSaleReturnsAmount;
  double? totalCreditNotesUsedAmount;
  double? totalCreditNotesRefundedAmount;
  double? totalSaleReturnsRoundOff;
  double? totalCashbackAmount;
  int? totalVouchersUsed;
  double? totalVoucherDiscountAmount;
  int? totalVouchersGenerated;
  int? totalSalePromotionUsed;
  double? totalSalePromotionDiscountAmount;
  int? totalSaleItemPromotionUsed;
  double? totalSaleItemPromotionDiscountAmount;
  double? totalDreamPriceUsed;
  double? totalDreamPriceDiscountAmount;
  double? totalComplimentaryItemDiscountUsed;
  double? totalComplimentaryItemDiscountAmount;
  double? totalPriceOverrideUsed;
  double? totalPriceOverrideDiscountAmount;
  double? totalBookingPaymentAmount;
  double? totalBookingPaymentRefundedAmount;
  double? totalBookingPaymentUsedAmount;
  double? totalCashInsAmount;
  double? totalCashOutsAmount;
  List<SalePayments>? salePayments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (counter != null) {
      map['counter'] = counter?.toJson();
    }
    map['cashier_id'] = cashierId;
    map['opening_balance'] = openingBalance;
    map['closing_balance'] = closingBalance;
    map['mismatch_amount'] = mismatchAmount;
    map['reason'] = reason;
    map['opening_date_time'] = openingDateTime;
    map['opened_at'] = openedAt;
    map['closed_at'] = closedAt;
    map['total_sales'] = totalSales;
    map['total_sales_amount'] = totalSalesAmount;
    map['total_layaway_sales'] = totalLayawaySales;
    map['total_layaway_sales_amount'] = totalLayawaySalesAmount;
    map['total_voided_sales'] = totalVoidedSales;
    map['total_voided_sales_amount'] = totalVoidedSalesAmount;
    map['total_item_wise_discount_amount'] = totalItemWiseDiscountAmount;
    map['total_cart_wide_discount_amount'] = totalCartWideDiscountAmount;
    map['total_tax_amount'] = totalTaxAmount;
    map['total_sales_round_off'] = totalSalesRoundOff;
    map['total_sale_returns'] = totalSaleReturns;
    map['total_sale_returns_amount'] = totalSaleReturnsAmount;
    map['total_credit_notes_used_amount'] = totalCreditNotesUsedAmount;
    map['total_credit_notes_refunded_amount'] = totalCreditNotesRefundedAmount;
    map['total_sale_returns_round_off'] = totalSaleReturnsRoundOff;
    map['total_cashback_amount'] = totalCashbackAmount;
    map['total_vouchers_used'] = totalVouchersUsed;
    map['total_voucher_discount_amount'] = totalVoucherDiscountAmount;
    map['total_vouchers_generated'] = totalVouchersGenerated;
    map['total_sale_promotion_used'] = totalSalePromotionUsed;
    map['total_sale_promotion_discount_amount'] =
        totalSalePromotionDiscountAmount;
    map['total_sale_item_promotion_used'] = totalSaleItemPromotionUsed;
    map['total_sale_item_promotion_discount_amount'] =
        totalSaleItemPromotionDiscountAmount;
    map['total_dream_price_used'] = totalDreamPriceUsed;
    map['total_dream_price_discount_amount'] = totalDreamPriceDiscountAmount;
    map['total_complimentary_item_discount_used'] =
        totalComplimentaryItemDiscountUsed;
    map['total_complimentary_item_discount_amount'] =
        totalComplimentaryItemDiscountAmount;
    map['total_price_override_used'] = totalPriceOverrideUsed;
    map['total_price_override_discount_amount'] =
        totalPriceOverrideDiscountAmount;
    map['total_booking_payment_amount'] = totalBookingPaymentAmount;
    map['total_booking_payment_refunded_amount'] =
        totalBookingPaymentRefundedAmount;
    map['total_booking_payment_used_amount'] = totalBookingPaymentUsedAmount;
    map['total_cash_ins_amount'] = totalCashInsAmount;
    map['total_cash_outs_amount'] = totalCashOutsAmount;
    if (salePayments != null) {
      map['sale_payments'] = salePayments?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// payment_type_id : 1
/// payment_type : "Cash"
/// total : 13860.2

SalePayments salePaymentsFromJson(String str) =>
    SalePayments.fromJson(json.decode(str));

String salePaymentsToJson(SalePayments data) => json.encode(data.toJson());

class SalePayments {
  SalePayments({
    this.paymentTypeId,
    this.paymentType,
    this.total,
  });

  SalePayments.fromJson(dynamic json) {
    paymentTypeId = json['payment_type_id'];
    paymentType = json['payment_type'];
    total = getDoubleValue(json['total']);
  }

  int? paymentTypeId;
  String? paymentType;
  double? total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['payment_type_id'] = paymentTypeId;
    map['payment_type'] = paymentType;
    map['total'] = total;
    return map;
  }
}

/// id : 72
/// name : "ARAPWT01"
/// store_id : 32

Counter counterFromJson(String str) => Counter.fromJson(json.decode(str));

String counterToJson(Counter data) => json.encode(data.toJson());

class Counter {
  Counter({
    this.id,
    this.name,
    this.storeId,
  });

  Counter.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    storeId = json['store_id'];
  }

  int? id;
  String? name;
  int? storeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['store_id'] = storeId;
    return map;
  }
}
