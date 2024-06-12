import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// round_off_configuration : [{"decimal_place":".01","value":"-0.01"},{"decimal_place":".02","value":"-0.02"},{"decimal_place":".03","value":"0.02"},{"decimal_place":".04","value":"0.01"},{"decimal_place":".05","value":"0.00"},{"decimal_place":".06","value":"-0.01"},{"decimal_place":".07","value":"-0.02"},{"decimal_place":".08","value":"0.02"},{"decimal_place":".09","value":"0.01"},{"decimal_place":".00","value":"0.00"}]
/// sales_tax_percentage : 0
/// sales_return_days_limit : 7
/// receipt_footer : "Product exchange must be made within 7 days from the date of purchase with original receipt presented"
/// disclaimer : "item MUST NOT have been USED/WORN/DAMAGED in any way\n\n**CLEARANCE/OFFER/SALES item NOT exchangeable/returnable\n\nSTRICTLY NO REFUND\n\nThank You for shopping at Ariani"
/// store_registration_number : "810393-X"
/// store_sst_number : "200801009105"
/// credit_note_expiration_days : 0
/// loyalty_point_expiration_days : 0
/// cash_out_limit_info : "0.00"
/// cash_out_limit_warning : "0.00"
/// cash_out_limit_restrict : "0.00"
/// new_member_free_loyalty_points : 0
/// min_promoters_per_item : 1
/// is_promoter_mandatory : true
/// is_bill_reference_number_mandatory : true
/// allow_exchange_to_different_store : 1
/// allow_price_override_cart_level : true
/// is_employee_booking_payment_allowed : false
/// allow_negative_payment : false
/// discount_applicable_type : {"id":1,"name":"Additional Discount On Already Discounted Prices","key":"ADDITIONAL_DISCOUNT_ON_ALREADY_DISCOUNTED_PRICES"}
/// booking_payment_use_type : {"id":1,"name":"Partially","key":"PARTIALLY"}
/// auto_birthday_voucher_generation : false

CompanyConfigurationResponse companyConfigurationResponseFromJson(String str) =>
    CompanyConfigurationResponse.fromJson(json.decode(str));

String companyConfigurationResponseToJson(CompanyConfigurationResponse data) =>
    json.encode(data.toJson());

class CompanyConfigurationResponse {
  CompanyConfigurationResponse({
    this.roundOffConfiguration,
    this.salesTaxPercentage,
    this.salesReturnDaysLimit,
    this.receiptFooter,
    this.disclaimer,
    this.storeRegistrationNumber,
    this.storeSstNumber,
    this.creditNoteExpirationDays,
    this.loyaltyPointExpirationDays,
    this.cashOutLimitInfo,
    this.cashOutLimitWarning,
    this.cashOutLimitRestrict,
    this.newMemberFreeLoyaltyPoints,
    this.minPromotersPerItem,
    this.isPromoterMandatory,
    this.isBillReferenceNumberMandatory,
    this.allowExchangeToDifferentStore,
    this.allowPriceOverrideCartLevel,
    this.isEmployeeBookingPaymentAllowed,
    this.allowNegativePayment,
    this.discountApplicableType,
    this.bookingPaymentUseType,
    this.autoBirthdayVoucherGeneration,
  });

  CompanyConfigurationResponse.fromJson(dynamic json) {
    if (json['round_off_configuration'] != null) {
      roundOffConfiguration = [];
      json['round_off_configuration'].forEach((v) {
        roundOffConfiguration?.add(CompanyRoundOffConfiguration.fromJson(v));
      });
    }
    salesTaxPercentage = getDoubleValue(json['sales_tax_percentage']);
    salesReturnDaysLimit = json['sales_return_days_limit'];
    receiptFooter = json['receipt_footer'];
    disclaimer = json['disclaimer'];
    storeRegistrationNumber = json['store_registration_number'];
    storeSstNumber = json['store_sst_number'];
    creditNoteExpirationDays = json['credit_note_expiration_days'];
    loyaltyPointExpirationDays = json['loyalty_point_expiration_days'];
    cashOutLimitInfo = json['cash_out_limit_info'];
    cashOutLimitWarning = json['cash_out_limit_warning'];
    cashOutLimitRestrict = json['cash_out_limit_restrict'];
    newMemberFreeLoyaltyPoints = json['new_member_free_loyalty_points'];
    minPromotersPerItem = json['min_promoters_per_item'];
    isPromoterMandatory = json['is_promoter_mandatory'];
    isBillReferenceNumberMandatory = json['is_bill_reference_number_mandatory'];
    allowExchangeToDifferentStore = json['allow_exchange_to_different_store'];
    allowPriceOverrideCartLevel = json['allow_price_override_cart_level'];
    isEmployeeBookingPaymentAllowed =
    json['is_employee_booking_payment_allowed'];
    allowNegativePayment = json['allow_negative_payment'];
    discountApplicableType = json['discount_applicable_type'] != null
        ? DiscountApplicableType.fromJson(json['discount_applicable_type'])
        : null;
    bookingPaymentUseType = json['booking_payment_use_type'] != null
        ? BookingPaymentUseType.fromJson(json['booking_payment_use_type'])
        : null;
    autoBirthdayVoucherGeneration = json['auto_birthday_voucher_generation'];
  }

