import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// counter_closing_details : {"cashier_name":"Hettie Olson Erik Walter","counter_name":"Samantha Beatty","opening_date_time":"2022-10-13 03:42:51","opening_balance":12.0,"closing_balance":13837.0,"total_sales":95,"total_sales_amount":15859.970000000001,"total_layaway_sales":10.0,"total_layaway_sales_amount":10.0,"total_voided_sales":8,"total_voided_sales_amount":365.70000000000005,"total_discount_amount":3454.33,"total_item_wise_discount_amount":3444.33,"total_cart_wide_discount_amount":10.10,"total_tax_amount":1192.3899999999996,"total_sales_round_off":-0.23999999999999994,"total_sale_returns":0,"total_sale_returns_amount":0.5,"total_credit_notes_used_amount":0.5,"total_credit_notes_refunded_amount":0.5,"total_sale_returns_round_off":0.5,"total_cashback":47,"total_cashback_amount":470.50,"total_vouchers_used":5,"total_voucher_discount_amount":72.28,"total_vouchers_generated":113,"total_sale_promotion_used":1,"total_sale_promotion_discount_amount":10.50,"total_sale_item_promotion_used":131,"total_sale_item_promotion_discount_amount":3419.330000000001,"total_dream_price_used":10.05,"total_dream_price_discount_amount":0.5,"total_complimentary_item_discount_used":0.5,"total_complimentary_item_discount_amount":0.5,"total_price_override_used":0.5,"total_price_override_discount_amount":0.5,"total_booking_payment_amount":10.10,"total_booking_payment_refunded_amount":0.50,"total_booking_payment_used_amount":10.50,"total_cash_ins_amount":32.50,"total_cash_outs_amount":12.50,"total_petty_cash_usage_amount":502.00,"total_cash_amount_in_sales":14296.999999999998,"total_cash_amount_in_booking_payment":10.50,"total_cash_amount_in_booking_payment_refunded":0.50,"total_cash_amount_in_credit_note_refunded":0.50,"payments":[{"payment_type_id":1,"payment_type":"Cash","total_transactions":89,"total":14307.50},{"payment_type_id":101,"payment_type":"Debit Card","total_transactions":3,"total":859.7},{"payment_type_id":102,"payment_type":"Visa credit","total_transactions":2,"total":320.9},null]}

ShiftDetailsResponse shiftDetailsResponseFromJson(String str) =>
    ShiftDetailsResponse.fromJson(json.decode(str));

String shiftDetailsResponseToJson(ShiftDetailsResponse data) =>
    json.encode(data.toJson());

class ShiftDetailsResponse {
  ShiftDetailsResponse({
    this.counterClosingDetails,
  });

  ShiftDetailsResponse.fromJson(dynamic json) {
    counterClosingDetails = json['counter_closing_details'] != null
        ? CounterClosingDetails.fromJson(json['counter_closing_details'])
        : null;
  }

  CounterClosingDetails? counterClosingDetails;

  ShiftDetailsResponse copyWith({
    CounterClosingDetails? counterClosingDetails,
  }) =>
      ShiftDetailsResponse(
        counterClosingDetails:
            counterClosingDetails ?? this.counterClosingDetails,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (counterClosingDetails != null) {
      map['counter_closing_details'] = counterClosingDetails?.toJson();
    }
    return map;
  }
}

/// cashier_name : "Hettie Olson Erik Walter"
/// counter_name : "Samantha Beatty"
/// opening_date_time : "2022-10-13 03:42:51"
/// opening_balance : 12.0
/// closing_balance : 13837.0
/// total_sales : 95
/// total_sales_amount : 15859.970000000001
/// total_layaway_sales : 10.0
/// total_layaway_sales_amount : 10.0
/// total_voided_sales : 8
/// total_voided_sales_amount : 365.70000000000005
/// total_discount_amount : 3454.33
/// total_item_wise_discount_amount : 3444.33
/// total_cart_wide_discount_amount : 10.10
/// total_tax_amount : 1192.3899999999996
/// total_sales_round_off : -0.23999999999999994
/// total_sale_returns : 0
/// total_sale_returns_amount : 0.5
/// total_credit_notes_used_amount : 0.5
/// total_credit_notes_refunded_amount : 0.5
/// total_sale_returns_round_off : 0.5
/// total_cashback : 47
/// total_cashback_amount : 470.50
/// total_vouchers_used : 5
/// total_voucher_discount_amount : 72.28
/// total_vouchers_generated : 113
/// total_sale_promotion_used : 1
/// total_sale_promotion_discount_amount : 10.50
/// total_sale_item_promotion_used : 131
/// total_sale_item_promotion_discount_amount : 3419.330000000001
/// total_dream_price_used : 10.05
/// total_dream_price_discount_amount : 0.5
/// total_complimentary_item_discount_used : 0.5
/// total_complimentary_item_discount_amount : 0.5
/// total_price_override_used : 0.5
/// total_price_override_discount_amount : 0.5
/// total_booking_payment_amount : 10.10
/// total_booking_payment_refunded_amount : 0.50
/// total_booking_payment_used_amount : 10.50
/// total_cash_ins_amount : 32.50
/// total_cash_outs_amount : 12.50
/// total_petty_cash_usage_amount : 502.00
/// total_cash_amount_in_sales : 14296.999999999998
/// total_cash_amount_in_booking_payment : 10.50
/// total_cash_amount_in_booking_payment_refunded : 0.50
/// total_cash_amount_in_credit_note_refunded : 0.50
/// payments : [{"payment_type_id":1,"payment_type":"Cash","total_transactions":89,"total":14307.50},{"payment_type_id":101,"payment_type":"Debit Card","total_transactions":3,"total":859.7},{"payment_type_id":102,"payment_type":"Visa credit","total_transactions":2,"total":320.9},null]

