

import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// credit_note : {"id":206,"counter_update_id":1704,"cashier":{"id":167,"first_name":"NAZREENA HAKIM BINTI HERMANSYAH","last_name":""},"counter":{"id":47,"name":"ARAALS01"},"sale_return_id":206,"user_type":"","user_id":"","user_details":"","expiry_date":"","total_amount":"","available_amount":"","status":"ACTIVE"}



CreditNotesApiResponse giftCardsResponseFromJson(String str) =>
    CreditNotesApiResponse.fromJson(json.decode(str));

String creditNotesApiResponseToJson(CreditNotesApiResponse data) =>
    json.encode(data.toJson());

class CreditNotesApiResponse {
  CreditNotesApiResponse({
    this.creditNote,});

  CreditNotesApiResponse.fromJson(dynamic json) {
    creditNote = json['credit_note'] != null ? CreditNote.fromJson(json['credit_note']) : null;
  }

  CreditNote? creditNote;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (creditNote != null) {
      map['credit_note'] = creditNote?.toJson();
    }
    return map;
  }

}

/// id : 206
/// counter_update_id : 1704
/// cashier : {"id":167,"first_name":"NAZREENA HAKIM BINTI HERMANSYAH","last_name":""}
/// counter : {"id":47,"name":"ARAALS01"}
/// sale_return_id : 206
/// user_type : ""
/// user_id : ""
/// user_details : ""
/// expiry_date : ""
/// total_amount : ""
/// available_amount : ""
/// status : "ACTIVE"

class CreditNote {
  CreditNote({
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

  CreditNote.fromJson(dynamic json) {
    id = json['id'];
    counterUpdateId = json['counter_update_id'];
    cashier = json['cashier'] != null ? Cashier.fromJson(json['cashier']) : null;
    counter = json['counter'] != null ? Counter.fromJson(json['counter']) : null;
    saleReturnId = json['sale_return_id'];
    userType = json['user_type'].toString();
    userId = json['user_id'].toString();
    userDetails = json['user_details'].toString();
    expiryDate = json['expiry_date'].toString();
    totalAmount = getDoubleValue(json['total_amount']);
    availableAmount = getDoubleValue(json['available_amount']);
    status = json['status'].toString();

  }
  int? id;
  int? counterUpdateId;
  Cashier? cashier;
  Counter? counter;
  int? saleReturnId;
  String? userType;
  String? userId;
  String? userDetails;
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

/// id : 47
/// name : "ARAALS01"

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

/// id : 167
/// first_name : "NAZREENA HAKIM BINTI HERMANSYAH"
/// last_name : ""

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