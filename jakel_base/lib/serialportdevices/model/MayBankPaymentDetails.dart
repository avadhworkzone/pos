import 'dart:convert';

/// cardNumber : ""
/// expiry : ""
/// statusCode : ""
/// traceNo : ""
/// approvalCode : ""
/// referenceNumber : ""
/// batchNumber : ""
/// hostNo : ""
/// errorMessage : "" --> This is custom error message to show in UI

MayBankPaymentDetails mayBankPaymentDetailsFromJson(String str) =>
    MayBankPaymentDetails.fromJson(json.decode(str));

String mayBankPaymentDetailsToJson(MayBankPaymentDetails data) =>
    json.encode(data.toJson());

class MayBankPaymentDetails {
  MayBankPaymentDetails({
    this.cardNumber,
    this.cardNumberName,
    this.cardType,
    this.expiry,
    this.statusCode,
    this.traceNo,
    this.approvalCode,
    this.referenceNumber,
    this.batchNumber,
    this.hostNo,
    this.errorMessage,
  });

  MayBankPaymentDetails.fromJson(dynamic json) {
    cardNumber = json['cardNumber'];
    cardNumberName = json['cardNumberName'];
    cardType = json['cardType'];
    expiry = json['expiry'];
    statusCode = json['statusCode'];
    traceNo = json['traceNo'];
    approvalCode = json['approvalCode'];
    referenceNumber = json['referenceNumber'];
    batchNumber = json['batchNumber'];
    hostNo = json['hostNo'];
    errorMessage = json['errorMessage'];
  }

  String? cardNumber;
  String? expiry;
  String? cardType;
  String? cardNumberName;
  String? statusCode;
  String? traceNo;
  String? approvalCode;
  String? referenceNumber;
  String? batchNumber;
  String? hostNo;
  String? errorMessage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cardNumber'] = cardNumber;
    map['cardType'] = cardType;
    map['cardNumberName'] = cardNumberName;
    map['expiry'] = expiry;
    map['statusCode'] = statusCode;
    map['traceNo'] = traceNo;
    map['approvalCode'] = approvalCode;
    map['referenceNumber'] = referenceNumber;
    map['batchNumber'] = batchNumber;
    map['hostNo'] = hostNo;
    map['errorMessage'] = errorMessage;
    return map;
  }
}
