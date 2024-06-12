import 'dart:convert';

import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesApiResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';

/// credit_notes : [{"id":140,"counter_update_id":47,"cashier":{"id":11,"first_name":"Cashier10","last_name":""},"counter":{"id":11,"name":"Counter1"},"sale_return_id":140,"sale_return_receipt_number":3411861683630422072,"original_sale_receipt_number":3411871683213720599,"user_type":"MEMBER","user_id":34,"user_details":{"first_name":"JYNew","last_name":"","email":"","mobile_number":172811180,"card_number":"X1020"},"expiry_date":"2023-05-19","total_amount":68.83,"available_amount":68.83,"status":"ACTIVE"}]
/// total_records : 1
/// last_page : 1
/// current_page : 1
/// per_page : 20
CreditNotesListApiResponse creditNotesListApiResponseFromJson(String str) =>
    CreditNotesListApiResponse.fromJson(json.decode(str));

String creditNotesListApiResponseToJson(CreditNotesListApiResponse data) =>
    json.encode(data.toJson());

class CreditNotesListApiResponse {
  CreditNotesListApiResponse({
      this.creditNotes, 
      this.totalRecords, 
      this.lastPage, 
      this.currentPage, 
      this.perPage,});

  CreditNotesListApiResponse.fromJson(dynamic json) {
    if (json['credit_notes'] != null) {
      creditNotes = [];
      json['credit_notes'].forEach((v) {
        creditNotes?.add(CreditNotes.fromJson(v));
      });
    }
    totalRecords = json['total_records'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }
  List<CreditNotes>? creditNotes;
  int? totalRecords;
  int? lastPage;
  int? currentPage;
  int? perPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (creditNotes != null) {
      map['credit_notes'] = creditNotes?.map((v) => v.toJson()).toList();
    }
    map['total_records'] = totalRecords;
    map['last_page'] = lastPage;
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    return map;
  }

}

/// id : 140
/// counter_update_id : 47
/// cashier : {"id":11,"first_name":"Cashier10","last_name":""}
/// counter : {"id":11,"name":"Counter1"}
/// sale_return_id : 140
/// sale_return_receipt_number : 3411861683630422072
/// original_sale_receipt_number : 3411871683213720599
/// user_type : "MEMBER"
/// user_id : 34
/// user_details : {"first_name":"JYNew","last_name":"","email":"","mobile_number":172811180,"card_number":"X1020"}
/// expiry_date : "2023-05-19"
/// total_amount : 68.83
/// available_amount : 68.83
/// status : "ACTIVE"

class CreditNotes {
  CreditNotes({
      this.id, 
      this.counterUpdateId, 
      this.cashier, 
      this.counter, 
      this.saleReturnId, 
      this.saleReturnReceiptNumber, 
      this.originalSaleReceiptNumber, 
      this.userType, 
      this.userId, 
      this.userDetails, 
      this.expiryDate, 
      this.totalAmount, 
      this.availableAmount, 
      this.status,});

  CreditNotes.fromJson(dynamic json) {
    id = json['id'];
    counterUpdateId = json['counter_update_id'];
    cashier = json['cashier'] != null ? Cashier.fromJson(json['cashier']) : null;
    counter = json['counter'] != null ? Counter.fromJson(json['counter']) : null;
    saleReturnId = json['sale_return_id'];
    saleReturnReceiptNumber = json['sale_return_receipt_number'].toString();
    originalSaleReceiptNumber = json['original_sale_receipt_number'].toString();
    userType = json['user_type'];
    userId = json['user_id'];
    userDetails = json['user_details'] != null ? UserMemberDetails.fromJson(json['user_details']) : null;
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
  String? saleReturnReceiptNumber;
  String? originalSaleReceiptNumber;
  String? userType;
  int? userId;
  UserMemberDetails? userDetails;
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
    map['sale_return_receipt_number'] = saleReturnReceiptNumber;
    map['original_sale_receipt_number'] = originalSaleReceiptNumber;
    map['user_type'] = userType;
    map['user_id'] = userId;
    if (userDetails != null) {
      map['user_details'] = userDetails?.toJson();
    }
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

class UserMemberDetails {
  UserMemberDetails({
      this.firstName, 
      this.lastName, 
      this.email, 
      this.mobileNumber, 
      this.cardNumber,});

  UserMemberDetails.fromJson(dynamic json) {
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