  List<CompanyRoundOffConfiguration>? roundOffConfiguration;
  double? salesTaxPercentage;
  int? salesReturnDaysLimit;
  String? receiptFooter;
  String? disclaimer;
  String? storeRegistrationNumber;
  String? storeSstNumber;
  int? creditNoteExpirationDays;
  int? loyaltyPointExpirationDays;
  String? cashOutLimitInfo;
  String? cashOutLimitWarning;
  String? cashOutLimitRestrict;
  int? newMemberFreeLoyaltyPoints;
  int? minPromotersPerItem;
  bool? isPromoterMandatory;
  bool? isBillReferenceNumberMandatory;
  int? allowExchangeToDifferentStore;
  bool? allowPriceOverrideCartLevel;
  bool? isEmployeeBookingPaymentAllowed;
  bool? allowNegativePayment;
  DiscountApplicableType? discountApplicableType;
  BookingPaymentUseType? bookingPaymentUseType;
  bool? autoBirthdayVoucherGeneration;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (roundOffConfiguration != null) {
      map['round_off_configuration'] =
          roundOffConfiguration?.map((v) => v.toJson()).toList();
    }
    map['sales_tax_percentage'] = salesTaxPercentage;
    map['sales_return_days_limit'] = salesReturnDaysLimit;
    map['receipt_footer'] = receiptFooter;
    map['disclaimer'] = disclaimer;
    map['store_registration_number'] = storeRegistrationNumber;
    map['store_sst_number'] = storeSstNumber;
    map['credit_note_expiration_days'] = creditNoteExpirationDays;
    map['loyalty_point_expiration_days'] = loyaltyPointExpirationDays;
    map['cash_out_limit_info'] = cashOutLimitInfo;
    map['cash_out_limit_warning'] = cashOutLimitWarning;
    map['cash_out_limit_restrict'] = cashOutLimitRestrict;
    map['new_member_free_loyalty_points'] = newMemberFreeLoyaltyPoints;
    map['min_promoters_per_item'] = minPromotersPerItem;
    map['is_promoter_mandatory'] = isPromoterMandatory;
    map['is_bill_reference_number_mandatory'] = isBillReferenceNumberMandatory;
    map['allow_exchange_to_different_store'] = allowExchangeToDifferentStore;
    map['allow_price_override_cart_level'] = allowPriceOverrideCartLevel;
    map['is_employee_booking_payment_allowed'] =
        isEmployeeBookingPaymentAllowed;
    map['allow_negative_payment'] = allowNegativePayment;
    if (discountApplicableType != null) {
      map['discount_applicable_type'] = discountApplicableType?.toJson();
    }
    if (bookingPaymentUseType != null) {
      map['booking_payment_use_type'] = bookingPaymentUseType?.toJson();
    }
    map['auto_birthday_voucher_generation'] = autoBirthdayVoucherGeneration;
    return map;
  }
}

/// id : 1
/// name : "Partially"
/// key : "PARTIALLY"

BookingPaymentUseType bookingPaymentUseTypeFromJson(String str) =>
    BookingPaymentUseType.fromJson(json.decode(str));

String bookingPaymentUseTypeToJson(BookingPaymentUseType data) =>
    json.encode(data.toJson());

class BookingPaymentUseType {
  BookingPaymentUseType({
    this.id,
    this.name,
    this.key,
  });

  BookingPaymentUseType.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    key = json['key'];
  }

  int? id;
  String? name;
  String? key;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['key'] = key;
    return map;
  }
}

/// id : 1
/// name : "Additional Discount On Already Discounted Prices"
/// key : "ADDITIONAL_DISCOUNT_ON_ALREADY_DISCOUNTED_PRICES"

DiscountApplicableType discountApplicableTypeFromJson(String str) =>
    DiscountApplicableType.fromJson(json.decode(str));

String discountApplicableTypeToJson(DiscountApplicableType data) =>
    json.encode(data.toJson());

class DiscountApplicableType {
  DiscountApplicableType({
    this.id,
    this.name,
    this.key,
  });

  DiscountApplicableType.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    key = json['key'];
  }

  int? id;
  String? name;
  String? key;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['key'] = key;
    return map;
  }
}

/// decimal_place : ".01"
/// value : "-0.01"

CompanyRoundOffConfiguration companyRoundOffConfigurationFromJson(String str) =>
    CompanyRoundOffConfiguration.fromJson(json.decode(str));

String companyRoundOffConfigurationToJson(CompanyRoundOffConfiguration data) =>
    json.encode(data.toJson());

class CompanyRoundOffConfiguration {
  CompanyRoundOffConfiguration({
    this.decimalPlace,
    this.value,
  });

  CompanyRoundOffConfiguration.fromJson(dynamic json) {
    decimalPlace = json['decimal_place'];
    value = getDoubleValue(json['value']);
  }

  String? decimalPlace;
  double? value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['decimal_place'] = decimalPlace;
    map['value'] = value;
    return map;
  }
}