CounterClosingDetails counterClosingDetailsFromJson(String str) =>
    CounterClosingDetails.fromJson(json.decode(str));

String counterClosingDetailsToJson(CounterClosingDetails data) =>
    json.encode(data.toJson());

class CounterClosingDetails {
  CounterClosingDetails({
    this.cashierName,
    this.counterName,
    this.openingDateTime,
    this.openingBalance,
    this.closingBalance,
    this.totalSales,
    this.totalSalesAmount,
    this.totalLayawaySales,
    this.totalLayawaySalesAmount,
    this.totalVoidedSales,
    this.totalVoidedSalesAmount,
    this.totalDiscountAmount,
    this.totalItemWiseDiscountAmount,
    this.totalCartWideDiscountAmount,
    this.totalTaxAmount,
    this.totalSalesRoundOff,
    this.totalSaleReturns,
    this.totalSaleReturnsAmount,
    this.totalCreditNotesUsedAmount,
    this.totalCreditNotesRefundedAmount,
    this.totalSaleReturnsRoundOff,
    this.totalCashback,
    this.totalCashbackAmount,
    this.totalVouchersUsed,
    this.totalVoucherDiscountAmount,
    this.totalNewBookingPayments,
    this.totalUsedBookingPayments,
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
    this.totalPettyCashUsageAmount,
    this.totalCashAmountInSales,
    this.totalCashAmountInBookingPayment,
    this.totalCashAmountInBookingPaymentRefunded,
    this.totalCashAmountInCreditNoteRefunded,
    this.payments,
  });

  CounterClosingDetails.fromJson(dynamic json) {
    cashierName = json['cashier_name'];
    counterName = json['counter_name'];
    openingDateTime = json['opening_date_time'];
    openingBalance = getDoubleValue(json['opening_balance']);
    closingBalance = getDoubleValue(json['closing_balance']);
    totalSales = json['total_sales'];
    totalSalesAmount = getDoubleValue(json['total_sales_amount']);
    totalLayawaySales = getDoubleValue(json['total_layaway_sales']);
    totalLayawaySalesAmount =
        getDoubleValue(json['total_layaway_sales_amount']);
    totalVoidedSales = json['total_voided_sales'];
    totalVoidedSalesAmount = getDoubleValue(json['total_voided_sales_amount']);
    totalDiscountAmount = getDoubleValue(json['total_discount_amount']);
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
    totalCashback = json['total_cashback'];
    totalCashbackAmount = getDoubleValue(json['total_cashback_amount']);
    totalVouchersUsed = json['total_vouchers_used'];
    totalVoucherDiscountAmount =
        getDoubleValue(json['total_voucher_discount_amount']);
    totalVouchersGenerated = json['total_vouchers_generated'];
    totalNewBookingPayments = json['total_new_booking_payments'];
    totalUsedBookingPayments = json['total_used_booking_payments'];
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
    totalPettyCashUsageAmount =
        getDoubleValue(json['total_petty_cash_usage_amount']);
    totalCashAmountInSales = getDoubleValue(json['total_cash_amount_in_sales']);
    totalCashAmountInBookingPayment =
        getDoubleValue(json['total_cash_amount_in_booking_payment']);
    totalCashAmountInBookingPaymentRefunded =
        getDoubleValue(json['total_cash_amount_in_booking_payment_refunded']);
    totalCashAmountInCreditNoteRefunded =
        getDoubleValue(json['total_cash_amount_in_credit_note_refunded']);
    if (json['payments'] != null) {
      payments = [];
      json['payments'].forEach((v) {
        payments?.add(ShiftClosingPayments.fromJson(v));
      });
    }
  }

