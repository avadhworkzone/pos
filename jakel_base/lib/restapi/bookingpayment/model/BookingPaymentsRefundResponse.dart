import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// booking_payment_refund : {"id":12,"member":{"id":34,"first_name":"JYNew","last_name":"","mobile_number":172811180},"total_amount":178.55,"available_amount":0,"status":"REFUNDED","created_at":"2023-05-0114: 49: 38","mismatches":[],"booking_payment_refund":{"payment_type":"Cash","amount":"178.55","created_at":"2023-05-0210: 03: 45"}}

BookingPaymentsRefundResponse bookingPaymentsResponseFromJson(String str) =>
    BookingPaymentsRefundResponse.fromJson(json.decode(str));

String bookingPaymentsRefundResponseToJson(
    BookingPaymentsRefundResponse data) =>
    json.encode(data.toJson());

class BookingPaymentsRefundResponse {
  BookingPaymentsRefundResponse({
    this.bookingPaymentRefund,});

  BookingPaymentsRefundResponse.fromJson(dynamic json) {
    bookingPaymentRefund =
    json['booking_payment_refund'] != null ? BookingPaymentRefund.fromJson(
        json['booking_payment_refund']) : null;
  }

  BookingPaymentRefund? bookingPaymentRefund;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (bookingPaymentRefund != null) {
      map['booking_payment_refund'] = bookingPaymentRefund?.toJson();
    }
    return map;
  }

}

/// id : 12
/// member : {"id":34,"first_name":"JYNew","last_name":"","mobile_number":172811180}
/// total_amount : 178.55
/// available_amount : 0
/// status : "REFUNDED"
/// created_at : "2023-05-0114: 49: 38"
/// mismatches : []
/// booking_payment_refund : {"payment_type":"Cash","amount":"178.55","created_at":"2023-05-0210: 03: 45"}

class BookingPaymentRefund {
  BookingPaymentRefund({
    this.id,
    this.member,
    this.totalAmount,
    this.availableAmount,
    this.status,
    this.createdAt,
    this.happenedAt,
    this.bookingPaymentRefundType,});

  BookingPaymentRefund.fromJson(dynamic json) {
    id = json['id'];
    member = json['member'] != null ? Member.fromJson(json['member']) : null;
    totalAmount = getDoubleValue(json['total_amount']);
    availableAmount = getDoubleValue(json['available_amount']);
    status = json['status'];
    createdAt = json['created_at'];
    happenedAt = json['happened_at'].toString();
    bookingPaymentRefundType =
    json['booking_payment_refund'] != null ? BookingPaymentRefundType.fromJson(
        json['booking_payment_refund']) : null;
  }

  int? id;
  Member? member;
  double? totalAmount;
  double? availableAmount;
  String? status;
  String? createdAt;
  String? happenedAt;
  BookingPaymentRefundType? bookingPaymentRefundType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (member != null) {
      map['member'] = member?.toJson();
    }
    map['total_amount'] = totalAmount;
    map['available_amount'] = availableAmount;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['happened_at'] = happenedAt;
    if (bookingPaymentRefundType != null) {
      map['booking_payment_refund'] = bookingPaymentRefundType?.toJson();
    }
    return map;
  }

}

/// payment_type : "Cash"
/// amount : 178.55
/// created_at : "2023-05-0210: 03: 45"

class BookingPaymentRefundType {
  BookingPaymentRefundType({
    this.paymentType,
    this.amount,
    this.createdAt,
    this.happenedAt,
  });

  BookingPaymentRefundType.fromJson(dynamic json) {
    paymentType = json['payment_type'];
    amount = json['amount'].toString();
    createdAt = json['created_at'].toString();
    happenedAt = json['happened_at'].toString();
  }

  String? paymentType;
  String? amount;
  String? createdAt;
  String? happenedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['payment_type'] = paymentType;
    map['amount'] = amount;
    map['created_at'] = createdAt;
    map['happened_at'] = happenedAt;
    return map;
  }

}

/// id : 34
/// first_name : "JYNew"
/// last_name : ""
/// mobile_number : "172811180"

class Member {
  Member({
    this.id,
    this.firstName,
    this.lastName,
    this.mobileNumber,});

  Member.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobileNumber = json['mobile_number'].toString();
  }

  int? id;
  String? firstName;
  String? lastName;
  String? mobileNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['mobile_number'] = mobileNumber;
    return map;
  }

}