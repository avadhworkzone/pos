import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// credit_notes : [{"id":43,"counter_update_id":32,"sale_return_id":43,"user_type":"MEMBER","status":"MEMBER","user_id":1,"expiry_date":"2022-12-17","total_amount":38.50,"available_amount":38.50,"credit_note_refund_mismatches":["",""]}]
/// total_records : 14
/// last_page : 1
/// current_page : 1
/// per_page : 20

CreditNotesResponse creditNotesResponseFromJson(String str) =>
    CreditNotesResponse.fromJson(json.decode(str));

String creditNotesResponseToJson(CreditNotesResponse data) =>
    json.encode(data.toJson());

class CreditNotesResponse {
  CreditNotesResponse({
    this.creditNotes,
    this.totalRecords,
    this.lastPage,
    this.currentPage,
    this.perPage,
  });

  CreditNotesResponse.fromJson(dynamic json) {
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

/// id : 43
/// counter_update_id : 32
/// sale_return_id : 43
/// sale_return_receipt_number: 05571687570569761,
/// original_sale_receipt_number: 05551687570306837,
/// user_type : "MEMBER"
/// status : "MEMBER"
/// user_id : 1
/// expiry_date : "2022-12-17"
/// total_amount : 38.50
/// available_amount : 38.50
/// credit_note_refund_mismatches : ["",""]

CreditNotes creditNotesFromJson(String str) =>
    CreditNotes.fromJson(json.decode(str));

String creditNotesToJson(CreditNotes data) => json.encode(data.toJson());

class CreditNotes {
  CreditNotes({
    this.id,
    this.counterUpdateId,
    this.saleReturnId,
    this.userType,
    this.saleReturnReceiptNumber,
    this.originalSaleReceiptNumber,
    this.status,
    this.userId,
    this.expiryDate,
    this.totalAmount,
    this.availableAmount,
    this.creditNoteRefundMismatches,
  });

  CreditNotes.fromJson(dynamic json) {
    id = json['id'];
    counterUpdateId = json['counter_update_id'];
    saleReturnId = json['sale_return_id'];
    saleReturnReceiptNumber = json['sale_return_receipt_number'].toString();
    originalSaleReceiptNumber = json['original_sale_receipt_number'].toString();
    userType = json['user_type'];
    status = json['status'];
    userId = json['user_id'];
    expiryDate = json['expiry_date'];
    totalAmount = getDoubleValue(json['total_amount']);
    availableAmount = getDoubleValue(json['available_amount']);
    creditNoteRefundMismatches = json['credit_note_refund_mismatches'] != null
        ? json['credit_note_refund_mismatches'].cast<String>()
        : [];
  }

  int? id;
  int? counterUpdateId;
  int? saleReturnId;
  String? saleReturnReceiptNumber;
  String? originalSaleReceiptNumber;
  String? userType;
  String? status;
  int? userId;
  String? expiryDate;
  double? totalAmount;
  double? availableAmount;
  List<String>? creditNoteRefundMismatches;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['counter_update_id'] = counterUpdateId;
    map['sale_return_id'] = saleReturnId;
    map['user_type'] = userType;
    map['sale_return_receipt_number'] = saleReturnReceiptNumber;
    map['original_sale_receipt_number'] = originalSaleReceiptNumber;
    map['status'] = status;
    map['user_id'] = userId;
    map['expiry_date'] = expiryDate;
    map['total_amount'] = totalAmount;
    map['available_amount'] = availableAmount;
    map['credit_note_refund_mismatches'] = creditNoteRefundMismatches;
    return map;
  }
}