  String? cashierName;
  String? counterName;
  String? openingDateTime;
  double? openingBalance;
  double? closingBalance;
  int? totalSales;
  double? totalSalesAmount;
  double? totalLayawaySales;
  double? totalLayawaySalesAmount;
  int? totalVoidedSales;
  double? totalVoidedSalesAmount;
  double? totalDiscountAmount;
  double? totalItemWiseDiscountAmount;
  double? totalCartWideDiscountAmount;
  double? totalTaxAmount;
  double? totalSalesRoundOff;
  int? totalSaleReturns;
  double? totalSaleReturnsAmount;
  double? totalCreditNotesUsedAmount;
  double? totalCreditNotesRefundedAmount;
  double? totalSaleReturnsRoundOff;
  int? totalCashback;
  double? totalCashbackAmount;
  int? totalVouchersUsed;
  double? totalVoucherDiscountAmount;
  int? totalVouchersGenerated;
  int? totalSalePromotionUsed;
  int? totalNewBookingPayments;
  int? totalUsedBookingPayments;
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
  double? totalPettyCashUsageAmount;
  double? totalCashAmountInSales;
  double? totalCashAmountInBookingPayment;
  double? totalCashAmountInBookingPaymentRefunded;
  double? totalCashAmountInCreditNoteRefunded;
  List<ShiftClosingPayments>? payments;

  void setPayments(List<ShiftClosingPayments>? payments) {
    payments = payments;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cashier_name'] = cashierName;
    map['counter_name'] = counterName;
    map['opening_date_time'] = openingDateTime;
    map['opening_balance'] = openingBalance;
    map['closing_balance'] = closingBalance;
    map['total_sales'] = totalSales;
    map['total_sales_amount'] = totalSalesAmount;
    map['total_layaway_sales'] = totalLayawaySales;
    map['total_layaway_sales_amount'] = totalLayawaySalesAmount;
    map['total_voided_sales'] = totalVoidedSales;
    map['total_voided_sales_amount'] = totalVoidedSalesAmount;
    map['total_discount_amount'] = totalDiscountAmount;
    map['total_item_wise_discount_amount'] = totalItemWiseDiscountAmount;
    map['total_cart_wide_discount_amount'] = totalCartWideDiscountAmount;
    map['total_tax_amount'] = totalTaxAmount;
    map['total_sales_round_off'] = totalSalesRoundOff;
    map['total_sale_returns'] = totalSaleReturns;
    map['total_sale_returns_amount'] = totalSaleReturnsAmount;
    map['total_credit_notes_used_amount'] = totalCreditNotesUsedAmount;
    map['total_credit_notes_refunded_amount'] = totalCreditNotesRefundedAmount;
    map['total_sale_returns_round_off'] = totalSaleReturnsRoundOff;
    map['total_cashback'] = totalCashback;
    map['total_cashback_amount'] = totalCashbackAmount;
    map['total_vouchers_used'] = totalVouchersUsed;
    map['total_voucher_discount_amount'] = totalVoucherDiscountAmount;
    map['total_vouchers_generated'] = totalVouchersGenerated;
    map['total_new_booking_payments'] = totalNewBookingPayments;
    map['total_used_booking_payments'] = totalUsedBookingPayments;
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
    map['total_petty_cash_usage_amount'] = totalPettyCashUsageAmount;
    map['total_cash_amount_in_sales'] = totalCashAmountInSales;
    map['total_cash_amount_in_booking_payment'] =
        totalCashAmountInBookingPayment;
    map['total_cash_amount_in_booking_payment_refunded'] =
        totalCashAmountInBookingPaymentRefunded;
    map['total_cash_amount_in_credit_note_refunded'] =
        totalCashAmountInCreditNoteRefunded;
    if (payments != null) {
      map['payments'] = payments?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// payment_type_id : 1
/// payment_type : "Cash"
/// total_transactions : 89
/// total : 14307.50

ShiftClosingPayments paymentsFromJson(String str) =>
    ShiftClosingPayments.fromJson(json.decode(str));

String paymentsToJson(ShiftClosingPayments data) => json.encode(data.toJson());

class ShiftClosingPayments {
  ShiftClosingPayments({
    this.paymentTypeId,
    this.paymentType,
    this.totalTransactions,
    this.total,
  });

  ShiftClosingPayments.fromJson(dynamic json) {
    paymentTypeId = json['payment_type_id'];
    paymentType = json['payment_type'];
    totalTransactions = json['total_transactions'];
    total = getDoubleValue(json['total']);
  }

  int? paymentTypeId;
  String? paymentType;
  int? totalTransactions;
  double? total;

  ShiftClosingPayments copyWith({
    int? paymentTypeId,
    String? paymentType,
    int? totalTransactions,
    double? total,
  }) =>
      ShiftClosingPayments(
        paymentTypeId: paymentTypeId ?? this.paymentTypeId,
        paymentType: paymentType ?? this.paymentType,
        totalTransactions: totalTransactions ?? this.totalTransactions,
        total: total ?? this.total,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['payment_type_id'] = paymentTypeId;
    map['payment_type'] = paymentType;
    map['total_transactions'] = totalTransactions;
    map['total'] = total;
    return map;
  }
}
