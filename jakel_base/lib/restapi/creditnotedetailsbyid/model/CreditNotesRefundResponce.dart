import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// credit_note : {"id":67,"counter_update_id":24,"cashier":{"id":11,"first_name":"Cashier10","last_name":"null"},"counter":{"id":11,"name":"Counter1"},"sale_return_id":1,"user_type":"","user_id":1,"user_details":"","expiry_date":"2023-05-12","total_amount":178.55,"available_amount":0,"status":"USED"}

CreditNotesRefundResponse giftCardsResponseFromJson(String str) =>
    CreditNotesRefundResponse.fromJson(json.decode(str));

String creditNotesRefundResponseToJson(CreditNotesRefundResponse data) =>
    json.encode(data.toJson());

class CreditNotesRefundResponse {
  CreditNotesRefundResponse({
      this.creditNote,});

  CreditNotesRefundResponse.fromJson(dynamic json) {
    creditNote = json['credit_note'] != null ? CreditNoteRefund.fromJson(json['credit_note']) : null;
  }
  CreditNoteRefund? creditNote;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (creditNote != null) {
      map['credit_note'] = creditNote?.toJson();
    }
    return map;
  }

}

/// id : 67
/// counter_update_id : 24
/// cashier : {"id":11,"first_name":"Cashier10","last_name":"null"}
/// counter : {"id":11,"name":"Counter1"}
/// sale_return_id : 1
/// user_type : ""
/// user_id : 1
/// user_details : ""
/// expiry_date : "2023-05-12"
/// total_amount : 178.55
/// available_amount : 0
/// status : "USED"

class CreditNoteRefund {
  CreditNoteRefund({
      this.id, 
      this.counterUpdateId, 
      this.cashier, 
      this.counter, 
      this.saleReturnId, 
      this.userType, 
      this.userId, 
      this.userDetails, 
      this.expiryDate, 
      this.totalAmount, 
      this.availableAmount, 
      this.status,});

  CreditNoteRefund.fromJson(dynamic json) {
    id = json['id'];
    counterUpdateId = json['counter_update_id'];
    cashier = json['cashier'] != null ? Cashier.fromJson(json['cashier']) : null;
    counter = json['counter'] != null ? Counter.fromJson(json['counter']) : null;
    saleReturnId = json['sale_return_id'];
    userType = json['user_type'];
    userId = json['user_id'];
    userDetails = json['user_details'] != null ? UserDetails.fromJson(json['user_details']) : null;
    expiryDate = json['expiry_date'];
    totalAmount = getDoubleValue(json['total_amount']);
    availableAmount = getDoubleValue(json['available_amount']);
    status = json['status'];
  }
  int? id;
  int? counterUpdateId;
  Cashier? cashier;
  Counter? counter;
  int? saleReturnId;
  String? userType;
  int? userId;
  UserDetails? userDetails;
  String? expiryDate;
  double? totalAmount;
  double? availableAmount;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['counter_update_id'] = counterUpdateId;
    if (cashier != null) {
      map['cashier'] = cashier?.toJson();
    }
    if (counter != null) {
      map['counter'] = counter?.toJson();
    }
    map['sale_return_id'] = saleReturnId;
    map['user_type'] = userType;
    map['user_id'] = userId;
    map['user_details'] = userDetails;
    map['expiry_date'] = expiryDate;
    map['total_amount'] = totalAmount;
    map['available_amount'] = availableAmount;
    map['status'] = status;
    return map;
  }

}

/// first_name : "JYNew"
/// last_name : ""
/// email : ""
/// mobile_number : 172811180
/// card_number : "X1020"

class UserDetails {
  UserDetails({
    this.firstName,
    this.lastName,
    this.email,
    this.mobileNumber,
    this.cardNumber,});

  UserDetails.fromJson(dynamic json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    mobileNumber = json['mobile_number'].toString();
    cardNumber = json['card_number'];
  }
  String? firstName;
  String? lastName;
  String? email;
  String? mobileNumber;
  String? cardNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['email'] = email;
    map['mobile_number'] = mobileNumber;
    map['card_number'] = cardNumber;
    return map;
  }

}

/// id : 11
/// name : "Counter1"

class Counter {
  Counter({
      this.id, 
      this.name,});

  Counter.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

/// id : 11
/// first_name : "Cashier10"
/// last_name : "null"

class Cashier {
  Cashier({
      this.id, 
      this.firstName, 
      this.lastName,});

  Cashier.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }
  int? id;
  String? firstName;
  String? lastName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    return map;
  }

}